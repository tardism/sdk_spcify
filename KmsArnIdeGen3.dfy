predicate ArnString?(s: string)
{
    s == "arn"
}
// MUST start with string arn
type ArnString = s:string |  s == "arn" witness *


// The partition MUST be a non-empty
predicate PartitionString?(s:string)
{
    |s|!=0
}
type PartitionString = s:string | PartitionString?(s) witness *



// The service MUST be the string kms
predicate ServiceString?(s:string)
{
    |s|!=0
}

type ServiceString = s | ServiceString?(s) witness *

// The region MUST be a non-empty string
predicate RegionString?(s:string)
{
    |s|!=0
}
type RegionString = s:string | RegionString?(s) witness *

//The account MUST be a non-empty string
predicate AccountString?(s:string)
{
    |s|!=0

}

type AccountString = s:string | AccountString?(s) witness *


datatype Resource = Resource(
    rtype : string,
    id : string
)

datatype ARN = ARN(
    arnLiteral: ArnString,
    partition: PartitionString,
    service: ServiceString,
    region: RegionString,
    account: AccountString,
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



lemma asdf(a: ARN)
    requires KmsArn?(a)
    ensures AwsKmsMrkArn(a).Success?
{
}