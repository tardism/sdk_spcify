predicate ArnString?(s: string)
{
    s == "arn"
}
// MUST start with string arn
type ArnString = s:string |  s == "arn" witness *


// // The partition MUST be a non-empty
// predicate PartitionString?(s:string)
// {
//     |s|!=0
// }
// type PartitionString = s:string | PartitionString?(s) witness *



// // The service MUST be the string kms
// predicate ServiceString?(s:string)
// {
//     |s|!=0
// }

// type ServiceString = s | ServiceString?(s) witness *

// // The region MUST be a non-empty string
// predicate RegionString?(s:string)
// {
//     |s|!=0
// }
// type RegionString = s:string | RegionString?(s) witness *

// //The account MUST be a non-empty string
// predicate AccountString?(s:string)
// {
//     |s|!=0

// }

// type AccountString = s:string | AccountString?(s) witness *


datatype Resource = Resource(
    rtype : string,
    id : string
)

datatype ARN = ARN(
    arnLiteral: ArnString,
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
    &&  (
        (&& a.resource.rtype == "key"
        && |a.resource.id| != 0 ) 
        || 
        (&& a.resource.rtype == "alias" 
        && |a.resource.id| != 0 )
        )

}

type KmsArn = a: ARN | KmsArn?(a) witness *

function method ParseKmsArn(s: string) : (r: Result<KmsArn>)

lemma ParseKmsArnIsCorrect(s: string)
    // MUST start with string arn
    ensures ParseKmsArn(s).Success? ==> "arn" < s


datatype Result =
| Success(value: bool)
| Failure(error: string)

function method AwsKmsMrkArn(a:ARN):Result{
    if KmsArn?(a) == false 
    then Result.Failure("not a KmsArn")
    else 
        var resBool := (
        && a.resource.rtype == "key"
        && |a.resource.id| > 4
        && "mrk-" < a.resource.id);

        Result.Success(resBool)
}


function method AwsKmsMrkArnIdentifier(a:string) : bool
{
    if "arn:" < a 
    then true // AwsKmsMrkArn's input is not a string yet, we'll fill in later
    else "mrk-" < a

}

function method splitArnString(s:string, delimiter:char):(output:seq<string>)
    requires multiset(s)[delimiter] == 5
    requires multiset(s)['/'] == 1
    ensures |output| == 5
    
    
    


function method splictArnResourceString (s:string):(output:seq<string>)
    requires multiset(s)['/'] == 2
    ensures |output| == 2



function method createArn(a:seq<string>):ARN
    requires |a| == 6 && multiset(a[5])['/'] == 2
    requires ARN(a[0], a[1], a[2], a[3], a[4], Resource(splictArnResourceString(a[5])[0],splictArnResourceString(a[5])[1])).ARN?
    requires multiset(a[5])['/'] == 2
{   
    var resourceSeq := splictArnResourceString(a[5]);    
    ARN(a[0], a[1], a[2], a[3], a[4], Resource(resourceSeq[0],resourceSeq[1]))
}




lemma asdf(a: ARN)
    requires KmsArn?(a)
    ensures AwsKmsMrkArn(a).Success?
{
}