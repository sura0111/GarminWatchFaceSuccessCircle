using Toybox.System;
using Toybox.Lang;

module Keg {
  module Time {
    function format(
      hour as Lang.Number or Null,
      minute as Lang.Number or Null,
      is24Hour as Lang.Boolean or Null
    ) {
      if (hour == null || minute == null) {
        return "--:--";
      }

      hour = is24Hour == true || is24Hour == null
                 ? hour
                 : (hour > 12 ? hour - 12 : hour);

      return hour.format(hour < 10 ? "%02d" : "%d") + ":" +
             minute.format(minute < 10 ? "%02d" : "%d");
    }
  }
}
