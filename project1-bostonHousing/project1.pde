/*
  CS6260 
  Che Shian Hung
  Project #1
  9/19/2018
  Description: This program aims to find the relateionship between attributes
               among Boston Housing data. To simplify the program, nine of the
               attributes are selected from the data, and the users can define
               a new set of labels in the program (change columnCount && labels).
               When the program runs, the users can select the attribute to
               compare on the x-axis and y-axis. The plot is shown on the right,
               and the user can immediatelt see the data change along with the
               axis label. Each axis is scale with the corresponding data 
               maximum and minimum value. The user can also user cursor and
               point to the data to view the data position.
  Design: The global variables are defined at the top. There are three classes
          in this program: DataStats, PlotData, and Button. DataStats stores the
          maximum and minimun values for each attribute. PlotData contains x and
          y values to show in the plot. Button contains the button position and
          a bool to see if the button is pressed or not. A comparator SortByX is
          implemented to sort PlotData along x-axis for display purpose. In setup
          function, all the variables are initialized, and the data is import from
          the csv file. An updatePlot function is implemented and called at the
          setup and also when a button is pressed. The draw function handles all
          the printing and the user events.
*/

import java.util.*;

// windows
float WINDOWS_WIDTH = 800;
float WINDOWS_HEIGHT = 400;

// table
Table table;
String tableName = "BostonHousing.csv";
int rowCount;
//int columnCount = 14;
int columnCount = 11;
int xColumn = 2;
int yColumn = 5;
//String[] labels = {"CRIM", "ZN", "INDUS", "CHAS", "NOX", "RM",
//                "AGE", "DIS", "RAD", "TAX", "PTRATIO", "LSTAT",
//                "MEDV", "CAT. MEDV"};
String[] labels = {"CRIM", "INDUS", "NOX", "RM",
                "AGE", "DIS", "RAD", "TAX", "PTRATIO", "LSTAT",
                "MEDV"};
float[][] data = new float[columnCount][];

// plot
float plotWidth = 500.0;
float plotHeight = 350.0;
float plotOriginX = 275;
float plotOriginY = 15;
float plotMarginX = 50;
float plotMarginY = 35;
float dotSpeed = 0.06;
PFont f;
String xLabel;
String yLabel;
String xMax;
String xMin;
String yMax;
String yMin;
DataStats[] statsAry = new DataStats[columnCount];
List<PlotData> plotData = new ArrayList<PlotData>();
List<PlotData> targetPlotData = new ArrayList<PlotData>();

// button
float buttonWidth = 50;
float buttonHeight = 20;
float buttonGroupHeight = WINDOWS_HEIGHT * 3 / 4;
Button[] xButtons = new Button[columnCount];
Button[] yButtons = new Button[columnCount];

class DataStats {
  float max, min, interval;
  DataStats(float maxVal, float minVal) {
    max = maxVal;
    min = minVal;
    interval = max - min;
  }
}

class PlotData {
  float x;
  float y;
  PlotData(float xVal, float yVal) {
    x = xVal;
    y = yVal;
  }
}

class Button {
  float x;
  float y;
  boolean selected;
  Button(float xVal, float yVal) {
    x = xVal;
    y = yVal;
    selected = false;
  }
  void select() {
    selected = !selected;
  }
}

class SortByX implements Comparator<PlotData> {
  public int compare(PlotData a, PlotData b) {
    return a.x < b.x ? -1 : a.x > b.x ? 1 : 0;
  }
}

void setup() {
  f = createFont("Arial", 16, true);
  
  // import data
  table = loadTable(tableName, "header");
  rowCount = table.getRowCount();
  for (int i = 0; i < columnCount; i++) {
    data[i] = new float[rowCount];
  }  
  int i = 0;
  for (TableRow row : table.rows()) {
    for (int j = 0; j < columnCount; j++) {
      data[j][i] = row.getFloat(labels[j]);
    }
    i++;
  }
  
  // updata statsAry and create buttons
  for (i = 0; i < columnCount; i++) {
    float max = data[i][0];
    float min = data[i][0];
    for (int j = 1; j < rowCount; j++) {
      if (max < data[i][j]) max = data[i][j];
      if (min > data[i][j]) min = data[i][j];
    }
    statsAry[i] = new DataStats(max, min);
    xButtons[i] = new Button((plotOriginX / 2.5 - buttonWidth) / 2, WINDOWS_HEIGHT / 4.1 + buttonGroupHeight / columnCount * i + (buttonGroupHeight / columnCount - buttonHeight) / 2);
    yButtons[i] = new Button(plotOriginX / 3.5 + (plotOriginX / 2 - buttonWidth)  / 2, WINDOWS_HEIGHT / 4.1 + buttonGroupHeight / columnCount * i + (buttonGroupHeight / columnCount - buttonHeight) / 2);
  }  
  xButtons[xColumn].select();
  yButtons[yColumn].select();
  
  // initialize plotData and create the first plot
  updatePlot();
  plotData.clear();
  for (PlotData pd : targetPlotData) {
    plotData.add(new PlotData(pd.x, pd.y));
  }
  
  // set windows info
  size(800, 400);
  background(255, 255, 255);
}

// update targetPlotData so that plotData would follow
void updatePlot() {
  targetPlotData.clear();
  xLabel = labels[xColumn];
  yLabel = labels[yColumn];
  xMax = str(statsAry[xColumn].max);
  xMin = str(statsAry[xColumn].min);
  yMax = str(statsAry[yColumn].max);
  yMin = str(statsAry[yColumn].min);
  
  for (int i = 0; i < rowCount; i++) {
    targetPlotData.add(new PlotData(map(data[xColumn][i], statsAry[xColumn].min, statsAry[xColumn].max, plotOriginX + plotMarginX, plotOriginX + plotWidth - plotMarginX)
                            , map(data[yColumn][i], statsAry[yColumn].min, statsAry[yColumn].max, plotOriginY + plotMarginY, plotOriginY + plotHeight - plotMarginY)));
  }
  Collections.sort(targetPlotData, new SortByX());
}

void draw() {
  background(255, 255, 255);
  
  // draw program header
  fill(0);
  textFont(f, 14);
  textAlign(LEFT);
  text("CS6260", 30, 25);
  text("Che Shian Hung", 30, 45);
  text("Project # 1", 30, 65);
  
  // draw buttons' attributes
  textFont(f, 13);
  textAlign(CENTER);
  text("x-axis", xButtons[0].x + buttonWidth / 2, xButtons[0].y - buttonHeight / 2);
  text("y-axis", yButtons[0].x + buttonWidth / 2, yButtons[0].y - buttonHeight / 2);
  
  // draw buttons and buttons text
  for (int i = 0; i < columnCount; i++) {
    if (xButtons[i].selected)
      fill(170, 125);
    else
      fill(255);
    rect(xButtons[i].x, xButtons[i].y, buttonWidth, buttonHeight); 
    if (yButtons[i].selected)
      fill(170, 125);
    else
      fill(255);
    rect(yButtons[i].x, yButtons[i].y, buttonWidth, buttonHeight);
    fill(0);
    textFont(f, 10);
    textAlign(CENTER);
    text(labels[i], xButtons[i].x + buttonWidth / 2, xButtons[i].y + buttonHeight / 2 + 4);
    text(labels[i], yButtons[i].x + buttonWidth / 2, xButtons[i].y + buttonHeight / 2 + 4);
  }
  
  // draw plot
  fill(255);
  rect(plotOriginX, plotOriginY, plotWidth, plotHeight);
  stroke(0);
  fill(153, 30);
  for (PlotData pd : plotData) {
    ellipse(pd.x, plotOriginY + plotHeight + plotMarginY / 2 - pd.y, 4, 4); 
  }
  
  // update each point
  for (int i = 0; i < rowCount; i++) {
    plotData.get(i).x += (targetPlotData.get(i).x - plotData.get(i).x) * dotSpeed;
    plotData.get(i).y += (targetPlotData.get(i).y - plotData.get(i).y) * dotSpeed;
  }
  
  // if user points to a data
  for (PlotData pd : plotData) {
   if (mouseX > pd.x - 4 && mouseX < pd.x + 4 && mouseY > plotOriginY + plotHeight + plotMarginY / 2 - pd.y - 4 && mouseY < plotOriginY + plotHeight + plotMarginY / 2 - pd.y + 4) {
     fill(255);
     rect(mouseX - 90, mouseY + 10, 80, 22);
     fill(0);
     textFont(f, 10);
     textAlign(CENTER);
     text("(" + nf(map(pd.x, plotOriginX + plotMarginX, plotOriginX + plotWidth - plotMarginX, statsAry[xColumn].min, statsAry[xColumn].max), 1, 2) + ", " + 
          nf(map(pd.y, plotOriginY + plotMarginY, plotOriginY + plotHeight - plotMarginY, statsAry[yColumn].min, statsAry[yColumn].max), 1 , 2) + ")", mouseX - 48, mouseY + 25);
     break;
   }
  }
  
  //draw plot labels
  fill(0);
  textFont(f, 14);
  textAlign(CENTER);
  text(xLabel, plotOriginX + plotWidth / 2, plotOriginY + plotHeight + 23);
  text(xMax, plotOriginX + plotWidth - plotMarginX, plotOriginY + plotHeight + 23);
  text(xMin, plotOriginX + plotMarginX, plotOriginY + plotHeight + 23);
  textAlign(RIGHT);
  text(yLabel, plotOriginX - 10, plotOriginY + plotHeight / 2);
  text(yMax, plotOriginX - 10, plotOriginY + plotMarginY + 6);
  text(yMin, plotOriginX - 10, plotOriginY + plotHeight - plotMarginY + 6);
    
  // if user press a button
  if (mousePressed) {
    for (int i = 0; i < columnCount; i++) {
      if (mouseX > xButtons[i].x && mouseX < xButtons[i].x + buttonWidth && mouseY > xButtons[i].y && mouseY < xButtons[i].y + buttonHeight) {
        xButtons[xColumn].select();
        xButtons[i].select();
        xColumn = i;
        updatePlot();
      }
      if (mouseX > yButtons[i].x && mouseX < yButtons[i].x + buttonWidth && mouseY > yButtons[i].y && mouseY < yButtons[i].y + buttonHeight) {
        yButtons[yColumn].select();
        yButtons[i].select();
        yColumn = i; 
        updatePlot();
      }
    }
  }
}
