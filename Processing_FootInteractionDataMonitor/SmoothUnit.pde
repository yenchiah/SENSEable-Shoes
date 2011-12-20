class SmoothUnit {
  int condition;
  int index;
  int total;
  int preData;
  int nowData;
  int[] readings;
  int window;
  
  SmoothUnit(int w) {
    window = w;
    condition = 0;
    index = 0;
    total = 0;
    preData = 0;
    nowData = 0;
    readings = new int[window];
    for(int i=0; i<window; i++)
    {
      readings[i] = 0;
    }
  }
  
  void SmoothData(int s)
  {
    
    total = total - readings[index];
    readings[index] = s;
    total +=readings[index];
    index++;

    if (index>=window)
      index = 0;

    nowData = total / window;
  }
}
