import Toybox.Weather;
import Toybox.Lang;
import Sura.StringHelper;
import Toybox.System;
import Toybox.WatchUi;

module Sura {
  module Weather {
    var currentConditions as Weather.CurrentConditions or Null = null;
    var sunnyIcon as WatchUi.Resource = WatchUi.loadResource(Rez.Drawables.weatherSunnyIcon);
    var nightIcon as WatchUi.Resource = WatchUi.loadResource(Rez.Drawables.weatherNightIcon);
    var weatherIcons as Dictionary<Number, WatchUi.Resource or Null> = {
      Weather.CONDITION_CLEAR => null,
      Weather.CONDITION_PARTLY_CLOUDY => 	WatchUi.loadResource(Rez.Drawables.weatherPartlyCloudyIcon),
      Weather.CONDITION_MOSTLY_CLOUDY => 	WatchUi.loadResource(Rez.Drawables.weatherCloudyIcon),
      Weather.CONDITION_RAIN => WatchUi.loadResource(Rez.Drawables.weatherRainyIcon),
      Weather.CONDITION_SNOW => WatchUi.loadResource(Rez.Drawables.weatherSnowyIcon),
      Weather.CONDITION_WINDY => 	WatchUi.loadResource(Rez.Drawables.weatherWindyIcon),
      Weather.CONDITION_THUNDERSTORMS => 	WatchUi.loadResource(Rez.Drawables.weatherLightningRainyIcon),
      Weather.CONDITION_WINTRY_MIX => WatchUi.loadResource(Rez.Drawables.weatherWindyVariantIcon),
      Weather.CONDITION_FOG => WatchUi.loadResource(Rez.Drawables.weatherFogIcon),
      Weather.CONDITION_HAZY => WatchUi.loadResource(Rez.Drawables.weatherHazyIcon),
      Weather.CONDITION_HAIL => WatchUi.loadResource(Rez.Drawables.weatherHailIcon),
      Weather.CONDITION_SCATTERED_SHOWERS => WatchUi.loadResource(Rez.Drawables.weatherPartlyRainyIcon),
      Weather.CONDITION_SCATTERED_THUNDERSTORMS => WatchUi.loadResource(Rez.Drawables.weatherLightningIcon),
      Weather.CONDITION_UNKNOWN_PRECIPITATION => null,
      Weather.CONDITION_LIGHT_RAIN => WatchUi.loadResource(Rez.Drawables.weatherRainyIcon),
      Weather.CONDITION_HEAVY_RAIN => WatchUi.loadResource(Rez.Drawables.weatherPouringIcon),
      Weather.CONDITION_LIGHT_SNOW => WatchUi.loadResource(Rez.Drawables.weatherSnowyIcon),
      Weather.CONDITION_HEAVY_SNOW => WatchUi.loadResource(Rez.Drawables.weatherSnowyHeavyIcon),
      Weather.CONDITION_LIGHT_RAIN_SNOW => WatchUi.loadResource(Rez.Drawables.weatherPartlySnowyRainyIcon),
      Weather.CONDITION_HEAVY_RAIN_SNOW => WatchUi.loadResource(Rez.Drawables.weatherSnowyRainyIcon),
      Weather.CONDITION_CLOUDY => WatchUi.loadResource(Rez.Drawables.weatherCloudyIcon),
      Weather.CONDITION_RAIN_SNOW => WatchUi.loadResource(Rez.Drawables.weatherSnowyRainyIcon),
      Weather.CONDITION_PARTLY_CLEAR => WatchUi.loadResource(Rez.Drawables.weatherPartlyCloudyIcon),
      Weather.CONDITION_MOSTLY_CLEAR => null,
      Weather.CONDITION_LIGHT_SHOWERS => WatchUi.loadResource(Rez.Drawables.weatherRainyIcon),
      Weather.CONDITION_SHOWERS => WatchUi.loadResource(Rez.Drawables.weatherRainyIcon),
      Weather.CONDITION_HEAVY_SHOWERS => WatchUi.loadResource(Rez.Drawables.weatherPouringIcon),
      Weather.CONDITION_CHANCE_OF_SHOWERS => WatchUi.loadResource(Rez.Drawables.weatherPartlySnowyIcon),
      Weather.CONDITION_CHANCE_OF_THUNDERSTORMS => WatchUi.loadResource(Rez.Drawables.weatherLightningRainyIcon),
      Weather.CONDITION_MIST => WatchUi.loadResource(Rez.Drawables.weatherFogIcon),
      Weather.CONDITION_DUST => WatchUi.loadResource(Rez.Drawables.weatherDustIcon),
      Weather.CONDITION_DRIZZLE => WatchUi.loadResource(Rez.Drawables.weatherRainyIcon),
      Weather.CONDITION_TORNADO => WatchUi.loadResource(Rez.Drawables.weatherTornadoIcon),
      Weather.CONDITION_SMOKE => WatchUi.loadResource(Rez.Drawables.weatherSmokeIcon),
      Weather.CONDITION_ICE => WatchUi.loadResource(Rez.Drawables.weatherIceIcon),
      Weather.CONDITION_SAND => WatchUi.loadResource(Rez.Drawables.weatherDustIcon),
      Weather.CONDITION_SQUALL => null,
      Weather.CONDITION_SANDSTORM => WatchUi.loadResource(Rez.Drawables.weatherTornadoIcon),
      Weather.CONDITION_VOLCANIC_ASH => WatchUi.loadResource(Rez.Drawables.weatherSmokeIcon),
      Weather.CONDITION_HAZE => WatchUi.loadResource(Rez.Drawables.weatherHazyIcon),
      Weather.CONDITION_FAIR => null,
      Weather.CONDITION_HURRICANE => WatchUi.loadResource(Rez.Drawables.weatherHurricaneOutlineIcon),
      Weather.CONDITION_TROPICAL_STORM => WatchUi.loadResource(Rez.Drawables.weatherLightningRainyIcon),
      Weather.CONDITION_CHANCE_OF_SNOW => WatchUi.loadResource(Rez.Drawables.weatherSnowyIcon),
      Weather.CONDITION_CHANCE_OF_RAIN_SNOW => WatchUi.loadResource(Rez.Drawables.weatherRainyIcon),
      Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN => WatchUi.loadResource(Rez.Drawables.weatherPartlyRainyIcon),
      Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW => WatchUi.loadResource(Rez.Drawables.weatherPartlySnowyIcon),
      Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW => WatchUi.loadResource(Rez.Drawables.weatherPartlySnowyRainyIcon),
      Weather.CONDITION_FLURRIES => null,
      Weather.CONDITION_FREEZING_RAIN => WatchUi.loadResource(Rez.Drawables.weatherSnowyRainyIcon),
      Weather.CONDITION_SLEET => null,
      Weather.CONDITION_ICE_SNOW => WatchUi.loadResource(Rez.Drawables.weatherSnowyHeavyIcon),
      Weather.CONDITION_THIN_CLOUDS => WatchUi.loadResource(Rez.Drawables.weatherPartlyCloudyIcon),
      Weather.CONDITION_UNKNOWN => null,
    } as Dictionary<Number, WatchUi.Resource or Null>;

    var temperatureUnitsTexts as Dictionary<System.UnitsSystem, String> = {
      System.UNIT_METRIC => "°C",
      System.UNIT_STATUTE => "°F",
    } as Dictionary<System.UnitsSystem, String>;

    function getClearIcon(isNight as Boolean) as WatchUi.Resource {
      if (isNight) {
        return 	Sura.Weather.nightIcon;
      }
      return Sura.Weather.sunnyIcon;
    }

    function getWeatherIcon(isNight as Boolean) as WatchUi.Resource or Null {
      var currentConditions = Sura.Weather.currentConditions;
      if (currentConditions == null) {
        return null;
      }

      var condition = currentConditions.condition;

      if (condition == null) {
        return null;
      }
      var clearIcon = getClearIcon(isNight);

      switch(condition) {
        case Weather.CONDITION_CLEAR: return clearIcon;
        case Weather.CONDITION_FAIR: return clearIcon;
        default: return Sura.Weather.weatherIcons[condition];
      }
    }

    function init() as Void {
      Sura.Weather.currentConditions = Weather.getCurrentConditions(); 
    }

    function getFahrenheit(celcius as Number or Null) as Number or Null {
      if (celcius == null) {
        return null;
      }

      return (celcius * 9/5) + 32;
    }

    function getTemperature(temperatureUnits as System.UnitsSystem or Null) as Number or Null {
      var conditions = Sura.Weather.currentConditions;
      if (conditions == null) {
        return null;
      }

      if (temperatureUnits == System.UNIT_STATUTE) {
        return getFahrenheit(conditions.temperature);
      }

      return conditions.temperature;
    }

    function getTemperatureUnitsText(temperatureUnits as System.UnitsSystem or Null) as String {
      if (temperatureUnits == null) {
        return "°";
      }

      var unit = Sura.Weather.temperatureUnitsTexts[temperatureUnits];

      if (unit == null) {
        return "°";
      }

      return unit;
    }

    function getTemperatureAndPrecipitationChanceInfo(temperatureUnits as System.UnitsSystem or Null) as String {
      var conditions = Sura.Weather.currentConditions;
      var temperature = getTemperature(temperatureUnits);
      var temperatureUnitsText = getTemperatureUnitsText(temperatureUnits);

      if (conditions == null || temperature == null) {
        return "--" + temperatureUnitsText + "/" + "--";
      }

      var precipitationChance = conditions.precipitationChance;
      var temperatureText = StringHelper.padStart(temperature.format("%d"), 3, " ") + temperatureUnitsText;

      if (precipitationChance == null) {
        return temperatureText;
      }

      var precipitationChanceText = StringHelper.padStart(precipitationChance.format("%d"), 2, " ") + "%";

      return temperatureText + "/" + precipitationChanceText;
    }
  }
}
