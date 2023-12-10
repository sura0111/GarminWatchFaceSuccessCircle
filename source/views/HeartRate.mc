import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Sura.StringHelper;

class HeartRateView extends BaseView {
  private var _heartIcon as WatchUi.BitmapResource = WatchUi.loadResource(Rez.Drawables.heartIcon);

  function initialize() {
    BaseView.initialize();
  }

  function draw(dc as Dc) {
    dc.drawBitmap(self.x, self.y - self._heartIcon.getHeight() / 2, self._heartIcon);

    dc.drawText(
      self.x + self._heartIcon.getWidth() + 4,
      self.y - Graphics.getFontHeight(Graphics.FONT_XTINY) / 2,
      Graphics.FONT_XTINY,
      Sura.HeartRate.getHeartRateText(),
      Graphics.TEXT_JUSTIFY_LEFT
    );
  }
}
