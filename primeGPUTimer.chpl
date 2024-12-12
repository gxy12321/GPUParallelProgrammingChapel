use GPU;

config const n = 10;

on here.gpus[0] {
  var A: [1..n] int;
  var clockDiff: [1..n] uint;
  @assertOnGpu foreach i in 1..n {
    var start, stop: uint;
    A[i] = i**2;
    start = gpuClock();
    for j in 0..<1000 do
      A[i] += i*j;
    stop = gpuClock();
    clockDiff[i] = stop - start;
  }
  writeln("Cycle count = ", clockDiff);
  writeln("Time = ", (clockDiff[1]: real) / (gpuClocksPerSec(0): real), " seconds");
  writeln("A = ", A);
}


