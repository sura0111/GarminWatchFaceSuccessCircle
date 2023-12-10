import Toybox.System;
import Toybox.Lang;
import Toybox.Time;
using Toybox.Time.Gregorian as Date;

module Sura {
  module Datetime {
    var is24Hour as Boolean = false;
    var clockTime as System.ClockTime or Null = null;

    function init() {
      self.is24Hour = System.getDeviceSettings().is24Hour;
      self.clockTime = System.getClockTime();
    }

    function getAmPm() as String {
      if (clockTime == null) {
        return "";
      }
      return self.is24Hour ? "" : (clockTime.hour >= 12 && clockTime.hour < 24 ? "PM" : "AM");
    }

    function getTimeText() as String {
      if (clockTime == null) {
        return "";
      }

      var hour = self.is24Hour ? clockTime.hour : (clockTime.hour % 12 == 0 ? 12 : clockTime.hour % 12);
      var timeText = Lang.format("$1$:$2$", [hour.format("%02d"), clockTime.min.format("%02d")]);

      return timeText;
    }

    function getDateText() as String {
      var now = Time.now();
      var date = Date.info(now, Time.FORMAT_LONG);
      var dateText = Lang.format("$1$ $2$ ($3$)", [ date.month, date.day, date.day_of_week ]);

      return dateText;
    }

    function getSecondsText() as String {
      if (clockTime == null) {
        return "";
      }

      var secondsText = Lang.format("$1$", [clockTime.sec.format("%02d")]);

      return secondsText;
    }
  }
}
