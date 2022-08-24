method m(n: nat)
{
   var i: int := 0;
   while i < n
      invariant i!=n // Change this. What happens?
   {
      i := i + 1;
   }
    
    assert i == n;

}
