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
  var offsetX as Number = 50;
  var topSeparatorY as Number = 0;
  var bottomSeparatorY as Number = 0;
  var timeFontSize as Graphics.FontDefinition = Graphics.FONT_NUMBER_MEDIUM;

  var stepBar as ArcGoalView;
  var battery as Battery;
  var heartRate as HeartRateView;
  var bodyBatteryBar as ArcGoalView;
  var iconDoNotDisturb as WatchUi.Resource;
  var backgroundImage as WatchUi.Resource or Null = null;

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

    self.offsetX = (Graphics.getFontHeight(Graphics.FONT_XTINY) * 2.8).toNumber();
    updateTimeFontSize();

    self.topSeparatorY = Device.screenCenter.x - (Graphics.getFontHeight(timeFontSize) / 2).toNumber();
    self.bottomSeparatorY = Device.screenCenter.x + (Graphics.getFontHeight(timeFontSize) / 2).toNumber();

    var arcRadius = Device.screenCenter.getMin() - 8;

    self.stepBar.setPosition(Device.screenCenter.x, Device.screenCenter.x);
    self.stepBar.setRadius(arcRadius);
    if (Device.isSmallScreen == false) {
      self.stepBar.setIcon(WatchUi.loadResource(Rez.Drawables.stepIcon));
    }

    self.bodyBatteryBar.setPosition(Device.screenCenter.x, Device.screenCenter.x);
    self.bodyBatteryBar.setRadius(arcRadius);
    self.bodyBatteryBar.setIcon(WatchUi.loadResource(Rez.Drawables.bodyBatteryIcon));

    self.heartRate.setPosition(
      (Device.screenCenter.x - self.offsetX).toNumber(),
      self.bottomSeparatorY + 12 + Graphics.getFontHeight(Graphics.FONT_XTINY) / 2
    );

    self.battery.setPosition(
      (Device.screenCenter.x + Graphics.getFontHeight(Graphics.FONT_XTINY)).toNumber(),
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
    self.isDoNotDisturb = settings.doNotDisturb;
    self.temperatureUnits = settings.temperatureUnits;
    Sura.Weather.loadCurrentConditions();
    Sura.Datetime.setup(settings.is24Hour);
    updateTimeFontSize();
    
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

    // Date
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawText(
      centerX,
      self.topSeparatorY - Graphics.getFontHeight(Graphics.FONT_XTINY) - 12,
      Graphics.FONT_XTINY,
      Sura.Datetime.getDateText(),
      Graphics.TEXT_JUSTIFY_CENTER
    );
    
    if (self.isDoNotDisturb && !Device.isSmallScreen) {
      dc.drawBitmap(
        centerX - self.iconDoNotDisturb.getWidth() / 2,
        self.topSeparatorY - Graphics.getFontHeight(Graphics.FONT_XTINY) - 12 - self.iconDoNotDisturb.getHeight() - 6,
        self.iconDoNotDisturb
      );
    }

    // Time
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawText(
      Device.screenSize.x - offsetX * (timeFontSize == Graphics.FONT_NUMBER_HOT ? 0.5 : 0.8),
      centerY,
      timeFontSize,
      Sura.Datetime.getTimeText(),
      Graphics.TEXT_JUSTIFY_VCENTER
    );
    dc.drawText(
      Device.screenSize.x - 10,
      centerY - Graphics.getFontHeight(Graphics.FONT_XTINY) / 2,
      Graphics.FONT_XTINY,
      Sura.Datetime.getAmPm(),
      Graphics.TEXT_JUSTIFY_VCENTER
    );
    dc.drawText(
      Device.screenSize.x - 10,
      centerY + Graphics.getFontHeight(Graphics.FONT_XTINY) / 2,
      Graphics.FONT_XTINY,
      clockTime.sec.format("%02d"),
      Graphics.TEXT_JUSTIFY_VCENTER
    );

    // Weather
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    var weatherIcon = Sura.Weather.getWeatherIcon(isNight);
    if (weatherIcon != null) {
      dc.drawBitmap(
        centerX - offsetX * 0.5 - weatherIcon.getWidth(),
        40 - weatherIcon.getHeight() / 2,
        weatherIcon
      );
    }
    dc.drawText(
      centerX - offsetX * 0.5,
      40 - Graphics.getFontHeight(Graphics.FONT_XTINY) / 2,
      Graphics.FONT_XTINY,
      Sura.Weather.getTemperatureAndPrecipitationChanceInfo(self.temperatureUnits),
      Graphics.TEXT_JUSTIFY_LEFT
    );

    // Separators
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(2);
    dc.drawLine(offsetX, self.topSeparatorY, Device.screenSize.x, self.topSeparatorY);
    dc.drawLine(offsetX, self.bottomSeparatorY, Device.screenSize.x, self.bottomSeparatorY);
    dc.setPenWidth(1);

    self.stepBar.draw(dc);
    self.battery.draw(dc);
    self.heartRate.draw(dc);
    self.bodyBatteryBar.draw(dc);
  }

  private function getStepText(info as ActivityMonitor.Info) as String {
    var stepText = Lang.format("$1$/$2$", [info.steps, info.stepGoal]);
    
    if (stepText.length() >= 10) {
      return info.steps.format("%d");
    }

    return stepText;
  }

  function updateTimeFontSize() {
    timeFontSize = Sura.Datetime.is24Hour ? Device.timeFontSize : Graphics.FONT_NUMBER_MEDIUM;
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
