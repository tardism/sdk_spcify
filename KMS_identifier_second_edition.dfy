// function slice(input: string): (output: seq<string>)
// //   requires input == "arn:partition" 
// //   ensures |output| == MatchCount(input,":")+1
// //   ensures MatchCount(input,":") == 2

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

method testing(input:string, m:char)
    requires input == "aaa"
    requires m in input
    {


    // var num := help_slice(input,m,"");
    // var multiset_result := multiset(input)[m]+2;

    assert |help_slice("aaa",'a',"")|== multiset("aaa")['a']+1;

    assert |help_slice(input,'z',"")| == multiset(input)['s']+1;
    
    assert |help_slice(input,'z',"")| == multiset(input)['s']+1;

}

function help_slice(input : string, m: char, section:string):(ouput:seq<string>)
{
    if |input| == 0 then
        [section]
    else
        if m == input[0] then
            [section] + help_slice(input[1..], m, "")
        else
            var fstChar := input[0];
            help_slice(input[1..], m, "")
}

function help_slice_complicated(input : string, m: char,section:string, str_seq : seq<string>):(ouput:seq<string>)

{
    if |input| == 0 then
        str_seq
    else
        if m == input[0] then
            var temp_str_seq := str_seq + [section];
            var temp_section := "";
            help_slice_complicated(input[1..], m, temp_section, temp_str_seq)
        else
            var temp_section := section + [input[0]];
            help_slice_complicated(input[1..], m, temp_section, str_seq)
}

