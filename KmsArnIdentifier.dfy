predicate ArnString?(s: string)
{
    s == "arn"
}
// MUST start with string arn
type ArnString = s:string | ArnString?(s) witness "arn"



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


datatype ARN = ARN(
    arnLiteral: string,
    partition: string,
    service: string,
    region: string,
    account: string,
    resource: Resource
)



// type KmsArn = a: ARN | KmsArn?(a) witness *


type resourceType = s:string | s == "alias" || s == "key" witness *

type ResourceId = s:string | |s| != 0 witness *



datatype Resource = Resource(
    rtype : string,
    id : string
)

datatype KmsResource = KmsResource(
    rtype : resourceType,
    id : ResourceId
)

datatype KmsArnDatatype = KmsArnDatatype(
    arnLiteral: ArnString,
    partition: PartitionString,
    service: ServiceString,
    region: RegionString,
    account: AccountString,
    resource: KmsResource
)




// predicate KmsArn?(a:ARN)

// {
//     if
//         // MUST start with string arn
//         && a.arnLiteral == "arn"

//         // The partition MUST be a non-empty
//         && |a.partition| !=0

//         // The service MUST be the string kms
//         && a.service == "kms"

//         //The account MUST be a non-empty string
//         && |a.account| != 0

//         // The region MUST be a non-empty string
//         && |a.region| !=0

//         // then it leads to resource type to be key or alias, and both id cannot be empty
//         &&  |a.resource|>=2
//         &&  (
//             (&& a.resource[0] == "key"
//             && |a.resource[1]|!=0 ) 
//             || 
//             (&& a.resource[0] == "alias" 
//             && |a.resource[1]| != 0 )
//             )
//     then true
//     else false
// }

// method test()
// {
//     assert ARN("arn","aws","kms","us-east-1","2222222222222",["key","testid"]).ARN? == true;

//     assert KmsArn?(ARN("arn","aws","kms","us-east-1","2222222222222",["alias","testid"])) == true;

//     assert KmsArnDatatype("arn","aws","kms","us-east-1","2222222222222",["key","testid"]).KmsArnDatatype? == true;

// }
