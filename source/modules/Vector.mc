import Toybox.Lang;

module Sura {
  module Vectors {
    class Vector2d {
      var x as Number = 0;
      var y as Number = 0;

      static function createFromNumber(value as Number) as Vector2d {
        var vector = new Vector2d();
        vector.x = value;
        vector.y = value;

        return vector;
      }

      static function createFromVector(value as Vector2d) as Vector2d {
        var vector = new Vector2d();
        vector.x = value.x;
        vector.y = value.y;

        return vector;
      }

      static function createFromXY(x as Number, y as Number) as Vector2d {
        var vector = new Vector2d();
        vector.x = x;
        vector.y = y;

        return vector;
      }

      function initialize() {
        //
      }

      function divide(divider as Number or Vector2d) as Vector2d {
        var dividerVector = divider instanceof Number ? Vector2d.createFromXY(divider, divider) : divider;
        self.x = self.x / dividerVector.x;
        self.y = self.y / dividerVector.y;
        return self;
      }

      function multiply(divider as Number or Vector2d) as Vector2d {
        var dividerVector = divider instanceof Number ? Vector2d.createFromXY(divider, divider) : divider;
        self.x = self.x * dividerVector.x;
        self.y = self.y * dividerVector.y;
        return self;
      }

      function add(divider as Number or Vector2d) as Vector2d {
        var dividerVector = divider instanceof Number ? Vector2d.createFromXY(divider, divider) : divider;
        self.x = self.x + dividerVector.x;
        self.y = self.y + dividerVector.y;
        return self;
      }

      function subtract(divider as Number or Vector2d) as Vector2d {
        var dividerVector = divider instanceof Number ? Vector2d.createFromXY(divider, divider) : divider;
        self.x = self.x - dividerVector.x;
        self.y = self.y - dividerVector.y;
        return self;
      }

      function getMin() as Number {
        return self.x >= self.y ? self.y : self.x;
      }
    }
  }
}
