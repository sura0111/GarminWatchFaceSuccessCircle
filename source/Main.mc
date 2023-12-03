import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Weather;
import Toybox.SensorHistory;
using Toybox.Time.Gregorian as Date;

class MainWatchFace extends WatchUi.WatchFace {
  var screenWidth as Number = 0;
  var screenHeight as Number = 0;
  var stepBar as ArcGoalView;
  var battery as Battery;
  var heartRate as HeartRateView;
  var energyBar as ArcGoalView;

  var is24Hour as Boolean = false;
  var isDoNotDisturb as Boolean = false;

  var iconDoNotDisturb as BitmapResource;

  public function initialize() {
    WatchFace.initialize();

    self.stepBar = new ArcGoalView({
      :direction => Graphics.ARC_COUNTER_CLOCKWISE,
      :position => "bottom",
    });
  
    self.energyBar = new ArcGoalView({
      :direction => Graphics.ARC_CLOCKWISE,
      :color => Graphics.COLOR_DK_BLUE,
      :position => "left",
    });

    self.battery = new Battery({});
    self.heartRate = new HeartRateView();
    
    self.iconDoNotDisturb = WatchUi.loadResource(Rez.Drawables.doNotDisturbIcon);
  }

  // Load your resources here
  public function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.WatchFace(dc));

    self.screenWidth = dc.getWidth();
    self.screenHeight = dc.getHeight();
    var screenCenterX = self.getCenterX();
    var screenCenterY = self.getCenterY();
    var arcRadius = (self.screenWidth > self.screenHeight ? screenCenterY : screenCenterX) - 4;

    self.stepBar.setPosition({ :x => screenCenterX, :y => screenCenterY });
    self.stepBar.setRadius(arcRadius);
    self.stepBar.setIcon(WatchUi.loadResource(Rez.Drawables.stepIcon));

    self.energyBar.setPosition({ :x => screenCenterX, :y => screenCenterY });
    self.energyBar.setRadius(arcRadius);
    self.energyBar.setIcon(WatchUi.loadResource(Rez.Drawables.bodyBatteryIcon));

    self.heartRate.setPosition({
      :x => screenCenterX - 120,
      :y => screenCenterY + 48 + 28
    });

    self.battery.setPosition({
      :x => screenCenterX + 38,
      :y => screenCenterY + 48 + 28
    });
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  public function onShow() as Void {}

  // Update the view
  public function onUpdate(dc as Dc) as Void {
    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);
    var clockTime = System.getClockTime();
    var centerX = self.getCenterX();
    var centerY = self.getCenterY();

    /**
     * ------------------------
     * Get Info
     * ------------------------
     */
    var settings = System.getDeviceSettings();
    self.is24Hour = settings.is24Hour;
    self.isDoNotDisturb = settings.doNotDisturb;
    var info = ActivityMonitor.getInfo();
    var weather = Weather.getCurrentConditions();
    var time = self.getTimeText(clockTime);
    var date = self.getDateText();
    var step = self.getStepText(info);
    var temperature = self.getTemperatureText(weather);
    var bodyBattery = self.getBodyBattery();

    /**
     * ------------------------
     * Update View Data
     * ------------------------
     */

    // Step 
    self.stepBar.setData({ :value => info.steps, :goal => info.stepGoal });
    self.stepBar.setText(step);

    // Energy
    self.energyBar.setData({ :value => bodyBattery, :goal => 100 });
    self.energyBar.setText(bodyBattery.format("%d") + "%");

    /**
     * ------------------------
     * Draw
     * ------------------------
     */
    // Date
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawText(centerX, centerY - 54 - 40, Graphics.FONT_XTINY, date, Graphics.TEXT_JUSTIFY_CENTER);
    if (self.isDoNotDisturb) {
      dc.drawBitmap(centerX - 12, centerY - 54 - 12 - 72, self.iconDoNotDisturb);
    }
    // Time
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawText(centerX, centerY - 67, Graphics.FONT_NUMBER_HOT, time, Graphics.TEXT_JUSTIFY_CENTER);
    // Temperature
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawText(centerX, 20, Graphics.FONT_XTINY, temperature, Graphics.TEXT_JUSTIFY_CENTER);
    // Separators
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(2);
    dc.drawLine(centerX - 150, centerY - 54, centerX + 150, centerY - 54);
    dc.drawLine(centerX - 150, centerY + 54, centerX + 150, centerY + 54);
    dc.setPenWidth(1);

    self.stepBar.draw(dc);
    self.battery.draw(dc);
    self.heartRate.draw(dc);
    self.energyBar.draw(dc);

    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawText(
      centerX + 160,
      centerY - 10,
      Graphics.FONT_XTINY,
      clockTime.sec.format("%02d"),
      Graphics.TEXT_JUSTIFY_LEFT
    );
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  public function onHide() as Void {}

  // The user has just looked at their watch. Timers and animations may be
  // started here.
  public function onExitSleep() as Void {}

  // Terminate any active timers and prepare for slow updates.
  public function onEnterSleep() as Void {}

  private function getCenterX() {
    return self.screenWidth / 2;
  }

  private function getCenterY() {
    return self.screenHeight / 2;
  }

  private function getTimeText(clockTime as System.ClockTime) as String {
    var hour = self.is24Hour ? clockTime.hour : (clockTime.hour % 12 == 0 ? 12 : clockTime.hour % 12);
    var ampm = self.is24Hour ? "" : (clockTime.hour >= 12 && clockTime.hour < 24 ? " PM" : " AM");
    var timeText = Lang.format("$1$:$2$$3$", [hour.format("%02d"), clockTime.min.format("%02d"), ampm]);

    return timeText;
  }

  private function getHeartRateText() as String {
    var heartRateHistory = ActivityMonitor.getHeartRateHistory(null, false);
    var heartRate = heartRateHistory.next().heartRate;

    if (heartRate == ActivityMonitor.INVALID_HR_SAMPLE) {
      return "-";
    }

    return heartRate.format("%d");
  }

  private function getDateText() as String {
    var now = Time.now();
    var date = Date.info(now, Time.FORMAT_LONG);
    var dateText = Lang.format("$1$ $2$ ($3$)", [ date.month, date.day, date.day_of_week ]);

    return dateText;
  }

  private function getBatteryText(systemStats as System.Stats) as String {
    return systemStats.battery.format("%d") + "%";
  }

  private function getStepText(info as ActivityMonitor.Info) as String {
    return Lang.format("$1$/$2$", [info.steps, info.stepGoal]);
  }

  private function getTemperatureText(currentCondition as Weather.CurrentConditions or Null) as String {
    return currentCondition == null ? "~°C" : currentCondition.temperature.format("%d") + "°C";
  }

  private function getBodyBatteryHistoryIterator() as SensorHistory.SensorHistoryIterator or Null {
    if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory)) {
        // Set up the method with parameters
        return Toybox.SensorHistory.getBodyBatteryHistory({ :period => 1 });
    }
    return null;
  }

  private function getBodyBattery() as Number {
    var bodyBatteryHistory = self.getBodyBatteryHistoryIterator();
    if (bodyBatteryHistory == null) {
      return 0;
    }

    var bodyBatterySample = bodyBatteryHistory.next();
    
    if (bodyBatterySample == null) {
      return 0;
    }

    var bodyBatteryData = bodyBatterySample.data;

    if (bodyBatteryData != null) {
      return bodyBatteryData;
    }

    return 0;
  }
}

