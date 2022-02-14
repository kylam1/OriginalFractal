Snowflake[] snow = new Snowflake[10];
public float snowTarget, snowHeight, snowColor;
public float[] cloudX, cloudY, cloudWide, cloudTall;
public int numClouds;
public float grassHeight;
public ArrayList <Float> grassHeights = new ArrayList <Float> ();
public boolean wPressed, sPressed;
public int radius;

public void setup() {
  size(1000,1000);
  background(16, 147, 173);
  snowTarget = 0;
  snowColor = 210;
  
  numClouds = 35;
  cloudX = new float[numClouds+1];
  cloudY = new float[numClouds+1];
  cloudWide = new float[numClouds+1];
  cloudTall = new float[numClouds+1];
  for(int i = 0; i < numClouds + 1; i++) {
    cloudX[i] = (float)(Math.random()*width);
    cloudY[i] = (float)(Math.random()*30);
    cloudWide[i] = (float)(Math.random()*50) + 250;
    cloudTall[i] = (float)(Math.random()*30) + 60;
  }
  
  for(int i = 0; i < 300; i++)
    grassHeights.add(((float)(Math.random()*20) + 30));
  
  int myX = (int)(Math.random() * 20);
  for(int i = 0; i < snow.length; i++) {
    snow[i] = new Snowflake(myX, (int)(Math.random()*height/4), (int)(Math.random()*5) + 7);  
    myX += (int)(Math.random() * 40) + 90;
  }
  
  radius = 10; //Initial radius of black hole
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public void draw() {
  background(16, 147, 173);
  
  noStroke();
  fill(125, 82, 1);
  rect(0, 900, width, 100);
  grass(width/2, width/4, grassHeights, 0);
  
  cloud(cloudX, cloudY, cloudWide, cloudTall, 0);
  
  noStroke();
  fill(0);
  if(wPressed)
    radius++;
  if(sPressed && radius > -50)
    radius--;
  if(radius > 0)
    ellipse(500, 400, radius, radius);
  if(radius > 0) {
    for(int i = 1; i <= 50; i++) {
      fill(0, 0, 0, 100 - i*7/5);
      ellipse(500, 400, radius+i*2, radius+i*2);
    }
  }
  else {
    for(int i = 1; i < 50 + radius; i++) {
      fill(0, 0, 0, 100 - i*11/6);
      ellipse(500, 400, 100 - ((50-i)-radius), 100 - ((50-i)-radius));
    }
  }
  
  strokeWeight(4 + (int)(radius/50));
  stroke(0);
  line(250, 800, 250, 940);
  tree1(250, 800, 25, 270);
  strokeWeight(4 + (int)(radius/50));
  line(750, 800, 750, 940);
  tree2(750, 800, 25, 270);
  
  fill(snowColor);
  noStroke();
  if(snowHeight < snowTarget)
    snowHeight+=0.1;
  rect(0, height - snowHeight, width, snowHeight);
  
  for(int i = 0; i < snow.length; i++) {
    if(dist(snow[i].getX(), snow[i].getY(), 500, 400) < radius + snow[i].getLen() + 50) {
      snow[i].incOpacity();
      snow[i].incSpeed();
      radius++;
    }
    snow[i].fall();
    snow[i].show();
  }
}
    
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Snowflake {
  private float x, y, rad;
  private float len, speed;
  private int opacity; 
  public Snowflake(int myX, int myY, int radius) {
    x = myX;
    y = myY;
    rad = radius;
    len = radius * 6.5/1.5;
    speed = (float)(Math.random()*3) + 1;
    opacity = 255;
  }
  
  public float getX() {return x;}
  public float getY() {return y;}
  public float getLen() {return len;}
  public void incOpacity() {opacity-=10;}
  public void incSpeed() {speed+=0.2;}
  
  public void show() {
    fill(255, opacity);
    stroke(255, opacity);
    noStroke();
    beginShape();
      vertex(x, y - rad);
      vertex(x + (float)Math.sqrt(3)*rad/2, y - rad/2);
      vertex(x + (float)Math.sqrt(3)*rad/2, y + rad/2);
      vertex(x, y + rad);
      vertex(x - (float)Math.sqrt(3)*rad/2, y + rad/2);
      vertex(x - (float)Math.sqrt(3)*rad/2, y - rad/2);
    endShape();
    Branch(x, y - rad, len, 270);
    Branch(x + (float)Math.sqrt(3)*rad/2, y - rad/2, len, 330);
    Branch(x + (float)Math.sqrt(3)*rad/2, y + rad/2, len, 30);
    Branch(x, y + rad, len, 90);
    Branch(x - (float)Math.sqrt(3)*rad/2, y + rad/2, len, 150);
    Branch(x - (float)Math.sqrt(3)*rad/2, y - rad/2, len, 210);
  }
  
  private void Branch(float x, float y, float rad, float angle) {
    float startX = x;
    float startY = y;
    float endX = (float)(x + (rad+10)*Math.cos(angle*PI/180));
    float endY = (float)(y + (rad+10)*Math.sin(angle*PI/180));
    strokeWeight(1);
    stroke(255, opacity);
    line(startX, startY, endX, endY);
    branches(startX, startY, endX, endY, rad, angle);
  }
  
  private void branches(float x1, float y1, float x2, float y2, float len, float ang) {
    strokeWeight(1);
    stroke(255, opacity);
    float avgX = (x1 + x2)/2;
    float avgY = (y1 + y2)/2;
    if(len <= 15) {
      line(avgX, avgY, (float)(avgX + 2*len/3*Math.cos((ang+55) * PI/180)), (float)(avgY + 2*len/3*Math.sin((ang+55) * PI/180)));
      line(avgX, avgY, (float)(avgX + 2*len/3*Math.cos((ang-55) * PI/180)), (float)(avgY + 2*len/3*Math.sin((ang-55) * PI/180)));
    }
    else {
      line(avgX, avgY, (float)(avgX + 2*len/3*Math.cos((ang+55) * PI/180)), (float)(avgY + 2*len/3*Math.sin((ang+55) * PI/180)));
      line(avgX, avgY, (float)(avgX + 2*len/3*Math.cos((ang-55) * PI/180)), (float)(avgY + 2*len/3*Math.sin((ang-55) * PI/180)));
      branches(x1, y1, avgX, avgY, 2*len/3, ang);
      branches(avgX, avgY, x2, y2, 2*len/3, ang);
    }
  }
  
  public void fall() {
    if((dist(x, y, 500, 400) < radius + len + 50)) {
      if(x < 500) {
        x+=speed*Math.cos(atan(Math.abs((500-x))/Math.abs((400-y))));
        if(speed*Math.cos(atan(Math.abs((500-x))/Math.abs((400-y)))) < 0.1)
          x+=8;
      }
      else {
        x-=speed*Math.cos(atan(Math.abs((500-x))/Math.abs((400-y))));
        if(speed*Math.cos(atan(Math.abs((500-x))/Math.abs((400-y)))) < 0.1)
          x-=8;
      }  
      if(y > 400)
        y-=speed+1;
    }
    if((dist(x, y, 500, 400) < radius + len + 50) && y < 400) {
      y+=speed;
    }
    else
      y+=speed;
    if(opacity < 20) {
      y = (int)(-1 - len);
      x = (int)(Math.random()*950) + 30;
      speed = (float)(Math.random()*3) + 1;
      opacity = 255;
    }
    if(y - len - 10 > height) {
      y = (int)(-1 - len);
      x = (int)(Math.random()*950) + 30;
      speed = (float)(Math.random()*3) + 1;
      if(snowColor < 255)
        snowColor++;
      snowTarget+=rad/3;    
      opacity = 255;
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public void cloud(float[] x, float[] y, float[] wide, float[] tall, int count) {
  noStroke();
  fill(126, 135, 150, 150);
  if(count == numClouds)
    ellipse(x[count], y[count], wide[count], tall[count]);
  else {
    ellipse(x[count], y[count], wide[count], tall[count]);
    cloud(x, y, wide, tall, count+1);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public void grass(int x, int add, ArrayList<Float> tall, int count) {
  strokeWeight(3);
  stroke(132, 192, 17);
  line(500, 910, 500, 910 - ((float)(Math.random()*20) + 30));
  line(495, 910, 495, 910 - ((float)(Math.random()*20) + 30));
  line(505, 910, 505, 910 - ((float)(Math.random()*20) + 30));
  if(add < 5) {
    line(x + add, 910, x + add, 910 - tall.get(count));
    line(x - add, 910, x - add, 910 - tall.get(count + 1));
  }
  else {
    line(x + add, 910, x + add, 910 - tall.get(count));
    line(x - add, 910, x - add, 910 - tall.get(count + 1));
    grass(x + add, add/2, tall, count + 2);
    grass(x - add, add/2, tall, count + 3);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public void tree1(float startX, float startY, float len, float ang) {
  float endX = startX + (float)(len*Math.cos(ang*PI/180));
  float endY = startY + (float)(len*Math.sin(ang*PI/180));
  float tempRad = radius;
  if(tempRad < 0)
    tempRad = 0;
  strokeWeight(3);
  stroke(0);
  if(len < 15)
    strokeWeight(2);
  if(len < 10)
    line(startX, startY, endX, endY);
  else {
    line(startX, startY, endX, endY);
    tree1(endX, endY, len-2, ang-30 + tempRad/10);
    tree1(endX, endY, len-2, ang+30 + tempRad/10);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public void tree2(float startX, float startY, float len, float ang) {
  float endX = startX + (float)(len*Math.cos(ang*PI/180));
  float endY = startY + (float)(len*Math.sin(ang*PI/180));
  float tempRad = radius;
  if(tempRad < 0)
    tempRad = 0;
  strokeWeight(3);
  stroke(0);
  if(len < 15)
    strokeWeight(2);
  if(len < 10)
    line(startX, startY, endX, endY);
  else {
    line(startX, startY, endX, endY);
    tree2(endX, endY, len-2, ang-30 - tempRad/10);
    tree2(endX, endY, len-2, ang+30 - tempRad/10);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public void keyPressed() {
  if(key == 'w')
    wPressed = true;
  if(key == 's')
    sPressed = true;
}

public void keyReleased() {
  if(key == 'w')
    wPressed = false;
  if(key == 's')
    sPressed = false;
}
