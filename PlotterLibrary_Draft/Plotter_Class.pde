// Plotter Class definition
//
// A plotter object is instantiated with a serial port address
// and an intended paper output size. It has a collection of functions
// that accept Processing-esque arguments for drawing and turns them into
// HPGL that is sent to the serial port for a pen plotter to execute.

class Plotter {
  /* attributes
  ------------------------------------*/
  Serial port; //Serial object for connecting to port
  
  /* constructor
  ------------------------------------*/
  Plotter(Serial _port, String paperSize) {
    port = _port;
    
    //initialize paper dimensions for input paperSize,
    //using the P1 and P2 scaling points (outer limits) of the plotter
    if (paperSize.equals("A")) {
      int xMin = 250;
      int yMin = 596;
      int xMax = 10250;
      int yMax = 7796;
    } else if (paperSize.equals("B")) {
      int xMin = 522;
      int yMin = 259;
      int xMax = 15722;
      int yMax = 10259;
    } else if (paperSize.equals("A3")) {
      int xMin = 170;
      int yMin = 602;
      int xMax = 15370;
      int yMax = 10602;
    } else if (paperSize.equals("A4")) {
      int xMin = 603;
      int yMin = 521;
      int xMax = 10603;
      int yMax = 7721;
    } else {
      println("A valid paper size wasn't given to your Plotter object.");
    }
  }
  
  
  /* methods
  ------------------------------------*/
  
  //write to plotter
  void write(String hpgl) {
    if (PLOTTING_ENABLED) {
      port.write(hpgl);
    }
  }
  
  
  //write to plotter with a provided delay (in ms)
  void write(String hpgl, int del) {
    if (PLOTTING_ENABLED) {
      port.write(hpgl);
      delay(del);
    }
  }
  
  
  //select a pen
  void selectPen(int slot) {
    if (slot >= 1 && slot <= 6 ) {
      write("SP" + slot + ";");
    } else {
      println("Your pen selection of " + 
      slot + " isn't a valid pen slot. Using default pen instead.");    
    }
  }
  
  
  //draw a line
  void drawLine(float _x1, float _y1, float _x2, float _y2) {
    //map input to paper size
    float x1 = map(_x1, 0, width, xMin, xMax);
    float y1 = map(_y1, 0, height, xMin, xMax);
    float x2 = map(_x2, 0, width, xMin, xMax);
    float y2 = map(_y2, 0, height, xMin, xMax);
    
    //pick up pen and go to x1, y1
    write("PU" + x1 + "," + y1 + ";");
    
    //put down pen and go to x2, y2
    write("PD" + x2 + "," + y2 + ";");
    
    //pick up pen
    write("PU;");
  }
  
  
  //draw an edge rectangle (no fill)
  void drawRect(float _x, float _y, float _w, float _h) {
    //map pixel input to Plotter Units
    float x = map(_x, 0, width, xMin, xMax);
    float y = map(_y, 0, height, yMin, yMax);
    float w = map(_w, 0, width, xMin, xMax);
    float h = map(_h, 0, height, yMin, yMax);
    
    //move to absolute position of x, y
    write("PA" + x + "," + y + ";");
    
    //draw a rectangle at current position with w x h dimensions
    write("ER" + w + "," + h + ";");
  }
  
  
  //draw a FILLED rectangle at x, y.
  //fill pattern is determined by latest lineType() setting
  void drawRectFill(float _x, float _y, float _w, float _h) {
    //map pixel input to plotter units
    float x = map(_x, 0, width, xMin, xMax);
    float y = map(_y, 0, height, yMin, yMax);
    float w = map(_w, 0, width, xMin, xMax);
    float h = map(_h, 0, height, yMin, yMax);
    
    //move to absolute position of x, y
    write("PA" + x + "," + y + ";");
    
    //draw a filled rectangle at current position with w x h dimensions
    write("RR" + w + "," + h + ";");
  }
  
  
  //draw a circle at x, y with input resolution
  void drawEllipse(float diam, float _x, float _y, float res) {
    float radius = map(diam/2, 0, width, xMin, xMax);
    float x = map(x1, 0, width, xMin, xMax);
    float y = map(y1, 0, height, yMin, yMax);
    
    //PAx,y; CIradius,res; //move to x, y and draw a circle 
    write("PA" + x + "," + y + ";" + "CI" + radius + "," + res + ";", 75);
  }
  
  
  //set the pattern used to draw lines and fill shapes.
  //default is solid line/fill if lineType() is never called
  void lineType(String pattern) {
    int selection; //pattern number to be selected
    
    //initialize selection based on desired pattern
    if (pattern.equals("single dot")) {
      selection = 0;
    } else if (pattern.equals("dotted")) {
      selection = 1;
    } else if (pattern.equals("short dash")) {
      selection = 2;
    } else if (pattern.equals("long dash")) {
      selection = 3;
    } else if (pattern.equals("dotted dash")) {
      selection = 4;
    } else if (pattern.equals("long dotted dash")) {
      selection = 5;
    } else if (pattern.equals("two point dash")) {
      selection = 6;
    } else {
      //debugging output
      println(pattern + " isn't a valid line type. Continuing plot with last selected line type.");
    }
    
    //write hpgl to port
    write("LT" + selection + ";");
  }
  
}
