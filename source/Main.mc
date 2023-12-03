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

    self.energyBar.setPosition({ :x => screenCenterX, :y => screenCenterY });
    self.energyBar.setRadius(arcRadius);

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
    var centerX = self.getCenterX();
    var centerY = self.getCenterY();

    /**
     * ------------------------
     * Get Info
     * ------------------------
     */
    var info = ActivityMonitor.getInfo();
    var weather = Weather.getCurrentConditions();
    var time = self.getTimeText();
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

  private function getTimeText() as String {
    var clockTime = System.getClockTime();
    var timeText = Lang.format("$1$:$2$", [ clockTime.hour.format("%02d"), clockTime.min.format("%02d") ]);

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

  function getBodyBattery() as Number {
    var bodyBattery = SensorHistory.getBodyBatteryHistory({ :period => 1 });
    var bodyBatteryData = bodyBattery.next().data;
    if (bodyBatteryData != null) {
      return bodyBatteryData;
    }
    return 0;
  }
}

