// function slice(input: string): (output: seq<string>)
//   requires input == "arn:partition" 
//   ensures |output| == MatchCount(input,":")+1
//   ensures MatchCount(input,":") == 2

// {
//     help_slice(input, ":", "")

// }




// function MatchCount_multiset(input:string, m:char):(out:nat)
// {
//     var a := char{|input|}
//     forall x:: x in input ==> 
//     multiset{input}[m]    

        
// }

// function MatchCount_charAsM(input: string, m: char):
//   (matchout: nat)
  
// {
//     if (m !in input) then
//         0
//     else if input[0] == m then
//         1+MatchCount_charAsM(input[1..], m)
//     else
//         MatchCount_charAsM(input[1..], m)
        
// }

// function MatchCount(input: string, m: string):
//   (matchout: nat)
//   requires m != ""
// {
//     if (|input| == 0) then 0 else
//     if m <= input then 1 + MatchCount(input[|m|..], m) else 
//         MatchCount(input[1..], m)    
// }

// lemma MatchLemma(input:string, m:char)
//     requires m in input
//     requires input == "aaa"
//     {

//         // var num := help_slice(input,m,"");
//         // var multiset_result := multiset(input)[m]+1;

//         var num := help_slice("a111aa11a2222",'a',"");
//         var multiset_result := multiset("aaaa11")['a']+1;


//         assert |num|== multiset_result;


//     }

// method testing(input:string, m:char)
//     requires input == "aaxxxxsaa"
//     requires m in input
//     {


//     // var num := help_slice(input,m,"");
//     // var multiset_result := multiset(input)[m]+2;

//     assert |help_slice("assasssassssaaaass",'a',"")|== multiset("aaa")['a']+1;

//     assert |help_slice(input,'m',"")| == multiset(input)['m']+1;

// }

// function help_slice(input : string, m: char, section:string):(ouput:seq<string>)
    
// {
//     if |input| == 0 then
//         [section]
//     else
//         if m == input[0] then
//             [section] + help_slice(input[1..], m, "")
//         else
//             var fstChar := [input[0]];
//             help_slice(input[1..], m, section+fstChar)
// }

method test3()
{
    var s:= ["a"];
    var x := ["b"];
    var sum := [""];
    // var sum2 := [];
    var y := [1,2,3];
    var t := [3.14, 2.7, 1.41, 1985.44, 100.0, 37.2][1:0:3];
    var sample := "ab:c"; 
    var c := sample[..2];
    var sli := "abc";
    var a := "abcd";
    var b := "b";



    assert [a[0]] == "a";
    var f := [a[0]];
    assert f+b =="ab";
    assert sum[0:= f+b] == ["ab"];

    // assert slii[0] == "a";
    // assert slii[|slii|-1] == "bc";
    // assert slii == ["a","bc"];


    // assert sample[..2] == "ab"; //???????????

    // assert sum[0 := sample[..2]] == ["ab"];

    // assert sum2+[sample] == ["ab:c"];
    


    // assert |t| == 3 && t[0] == [3.14] && t[1] == []&&t[2]==[2.7, 1.41, 1985.44];

    // assert s+x+sum == ["a","b",""];

    // assert  s[0]+x[0] == "ab";
    
    // assert sum[0 := (s[0]+x[0])] == ["ab"]

}

// function slice2(input:string, delimiter:char, curIndex:int, preDeliIndex:int, tempOut:seq<string>):(output:seq<string>)
// requires curIndex<=|input|;
// {    
//     if curIndex == |input|-1 then tempOut
//     else if (input[curIndex] == delimiter)
//     then slice2(input,delimiter,curIndex+1,curIndex,tempOut+[input[preDeliIndex..curIndex+1]])
//     else slice2(input,delimiter,curIndex+1,preDeliIndex,tempOut)


// }

// function slice3(input:string, delimiter:char,tempOut:seq<string>):(output:seq<string>)
// {
//     if |input| == 0 then tempOut
//     else if input[0] != delimiter
//     then slice3(input[1..],delimiter,tempOut[0])
// }











// function help_slice_complicated(input : string, m: char,section:string, str_seq : seq<string>):(ouput:seq<string>)

//     requires 

// {
//     if |input| == 0 then
//         str_seq
//     else
//         if m == input[0] then
//             var temp_str_seq := str_seq + [section];
//             var temp_section := "";
//             help_slice_complicated(input[1..], m, temp_section, temp_str_seq)
//         else
//             var temp_section := section + [input[0]];
//             help_slice_complicated(input[1..], m, temp_section, str_seq)
// }






