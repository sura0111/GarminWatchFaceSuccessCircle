import Toybox.Graphics;
import Toybox.Math;
import Toybox.Lang;

class ArcGoalView extends ArcGoalGraph {
  var textColor = Graphics.COLOR_LT_GRAY;
  var text = "";

  function initialize(params) {
    ArcGoalGraph.initialize(params);
  }

  function draw(dc as Dc) {
    ArcGoalGraph.draw(dc);
    var tX = (Math.cos(Math.PI / 180 * (self.getCenterDegree())) * self.radius).toNumber() + self.getTextOffsetX();
    var tY = - (Math.sin(Math.PI / 180 * (self.getCenterDegree())) * self.radius).toNumber() + self.getTextOffsetY();

    System.println(self.getCenterDegree() + "," + tX + "," + tY + "," + self.position);


    if (self.text) {
      dc.setColor(self.textColor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(tX + self.x, tY + self.y, Graphics.FONT_XTINY, self.text, self.getTextJustify());
    }
  }

  function setTextColor(color as Number) {
    self.textColor = color;
  }

  function setText(text as String) {
    self.text = text;
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
      case "left": return 8;
      case "top": return 0;
      case "right": return -8;
      case "bottom": return 0;
      default: return 0;
    }
  }

  function getTextOffsetY() {
     switch (self.position) {
      case "left": return -8;
      case "top": return 0;
      case "right": return -8;
      case "bottom": return -48;
      default: return -48;
    }
  }
}
