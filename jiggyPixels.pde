import java.io.FileInputStream;

FileInputStream fs;

byte[] bytes;
byte[] pixelData;
int areaSizeW;

int f = 2;
int fileSize;
String fname;

void setup() {
  switch(f) {
    case 0: // image1.pntg
      fileSize = 8028;
      fname = "C:\\Users\\AHS Student\\Documents\\Processing\\jiggyPixels\\Untitled1.pntg";
      break;
    case 1: // test.pntg
      fileSize = 2536;
      fname = "C:\\Users\\AHS Student\\Documents\\Processing\\jiggyPixels\\test.pntg";
      break;
    case 2: // wHeader.pntg
      fileSize = 8038;
      fname = "C:\\Users\\AHS Student\\Documents\\Processing\\jiggyPixels\\wHeader.pntg";
      break;
  }
  // 576 x 720px 1bit per pixel
  size(576, 720);
  background(255, 0, 0);
  
  areaSizeW = width;
  bytes = new byte[fileSize];
  try {
    fs = new FileInputStream(new File(fname));
    fs.read(bytes);
  } catch(Exception e) {
    System.out.println(e);
  }
  
  pixelData = new byte[720 * 72]; // 2 for good measure
  for(int i = 0; i < pixelData.length; i++) {
    pixelData[i] = 0;
  }
  
  frameRate(10);
}

void unpackAndShow(int start) {
  int pdIndex = 0;
  int HEADER = 0;
  int UNPACKING = 1;
  int LITERAL = 2;
  int state = HEADER;
  int header = 0;
  
  for(int i = start; i < fileSize - start; i++) {
    if(state == HEADER) {
      header = bytes[i];
      if(header < 0) {
        header = 1 - header; // get the number of repeats
        state = UNPACKING;
        if(i < 600) {
          print("Repeat byte " + header + " times. ");
        }
      } else {
        header += 1;
        //if(header > 72) {
        //  print("Header greater than 72");
        //}
        if(i < 600) {
          print(header + " literal bytes. ");
        }
        
        state = LITERAL;
      }
    } else if(state == UNPACKING) {
      for(int j = 0; j < header; j++) {
        pixelData[pdIndex] = bytes[i];
        pdIndex++;
      }
      header = 0;
      state = HEADER;
    } else if(state == LITERAL) {
      // given the number of literal bytes
      pixelData[pdIndex] = bytes[i];
      pdIndex++;
      header--;
      if(header == 0) {
        state = HEADER;
      }
    }
  }
  //for(int i = 0; i < 100; i++) {
  //  print(pixelData[i]);
  //  print(", ");
  //}
  loadPixels();
  // each line in the pixels thingo
  
  for(int i = 0; i < pixels.length / width; i++) {
    for(int j = 0; j < width / 8; j++) {
      for(int k = 0; k < 8; k++) {
        color c = 0xff000000;
        if((pixelData[(width / 8) * i + j] & (128 >> k)) == 0) {
          c = 0xffffffff;
        }
        pixels[width * i + j * 8 + k] = c;
      }
    }
  }
  //for(int i = 0; i < pixels.length / 576; i++) {
  //  // only go to the little width
  //  for(int w = 0; w < (areaSizeW / 8); w++) { // 576 / 8 == 72
  //    for(int j = 0; j < 8; j++) {
  //      int pos = 1 << j;
  //      if((i * areaSizeW + 8 * w + j) < pixelData.length) {
  //        int bit = pixelData[i * areaSizeW + 8 * w + j] & pos; // get the jth bit
  //        if(bit == 0) { // inverted because of course
  //          pixels[i * width + 8 * w + j] = 0xffffffff;
  //        }
  //      } else {
  //        //print(i * areaSizeW + 8 * w + j - pixelData.length);
  //        //print(" over. areaSizeW = ");
  //        //print(areaSizeW);
  //        //print(". width = ");
  //        //print(width);
  //        //print(".\n");
  //      }
  //    }
  //  }
  //}
  updatePixels();
}

int start = 512;
boolean inc = true;

void draw() {
  if(inc) {
    //String str = "";
    //for(int i = 0; i < bytes.length; i++) {
    //  str += hex(bytes[i]) + " ";
    //  if(i % 16 == 15) {
    //    System.out.println(str);
    //    str = "";
    //  }
    //}
    background(255, 0, 0);
    inc = false;
    unpackAndShow(start);
  }
}

void keyPressed() {
  if(key == 'n') {
    start++;
    inc = true;
  }
  if(key == 'N') {
    start--;
    inc = true;
  }
  if(key == '-') {
    areaSizeW--;
    inc = true;
  }
  return;
}
