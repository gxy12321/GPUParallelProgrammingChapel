use Time;

config const n = 2_000;   // 2000^2 image
var watch: stopwatch;
config const save = false;

if here.gpus.size == 0 {
  writeln("need a GPU ...");
  exit(1);
}

proc pixel(x0,y0) {
  const c = 0.355 + 0.355i;
  var x = x0*1.2; // zoom out
  var y = y0*1.2; // zoom out
  for i in 1..255 {
    var xnew = x**2 - y**2 + c.re;
    var ynew = 2*x*y + c.im;
    x = xnew;
    y = ynew;
    if x**2+y**2 >= 16 then
      return i;
  }
  return 255;
}

writeln("Computing ", n, "x", n, " Julia set ...");
watch.start();
on here.gpus[0] {
  var stability: [1..n,1..n] int;
  @gpu.assertEligible foreach i in 1..n {
    var y = 2*(i-0.5)/n - 1;
    for j in 1..n {
      var x = 2*(j-0.5)/n - 1;
      stability[i,j] = pixel(x,y);
    }
  }
}
watch.stop();
writeln('It took ', watch.elapsed(), ' seconds');