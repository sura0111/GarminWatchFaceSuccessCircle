import Toybox.WatchUi;
import Toybox.Time;
import Toybox.System;

class Delegate extends WatchUi.WatchFaceDelegate {
  function initialize() {
    WatchFaceDelegate.initialize();
  }
  function onPress(powerInfo) {
    store.shouldHideSecond = !store.shouldHideSecond;
    return true;
  }
}
