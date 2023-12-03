import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import StringHelpers;

class HeartRateView extends BaseView {
  private var _heartIcon = WatchUi.loadResource(Rez.Drawables.heartIcon);

  function initialize() {
    BaseView.initialize();
  }

  private function getHeartRateText() as String {
    var heartRateHistory = ActivityMonitor.getHeartRateHistory(null, false);
    var heartRate = heartRateHistory.next().heartRate;

    if (heartRate == ActivityMonitor.INVALID_HR_SAMPLE) {
      return "-";
    }

    return StringHelpers.padStart(heartRate.format("%d"), 3, " ");
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
