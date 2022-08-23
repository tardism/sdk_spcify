predicate ArnString?(s: string)
{
    s == "arn"
}
// MUST start with string arn
type ArnString = s:string | ArnString?(s) witness *

// The partition MUST be a non-empty
type PartitionString = s:string | |s| != 0 witness "a"

// The service MUST be the string kms
type ServiceString = s | s =="kms"

// The region MUST be a non-empty string
type RegionString = s:string | |s| != 0

//The account MUST be a non-empty string
type AccountString = s:string | |s| != 0


// The resource section MUST be non-empty and MUST be split by a single / any additional / are included in the resource id
// The resource type MUST be either alias or key
// The resource id MUST be a non-empty string 
// this seq<string> length is 2, x[0] is key, x[1] is ID.

type KmsResourceSeqStr = x:seq<string> | |x| == 2 && (x[0]=="alias" || x[0] == "key") && |x[1]| != 0

datatype ARN = ARN(
    arnLiteral: string,
    partition: string,
    service: string,
    region: string,
    account: string,
    resource: seq<string>
)



type KmsArn = a: ARN | KmsArn?(a)


predicate KmsArn?(a:ARN)
{
    if
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
            (&& a.resource[0] == "key"
            && |a.resource[1]|!=0 ) 
            || 
            (&& a.resource[0] == "alias" 
            && |a.resource[1]| != 0 )
            )
    then true
    else false
}

method test()
{
    assert ARN("arn","aws","kms","us-east-1","2222222222222",["key","testid"]).ARN?;


    assert KmsArn?(ARN("arn","aws","kms","us-east-1","2222222222222",["key","testid"])) == true;

}
