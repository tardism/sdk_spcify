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

type AwsKmsArn = a: ARN | KmsArn?(a) witness *

datatype Result =
| Success(value: bool)
| Failure(error: string)




function method AwsArn?(s:string) : (output : Result)
    ensures output == Result.Success(true) ==> |split(s,':')| == 6
    ensures output == Result.Success(true) ==> '/' in split(s,':')[5]
    ensures output == Result.Success(true) ==> multiset(split(s,':')[5])['/'] == 1
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


function method CreateArn(s:string):(output : Result<AwsKmsArn>)
{
    var seqS := split(s,':');
    var seqResource := split(seqS[5], '/');
    var resource := Resource(seqResource[0], seqResource[1]);
    var arn := ARN(seqS[0], seqS[1], seqS[2], seqS[3], seqS[4], resource);

    if arn.service != "kms" then
        Failure("Wow, this is not an AwsKmsArn is it...")
}

function method AwsKmsMrkArn_helper(a:ARN):Result
    
{
    if !KmsArn?(a)
    then Result.Failure("not a KmsArn, due to KmsArn? false")
    else 
        var resBool := (
        && a.resource.rtype == "key"
        && "mrk-" < a.resource.id);
        Result.Success(resBool)
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

method IAmStatement() returns (o: bool)
{
    if true {
        // this was an if statement
    }

    for i := 0 to 5 {
        // more statements
    }

    var iAmExpression := if true then "asdf" else "qwer";
    return true;
}

lemma ProveAwsArn (s:string,ss:seq<string>)
    requires IAmStatement()
    requires 5 < |s|
    requires
        && 5 < |s|
        && var a := AwsArn?(s);
        && a.Success?
        && a.value
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

{
    assert AwsArn?(s) == Result.Success(true);
}

lemma test3(s:string, arn : ARN)
    requires AwsArn?(s) == Result.Success(true)
    requires arn == CreateArn(s)
    requires arn.resource.rtype == "key" 
    requires "mrk-" < arn.resource.id 
{
    assert AwsArn?(s) == Result.Success(true);
    assert arn == CreateArn(s);
    assert (arn.resource.rtype == "key") && "mrk-" < arn.resource.id;
    assert AwsKmsMrkArn_helper(arn) == Result.Success(true);
    // assert AwsKmsMrkArn?(s) == Result.Success(true);
}




