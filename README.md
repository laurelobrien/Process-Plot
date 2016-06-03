# Process-Plot
### a Processing-to-HPGL library for HP pen plotters

*This library is still under development and not functional. However, feel free to download the project and use the setup/draw template and Plotter class in PlotterLibrary_Draft.pde in the meantime.*

Process-Plot allows you to send commands to a HPGL-compatible pen plotter, such as the HP 7475a or HP 7550a, using Processing-esque syntax and parameters. Unit-mapping inherent in the library's drawing functions mean that you can draw according to Processing's canvas as per usual, and the output will be mapped to your chosen paper size and Plotter Units.

Unlike other HPGL libraries, Process-Plot avoids rolling distinct HPGL commands into one drawing function to allow better control over your plotter's behaviour. For example, selecting a pen is never automatic to avoid jamming for users who have hacked over-sized pens or "non-compatible" into their plotter (like a Sharpie).

The benefit of using Process-Plot or similar libraries is in being able to ignore the proprietary measurements and syntax used by old HP plotters, and instead let the library worry about it. 

For example, a 100px by 200px rectangle in Processing might be called with

``` java
rect(0, 0, 100, 200);
```

but in HPGL, it would be called with 

```
PA0,0;
ER100,200;
```

Even then, the scale would be all wrong when provided in pixels, unless you map your input to Plotter Units (in this example, an A3 page):

``` java
float x = map(100, 0, width, 170, 15370);
float y = map(200, 0, height, 250, 10602);
```

and use that new value to construct an HPGL string to be sent to the serial port.

Process-Plot allows you to call a drawing function for your own canvas preview, and a matching drawing function from the Plotter class to eliminate the need for constant translation and mapping:

``` java
rect(0, 0, 100, 200);
yourPlotter.drawRect(0, 0, 100, 200);
```

And now you can use your canvas preview throughout the development process, only needing to boot up your plotter and consume paper + ink when you're ready to draw.

HPGL Library also includes plotter-only functions like selecting a pen and changing fill patterns, which have a more intuitive syntax for Processing users than its HPGL counterpart:

``` java
//choose pen in second carousel slot
yourPlotter.selectPen(2);

//select the 4th line quality option, "dotted"
yourPlotter.lineType(4);

//draw a rectangle using your selected pen and
//pattern fill at 0, 0
yourPlotter.drawRectFill(0, 0, 100, 200);
```

The HPGL output that is automatically sent to your plotter looks like:

```
SP2; LT4; PA170,602,; RR2149,4376;
```

Because Process-Plot simply sends Strings of HPGL to your serial port, you can use plotter emulators like PlotterGeist or simply write the Strings to a text file.

*Full documentation forthcoming.*