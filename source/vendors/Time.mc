using Toybox.System;
using Toybox.Lang;

module Keg {
  module Time {
    function format(
      hour as Lang.Number or Null,
      minute as Lang.Number or Null,
      is24Hour as Lang.Boolean or Null
    ) as Lang.String {
      if (hour == null || minute == null) {
        return "--:--";
      }

      var newHour = (is24Hour == false) ? (hour > 12 ? hour - 12 : hour) : hour;

      return newHour.format(newHour < 10 ? "%02d" : "%d") + ":" +
             minute.format(minute < 10 ? "%02d" : "%d");
    }
  }
}
