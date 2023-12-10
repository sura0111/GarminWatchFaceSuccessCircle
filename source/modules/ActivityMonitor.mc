
import Toybox.Lang;
import Toybox.ActivityMonitor;

module Sura {
  module ActivityMonitor {
    var info as ActivityMonitor.Info? = null;

    function init() {
      self.info = ActivityMonitor.getInfo();
    }

    function getStepText() as String {
      var stepText = Lang.format("$1$/$2$", [self.getSteps(), self.getStepGoal()]);
      
      if (stepText.length() >= 10) {
        return info.steps.format("%d");
      }

      return stepText;
    }

    function getSteps() as Number {
      var info = self.info;
      return info != null && info.steps != null ? info.steps : 0;
    }

    function getStepGoal() as Number {
      var info = self.info;
      return info != null && info.stepGoal != null ? info.stepGoal : 0;
    }
  }
}
