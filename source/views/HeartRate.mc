import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Sura.StringHelper;

class HeartRateView extends BaseView {
  private var _heartIcon = WatchUi.loadResource(Rez.Drawables.heartIcon);

  function initialize() {
    BaseView.initialize();
  }

  private function getHeartRateText() as String {
    var heartRate = Activity.getActivityInfo().currentHeartRate;

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

    return StringHelper.padStart(heartRate.format("%d"), 3, " ");
  }

  function draw(dc as Dc) {
    var fontSizeOffset = 8;
    dc.drawBitmap(self.x, self.y - 12, self._heartIcon);
    dc.drawText(
      self.x + 24 + 4,
      self.y - fontSizeOffset * 2,
      Graphics.FONT_XTINY,
      self.getHeartRateText(),
      Graphics.TEXT_JUSTIFY_LEFT
    );
  }
}
