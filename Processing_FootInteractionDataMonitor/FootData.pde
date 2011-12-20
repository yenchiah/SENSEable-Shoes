class FootData 
{
  ArrayList datas;
  int status = 0; // 0 = even; 1 = peak; 2 = valley;
  Extrema peak, valley;


  FootData() 
  {
    datas = new ArrayList();
    peak = new Extrema(50, -50);
    valley = new Extrema(-100, 100);
  }

  FootData(int peakThreshold0, int peakThreshold1, int valleyThreshold0, int valleyThreshold1)
  {
    datas = new ArrayList();
    peak = new Extrema(peakThreshold0, peakThreshold1);
    valley = new Extrema(valleyThreshold0, valleyThreshold1);
  }

  void AddDataPoint(int value)
  {
    long time = millis();
    datas.add(new FootPoint(time, value));
  }

  void UpdateExtrema()
  {
    if (this.GetDeltaValue()>peak.threshold0 && peak.start == false)
    {
      peak.extrema = false;
      peak.start = true;
    }
    if (peak.start == true)
    {
      peak.counter++;
    }
    if (peak.counter<10 && this.GetDeltaValue()<peak.threshold1 && peak.start == true)
    {
      peak.extrema = true;
      peak.start = false;
      peak.counter = 0;
    }
    else if (peak.counter>10 && peak.start == true)
    {
      peak.extrema = false;
      peak.start = false;
      peak.counter = 0;
    }
    else if (peak.start == false && peak.extrema == true)
    {
      peak.extrema = false;
      peak.counter = 0;
    }

    if (this.GetDeltaValue()<valley.threshold0 && valley.start == false)
    {
      //println(GetDeltaValue());
      valley.extrema = false;
      valley.start = true;
    }
    if(valley.start == true)
    {
       valley.counter++;
    }
    if (valley.counter<10 && this.GetDeltaValue()>valley.threshold1 && valley.start == true)
    {
      valley.extrema = true;
      valley.start = false;
      valley.counter = 0;
    }
    else if (valley.counter>10 && valley.start == true)
    {
      valley.extrema = false;
      valley.start = false;
      valley.counter = 0;
    }
    else if (valley.start == false && valley.extrema == true)
    {
      valley.extrema = false;
      valley.counter = 0;
    }
  }
  int GetDeltaValue()
  {
    if (datas.size()>1)
      return ((FootPoint)datas.get(datas.size()-1)).value - ((FootPoint)datas.get(datas.size()-2)).value;
    else
      return 0;
  }

  FootPoint GetLatestPoint()
  {
    if (datas.size()>0)
    {
      return (FootPoint)datas.get(datas.size()-1);
    }
    else
    {
      return new FootPoint(0, 0);
    }
  }

  FootPoint GetPoint(int i)
  {
    if (i>0 && i<datas.size())
    {
      return (FootPoint)datas.get(i);
    }
    else
      return new FootPoint(0, 0);
  }

  int size()
  {
    return datas.size();
  }
}

class Extrema {
  int counter;
  boolean start;
  int threshold0;
  int threshold1;
  boolean extrema;

  Extrema(int t0, int t1)
  {
    counter = 0;
    start = false;
    extrema = false;
    threshold0 = t0;
    threshold1 = t1;
  }
};

class FootPoint 
{
  long time;
  int value;

  FootPoint(long _time, int _value)
  {
    time = _time;
    value = _value;
  }
}

