method SumMax(x: int, y:int) returns (s:int, m:int)
    ensures s == x+y
    ensures x <= m && y <= m
    ensures m == x || m == y
{
    s := x+y;
    if x<y{
        m:=y;
    } else{
        m :=x;
    }
}



method SumMaxBackwards(s: int, m:int) returns (x: int, y:int)
    ensures s == x+y
    ensures x <= m && y <= m
    ensures m == x || m == y
{
    if x<y{
        x := m;
        y := s-m;
    } else {
        y :=m;
        x := s-m;
    }
}
