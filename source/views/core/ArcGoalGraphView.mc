import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.WatchUi;
import Toybox.Graphics;

class ArcGoalGraphView extends BaseView {
  var value as Number = 0;
  var goal as Number = 1;
  var color as Graphics.ColorValue = Graphics.COLOR_BLUE;
  var backgroundColor as Graphics.ColorValue = Graphics.COLOR_LT_GRAY;
  var direction as Graphics.ArcDirection = Graphics.ARC_CLOCKWISE;
  var radius as Number = 20;
  var position as String = "bottom";
  var arcAngleRage as Number = 75;

  function initialize(params as {
    :value as Number?,
    :goal as Number?,
    :color as Graphics.ColorValue?,
    :backgroundColor as Graphics.ColorValue?,
    :direction as Graphics.ArcDirection?,
    :radius as Number?,
    :position as String?,
    :arcAngleRage as Number?,
  }) {
    BaseView.initialize();
    var value = params[:value];
    var goal = params[:goal];
    var color = params[:color];
    var backgroundColor = params[:backgroundColor];
    var direction = params[:direction];
    var radius = params[:radius];
    var position = params[:position];
    var arcAngleRage = params[:arcAngleRage];

    if (value != null) {
      self.value = value;
    }
    if (goal != null) {
      self.goal = goal;
    }
    if (color != null) {
      self.color = color;
    }
    if (backgroundColor != null) {
      self.backgroundColor = backgroundColor;
    }
    if (direction != null) {
      self.direction = direction;
    }
    if (radius != null) {
      self.radius = radius;
    }
    if (position != null) {
      self.position = position;
    }
    if (arcAngleRage != null) {
      self.arcAngleRage = arcAngleRage;
    }
  }

  function setRadius(radius as Number) as Void {
    self.radius = radius;
  }

  function setData(params as { :value as Number, :goal as Number }) as Void {
    var value = params[:value];
    var goal = params[:goal];

    if (value != null) {
      self.value = value;
    }

    if (goal != null) {
      self.goal = goal;
    }
  }
  
  function draw(dc as Dc) as Void {
    dc.setColor(self.backgroundColor, self.backgroundColor);
    var penWidth = 4;
    var radius = (self.radius - penWidth / 2).toNumber();
    dc.setPenWidth(penWidth);
    var startDegree = self.getStartDegree();

    dc.drawArc(
      self.x,
      self.y,
      radius,
      self.direction,
      startDegree,
      self.getEndDegree()
    );

    dc.setColor(self.color, self.color);

    var currentDegree = self.getCurrentDegree();
    var circleDotRadius = penWidth * 1.25;

    dc.drawArc(
      self.x,
      self.y,
      radius,
      self.direction,
      startDegree,
      currentDegree
    );

    dc.setColor(self.color, Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(
      self.x + Math.cos(currentDegree * Math.PI / 180) * radius,
      self.y - Math.sin(currentDegree * Math.PI / 180) * radius,
      circleDotRadius
    );
    dc.setPenWidth(1);
  }

  function getCenterDegree() as Number {
    switch (self.position) {
      case "left": return 180;
      case "top": return 90;
      case "right": return 0;
      case "bottom": return 270;
      default: return 270;
    }
  }

  function getMultiplier() as Number {
    return self.direction == Graphics.ARC_CLOCKWISE ? -1 : 1;
  }

  function getStartDegree() as Number {
    return self.getCenterDegree() - (self.getMultiplier() * self.arcAngleRage / 2);
  }

  function getEndDegree() as Number {
    return self.getCenterDegree() + (self.getMultiplier() * self.arcAngleRage / 2);
  }

  function getCurrentDegree() as Number {
    var multiplier = self.getMultiplier();
    var startDegree = self.getStartDegree();
    var percentage = self.value.toFloat() / self.goal.toFloat();
    var displayPercentage = percentage > 1 ? 1 : percentage;
    var currentDegree = (self.getStartDegree() + (multiplier * self.arcAngleRage * displayPercentage)).toNumber();

    if (currentDegree == startDegree) {
      return currentDegree + multiplier;
    }

    return currentDegree;
  }
}
