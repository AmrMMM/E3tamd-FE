import '../DI.dart';
import '../screens/end_user_phase/settings/settings_screen.dart';

class Location {
  List<Region>? regions;
  List<City>? cities;
  List<Country>? countries;

  Location() {
    regions = [
      Region(1, 'المنطقة1', ""),
      Region(2, 'المنطقة2', ""),
      // Add more regions here
    ];

    countries = [
      Country(1, 'بلد1', 'Country1', 1),
      Country(2, 'بلد2', 'Country2', 2),
      // Add more countries here
    ];

    cities = [
      City(1, 'مدينة1', 'City1', 1),
      City(2, 'مدينة2', 'City2', 2),
      // Add more cities here
    ];
  }

  List<City> getCitiesByCountryId(int countryId) {
    return cities!.where((city) => city.countryId == countryId).toList();
  }

  List<Country> getCountriesByRegionId(int regionId) {
    return countries!.where((country) => country.regionId == regionId).toList();
  }
}

class Region {
  final int id;
  final String arabicName;
  final String englishName;

  Region(this.id, this.arabicName, this.englishName);

  String getRegionName() {
    if (useLanguage == Languages.arabic.name) {
      return arabicName;
    } else {
      return englishName;
    }
  }
}

class City {
  final int id;
  final String arabicName;
  final String englishName;
  final int countryId;

  City(this.id, this.arabicName, this.englishName, this.countryId);

  String getCityName() {
    if (useLanguage == Languages.arabic.name) {
      return arabicName;
    } else {
      return englishName;
    }
  }
}

class Country {
  final int id;
  final String arabicName;
  final String englishName;
  final int regionId;

  Country(this.id, this.arabicName, this.englishName, this.regionId);

  String getCountryName() {
    if (useLanguage == Languages.arabic.name) {
      return arabicName;
    } else {
      return englishName;
    }
  }
}
