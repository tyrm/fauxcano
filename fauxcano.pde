class Fauxcano {
  int setTemp, _temp;           // Temps
  char unit;                    // Temp Unit
  boolean pump, power, _heater; // Module Status
  
  PFont font;
  
  // Variables for the Illusion
  int _roomTempF   = 68;        // °
  int _roomTempC   = 20;        // °
  int _speedUpF   = 1000;       // ms per °
  int _speedUpC   = 2000;       // ms per °
  int _speedDownF = 7000;       // ms per °
  int _speedDownC = 13000;      // ms per °
  int _topF       = 446;        // °
  int _topC       = 230;        // °
  int _bottomF    = 104;        // °
  int _bottomC    = 40;         // °
  int _lastChange;
  
  Fauxcano () {
    // Load setTemp and Unit from File
    String config[] = loadStrings("fauxcano.conf");
    setTemp = int(config[0]);
    unit = config[1].charAt(0);
    println("Loaded setTemp: " + setTemp + "° " + unit);
    
    // All Modules are Off
    power   = false;
    pump    = false;
    _heater = false;
    switch (unit) {
      case 'C':
        _temp   = _roomTempC;
        break;
      case 'F':
        _temp   = _roomTempF;
        break;
    }
    
    // Load Font
    font = loadFont("AgencyFB-Reg-48.vlw");
  }
  
  void draw(int xPos, int yPos) {
    // Init "Physics"
    int speedUp   = 0;
    int speedDown = 0;
    int roomTemp  = 0;
    
    // Load "Physics"
    switch (unit) {
      case 'C':
        speedUp   = _speedUpC;
        speedDown = _speedDownC;
        roomTemp  = _roomTempC;
        break;
      case 'F':
        speedUp   = _speedUpF;
        speedDown = _speedDownF;
        roomTemp  = _roomTempF;
        break;
    }
    
    // Do "Physics"
    if (power) {
      // Power On: Mainteain setTemp
      if (_temp < setTemp) {
        _heater = true;
        if (millis() > _lastChange + speedUp) {
          _temp++;
          _lastChange = millis();
        }
      } else if (_temp > setTemp) {
        _heater = false;
        if (millis() > _lastChange + speedDown) {
          _temp--;
          _lastChange = millis();
        }
      } else {
        _heater = false;
      }
    } else {
      _heater = false;
      // Power Off: Maintain roomTemp
      if ((_temp > roomTemp) && (millis() > _lastChange + speedDown)) {
        _temp--;
        _lastChange = millis();
      }
      else {
      }
    }
    
    // Draw The Volacno
    ellipseMode(CENTER);
    noStroke();
    fill(40);
    rect(xPos+10, yPos+140, 180, 50);
    
    fill(127);
    rect(xPos+5, yPos+120, 190, 20);
    rect(xPos+75, yPos+10, 50, 110);
    triangle(xPos+75, yPos+30, xPos+75, yPos+120, xPos+5, yPos+120);
    triangle(xPos+125, yPos+30, xPos+125, yPos+120, xPos+195, yPos+120);
    
    fill(40);
    rect(xPos+44, yPos+100, 112, 20);
    rect(xPos+80, yPos+50, 40, 50);
    triangle(xPos+80, yPos+50, xPos+80, yPos+102, xPos+38, yPos+102);
    triangle(xPos+120, yPos+50, xPos+120, yPos+102, xPos+162, yPos+102);
    ellipse(xPos+100, yPos+61, 46, 44);
    ellipse(xPos+44, yPos+110, 20, 20);
    ellipse(xPos+155, yPos+110, 20, 20);
    
    
    // Indicators
    ellipseMode(CENTER);
    stroke(0);
    
    if (power) {
      fill(0,255,0);
    } else {
      fill(0,128,0);
    }
    ellipse(xPos+50, yPos+165, 40, 40);
    
    if (_heater) {
      fill(255,255,0);
    } else {
      fill(128,128,0);
    }
    ellipse(xPos+100, yPos+165, 20, 20);
    
    if (pump) {
      fill(255,0,0);
    } else {
      fill(128,0,0);
    }
    ellipse(xPos+150, yPos+165, 40, 40);
    
    // Temps
    textFont(font, 30); 
    textAlign(CENTER, TOP);
    
    fill(255,0,0);
    text(_temp + "°" + unit, xPos+100, yPos+4+60);
    if (power) {
      fill(0,255,0);
      text(setTemp + "°" + unit, xPos+100, yPos+31+60);
    } else {
      fill(0,128,0);
      text("0° " + unit, xPos+100, yPos+31+60);
    }
  }
  
  // Power Methods
  void powerOn() {
    power = true;
    _lastChange = millis();
  }
  void powerOff() {
    power = false;
    _lastChange = millis();
  }
  void togglePower() {
    if (power) {
      power = false;
    } else {
      power = true;
    }
  }
  boolean getPower() {
    return power;
  }
  
  // Pump Methods
  void startPump() {
    if (power) {
      pump = true;
    }
  }
  void stopPump() {
    if (power) {
      pump = false;
    }
  }
  void togglePump() {
    if (power) {
      if (pump) {
        pump = false;
      } else {
        pump = true;
      }
    }
  }
  boolean getPump() {
    return pump;
  }
  
  // Temperature Methods
  int getTemp() {
    return _temp;
  }
  
  void setSetTemp(int t) {
    if (power) {
      setTemp = t;

      _lastChange = millis();
      this._updateConf();
    }
  }
  void incSetTemp() {
    if (power) {
      setTemp++;

      _lastChange = millis();
      this._updateConf();
    }
  }
  void decSetTemp() {
    if (power) {
      setTemp--;

      _lastChange = millis();
      this._updateConf();
    }
  }
  int getSetTemp() {
    return setTemp;
  }
  
  void toF() {
    if ((unit != 'F') && power) {
      setTemp = ((setTemp*9)/5)+32;
      _temp = ((_temp*9)/5)+32;
      unit = 'F';
      
      println("Switching to Imperial Units");
      
      _lastChange = millis();
      this._updateConf();
    }
  }
  void toC() {
    if ((unit != 'C') && power) {
      setTemp = ((setTemp-32)*5)/9;
      _temp = ((_temp-32)*5)/9;
      unit = 'C';
      
      println("Switching to Metric Units");
      
      _lastChange = millis();
      this._updateConf();
    }
  }
  char getUnit() {
    return unit;
  }
  
  // Private Methods
  void _updateConf() {
    String config[] = {str(setTemp),str(unit)};
    saveStrings("data/fauxcano.conf", config);
    
    println("setTemp: " + setTemp + "° " + unit);
  }
}
