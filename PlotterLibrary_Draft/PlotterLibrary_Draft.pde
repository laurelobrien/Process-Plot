// draft for creating a Processing-to-HPGL library
// for interfacing with pen plotters


//import the native serial and PDF-writing library
import processing.serial.*;
import processing.pdf.*;

Serial myPort;        //instantiate a Serial object
Plotter penPlotter;   //instantiate a Plotter object
int lineFeed = 10;    //ASCII linefeed

/* Enable plotting?
---------------------------------------
Disable to see canvas output without sending commands
to serial port or to test the program without a plotter hooked up */
boolean PLOTTING_ENABLED = true;

/* Enable PDF output?
---------------------------------------
PDF output is not currently possible when plotting.
If not plotting, you can toggle this boolean to true
to have a PDF of your drawing exported into the program folder. */
boolean WANT_PDF = false;
String pdfName = "test_file.pdf";

// Paper dimensions of intended output
int xMin, yMin;
int xMax, yMax;


void setup() {
  if (WANT_PDF) {
    size(350, 700, PDF, pdfName); //pixel dimensions of PDF output
  }
  
  background(255); //white bg
  
  /* Select a serial port
  ---------------------------------------
  Print out all available serial ports to check the port you want
  is detected by Processing. Assign the index location of your port to
  portName, and print out a confirmation that commands are being sent to that port. */
  println(Serial.list());                     //list all ports
  String portName = Serial.list()[1];         //assign index of desired port
  println("Plotting to port: " + portName);   //confirm port selection
  
  myPort = new Serial(this, portName, 9600);  //initialize myPort 
  myPort.bufferUntil(lf);                     //set ASCII linefeed buffer
  
  
  /* Instantiate a Plotter object
  ---------------------------------------
  Plotters need to be instantiated with a port to connect to and a paper size.
  "A" = letter size, "B" = tabloid size, "A4" = metric A4, "A3" = metric A3 */
  penPlotter = new Plotter(myPort, "A");
  
  
  /* Scale the canvas size to represent paper output
  ---------------------------------------
  The canvas size() in pixels is scaled to be 1/20th of the paper size 
  in Plotter Units since the number of Plotter Units in a few inches is so massive. */ 
  if (!WANT_PDF) {
    int paperX = int(xMax / 20);
    int paperY = int(yMax / 20);
    size(paperY, paperX);
  }
  
  //all drawing commands go here
  //
  //
  //
  
  
  if (PLOTTING_ENABLED) {
    println("Sent all HPGL commands.");
  }
  
  if (WANT_PDF) {
    println("Done recording PDF to program folder.");
    exit(); //exit program to ensure correct PDF export
  }

}
