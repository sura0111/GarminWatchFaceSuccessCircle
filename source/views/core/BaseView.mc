import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;

class BaseView extends WatchUi.View {
  var x as Number = -9999;
  var y as Number = -9999;

  function initialize() {
    View.initialize();
  }

  public function setPosition(x as Number, y as Number) as Void {
    self.x = x;
    self.y = y;
  }
}
