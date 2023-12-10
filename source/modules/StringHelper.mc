import Toybox.Lang;

module Sura {
  module StringHelper {
    function padStart(target as String, targetLength as Number, padChar as String) as String {
      while (target.length() < targetLength) {
        target = padChar + target;
      }

      return target;
    }
  }
}
