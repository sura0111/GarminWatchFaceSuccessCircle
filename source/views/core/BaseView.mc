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

  public function setPosition(params as { :x as Number, :y as Number }) as Void {
    self.x = params[:x];
    self.y = params[:y];
  }
}
