import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
import Sura.StringHelper;

class Battery extends BaseView {
  var width as Number;
  var height as Number;
  var primaryColor as Number;
  var lowBatteryColor as Number;
  var fullBatteryColor as Number;

  function initialize(params as {
    :width as Number or Null,
    :height as Number or Null,
    :primaryColor as Number or Null,
    :lowBatteryColor as Number or Null,
    :fullBatteryColor as Number or Null
  }) {
    BaseView.initialize();
    self.width = params[:width] == null ? 24 : params[:width];
    self.height = params[:height] == null ? 12 : params[:height];
    self.primaryColor = params[:primaryColor] == null ? Graphics.COLOR_DK_GREEN : params[:primaryColor];
    self.lowBatteryColor = params[:lowBatteryColor] == null ? Graphics.COLOR_DK_RED : params[:lowBatteryColor];
    self.fullBatteryColor = params[:fullBatteryColor] == null ? Graphics.COLOR_DK_GREEN : params[:fullBatteryColor];
  }

  function draw(dc) {
    var battery = System.getSystemStats().battery;
    var color = self.getBatteryColor(battery);
    var batteryHeadWidth = self.width / 10;
    var batteryHeadHeight = self.height / 2;
    var batteryHeadX = self.x + self.width;
    var batteryHeadY = self.y + (self.height - batteryHeadHeight) / 2;
    var fontSizeOffset = 8;

    // battery
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    dc.fillRectangle(self.x, self.y - fontSizeOffset + 2, (self.width * battery / 100), self.height);

    // frame
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawRectangle(self.x, self.y - fontSizeOffset + 2, self.width, self.height);

    // batteryHead
    if(battery == 100.0) {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(batteryHeadX,  batteryHeadY - fontSizeOffset + 2,  batteryHeadWidth, batteryHeadHeight);
    }

    // BatteryHead Frame
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawRectangle(batteryHeadX, batteryHeadY - fontSizeOffset + 2, batteryHeadWidth, batteryHeadHeight);

    dc.drawText(
      batteryHeadX + batteryHeadWidth + 2,
      self.y - fontSizeOffset * 2,
      Graphics.FONT_XTINY,
      StringHelper.padStart(battery.format("%d") + "%", 4, " "),
      Graphics.TEXT_JUSTIFY_LEFT
    );
  }

  private function getBatteryColor(battery as Float) as Number {
    if (battery < 15) {
      return self.lowBatteryColor;
    }
    if (battery == 100) {
      return self.fullBatteryColor;
    }
    return self.primaryColor;
  }
}
