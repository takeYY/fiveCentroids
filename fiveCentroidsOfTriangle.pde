Triangle[] tris;
float d = 10;        //三角形の頂点と五心の円の直径
float a,b,c;         //三角形の辺
PVector va,vb,vc;    //三角形の頂点の位置ベクトル
float A,B,C;         //三角形のそれぞれの内角
boolean centerLine,circumLine,innerLine,orthoLine,excenterLine;

void setup()
{
  size(1000,1000);
  strokeWeight(2);
  tris = new Triangle[3];
  tris[0] = new Triangle(random(width),random(height));
  tris[1] = new Triangle(random(width),random(height));
  tris[2] = new Triangle(random(width),random(height));
  centerLine = false;
  circumLine = false;
  innerLine = false;
  orthoLine = false;
  excenterLine = false;
}

void draw()
{
  background(255);
  //OA,OB,OCの位置ベクトル,　辺a,b,c,　角A,B,Cを計算
  setPoint();
  //重心の描画(赤),　最後の引数は線を描画するか否か
  drawCenter(va,vb,vc,centerLine);
  //外心の描画(緑),　最後の引数は線を描画するか否か
  drawCircum(va,vb,vc,circumLine);
  //内心の描画(青),　最後の引数は線を描画するか否か
  drawInner(va,vb,vc,innerLine);
  //垂心の描画(水),　最後の引数は線を描画するか否か
  drawOrtho(va,vb,vc,orthoLine);
  //傍心の描画(紫),　最期の引数は線を描画するか否か
  drawExcenter(va,vb,vc,excenterLine);
  //三角形の描画
  drawTriangle();
}

void keyPressed()
{
  switch(key)
  {
    //重心の線を描画するスイッチ
    case 'j':
    if(centerLine)
    {
      centerLine = false;
    }else
    {
      centerLine = true;
    }
    break;
    
    //外心の線を描画するスイッチ
    case 'g':
    if(circumLine)
    {
      circumLine = false;
    }else
    {
      circumLine = true;
    }
    break;
    
    //内心の線を描画するスイッチ
    case 'n':
    if(innerLine)
    {
      innerLine = false;
    }else
    {
      innerLine = true;
    }
    break;
    
    //垂心の線を描画するスイッチ
    case 's':
    if(orthoLine)
    {
      orthoLine = false;
    }else
    {
      orthoLine = true;
    }
    break;
    
    //傍心の線を描画するスイッチ
    case 'b':
    if(excenterLine)
    {
      excenterLine = false;
    }else
    {
      excenterLine = true;
    }
    break;
  }
}

//左クリックを押し続けることで三角形の頂点の座標を変更可能
void mouseDragged()
{
  for(int i=0; i<3; i++)
  {
    float distance = dist(mouseX,mouseY,tris[i].x,tris[i].y);
    if(distance<=d*5)
    {
      tris[i].x = mouseX;
      tris[i].y = mouseY;
      break;
    }
  }
}

void drawTriangle()
{
  for(int i=0; i<3; i++)
  {
    fill(0);
    String vertex = "";
    if(i==0)
    {
      vertex = "A";
    }else if(i==1)
    {
      vertex = "B";
    }else
    {
      vertex = "C";
    }
    text(vertex,tris[i].x+10,tris[i].y-10);
    tris[i].drawPoint();
    float x1,x2,y1,y2;
    x1 = tris[i].x;
    y1 = tris[i].y;
    if(i==2)
    {
      x2 = tris[0].x;
      y2 = tris[0].y;
    }else
    {
      x2 = tris[i+1].x;
      y2 = tris[i+1].y;
    }
    tris[i].drawLine(x1,y1,x2,y2);
  }
}

void setPoint()
{
  va = new PVector(tris[0].x,tris[0].y);
  vb = new PVector(tris[1].x,tris[1].y);
  vc = new PVector(tris[2].x,tris[2].y);
  a = dist(vb.x,vb.y,vc.x,vc.y);
  b = dist(va.x,va.y,vc.x,vc.y);
  c = dist(va.x,va.y,vb.x,vb.y);
  A = calcAngle(vb.copy().sub(va),vc.copy().sub(va));
  B = calcAngle(vc.copy().sub(vb),va.copy().sub(vb));
  C = calcAngle(va.copy().sub(vc),vb.copy().sub(vc));
}

//三角形の重心を赤丸で表示
void drawCenter(PVector va,PVector vb,PVector vc,boolean visible)
{
  PVector center;
  center = (va.copy().add(vb.copy().add(vc))).copy().div(3);
  
  fill(255,0,0);
  noStroke();
  text("G",center.x+10,center.y-10);
  ellipse(center.x,center.y,d,d);
  stroke(255,0,0);
  if(visible)
  {
      PVector mab = (va.copy().add(vb)).div(2);
      PVector mbc = (vb.copy().add(vc)).div(2);
      PVector mca = (vc.copy().add(va)).div(2);
      line(va.x,va.y,mbc.x,mbc.y);
      line(vb.x,vb.y,mca.x,mca.y);
      line(vc.x,vc.y,mab.x,mab.y);
  }
}

//三角形の外心を緑丸で表示
void drawCircum(PVector va,PVector vb,PVector vc,boolean visible)
{
  PVector circum;
  float deno = sin(2*A) + sin(2*B) + sin(2*C);
  PVector moleA = va.copy().mult(sin(2*A));
  PVector moleB = vb.copy().mult(sin(2*B));
  PVector moleC = vc.copy().mult(sin(2*C));
  PVector mole = moleA.copy().add(moleB.copy().add(moleC));
  circum = mole.div(deno);
  
  float dist = dist(circum.x,circum.y,va.x,va.y);
  
  //外心
  fill(0,255,0);
  noStroke();
  text("O",circum.x+10,circum.y-10);
  ellipse(circum.x,circum.y,d,d);
  
  //外接円
  fill(255,255,255,0);
  stroke(0,255,0);
  ellipse(circum.x,circum.y,dist*2,dist*2);
  if(visible)
  {
    PVector mab = (va.copy().add(vb)).div(2);
    PVector mbc = (vb.copy().add(vc)).div(2);
    PVector mca = (vc.copy().add(va)).div(2);
    line(circum.x,circum.y,mbc.x,mbc.y);
    line(circum.x,circum.y,mca.x,mca.y);
    line(circum.x,circum.y,mab.x,mab.y);
  }
}

//三角形の内心を青丸で表示
void drawInner(PVector va,PVector vb,PVector vc,boolean visible)
{
  PVector moleA = va.copy().mult(a);
  PVector moleB = vb.copy().mult(b);
  PVector moleC = vc.copy().mult(c);
  PVector mole = moleA.copy().add(moleB.copy().add(moleC));
  float deno = a + b + c;
  PVector inner = mole.div(deno);
  float r = (2*calcS())/(a+b+c);
  
  //内心
  fill(0,0,255);
  noStroke();
  text("I",inner.x+10,inner.y-10);
  ellipse(inner.x,inner.y,d,d);
  
  //内接円
  fill(255,255,255,0);
  stroke(0,0,255);
  ellipse(inner.x,inner.y,r*2,r*2);
  if(visible)
  {
    //各頂点から内心までを引いた線
    line(va.x,va.y,inner.x,inner.y);
    line(vb.x,vb.y,inner.x,inner.y);
    line(vc.x,vc.y,inner.x,inner.y);
    
    //内心(inner)から各辺(ab,bc,ca)に対して引いた垂線
    drawPerpendicularLine(inner,va,vb);
    drawPerpendicularLine(inner,vb,vc);
    drawPerpendicularLine(inner,vc,va);
  }
}

//三角形の垂心を水丸で表示
void drawOrtho(PVector va,PVector vb,PVector vc,boolean visible)
{
  PVector moleA = va.copy().mult(tan(A));
  PVector moleB = vb.copy().mult(tan(B));
  PVector moleC = vc.copy().mult(tan(C));
  PVector mole = moleA.copy().add(moleB.copy().add(moleC));
  float deno = tan(A) + tan(B) + tan(C);
  PVector ortho = mole.div(deno);
  
  //垂心
  fill(0,255,255);
  noStroke();
  text("H",ortho.x+10,ortho.y-10);
  ellipse(ortho.x,ortho.y,d,d);
  stroke(0,255,255);
  if(visible)
  {
    drawPerpendicularLine(ortho,va,vb);
    drawPerpendicularLine(ortho,vb,vc);
    drawPerpendicularLine(ortho,vc,va);
  }
}

//三角形の傍心を紫丸で表示
void drawExcenter(PVector va,PVector vb,PVector vc,boolean visible)
{
  for(int i=0; i<3; i++)
  {
    if(i==0)
    {
      a *= -1;
    }else if(i==1)
    {
      a *= -1;
      b *= -1;
    }else
    {
      b *= -1;
      c *= -1;
    }
    PVector moleA = va.copy().mult(a);
    PVector moleB = vb.copy().mult(b);
    PVector moleC = vc.copy().mult(c);
    PVector mole = moleA.copy().add(moleB.copy().add(moleC));
    float deno = a + b + c;
    PVector excenter = mole.div(deno);
    float r = (2*calcS())/(a+b+c);
  
    //傍心
    fill(255,0,255);
    noStroke();
    text("J"+(i+1),excenter.x+10,excenter.y-10);
    ellipse(excenter.x,excenter.y,d,d);
  
    //傍接円
    fill(255,255,255,0);
    stroke(255,0,255);
    ellipse(excenter.x,excenter.y,r*2,r*2);
    if(visible)
    {
      PVector ai = excenter.copy().add(excenter.copy().sub(va));
      PVector bi = excenter.copy().add(excenter.copy().sub(vb));
      PVector ci = excenter.copy().add(excenter.copy().sub(vc));
    
      line(va.x,va.y,ai.x,ai.y);
      line(vb.x,vb.y,bi.x,bi.y);
      line(vc.x,vc.y,ci.x,ci.y);
    }
  }
}

//v1からV2V3(ベクトル)へ引く垂線を描画する
void drawPerpendicularLine(PVector v1,PVector v2,PVector v3)
{
  PVector v2v3 = v3.copy().sub(v2);
  v2v3.normalize();
  PVector v2v1 = v1.copy().sub(v2);
  float distance = v2v3.copy().dot(v2v1);
  PVector v = v2.copy().add(v2v3.copy().mult(distance));
  line(v1.x,v1.y,v.x,v.y);
  //垂心が三角形の外側にある場合,　辺を伸ばす
  if(distance<0 || (v3.copy().sub(v2)).copy().mag()<distance)
  {
    line(v2.x,v2.y,v.x,v.y);
  }
}

float calcS()
{
  float C = radians(degrees((float)calcAngle(va.copy().sub(vc),vb.copy().sub(vc))));
  return 0.5*a*b*sin(C);
}

float calcAngle(PVector v1,PVector v2)
{
  float d = acos(v1.copy().dot(v2)/(v1.copy().mag()*v2.copy().mag()));
  return radians(degrees(d));
}

class Triangle
{
  float x;
  float y;
  
  Triangle(float x,float y)
  {
    this.x = x;
    this.y = y;
  }
  
  void drawPoint()
  {
    fill(0);
    noStroke();
    ellipse(x,y,d,d);
  }
  
  void drawLine(float x1,float y1,float x2,float y2)
  {
    stroke(0);
    line(x1,y1,x2,y2);
  }
}