function method split_main(input:string, delimiter:char):(output:seq<string>)
   requires |input|>0
   requires multiset(input)[delimiter] == 5
   ensures |output| == 6
{
   split(input,delimiter,[""])
}




function method split(input:string, delimiter:char, partStr:seq<string>):(output:seq<string>)
   requires |input|>=0
   requires |partStr|==1
   decreases |input|
{
   if |input| == 0
   then partStr
   else 
      if input[0] != delimiter then
         var temp := partStr[0]+input[..1];
         split(input[1..], delimiter, partStr[0 := temp])
      else 
         partStr + split(input[1..], delimiter, [""])
}



method asdf()
{
   var a := "abc";
   var b := [""];
   var c :=  b[0]+a[..1];
   // assert b[0 := c] == [c];

   assert ""+"a" == "a";
}