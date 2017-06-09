// RUN: %dafny /print:"%t.print" /rprint:"%t.dprint" "%s" > "%t"
// RUN: %diff "%s.expect" "%t"

module AM {

  method M0(d: int)
  {
    var a := new int[25](_ => d);
    assert a.Length == 25;
    assert a[18] == d;
  }

  method M1()
  {
    var f := (r: real) => r;
    var a := new real[25](f);  // error: initializer has incorrect type
    assert a.Length == 25;
    assert a[18] == 18.0;
  }

  method M2<D>(d: D)
  {
    var a := new D[25](d);  // error: initializer has incorrect type (error message includes a hint)
    assert a.Length == 25;
    assert a[18] == d;
  }

  method M3<D>(d: D)
  {
    var g := (_: int) => d;
    var a := new D[25](g);
    assert a.Length == 25;
    assert a[18] == d;
  }

  method M4(d: char)
  {
    var a := new char[25,10,100]((x:int) => d);  // error: wrong type
    assert a.Length0 == 25;
    assert a.Length1 == 10;
    assert a.Length2 == 100;
    assert a[18,3,23] == d;
  }

  method M5(d: char)
  {
    var a := new char[25,10]((x, y) => if x==y then '=' else d);
    assert a.Length0 == 25;
    assert a.Length1 == 10;
    assert a[18,3] == d;
  }

  method M6<D>(d: D)
  {
    var a := new D[1,2,4,8,16](d);  // error: initializer has incorrect type (error message includes a hint)
    assert a.Length3 == 8;
    assert a[0,0,0,0,0] == d;
  }
}

module BM {
  function GhostF(x: int): char { 'D' }
  method M(n: nat) {
    var a := new char[n](GhostF);  // error: use of ghost function not allowed here
    if 5 < n {
      assert a[5] == 'D';
    }
  }
}
