import Toybox.Graphics;
import Toybox.Lang;
import Sura.Vectors;


module Sura {
  module Device {
    var screenSize as Vector2d = Sura.Vectors.Vector2d.createFromNumber(0);
    var screenCenter as Vector2d = Sura.Vectors.Vector2d.createFromNumber(0);
    var deviceSizeConfigs as Array<{
      :size as Number,
      :timeFontSize as Graphics.FontDefinition,
      :isBackgroundImageSupported as Boolean,
      :isSmallScreen as Boolean
    }> = [
      {
        :size => 260,
        :timeFontSize => Graphics.FONT_NUMBER_MEDIUM,
        :isBackgroundImageSupported => false,
        :isSmallScreen => true,
      },
      {
        :size => 360,
        :timeFontSize => Graphics.FONT_NUMBER_MEDIUM,
        :isBackgroundImageSupported => true,
        :isSmallScreen => false,
      },
      {
        :size => 416,
        :timeFontSize => Graphics.FONT_NUMBER_HOT,
        :isBackgroundImageSupported => true,
        :isSmallScreen => false,
      },
      {
        :size => 454,
        :timeFontSize => Graphics.FONT_NUMBER_HOT,
        :isBackgroundImageSupported => true,
        :isSmallScreen => false,
      }
    ] as Array<{
      :size as Number,
      :timeFontSize as Graphics.FontDefinition,
      :isBackgroundImageSupported as Boolean
    }>;
    var deviceSizeConfig as {
      :size as Number,
      :timeFontSize as Graphics.FontDefinition,
      :isBackgroundImageSupported as Boolean
    } = {
      :size => 0,
      :timeFontSize => Graphics.FONT_NUMBER_MEDIUM,
      :isBackgroundImageSupported => false,
      :isSmallScreen => true
    };
    var timeFontSize as Graphics.FontDefinition = Graphics.FONT_NUMBER_MEDIUM;
    var isBackgroundImageSupported as Boolean = false;
    var isSmallScreen as Boolean = false;

    function load(dc as Dc) as Void {
      self.screenSize = Sura.Vectors.Vector2d.createFromXY(dc.getWidth(), dc.getHeight());
      self.screenCenter = Sura.Vectors.Vector2d.createFromVector(self.screenSize).divide(2);
      self.deviceSizeConfig = self.getDeviceSizeConfig();
      var timeFontSize = self.deviceSizeConfig[:timeFontSize];
      var isBackgroundImageSupported = self.deviceSizeConfig[:isBackgroundImageSupported];
      var isSmallScreen = self.deviceSizeConfig[:isSmallScreen];
      self.timeFontSize = timeFontSize == null ? Graphics.FONT_NUMBER_MEDIUM : timeFontSize;
      self.isBackgroundImageSupported =  isBackgroundImageSupported == null ? false : isBackgroundImageSupported;
      self.isSmallScreen =  isSmallScreen == null ? false : isSmallScreen;
    }

    function getDeviceSizeConfig() as {
      :size as Number,
      :timeFontSize as Graphics.FontDefinition,
      :isBackgroundImageSupported as Boolean
    } {
      var config = self.deviceSizeConfigs[0];

      for (var i = 0; i < self.deviceSizeConfigs.size(); i += 1) {
        config = deviceSizeConfigs[i];
        var size = config[:size];
        if (self.screenSize.x <= (size == null ? 0 : size)) {
          return config;
        }
      }

      return config;
    }
  }
}
