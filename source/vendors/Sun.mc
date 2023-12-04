using Toybox.Math;
using Toybox.Lang;
using Toybox.Position;
using Toybox.System;
using Toybox.Time as T;
using Toybox.Time.Gregorian;
using Toybox.Weather;
using Keg.Time;

module Keg {
	module Sun {
		class SunNextEventInfo {
			public var minutes = 0;
			public var hours = 0;
			public var event = :sunrise;

			public function asString() {
				return self.hours + "h " + self.minutes + "m";
			}
		}

		class SunEventInfo {
			public var minute = 0;
			public var hour = 0;
			public var degree = 0;

			public function asString(is24Hour as Lang.Boolean or Null) {
				return Time.format(self.hour, self.minute, is24Hour);
			}
		}

		class SunInfo {
			public var nextEvent as Sun.SunNextEventInfo;
			public var sunrise as Sun.SunEventInfo;
			public var sunset as Sun.SunEventInfo;
			public var tomorrow = Sun.SunEventInfo;
      
      function initialize() {
        self.nextEvent = new Sun.SunNextEventInfo();
        self.sunrise = new SunEventInfo();
        self.sunset = new SunEventInfo();
        self.tomorrow = new SunEventInfo();
      }

      function getInfo(position as Lang.Array<Lang.Double> or Null, moment as T.Moment) {
        if (position == null) {
          return self;
        }

        var location = new Position.Location({
          :latitude 	=> position[0],
          :longitude 	=> position[1],
          :format 		=> :radians
        });

        var sunrise = Weather.getSunrise(location, moment);
        var sunset = Weather.getSunset(location, moment);
        var sunriseTomorrow = Weather.getSunset(location, moment.add(new T.Duration(Gregorian.SECONDS_PER_DAY)));

        if (sunrise != null) {
          sunrise = Gregorian.info(sunrise, T.FORMAT_SHORT);

          self.sunrise.minute = sunrise.min;
          self.sunrise.hour = sunrise.hour;
          self.sunrise.degree = -90 - ((sunrise.hour * 60) + sunrise.min)/4;
        }

        if (sunset != null) {
          sunset = Gregorian.info(sunset, T.FORMAT_SHORT);

          self.sunset.minute = sunset.min;
          self.sunset.hour = sunset.hour;
          self.sunset.degree = -90 - ((sunset.hour * 60) + sunset.min)/4;
        }

        if (sunriseTomorrow != null) {
          sunriseTomorrow = Gregorian.info(sunriseTomorrow, T.FORMAT_SHORT);

          self.tomorrow.minute = sunriseTomorrow.min;
          self.tomorrow.hour = sunriseTomorrow.hour;
          self.tomorrow.degree = -90 - ((sunriseTomorrow.hour * 60) + sunriseTomorrow.min)/4;
        }

        var clock = System.getClockTime();

        var currentMinutes = (clock.hour * 60) + clock.min;

        var sunriseMinutes = (self.sunrise.hour * 60) + self.sunrise.minute;
        var sunsetMinutes = (self.sunset.hour * 60) + self.sunset.minute;
        var sunriseTomorrowSinceNextMidnightMinutes = (self.tomorrow.hour * 60) + self.tomorrow.minute;

        var isBeforeSunrise = currentMinutes < sunriseMinutes;
        var isBetweenSunriseAndSunset = currentMinutes > sunriseMinutes && currentMinutes < sunsetMinutes;
        var isAfterSunset = currentMinutes > sunsetMinutes;

        var minutesUntilSunrise = 0;
        var minutesSinceSunrise = 0;
        var minutesBetweenSunriseAndSunset = sunsetMinutes - sunriseMinutes;

        if (isBeforeSunrise) {
          minutesUntilSunrise = sunriseMinutes - currentMinutes;
        } else if (isBetweenSunriseAndSunset) {
          minutesSinceSunrise = currentMinutes - sunriseMinutes;
        } else if (isAfterSunset) {
          minutesUntilSunrise = (1440 - currentMinutes) + sunriseTomorrowSinceNextMidnightMinutes;
        }

        var hours = 0;
        var minutes = 0;

        if (isBetweenSunriseAndSunset) {
          var minutesUntilSunset = (minutesBetweenSunriseAndSunset - minutesSinceSunrise).abs();

          hours = ((minutesUntilSunset * 60)/3600).abs();
          minutes = Math.round((((minutesUntilSunset / 60.0) - hours.toNumber()) * 60).abs()).toNumber();

          self.nextEvent.event = :sunset;
        } else {
          hours = ((minutesUntilSunrise * 60)/3600).abs();
          minutes = Math.round((((minutesUntilSunrise / 60.0) - hours.toNumber()) * 60).abs()).toNumber();

          self.nextEvent.event = :sunrise;
        }

        self.nextEvent.hours = hours;
        self.nextEvent.minutes = minutes;
        return self;
      }
		}
	}
}
