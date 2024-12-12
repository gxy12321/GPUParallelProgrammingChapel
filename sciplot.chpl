// save this as sciplot.chpl
use IO;
use List;

proc readColourmap(filename: string) {
  var reader = open(filename, ioMode.r).reader();
  var line: string;
  if (!reader.readLine(line)) then   // skip the header
    halt("ERROR: file appears to be empty");
  var dataRows : list(string); // a list of lines from the file
  while (reader.readLine(line)) do   // read all lines into the list
    dataRows.pushBack(line);
  var cmap: [1..dataRows.size, 1..3] real;
  for (i, row) in zip(1..dataRows.size, dataRows) {
    var c1 = row.find(','):int;    // position of the 1st comma in the line
    var c2 = row.rfind(','):int;   // position of the 2nd comma in the line
    cmap[i,1] = row[0..c1-1]:real;
    cmap[i,2] = row[c1+1..c2-1]:real;
    cmap[i,3] = row[c2+1..]:real;
  }
  reader.close();
  return cmap;
}
