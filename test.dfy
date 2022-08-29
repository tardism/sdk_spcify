//Failure compatible types


datatype Result<T> =
| Success(value: T)
| Failure(error: string)
{
  predicate method IsFailure() {
    this.Failure?
  }
  function method PropagateFailure<U>(): Result<U>
    requires IsFailure()
  {
    Failure(this.error) // this is Result<U>.Failure(...)
  }

  function method Extract(): T
    requires !IsFailure()
  {
    this.value
  }

}

function method split(s:string) :(output: seq<string>)

function method F(s:string): Result<seq<string>>
{
    var test := split(s);

    if (|test| == 5) then
        Success(test)
    else
        Result.Failure("did not split to 5")
}

datatype ARN = ARN(
    l: string,
    p: string,
    s: string,
    a: string,
    r: string
)

function method use(s: string): Result<ARN>

{
    var asdf :- F(s);

    // var t := F(s);

    // if t.Failure? then
    //     Failure(t.error)
    // else
    //     var v := t.value;

    // var asdf := F(s);
    // var asdf := split(s);

    Success(ARN(asdf[0], asdf[1], asdf[2], asdf[3], asdf[4])) 
}




datatype M =
| A
| B
| C
| D


lemma asdf(a: M, b: M)
  ensures a.A? ==> b.B?

lemma qwer(b: M, c: M)
  ensures b.B? ==> c.C?

lemma zxcv(a: M, b: M, c: M)
  ensures a.A? ==> c.C?
{
  asdf(a, b);
  qwer(b, c);
}

