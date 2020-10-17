Timer timer = new Timer();

class Timer {
  int time;
  int duration;
  Timer() {
    duration = 100;
    reset();
  }
  void reset() {
    time = millis() + duration;
  }
  boolean alarm() {
    if ( millis() > time ) {
      time = millis() + duration;
      return true;
    }
    return false;
  }
}
