predicate ArnString?(s: string)
{
    s == "arn"
}
// MUST start with string arn
type ArnString = s:string |  s == "arn" witness *


// The partition MUST be a non-empty
predicate PartitionString?(s:string)
{
    s != ""
}
type PartitionString = s:string | PartitionString?(s) witness *



// The service MUST be the string kms
predicate ServiceString?(s:string)
{
    s == "kms"
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


// The resource section MUST be non-empty and MUST be split by a single / any additional / are included in the resource id
// The resource type MUST be either alias or key
// The resource id MUST be a non-empty string 
// this seq<string> length is 2, x[0] is key, x[1] is ID.

predicate KmsResource?(x:string, y:string)
{
    (x=="alias" ||x == "key") && |y| != 0
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

