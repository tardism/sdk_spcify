
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





type ResourceType = s:string | s == "alias" || s == "key" witness *

type ResourceId = s:string | |s| != 0 witness *



datatype KmsResource = KmsResource(
    rtype : ResourceType,
    id : ResourceId
)

//remeber to add witness
type KeyType = s:ResourceType | s == "key" 
type MrkId = s:ResourceId | |s|>4 && s[..4] == "mrk-" witness*

predicate MrkId? (s:ResourceId)
{
    |s|>4 && s[..4] == "mrk-"
}

predicate KeyType?(s:ResourceType)
{
    s == "key" 
}

datatype MrkResource = MrkResource(
    rtype : KeyType,
    id : MrkId

)

predicate AwsKmsMrkIdentifier(a:KmsArnSubtype)
{
    true
    // && KeyType?(a.resource.rtype)
    // && MrkId?(a.resource.id)
}

type KmsArnSubtype = a: ARN | KmsArn?(a) witness *



datatype KmsArnDatatype = KmsArnDatatype(
    arnLiteral: ArnString,
    partition: PartitionString,
    service: ServiceString,
    region: RegionString,
    account: AccountString
    // resource: KmsResource
)

// lemma asdf(stuff: seq<string>)
//     requires 5 == |stuff|
// {
//     var k := KmsArnDatatype( stuff[0], stuff[1], stuff[2], stuff[3], stuff[4]);
// }


predicate KmsArn?(a:ARN)

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

method test()
{
    // assert ARN("arn","aws","kms","us-east-1","2222222222222",Resource("key","test")).ARN? == false;

    // assert KmsArn?(ARN("arn","aws","kms","us-east-1","2222222222222",Resource("key","test"))) == true;

    // assert (KmsArnDatatype("arn","aws","kms","us-east-1","2222222222222",KmsResource("key","test")).KmsArnDatatype?) == false;

    // assert AwsKmsMrkIdentifier(KmsArnDatatype("arn","aws","kms","us-east-1","2222222222222",KmsResource("key","test"))) == false;

}
