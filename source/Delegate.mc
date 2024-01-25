import Toybox.WatchUi;
import Toybox.Time;
import Toybox.System;
import Toybox.Application;

class Delegate extends WatchUi.WatchFaceDelegate {
  function initialize() {
    WatchFaceDelegate.initialize();
  }
  function onPress(powerInfo) {
    store.canDisplaySecond = !Application.Properties.getValue(storeName.canDisplaySecond);
    Application.Properties.setValue(storeName.canDisplaySecond, store.canDisplaySecond);

    return true;
  }
}
