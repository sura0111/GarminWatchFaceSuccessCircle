import Toybox.SensorHistory;
import Toybox.Lang;

module Sura {
  module BodyBattery {
    function getBodyBatteryHistoryIterator() as SensorHistory.SensorHistoryIterator or Null {
      if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory)) {
          // Set up the method with parameters
          return Toybox.SensorHistory.getBodyBatteryHistory({ :period => 1 });
      }
      return null;
    }

    function getBodyBattery() as Number {
      var bodyBatteryHistory = self.getBodyBatteryHistoryIterator();
      if (bodyBatteryHistory == null) {
        return 0;
      }

      var bodyBatterySample = bodyBatteryHistory.next();
      
      if (bodyBatterySample == null) {
        return 0;
      }

      var bodyBatteryData = bodyBatterySample.data;

      if (bodyBatteryData != null) {
        return bodyBatteryData.toNumber();
      }

      return 0;
    }
  }
}
