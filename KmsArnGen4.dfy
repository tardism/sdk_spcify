function method FindNextDelimiter(input:string, delimiter:char, index :nat)
    :(output:nat)
    requires 0 <= index < |input|
    requires delimiter in input[index..]
    decreases |input|-index
    ensures index <= output < |input|
    ensures input[output] == delimiter
    ensures delimiter !in input[index..output]
{
    if input[index] == delimiter then
        index
    else
        FindNextDelimiter(input, delimiter, index+1)
}

function method Join(s: seq<string>, d: char)
    :(output: string)
    requires |s|>0
     decreases |s|
{
    if |s| == 1 then
        s[0]
    else
        s[0] + [d] + Join(s[1..], d)
}


function method split(s:string, d:char)
    :(output:seq<string>)
    ensures forall o <- output :: d !in o
    ensures 0 < |output|
    decreases |s|
    ensures s == Join(output,d)
    ensures |output| == multiset(s)[d]+1
{
    if d !in s then
        [s]
    else
        var index := FindNextDelimiter(s,d,0);
        [s[..index]]+split(s[index+1..],d)
}


datatype Resource = Resource(
    rtype : string,
    id : string
)

datatype ARN = ARN(
    arnLiteral: string,
    partition: string,
    service: string,
    region: string,
    account: string,
    resource: Resource
)


predicate method KmsArn?(a:ARN)
{
    // MUST start with string arn
    && a.arnLiteral == "arn"

    // The partition MUST be a non-empty
    && |a.partition| !=0

    // The service MUST be the string kms
    && a.service == "kms"

    //The account MUST be a non-empty string
    && |a.account| != 0

    // The region MUST be a non-empty string
    && |a.region| !=0

    // then it leads to resource type to be key or alias, and both id cannot be empty
    &&  
    (|| a.resource.rtype == "key" 
    || a.resource.rtype == "alias") 

    && |a.resource.id| != 0 

}

datatype Result =
| Success(value: bool)
| Failure(error: string)


function method AwsKmsMrkArn_helper(a:ARN):Result
    
{
    if KmsArn?(a) == false 
    then Result.Failure("not a KmsArn, due to KmsArn? false")
    else 
        var resBool := (
        && a.resource.rtype == "key"
        && "mrk-" < a.resource.id);
        Result.Success(resBool)
}

function method AwsArn?(s:string) : (output : Result)
    ensures output == Result.Success(true) ==> multiset(s)[':'] == 5
{
    var seqS := split(s,':');
    if |seqS| != 6 
    then 
        Result.Failure("not a Arn, due to |seqS| != 6")
    else
        var seqResource := split(seqS[5], '/');
        if |seqResource| == 2
        then 
            Result.Success(true)
        else             
            Result.Failure("not a Arn, due to |seqResource|!=2")
}

lemma ProveAwsArn (s:string,ss:seq<string>)
    requires AwsArn?(s) == Result.Success(true)
    requires ss == split(s,':')
{
    assert multiset(s)[':'] == 5;
    assert |ss| == 6;
    assert '/' in ss[5];
    assert |split(ss[5],'/')| == 2;
}

lemma ProveAwsArn2 (s:string, ss:seq<string>)
    requires multiset(s)[';'] == 5
    requires ss == split(s,':')
    requires |ss| == 6
    requires multiset(ss[5])['/'] == 1
    requires |split(ss[5],'/')| == 2
    ensures AwsArn?(s) == Result.Success(true)
{

}


function method CreateArn(s:string):(output : ARN)
    requires AwsArn?(s) == Result.Success(true)
{
    var seqS := split(s,':');
    var seqResource := split(seqS[5], '/');
    var resource := Resource(seqResource[0], seqResource[1]);
    ARN(seqS[0], seqS[1], seqS[2], seqS[3], seqS[4], resource)
}

function method AwsKmsMrkArn?(s:string) : (result : Result)
{
    var awsArn? := AwsArn?(s);
    if  awsArn? == Result.Success(true)
    then
        var arn := CreateArn(s);
        AwsKmsMrkArn_helper(arn)  
    else 
        awsArn?
}

function method AwsKmsMrkArnIdentifier?(s:string) : (output:Result)
{
    if "arn:" < s
    then 
        AwsKmsMrkArn?(s)
    else 
        Result.Success("mrk-" < s)
}

// method test()
// {   
//     var a := "arn:aws:kms:us-east-1:2222222222222:key/1234abcd-12ab-34cd-56ef-1234567890ab";
//     assert AwsKmsMrkArn?(a) == Result.Success(false);
// }



