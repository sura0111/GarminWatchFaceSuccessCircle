import Toybox.Graphics;
import Toybox.Math;
import Toybox.Lang;
import Toybox.WatchUi;

class ArcGoalView extends ArcGoalGraphView {
  var textColor as Graphics.ColorValue = Graphics.COLOR_LT_GRAY;
  var text as String = "";
  var icon as WatchUi.Resource or Null = null;

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
    ArcGoalGraphView.initialize(params);
  }

  function draw(dc as Dc) {
    ArcGoalGraphView.draw(dc);
    var tX = (Math.cos(Math.PI / 180 * (self.getCenterDegree())) * self.radius).toNumber();
    var tY = - (Math.sin(Math.PI / 180 * (self.getCenterDegree())) * self.radius).toNumber();
    var text = self.text;
    var icon = self.icon;

    if (text.length() != 0) {
      dc.setColor(self.textColor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        tX + self.x + self.getTextOffsetX(),
        tY + self.y + self.getTextOffsetY(),
        Graphics.FONT_XTINY,
        text,
        self.getTextJustify()
      );

      if (icon != null) {
        dc.drawBitmap(
          tX + self.x + self.getIconOffsetX(),
          tY + self.y + self.getIconOffsetY(),
          icon
        );
      }
    }
  }

  function setTextColor(color as Graphics.ColorValue) as Void {
    self.textColor = color;
  }

  function setText(text as String) as Void {
    self.text = text;
  }

  function setIcon(icon as BitmapResource) as Void {
    self.icon = icon;
  }

  function getIconHeight() as Number {
    if (self.icon == null) {
      return 0;
    }
    return self.icon.getHeight();
  }

  function getIconWidth() as Number {
    if (self.icon == null) {
      return 0;
    }
    return self.icon.getWidth();
  }

  function getGap() as Number {
    if (self.icon == null) {
      return 0;
    }
    return 4;
  }

  function getFontHeight() as Number {
    return Graphics.getFontHeight(Graphics.FONT_XTINY);
  }

  function getTotalHeight() as Number {
    return self.getIconHeight() + self.getFontHeight() + self.getGap();
  }

  function getTextJustify() as Graphics.TextJustification {
     switch (self.position) {
      case "left": return Graphics.TEXT_JUSTIFY_LEFT;
      case "top": return Graphics.TEXT_JUSTIFY_CENTER;
      case "right": return Graphics.TEXT_JUSTIFY_RIGHT;
      case "bottom": return Graphics.TEXT_JUSTIFY_CENTER;
      default: return Graphics.TEXT_JUSTIFY_CENTER;
    }
  }

  function getTextOffsetX() as Number {
     switch (self.position) {
      case "top": return 0;
      case "right": return - self.getFontHeight() / 2;
      case "bottom": return 0;
      case "left": return self.getFontHeight() / 2;
      default: return 0;
    }
  }

  function getTextOffsetY() as Number {
     switch (self.position) {
      case "top": return 0;
      case "right": return -8;
      case "bottom": return - self.getFontHeight() - 12;
      case "left": return (-(self.getTotalHeight() / 2) + self.getGap() + self.getIconHeight()).toNumber();
      default: return - self.getFontHeight() - 12;
    }
  }

  function getIconOffsetX() as Number {
     switch (self.position) {
      case "top": return -self.icon.getWidth() / 2;
      case "right": return (- self.getFontHeight() / 2).toNumber();
      case "bottom": return -self.icon.getWidth() / 2;
      case "left": return (self.getFontHeight() / 2).toNumber();
      default: return 0;
    }
  }

  function getIconOffsetY() as Number {
     switch (self.position) {
      case "top": return 0;
      case "right": return -8;
      case "bottom": return (-1 * self.getTotalHeight() - 12).toNumber();
      case "left": return (-1 * self.getTotalHeight() / 2).toNumber();
      default: return -100;
    }
  }
}
