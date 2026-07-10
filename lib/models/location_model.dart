import '../DI.dart';
import '../screens/end_user_phase/settings/settings_screen.dart';

class Location {
  List<Region>? regions;
  List<City>? cities;
  List<Country>? countries;

  Location() {
    countries = [
      Country(1, 'المملكة العربية السعودية', 'Saudi Arabia', 1),
    ];

    cities = [
      City(1, 'الرياض', 'Riyadh', 1),
    ];

    // Districts ("الحي") of Riyadh, shown in place of the old "region" field.
    regions = [
      Region(1, 'العليا', 'Al Olaya'),
      Region(2, 'السليمانية', 'Al Sulimaniyah'),
      Region(3, 'الملز', 'Al Malaz'),
      Region(4, 'المروج', 'Al Muruj'),
      Region(5, 'الملقا', 'Al Malqa'),
      Region(6, 'الياسمين', 'Al Yasmin'),
      Region(7, 'النرجس', 'Al Narjis'),
      Region(8, 'الصحافة', 'Al Sahafah'),
      Region(9, 'النخيل', 'Al Nakheel'),
      Region(10, 'الورود', 'Al Wurud'),
      Region(11, 'المصيف', 'Al Masif'),
      Region(12, 'المغرزات', 'Al Mughrizat'),
      Region(13, 'التعاون', 'Al Taawun'),
      Region(14, 'الازدهار', 'Al Izdihar'),
      Region(15, 'الربوة', 'Al Rabwah'),
      Region(16, 'الروضة', 'Al Rawdah'),
      Region(17, 'الريان', 'Al Rayyan'),
      Region(18, 'النسيم الغربي', 'West Al Naseem'),
      Region(19, 'النسيم الشرقي', 'East Al Naseem'),
      Region(20, 'القدس', 'Al Quds'),
      Region(21, 'الحمراء', 'Al Hamra'),
      Region(22, 'غرناطة', 'Ghirnatah'),
      Region(23, 'قرطبة', 'Qurtubah'),
      Region(24, 'اشبيلية', 'Ishbiliyah'),
      Region(25, 'الروابي', 'Al Rawabi'),
      Region(26, 'الخليج', 'Al Khaleej'),
      Region(27, 'المنار', 'Al Manar'),
      Region(28, 'السلام', 'Al Salam'),
      Region(29, 'الدار البيضاء', 'Al Dar Al Baida'),
      Region(30, 'المنصورة', 'Al Mansurah'),
      Region(31, 'اليمامة', 'Al Yamamah'),
      Region(32, 'منفوحة', 'Manfuhah'),
      Region(33, 'منفوحة الجديدة', 'New Manfuhah'),
      Region(34, 'العود', 'Al Oud'),
      Region(35, 'الديرة', 'Al Dirah'),
      Region(36, 'الفوطة', 'Al Futah'),
      Region(37, 'الوشام', 'Al Wisham'),
      Region(38, 'المرقب', 'Al Marqab'),
      Region(39, 'الجرادية', 'Al Jaradiyah'),
      Region(40, 'الشميسي', 'Al Shumaisi'),
      Region(41, 'عليشة', 'Ulaishah'),
      Region(42, 'البديعة', 'Al Badiah'),
      Region(43, 'الشرفية', 'Al Sharafiyah'),
      Region(44, 'الناصرية', 'Al Nasriyah'),
      Region(45, 'الفاخرية', 'Al Fakhriyah'),
      Region(46, 'الحائر', 'Al Hair'),
      Region(47, 'السويدي', 'Al Suwaidi'),
      Region(48, 'السويدي الغربي', 'West Al Suwaidi'),
      Region(49, 'ظهرة البديعة', 'Dhahrat Al Badiah'),
      Region(50, 'شبرا', 'Shubra'),
      Region(51, 'السلي', 'Al Sulai'),
      Region(52, 'الفيصلية', 'Al Faisaliyah'),
      Region(53, 'الفلاح', 'Al Falah'),
      Region(54, 'القيروان', 'Al Qirawan'),
      Region(55, 'حطين', 'Hittin'),
      Region(56, 'الرحمانية', 'Al Rahmaniyah'),
      Region(57, 'الرائد', 'Al Raid'),
      Region(58, 'الجزيرة', 'Al Jazirah'),
      Region(59, 'الخزامى', 'Al Khuzama'),
      Region(60, 'أم الحمام الشرقي', 'East Umm Al Hamam'),
      Region(61, 'أم الحمام الغربي', 'West Umm Al Hamam'),
      Region(62, 'الوزارات', 'Al Wizarat'),
      Region(63, 'المعذر', 'Al Mathar'),
      Region(64, 'المعذر الشمالي', 'North Al Mathar'),
      Region(65, 'صلاح الدين', 'Salah Ad Din'),
      Region(66, 'الواحة', 'Al Wahah'),
      Region(67, 'الفيحاء', 'Al Fayha'),
      Region(68, 'الربيع', 'Al Rabi'),
      Region(69, 'الغدير', 'Al Ghadir'),
      Region(70, 'العقيق', 'Al Aqiq'),
      Region(71, 'الوادي', 'Al Wadi'),
      Region(72, 'النزهة', 'Al Nuzhah'),
      Region(73, 'النظيم', 'Al Nadheem'),
      Region(74, 'المونسية', 'Al Munsiyah'),
      Region(75, 'اليرموك', 'Al Yarmuk'),
      Region(76, 'السعادة', 'Al Saadah'),
      Region(77, 'الرمال', 'Al Rimal'),
      Region(78, 'النهضة', 'Al Nahdah'),
      Region(79, 'غبيرة', 'Ghubairah'),
      Region(80, 'طويق', 'Tuwaiq'),
      Region(81, 'ديراب', 'Dirab'),
      Region(82, 'عرقة', 'Irqah'),
      Region(83, 'لبن', 'Laban'),
      Region(84, 'الحزم', 'Al Hazm'),
      Region(85, 'ظهرة لبن', 'Dhahrat Laban'),
      Region(86, 'الشفا', 'Al Shifa'),
      Region(87, 'بدر', 'Badr'),
      Region(88, 'المصفاة', 'Al Masfah'),
      Region(89, 'عكاظ', 'Ukadh'),
      Region(90, 'سلطانة', 'Sultanah'),
      Region(91, 'الخالدية', 'Al Khalidiyah'),
      Region(92, 'المؤتمرات', 'Al Mutamarat'),
      Region(93, 'الملك فهد', 'King Fahd'),
      Region(94, 'الملك عبدالله', 'King Abdullah'),
      Region(95, 'الملك عبدالعزيز', 'King Abdulaziz'),
      Region(96, 'المروة', 'Al Marwah'),
      Region(97, 'الزهرة', 'Al Zahrah'),
      Region(98, 'الصفا', 'Al Safa'),
      Region(99, 'النور', 'Al Noor'),
      Region(100, 'الدريهمية', 'Al Duraihimiyah'),
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
