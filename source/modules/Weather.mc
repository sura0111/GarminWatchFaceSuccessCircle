import Toybox.Weather;
import Toybox.Lang;

module Sura {
  module Weather {
    function getClearIcon(isNight as Boolean) as Symbol {
      if (isNight) {
        return 	Rez.Drawables.weatherNightIcon;
      }
      return Rez.Drawables.weatherSunnyIcon;
    }

    function getWeatherIcon(condition as Number or Null, isNight as Boolean) as Symbol or Null {
      var clearIcon = getClearIcon(isNight);

      switch(condition) {
        case Weather.CONDITION_CLEAR: return clearIcon;
        case Weather.CONDITION_PARTLY_CLOUDY: return 	Rez.Drawables.weatherPartlyCloudyIcon;
        case Weather.CONDITION_MOSTLY_CLOUDY: return 	Rez.Drawables.weatherCloudyIcon;
        case Weather.CONDITION_RAIN: return Rez.Drawables.weatherRainyIcon;
        case Weather.CONDITION_SNOW: return Rez.Drawables.weatherSnowyIcon;
        case Weather.CONDITION_WINDY: return 	Rez.Drawables.weatherWindyIcon;
        case Weather.CONDITION_THUNDERSTORMS: return 	Rez.Drawables.weatherLightningRainyIcon;
        case Weather.CONDITION_WINTRY_MIX: return Rez.Drawables.weatherWindyVariantIcon;
        case Weather.CONDITION_FOG: return Rez.Drawables.weatherFogIcon;
        case Weather.CONDITION_HAZY: return Rez.Drawables.weatherHazyIcon;
        case Weather.CONDITION_HAIL: return Rez.Drawables.weatherHailIcon;
        case Weather.CONDITION_SCATTERED_SHOWERS: return Rez.Drawables.weatherPartlyRainyIcon;
        case Weather.CONDITION_SCATTERED_THUNDERSTORMS: return Rez.Drawables.weatherLightningIcon;
        case Weather.CONDITION_UNKNOWN_PRECIPITATION: return null;
        case Weather.CONDITION_LIGHT_RAIN: return Rez.Drawables.weatherRainyIcon;
        case Weather.CONDITION_HEAVY_RAIN: return Rez.Drawables.weatherPouringIcon;
        case Weather.CONDITION_LIGHT_SNOW: return Rez.Drawables.weatherSnowyIcon;
        case Weather.CONDITION_HEAVY_SNOW: return Rez.Drawables.weatherSnowyHeavyIcon;
        case Weather.CONDITION_LIGHT_RAIN_SNOW: return Rez.Drawables.weatherPartlySnowyRainyIcon;
        case Weather.CONDITION_HEAVY_RAIN_SNOW: return Rez.Drawables.weatherSnowyRainyIcon;
        case Weather.CONDITION_CLOUDY: return Rez.Drawables.weatherCloudyIcon;
        case Weather.CONDITION_RAIN_SNOW: return Rez.Drawables.weatherSnowyRainyIcon;
        case Weather.CONDITION_PARTLY_CLEAR: return Rez.Drawables.weatherPartlyCloudyIcon;
        case Weather.CONDITION_MOSTLY_CLEAR: return clearIcon;
        case Weather.CONDITION_LIGHT_SHOWERS: return Rez.Drawables.weatherRainyIcon;
        case Weather.CONDITION_SHOWERS: return Rez.Drawables.weatherRainyIcon;
        case Weather.CONDITION_HEAVY_SHOWERS: return Rez.Drawables.weatherPouringIcon;
        case Weather.CONDITION_CHANCE_OF_SHOWERS: return Rez.Drawables.weatherPartlySnowyIcon;
        case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS: return Rez.Drawables.weatherLightningRainyIcon;
        case Weather.CONDITION_MIST: return Rez.Drawables.weatherFogIcon;
        case Weather.CONDITION_DUST: return Rez.Drawables.weatherDustIcon;
        case Weather.CONDITION_DRIZZLE: return Rez.Drawables.weatherRainyIcon;
        case Weather.CONDITION_TORNADO: return Rez.Drawables.weatherTornadoIcon;
        case Weather.CONDITION_SMOKE: return Rez.Drawables.weatherSmokeIcon;
        case Weather.CONDITION_ICE: return Rez.Drawables.weatherIceIcon;
        case Weather.CONDITION_SAND: return Rez.Drawables.weatherDustIcon;
        case Weather.CONDITION_SQUALL: return null;
        case Weather.CONDITION_SANDSTORM: return Rez.Drawables.weatherTornadoIcon;
        case Weather.CONDITION_VOLCANIC_ASH: return Rez.Drawables.weatherSmokeIcon;
        case Weather.CONDITION_HAZE: return Rez.Drawables.weatherHazyIcon;
        case Weather.CONDITION_FAIR: return clearIcon;
        case Weather.CONDITION_HURRICANE: return Rez.Drawables.weatherHurricaneOutlineIcon;
        case Weather.CONDITION_TROPICAL_STORM: return Rez.Drawables.weatherLightningRainyIcon;
        case Weather.CONDITION_CHANCE_OF_SNOW: return Rez.Drawables.weatherSnowyIcon;
        case Weather.CONDITION_CHANCE_OF_RAIN_SNOW: return Rez.Drawables.weatherRainyIcon;
        case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN: return Rez.Drawables.weatherPartlyRainyIcon;
        case Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW: return Rez.Drawables.weatherPartlySnowyIcon;
        case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW: return Rez.Drawables.weatherPartlySnowyRainyIcon;
        case Weather.CONDITION_FLURRIES: return null;
        case Weather.CONDITION_FREEZING_RAIN: return Rez.Drawables.weatherSnowyRainyIcon;
        case Weather.CONDITION_SLEET: return null;
        case Weather.CONDITION_ICE_SNOW: return Rez.Drawables.weatherSnowyHeavyIcon;
        case Weather.CONDITION_THIN_CLOUDS: return Rez.Drawables.weatherPartlyCloudyIcon;
        case Weather.CONDITION_UNKNOWN: return null;
        default: return null;
      }
    }
  }
}
