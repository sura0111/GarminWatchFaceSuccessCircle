import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Time;
import Toybox.Position;
import Toybox.SensorHistory;
using Toybox.Time.Gregorian as Date;
import Sura.Sun;
import Sura.Device;
import Sura.BodyBattery;

class MainWatchFace extends WatchUi.WatchFace {
  var offsetX as Number = 20;
  var topSeparatorY as Number = 0;
  var bottomSeparatorY as Number = 0;

  var stepBar as ArcGoalView;
  var battery as Battery;
  var heartRate as HeartRateView;
  var bodyBatteryBar as ArcGoalView;
  var iconDoNotDisturb as WatchUi.Resource;
  var backgroundImage as WatchUi.Resource or Null = null;

  var is24Hour as Boolean = false;
  var isDoNotDisturb as Boolean = false;
  var temperatureUnits as System.UnitsSystem or Null = null;

  public function initialize() {
    WatchFace.initialize();

    self.stepBar = new ArcGoalView({
      :direction => Graphics.ARC_COUNTER_CLOCKWISE,
      :position => "bottom",
    });
  
    self.bodyBatteryBar = new ArcGoalView({
      :direction => Graphics.ARC_CLOCKWISE,
      :color => Graphics.COLOR_DK_BLUE,
      :position => "left",
    });

    self.battery = new Battery({
      :width => 30,
      :height => 15,
    });
    self.heartRate = new HeartRateView();

    self.iconDoNotDisturb = WatchUi.loadResource(Rez.Drawables.doNotDisturbIcon);
  }

  // Load your resources here
  public function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.WatchFace(dc));
    Device.load(dc);

    self.topSeparatorY = Device.screenCenter.x - (Graphics.getFontHeight(Device.timeFontSize) / 2).toNumber();
    self.bottomSeparatorY = Device.screenCenter.x + (Graphics.getFontHeight(Device.timeFontSize) / 2).toNumber();

    var arcRadius = Device.screenCenter.getMin() - 8;

    self.stepBar.setPosition(Device.screenCenter.x, Device.screenCenter.x);
    self.stepBar.setRadius(arcRadius);
    self.stepBar.setIcon(WatchUi.loadResource(Rez.Drawables.stepIcon));

    self.bodyBatteryBar.setPosition(Device.screenCenter.x, Device.screenCenter.x);
    self.bodyBatteryBar.setRadius(arcRadius);
    self.bodyBatteryBar.setIcon(WatchUi.loadResource(Rez.Drawables.bodyBatteryIcon));

    self.heartRate.setPosition(
      Device.screenCenter.x - 120,
      self.bottomSeparatorY + 12 + Graphics.getFontHeight(Graphics.FONT_XTINY) / 2
    );

    self.battery.setPosition(
      Device.screenCenter.x + 38,
      self.bottomSeparatorY + 12 + Graphics.getFontHeight(Graphics.FONT_XTINY) / 2
    );

    self.backgroundImage = Device.isBackgroundImageSupported? WatchUi.loadResource(
      Device.screenSize.getMin() > 416 ? Rez.Drawables.backgroundBig : Rez.Drawables.backgroundSmall
    ) : null;

  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  public function onShow() as Void {
    Sun.loadLocation();
  }

  // Update the view
  public function onUpdate(dc as Dc) as Void {
    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);

    var settings = System.getDeviceSettings();
    self.is24Hour = settings.is24Hour;
    self.isDoNotDisturb = settings.doNotDisturb;
    self.temperatureUnits = settings.temperatureUnits;
    Sura.Weather.loadCurrentConditions();
    
    if (self.backgroundImage != null) {
      dc.drawBitmap(
        Device.screenCenter.x - backgroundImage.getWidth() / 2, 
        Device.screenCenter.y - backgroundImage.getHeight() / 2,
        self.backgroundImage
      );
    }

    var clockTime = System.getClockTime();
    var centerX = Device.screenCenter.x;
    var centerY = Device.screenCenter.y;

    /**
     * ------------------------
     * Get Info
     * ------------------------
     */
    var info = ActivityMonitor.getInfo();
    var time = self.getTimeText(clockTime);
    var date = self.getDateText();
    var step = self.getStepText(info);
    var bodyBattery = Sura.BodyBattery.getBodyBattery();
    var isNight = Sun.getIsNight();

    /**
     * ------------------------
     * Update View Data
     * ------------------------
     */

    // Step 
    self.stepBar.setData({ :value => info.steps, :goal => info.stepGoal });
    self.stepBar.setText(step);

    // bodyBattery
    self.bodyBatteryBar.setData({ :value => bodyBattery, :goal => 100 });
    self.bodyBatteryBar.setText(bodyBattery.format("%d") + "%");

    /**
     * ------------------------
     * Draw
     * ------------------------
     */
    // Seconds Dot
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(
      centerX + (centerX - 3) * Math.cos(clockTime.sec * Math.PI / 30 - Math.PI / 2), 
      centerY + (centerY - 3) * Math.sin(clockTime.sec * Math.PI / 30 - Math.PI / 2),
      3
    );

    // Date
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawText(
      centerX,
      self.topSeparatorY - Graphics.getFontHeight(Graphics.FONT_XTINY) - 12,
      Graphics.FONT_XTINY,
      date,
      Graphics.TEXT_JUSTIFY_CENTER
    );
    
    if (self.isDoNotDisturb) {
      dc.drawBitmap(
        centerX - self.iconDoNotDisturb.getWidth() / 2,
        self.topSeparatorY - Graphics.getFontHeight(Graphics.FONT_XTINY) - 12 - self.iconDoNotDisturb.getHeight() - 6,
        self.iconDoNotDisturb
      );
    }

    // Time
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawText(Device.screenSize.x - 45, centerY, Device.timeFontSize, time, Graphics.TEXT_JUSTIFY_VCENTER);
    dc.drawText(
      Device.screenSize.x - 10,
      centerY,
      Graphics.FONT_XTINY,
      clockTime.sec.format("%02d"),
      Graphics.TEXT_JUSTIFY_VCENTER
    );

    // Weather
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    var weatherIcon = Sura.Weather.getWeatherIcon(isNight);
    if (weatherIcon != null) {
      dc.drawBitmap(
        centerX - 50 - weatherIcon.getWidth(),
        40 - weatherIcon.getHeight() / 2,
        weatherIcon
      );
    }
    dc.drawText(
      centerX - 50,
      40 - Graphics.getFontHeight(Graphics.FONT_XTINY) / 2,
      Graphics.FONT_XTINY,
      Sura.Weather.getTemperatureAndPrecipitationChanceInfo(self.temperatureUnits),
      Graphics.TEXT_JUSTIFY_LEFT
    );

    // Separators
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(2);
    dc.drawLine(centerX + offsetX - Device.screenSize.x * 0.38, self.topSeparatorY, centerX + offsetX + Device.screenSize.x * 0.38, self.topSeparatorY);
    dc.drawLine(centerX + offsetX - Device.screenSize.x * 0.38, self.bottomSeparatorY, centerX + offsetX + Device.screenSize.x * 0.38, self.bottomSeparatorY);
    dc.setPenWidth(1);

    self.stepBar.draw(dc);
    self.battery.draw(dc);
    self.heartRate.draw(dc);
    self.bodyBatteryBar.draw(dc);
  }

  private function getTimeText(clockTime as System.ClockTime) as String {
    var hour = self.is24Hour ? clockTime.hour : (clockTime.hour % 12 == 0 ? 12 : clockTime.hour % 12);
    var ampm = self.is24Hour ? "" : (clockTime.hour >= 12 && clockTime.hour < 24 ? " PM" : " AM");
    var timeText = Lang.format("$1$:$2$$3$", [hour.format("%02d"), clockTime.min.format("%02d"), ampm]);

    return timeText;
  }

  private function getDateText() as String {
    var now = Time.now();
    var date = Date.info(now, Time.FORMAT_LONG);
    var dateText = Lang.format("$1$ $2$ ($3$)", [ date.month, date.day, date.day_of_week ]);

    return dateText;
  }

  private function getStepText(info as ActivityMonitor.Info) as String {
    var stepText = Lang.format("$1$/$2$", [info.steps, info.stepGoal]);
    
    if (stepText.length() >= 10) {
      return info.steps.format("%d");
    }

    return stepText;
  }

  // // Called when this View is removed from the screen. Save the
  // // state of this View here. This includes freeing resources from
  // // memory.
  // public function onHide() as Void {}

  // // The user has just looked at their watch. Timers and animations may be
  // // started here.
  // public function onExitSleep() as Void {}

  // // Terminate any active timers and prepare for slow updates.
  // public function onEnterSleep() as Void {}
}
