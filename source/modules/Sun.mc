
import Toybox.Time;
import Toybox.System;
import Toybox.Position;
import Toybox.Lang;
import Keg.Sun;

module Sura {
  module Sun {
    var location as Array<Double> or Null = null;
    var sun as Sun.SunInfo = new Sun.SunInfo();

    function init() as Void {
      var position = Position.getInfo();
      if (position.accuracy != Position.QUALITY_NOT_AVAILABLE) {
        var pos = position.position;
        if (pos != null) {
          Sura.Sun.location = pos.toRadians();
        }
      }
    }

    function getIsNight() as Boolean {
      var clockTime = System.getClockTime();
      var minutesSinceMidnight = clockTime.hour * 60 + clockTime.min;
      var sunInfo = Sura.Sun.sun.getInfo(Sura.Sun.location, new Time.Moment(Time.now().value()));
      var isNight =
            (minutesSinceMidnight < ((sunInfo.sunrise.hour * 60) + sunInfo.sunrise.minute) ||
            minutesSinceMidnight > ((sunInfo.sunset.hour * 60) + sunInfo.sunset.minute)) as Boolean;
      return isNight;
    }
  }
}
