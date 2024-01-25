import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Time;
import Toybox.Position;
import Toybox.SensorHistory;
using Toybox.Time.Gregorian as Date;
import Sura.Sun;
import Sura.Device;
import Sura.Datetime;
import Sura.Weather;
import Sura.ActivityMonitor;
import Sura.BodyBattery;

class MainWatchFace extends WatchUi.WatchFace {
  var backgroundImage as WatchUi.Resource or Null = null;
  var battery as Battery;
  var bodyBatteryGraph as ArcGoalView;
  var heartRate as HeartRateView;
  var iconDoNotDisturb as WatchUi.Resource = WatchUi.loadResource(Rez.Drawables.doNotDisturbIcon);
  var iconMessageBadge as WatchUi.Resource = WatchUi.loadResource(Rez.Drawables.messageBadgeCustom);
  var isDoNotDisturb as Boolean = false;
  var isLowPowerMode = false;
  var offsetX as Number = 50;
  var separatorYBottom as Number = 0;
  var separatorYTop as Number = 0;
  var stepGraph as ArcGoalView;
  var temperatureUnits as System.UnitsSystem or Null = null;
  var timeFontSize as Graphics.FontDefinition = Graphics.FONT_NUMBER_MEDIUM;
  var smallFont = Graphics.FONT_XTINY;
  var smallFontSize = Graphics.getFontHeight(smallFont);

  public function initialize() {
    WatchFace.initialize();

    self.heartRate = new HeartRateView();
    self.battery = new Battery({ :width => 30, :height => 15 });

    self.stepGraph = new ArcGoalView({
      :direction => Graphics.ARC_COUNTER_CLOCKWISE,
      :position => "bottom",
    });
  
    self.bodyBatteryGraph = new ArcGoalView({
      :direction => Graphics.ARC_CLOCKWISE,
      :color => Graphics.COLOR_DK_BLUE,
      :position => "left",
    });
  }

  // Load your resources here
  public function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.WatchFace(dc));
    Device.init(dc);

    self.offsetX = (smallFontSize * 2.8).toNumber();

    self.separatorYTop = Device.screenCenter.x - (Graphics.getFontHeight(timeFontSize) / 2).toNumber();
    self.separatorYBottom = Device.screenCenter.x + (Graphics.getFontHeight(timeFontSize) / 2).toNumber();

    var arcGraphRadius = Device.screenCenter.getMin() - 8;

    self.stepGraph.setPosition(Device.screenCenter.x, Device.screenCenter.x);
    self.stepGraph.setRadius(arcGraphRadius);
    if (Device.isSmallScreen == false) {
      self.stepGraph.setIcon(WatchUi.loadResource(Rez.Drawables.stepIcon));
    }

    self.bodyBatteryGraph.setPosition(Device.screenCenter.x, Device.screenCenter.x);
    self.bodyBatteryGraph.setRadius(arcGraphRadius);
    self.bodyBatteryGraph.setIcon(WatchUi.loadResource(Rez.Drawables.bodyBatteryIcon));

    self.heartRate.setPosition(
      self.offsetX,
      self.separatorYBottom + 12 + smallFontSize / 2
    );

    self.battery.setPosition(
      (Device.screenCenter.x + smallFontSize).toNumber(),
      self.separatorYBottom + 12 + smallFontSize / 2
    );

    self.backgroundImage = Device.isBackgroundImageSupported? WatchUi.loadResource(
      Device.screenSize.getMin() > 416 ? Rez.Drawables.backgroundBig : Rez.Drawables.backgroundSmall
    ) : null;
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  public function onShow() as Void {
    Sun.init();
    Weather.init();
  }

  // Update the view
  public function onUpdate(dc as Dc) as Void {
    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);
    Datetime.init();
    ActivityMonitor.init();


    var settings = System.getDeviceSettings();
    self.isDoNotDisturb = settings.doNotDisturb;
    self.temperatureUnits = settings.temperatureUnits;
    
    self.clearScreen(dc);
    self.drawBackgroundImage(dc);
    self.drawWeather(dc);
    self.drawTime(dc);
    self.drawDate(dc);
    self.battery.draw(dc);
    self.heartRate.draw(dc);

    if (!Device.isSmallScreen) {
      if (self.isDoNotDisturb) {
        dc.drawBitmap(
          Device.screenCenter.x - self.iconDoNotDisturb.getWidth() / 2,
          self.separatorYTop - smallFontSize - 12 - self.iconDoNotDisturb.getHeight() - 6,
          self.iconDoNotDisturb
        );
      } else if (settings.notificationCount > 0) {
        dc.drawBitmap(
          Device.screenCenter.x - self.iconMessageBadge.getWidth() / 2,
          self.separatorYTop - smallFontSize - 12 - self.iconMessageBadge.getHeight() - 6,
          self.iconMessageBadge
        );
      }
    }

    // Separators
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(2);
    dc.drawLine(offsetX, self.separatorYTop, Device.screenSize.x, self.separatorYTop);
    dc.drawLine(offsetX, self.separatorYBottom, Device.screenSize.x, self.separatorYBottom);
    dc.setPenWidth(1);

    if (!self.isLowPowerMode) {
      self.drawStepGraph(dc);
      self.drawBodyBatteryGraph(dc);
    }
  }

  // // Called when this View is removed from the screen. Save the
  // // state of this View here. This includes freeing resources from
  // // memory.
  // public function onHide() as Void {}

  // The user has just looked at their watch. Timers and animations may be
  // started here.
  public function onExitSleep() as Void {
    self.isLowPowerMode = false;
  }

  // Terminate any active timers and prepare for slow updates.
  public function onEnterSleep() as Void {
    self.isLowPowerMode = true;
  }

  function clearScreen(dc as Dc) as Void {
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    dc.clear();
  }

  function drawBackgroundImage(dc as Dc) as Void {
    if (self.backgroundImage != null && !self.isLowPowerMode) {
      var imageWidth = backgroundImage.getWidth();
      var imageHeight = backgroundImage.getHeight();

      var centerX = Device.screenCenter.x;
      var centerY = Device.screenCenter.y;

      var x = centerX - imageWidth / 2;
      var y = centerY - imageHeight / 2;

      dc.drawBitmap(x, y, self.backgroundImage);
    }
  }

  function drawWeather(dc as Dc) as Void {
    var weatherIcon = Weather.getWeatherIcon(Sun.getIsNight());
    var x = Device.screenCenter.x - offsetX * 0.5;
    var y = 40;
    var temperatureText = Weather.getTemperatureAndPrecipitationChanceInfo(self.temperatureUnits);

    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);

    if (weatherIcon != null) {
      dc.drawBitmap(x - weatherIcon.getWidth(), y - weatherIcon.getHeight() / 2, weatherIcon);
    }

    dc.drawText(x, y - smallFontSize / 2, smallFont, temperatureText, Graphics.TEXT_JUSTIFY_LEFT);
  }

  function drawDate(dc as Dc) as Void {
    var textAlign = Graphics.TEXT_JUSTIFY_CENTER;

    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawText(
      Device.screenCenter.x,
      self.separatorYTop - smallFontSize - 12,
      smallFont,
      Datetime.getDateText(),
      textAlign
    );
  }

  function getTimeFontSize() as Graphics.FontDefinition {
    var isBigFontSize = Device.timeFontSize == Graphics.FONT_NUMBER_HOT;

    if (isBigFontSize && BodyBattery.getBodyBattery() == 100) {
      return Graphics.FONT_NUMBER_MEDIUM;
    }

    if (!Datetime.is24Hour) {
      return Graphics.FONT_NUMBER_MEDIUM;
    }

    return Device.timeFontSize;
  }

  function drawTime(dc as Dc) as Void {
    var textAlign = Graphics.TEXT_JUSTIFY_VCENTER;
    var timeFontSize = self.getTimeFontSize();

    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    
    // Time
    dc.drawText(
      Device.screenSize.x - offsetX * (timeFontSize == Graphics.FONT_NUMBER_HOT ? 0.42 : 0.75),
      Device.screenCenter.y,
      timeFontSize,
      Datetime.getTimeText(),
      textAlign
    );

    // AM/PM
    dc.drawText(
      Device.screenSize.x - 10,
      Device.screenCenter.y - smallFontSize / 2,
      smallFont,
      Datetime.getAmPm(),
      textAlign
    );

    if (!self.isLowPowerMode && !store.shouldHideSecond) {
      // Seconds
      dc.drawText(
        Device.screenSize.x - 10,
        Device.screenCenter.y + smallFontSize / 2,
        smallFont,
        Datetime.getSecondsText(),
        textAlign
      );
    }
  }

  function drawStepGraph(dc as Dc) as Void {
    var steps = ActivityMonitor.getSteps();
    var stepText = Sura.ActivityMonitor.getStepText();
    var stepGoal = ActivityMonitor.getStepGoal();
    self.stepGraph.setData({ :value => steps, :goal => stepGoal });
    self.stepGraph.setText(stepText);
    self.stepGraph.draw(dc);
  }

  function drawBodyBatteryGraph(dc as Dc) as Void {
    var bodyBattery = BodyBattery.getBodyBattery();
    self.bodyBatteryGraph.setData({ :value => bodyBattery, :goal => 100 });
    self.bodyBatteryGraph.setText(bodyBattery.format("%d") + "%");
    self.bodyBatteryGraph.draw(dc);
  }
}
