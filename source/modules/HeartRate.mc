import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Lang;
import Sura.StringHelper;

module Sura {
  module HeartRate {
    function getHeartRateText() as String {
      var activity = Activity.getActivityInfo();

      if (activity == null) {
        return "-";
      }

      var heartRate = activity.currentHeartRate;

      if ((heartRate == null || heartRate == ActivityMonitor.INVALID_HR_SAMPLE) && ActivityMonitor has :getHeartRateHistory) {
        var heartRateHistory = ActivityMonitor.getHeartRateHistory(1, true);
        var heartRateSample = heartRateHistory.next();

        if (heartRateSample == null) {
          return "-";
        }

        heartRate = heartRateSample.heartRate;

        if (heartRate == ActivityMonitor.INVALID_HR_SAMPLE || heartRate == null) {
          return "-";
        }
      }

      if (heartRate == null) {
        return "-";
      }

      return StringHelper.padStart(heartRate.format("%d"), 3, " ");
    }
  }
}
