import Toybox.Lang;

module StringHelpers {
  function padStart(target as String, targetLength as Number, padChar) as String {
    while (target.length() < targetLength) {
      target = padChar + target;
    }

    return target;
  }
}
