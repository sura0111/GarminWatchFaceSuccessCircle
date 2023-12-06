import Toybox.Graphics;
import Toybox.Math;
import Toybox.Lang;
import Toybox.WatchUi;

class ArcGoalView extends ArcGoalGraph {
  var textColor = Graphics.COLOR_LT_GRAY;
  var text = "";
  var icon as WatchUi.BitmapResource or Null = null;

  function initialize(params) {
    ArcGoalGraph.initialize(params);
  }

  function draw(dc as Dc) {
    ArcGoalGraph.draw(dc);
    var tX = (Math.cos(Math.PI / 180 * (self.getCenterDegree())) * self.radius).toNumber();
    var tY = - (Math.sin(Math.PI / 180 * (self.getCenterDegree())) * self.radius).toNumber();

    if (self.text) {
      dc.setColor(self.textColor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        tX + self.x + self.getTextOffsetX(),
        tY + self.y + self.getTextOffsetY(),
        Graphics.FONT_XTINY,
        self.text,
        self.getTextJustify()
      );

      if (self.icon != null) {
        dc.drawBitmap(
          tX + self.x + self.getIconOffsetX(),
          tY + self.y + self.getIconOffsetY(),
          self.icon
        );
      }
    }
  }

  function setTextColor(color as Number) {
    self.textColor = color;
  }

  function setText(text as String) {
    self.text = text;
  }

  function setIcon(icon as BitmapResource) {
    self.icon = icon;
  }

  function getTextJustify() {
     switch (self.position) {
      case "left": return Graphics.TEXT_JUSTIFY_LEFT;
      case "top": return Graphics.TEXT_JUSTIFY_CENTER;
      case "right": return Graphics.TEXT_JUSTIFY_RIGHT;
      case "bottom": return Graphics.TEXT_JUSTIFY_CENTER;
      default: return Graphics.TEXT_JUSTIFY_CENTER;
    }
  }

  function getTextOffsetX() {
     switch (self.position) {
      case "top": return 0;
      case "right": return -8;
      case "bottom": return 0;
      case "left": return 8;
      default: return 0;
    }
  }

  function getTextOffsetY() {
     switch (self.position) {
      case "top": return 0;
      case "right": return -8;
      case "bottom": return -48;
      case "left": return -8;
      default: return -48;
    }
  }

  function getIconOffsetX() {
     switch (self.position) {
      case "top": return -self.icon.getWidth() / 2;
      case "right": return 0;
      case "bottom": return -self.icon.getWidth() / 2;
      case "left": return self.getTextOffsetX() + self.icon.getWidth() / 2;
      default: return 0;
    }
  }

  function getIconOffsetY() {
     switch (self.position) {
      case "top": return 0;
      case "right": return -8;
      case "left": return -(self.icon.getHeight() + 12);
      case "bottom": return -(self.icon.getHeight() - self.getTextOffsetY() + 4);
      default: return -100;
    }
  }
}
