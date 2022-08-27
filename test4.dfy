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

function Join(s: seq<string>, d: char)
    :(output: string)
    requires 0 < |s|
    // requires forall i <- s :: d !in i
    ensures |output|>=0
    ensures s[0] <= output
    ensures |s| > 1 ==> d in output
    decreases |s|
    // ensures multiset(output)[d] + 1 <= |s|
{
    if |s| == 1 then
        s[0]
    else
        s[0] + [d] + Join(s[1..], d)
}

lemma asdf(ss: seq<string>, d: char, s: string)
    requires 0 < |ss|
    requires Join(ss, d) == s
    // ensures multiset(s)[d] + 1 <= |ss|

{
    // assert multiset(s)[d] < |ss|;
    assert ss == split(s, d) ==> |ss| == multiset(s)[d] + 1;
    assert ss == split(s, d) ==> !exists t <- ss :: d in t;
    assert ss == split(s, d) ==> forall t <- ss :: d !in t;

    // |split(s, d)| - |ss| == number of d's in ss 
    // assert |ss| != |split(s, d)| ==> exists t <- ss :: d in t;

}

function split(s:string, d:char)
    :(output:seq<string>)
    ensures forall o <- output :: d !in o
    ensures 0 < |output|
    ensures s == Join(output,d)
    ensures |output| == multiset(s)[d]+1
{
    if d !in s then
        [s]
    else
        var index := FindNextDelimiter(s,d,0);
        [s[..index]]+split(s[index+1..],d)
}

lemma

// lemma help_split(s:string,d:char)
// {
//     if s == ""
//     {
//         assert |split(s,d)| == 1;
//         assert multiset(s)[d]+1 == 1;

//     }
//     else if s[0] == d
//     {
//         assert multiset(s)[d] >= 1;
//         assert |split(s,d)| >= 2;
//     }
//     else if d in s
//     {
//         // assert multiset(s)[d]+1 == |split(s,d)|;
//     }
//     else if d !in s
//     {
//         assert |split(s,d)| == multiset(s)[d]+1;
//     }
// }

// lemma tttt(s:string, d:char)
//     requires  multiset(s)[d] == 1;
// {
//     assert d in s;
//     var asdf := FindNextDelimiter(s, d, 0);

//     var a := s[..asdf];
//     var b := s[asdf+1 ..];

//     assert d !in a;
//     assert s == a + [d] + b;
//     assert d !in b;
// }

// lemma test2(s:string, d:char, n:nat)
//     requires |split(s, d)| == n
//     requires n == 2
//     // ensures d !in s
// {
//     assert d in s;
// }

// method qwer(s:string, d:char)
//     requires d in s
//     // requires 0< |s| < 2
//     requires d == 'a'
//     requires s == "aa"

// {
//     // var s:= "abcs";
//     // var d:= 'a';
//     var h := multiset(s);
//     var j := h['a']+1;
//     // assert j == |split(s,d)|;
//     assert multiset("aaa")['a']+1 == |split("aaa",'a')|;

    
    
// }


