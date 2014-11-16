// Dave, Aditya

Cell[][] grid;
int rows, cols; 


void setup()
{
  
  size(160, 160); 
  ReadFile test = new ReadFile("test.nrrd");
  test.populateMeta();
  test.populateValues();
  test.printLines();
  
  rows = test.sizeX; 
  cols = test.sizeY; 
  grid = new Cell[cols][rows];
  for (int i = 0; i < rows; i++) 
  {
    for (int j = 0; j < cols; j++)
    {
      // Initialize each object
      float colorValue = test.cells[i][j];
      grid[i][j] = new Cell(i*20,j*20, 20, 20, colorValue );
    }
  }
  
}


void draw()
{
  for (int i = 0; i < cols; i++)
  {
    for (int j = 0; j < rows; j++)
    {
      grid[i][j].display();
    }
  }
}


//---------------------------------------------------------------------------------------------------------

class ReadFile{

   String fileName; 
   String lines[];
   String values[][];
   float cells[][]; 
   
   public ReadFile(String fileName)
   {
     this.fileName = fileName; 
     this.lines = loadStrings(this.fileName);  
   }
   
   int sizeX; 
   int sizeY;
   int dimension; 
   String encoding;
   String type; 

  
  public void printLines()
  {
//    for(int i=0; i<lines.length; i++)
//    {
//      println(lines[i]); 
//    }
  println(this.type + " " + this.dimension + " " + sizeX + " " + sizeY + " " + this.encoding );  

  for(int i=0; i<this.sizeX; i++)
  {
    for(int j=0; j<this.sizeY; j++)
    {
       print(this.cells[i][j] + " ");
    }
    println();
  }

}

  
  public void populateMeta()
  {
    // first all the metadata
    for(int i=0; i<lines.length; i++)
   {
     
     if(lines[i].startsWith("NRRD") || lines[i].startsWith("#"))
     {
       // do nothing
       continue; 
     }
     
     if(lines[i].startsWith("type"))
     {
       this.type = lines[i].split(":")[1].trim();
     }
     
     if(lines[i].startsWith("dimension"))
     {
       String d = lines[i].split(":")[1].trim();
       this.dimension = Integer.parseInt(d); 
     }
     
     if(lines[i].startsWith("sizes"))
     {
       String sizes = lines[i].split(":")[1].trim();
       String y = sizes.split(" ")[0]; 
       String x = sizes.split(" ")[1];
       
       this.sizeX = Integer.parseInt(x); 
       this.sizeY = Integer.parseInt(y); 
     }
     
     if(lines[i].startsWith("encoding"))
     {
       this.encoding = lines[i].split(":")[1].trim();
     }
     
   } 
   
  }
  
  
  public void populateValues()
  {
    
    this.values = new String[this.sizeX][this.sizeY]; 
    // skip to startingLine and start reading 
    int startingLine = 6; 
   
   String temp[] = new String[this.lines.length - startingLine]; 
   int tempL = 0; 
   for(int i=startingLine; i<this.lines.length; i++)
   {
     temp[tempL++] = this.lines[i];
   }
   
    int count = 0; 
      for(int i=0; i<this.sizeX; i++)
      {
        for(int j=0; j<this.sizeY; j++)
        {
          // this.values[i][j] = temp[(j*this.sizeX) + i];
          if(count == temp.length) break; 
          this.values[i][j] = temp[count];
          count++;   
        }
      }
     
   this.cells = new float[this.sizeX][this.sizeY];
   for(int i=0; i<this.sizeX; i++)
   {
     for(int j=0; j<this.sizeY; j++)
     {
       this.cells[i][j] = Float.parseFloat(this.values[i][j]);
     }
   }
     
  }
  

}


//------------------------------------------------------------------------------------


// A Cell object
class Cell {
  // A cell object knows about its location in the grid as well as its size with the variables x,y,w,h.
  float x,y;   // x,y location
  float w,h;   // width and height
  float fillColor; 

  // Cell Constructor
  Cell(float tempX, float tempY, float tempW, float tempH, float fillColor) 
  {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    this.fillColor = fillColor; 
  } 
  

  void display() {
    stroke(255);
    fill(this.fillColor%255);
    rect(x,y,w,h); 
  }
}

