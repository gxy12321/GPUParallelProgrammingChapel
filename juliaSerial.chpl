use Time;

config const n = 2_000;   // 2000^2 image
var watch: stopwatch;
config const save = false;

proc pixel(z0) {
  const c = 0.355 + 0.355i;
  var z = z0*1.2;   // zoom out
  for i in 1..255 {
    z = z*z + c;
    if z.re**2+z.im**2 >= 16 then // abs(z)>=4 does not work with LLVM
      return i;
  }
  return 255;
}

writeln("Computing ", n, "x", n, " Julia set ...");
watch.start();
var stability: [1..n,1..n] int;
for i in 1..n {
  var y = 2*(i-0.5)/n - 1;
  for j in 1..n {
    var point = 2*(j-0.5)/n - 1 + y*1i;
    stability[i,j] = pixel(point);
  }
}
watch.stop();
writeln('It took ', watch.elapsed(), ' seconds');

writeln("Plotting ...");
use Image, Math, sciplot;
watch.clear();
watch.start();
const smin = min reduce(stability);
const smax = max reduce(stability);
var colour: [1..n, 1..n] 3*int;
var cmap = readColourmap('nipy_spectral.csv');   // cmap.domain is {1..256, 1..3}
for i in 1..n {
  for j in 1..n {
    var idx = ((stability[i,j]:real-smin)/(smax-smin)*255):int + 1; //scale to 1..256
    colour[i,j] = ((cmap[idx,1]*255):int, (cmap[idx,2]*255):int, (cmap[idx,3]*255):int);
  }
}
var pixels = colorToPixel(colour);               // array of pixels
writeImage(n:string+".png", imageType.png, pixels);
watch.stop();
writeln('It took ', watch.elapsed(), ' seconds');
