PImage img;

void setup() {
  size(768, 480); 
  img = loadImage("bird.jpg");
  img.resize(width, height);
  
  println("Press a number to choose a special image effect:");
  println("0: No effect (Original)");
  println("1: Sharpen");
  println("2: Blur 3x3");
  println("3: Vertical Flip");
  println("4: Horizontal Flip");
  println("5: Grayscale");
  println("6: Rotate 180 Degrees");
  println("7: Threshold");
  println("8: Brightness Change with mouseY");
}

void draw() {
  image(img, 0, 0); //Always display the modified image
}

void keyPressed() {
  if (key == '0') {
    img = loadImage("bird.jpg"); //Reload original image
    img.resize(width, height);
  } else if (key == '1') {
    sharpenEffect();
  } else if (key == '2') {
    blurEffect();
  } else if (key == '3') {
    verticalFlip();
  } else if (key == '4') {
    horizontalFlip();
  } else if (key == '5') {
    grayscaleEffect();
  } else if (key == '6') {
    rotate180();
  } else if (key == '7') {
    thresholdEffect();
  } else if (key == '8') {
    brightnessChange();
  }
}

//Sharpen effect
void sharpenEffect() {
  img.loadPixels();
  float[][] kernel = {
    {-1, -1, -1},
    {-1,  9, -1},
    {-1, -1, -1}
  };
  applyConvolution(kernel);
  img.updatePixels();
}

//Blur effect
void blurEffect() {
  img.loadPixels();
  float[][] kernel = {
    {1/9.0, 1/9.0, 1/9.0},
    {1/9.0, 1/9.0, 1/9.0},
    {1/9.0, 1/9.0, 1/9.0}
  };
  applyConvolution(kernel);
  img.updatePixels();
}

//Grayscale effect
void grayscaleEffect() {
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    color c = img.pixels[i];
    float gray = (red(c) + green(c) + blue(c)) / 3;
    img.pixels[i] = color(gray, gray, gray);
  }
  img.updatePixels();
}

//Vertical flip
void verticalFlip() {
  img.loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height / 2; y++) {
      int top = x + y * width;
      int bottom = x + (height - y - 1) * width;
      color temp = img.pixels[top];
      img.pixels[top] = img.pixels[bottom];
      img.pixels[bottom] = temp;
    }
  }
  img.updatePixels();
}

//Horizontal flip
void horizontalFlip() {
  img.loadPixels();
  for (int x = 0; x < width / 2; x++) {
    for (int y = 0; y < height; y++) {
      int left = x + y * width;
      int right = (width - x - 1) + y * width;
      color temp = img.pixels[left];
      img.pixels[left] = img.pixels[right];
      img.pixels[right] = temp;
    }
  }
  img.updatePixels();
}

//Rotate 180 degrees
void rotate180() {
  img.loadPixels();
  for (int i = 0; i < img.pixels.length / 2; i++) {
    int opposite = img.pixels.length - i - 1;
    color temp = img.pixels[i];
    img.pixels[i] = img.pixels[opposite];
    img.pixels[opposite] = temp;
  }
  img.updatePixels();
}

//Threshold effect
void thresholdEffect() {
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    color c = img.pixels[i];
    float brightness = (red(c) + green(c) + blue(c)) / 3;
    img.pixels[i] = (brightness > 128) ? color(255) : color(0);
  }
  img.updatePixels();
}

//Brightness change with mouseY
void brightnessChange() {
  float factor = map(mouseY, 0, height, 0.5, 1.5); //Adjust brightness factor
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    color c = img.pixels[i];
    float r = constrain(red(c) * factor, 0, 255);
    float g = constrain(green(c) * factor, 0, 255);
    float b = constrain(blue(c) * factor, 0, 255);
    img.pixels[i] = color(r, g, b);
  }
  img.updatePixels();
}

//Apply convolution with kernel
void applyConvolution(float[][] kernel) {
  img.loadPixels();
  PImage tempImg = img.copy();
  tempImg.loadPixels();
  int kw = kernel.length;
  int kh = kernel[0].length;
  int kOffset = kw / 2;
  
  for (int x = kOffset; x < width - kOffset; x++) {
    for (int y = kOffset; y < height - kOffset; y++) {
      float r = 0, g = 0, b = 0;
      for (int i = 0; i < kw; i++) {
        for (int j = 0; j < kh; j++) {
          int px = x + i - kOffset;
          int py = y + j - kOffset;
          color c = tempImg.pixels[px + py * width];
          r += red(c) * kernel[i][j];
          g += green(c) * kernel[i][j];
          b += blue(c) * kernel[i][j];
        }
      }
      img.pixels[x + y * width] = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
    }
  }
}
