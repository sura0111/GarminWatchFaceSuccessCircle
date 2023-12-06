import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.WatchUi;
import Toybox.Graphics;

class ArcGoalGraph extends BaseView {
  var value as Number = 0;
  var goal as Number = 1;
  var color = Graphics.COLOR_BLUE;
  var backgroundColor = Graphics.COLOR_LT_GRAY;
  var direction = Graphics.ARC_CLOCKWISE;
  var radius = 20;
  var position = 20;
  var arcAngleRage as Number = 75;

  function initialize(params as {
    :value as Number or Null,
    :goal as Number or Null,
    :color as Number or Null,
    :backgroundColor as Number or Null,
    :direction as Number or Null,
    :radius as Number or Null,
    :position as String or Null,
    :arcAngleRage as Number or Null,
  }) {
    BaseView.initialize();

    if (params[:value] != null) {
      self.value = params[:value];
    }
    if (params[:goal] != null) {
      self.goal = params[:goal];
    }
    if (params[:color] != null) {
      self.color = params[:color];
    }
    if (params[:backgroundColor] != null) {
      self.backgroundColor = params[:backgroundColor];
    }
    if (params[:direction] != null) {
      self.direction = params[:direction];
    }
    if (params[:radius] != null) {
      self.radius = params[:radius];
    }
    if (params[:position] != null) {
      self.position = params[:position];
    }
    if (params[:arcAngleRage] != null) {
      self.arcAngleRage = params[:arcAngleRage];
    }
  }

  function setRadius(radius as Number) {
    self.radius = radius;
  }

  function setData(params as { :value as Number, :goal as Number }) {
    self.value = params[:value];
    self.goal = params[:goal];
  }
  
  function draw(dc as Dc) {
    dc.setColor(self.backgroundColor, self.backgroundColor);
    var penWidth = 4;
    var radius = self.radius - penWidth / 2;
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

  function getMultiplier() {
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
    var currentDegree = self.getStartDegree() + (multiplier * self.arcAngleRage * self.value  / self.goal);

    if (currentDegree == startDegree) {
      return currentDegree + multiplier;
    }

    return currentDegree;
  }
}
