import 'package:iqmap/src/home/domain/entities/search_items.dart';
import 'package:iqmap/src/home/domain/entities/coordinates.dart';

/// Bundled search data. Coordinates are approximate city/district centers.
const List<SearchItems> iraqLocations = [
  // Governorate capitals
  SearchItems(
    labelAr: 'بغداد',
    labelEn: 'Baghdad',
    coordinates: Coordinates(lat: 33.3152, lng: 44.3661),
  ),
  SearchItems(
    labelAr: 'البصرة',
    labelEn: 'Basra',
    coordinates: Coordinates(lat: 30.5085, lng: 47.7804),
  ),
  SearchItems(
    labelAr: 'الموصل',
    labelEn: 'Mosul',
    coordinates: Coordinates(lat: 36.3400, lng: 43.1300),
  ),
  SearchItems(
    labelAr: 'أربيل',
    labelEn: 'Erbil',
    coordinates: Coordinates(lat: 36.1911, lng: 44.0092),
  ),
  SearchItems(
    labelAr: 'السليمانية',
    labelEn: 'Sulaymaniyah',
    coordinates: Coordinates(lat: 35.5613, lng: 45.4306),
  ),
  SearchItems(
    labelAr: 'دهوك',
    labelEn: 'Duhok',
    coordinates: Coordinates(lat: 36.8669, lng: 42.9503),
  ),
  SearchItems(
    labelAr: 'كركوك',
    labelEn: 'Kirkuk',
    coordinates: Coordinates(lat: 35.4681, lng: 44.3922),
  ),
  SearchItems(
    labelAr: 'النجف',
    labelEn: 'Najaf',
    coordinates: Coordinates(lat: 32.0000, lng: 44.3333),
  ),
  SearchItems(
    labelAr: 'كربلاء',
    labelEn: 'Karbala',
    coordinates: Coordinates(lat: 32.6160, lng: 44.0249),
  ),
  SearchItems(
    labelAr: 'الحلة',
    labelEn: 'Hillah',
    coordinates: Coordinates(lat: 32.4637, lng: 44.4196),
  ),
  SearchItems(
    labelAr: 'الرمادي',
    labelEn: 'Ramadi',
    coordinates: Coordinates(lat: 33.4206, lng: 43.3078),
  ),
  SearchItems(
    labelAr: 'تكريت',
    labelEn: 'Tikrit',
    coordinates: Coordinates(lat: 34.6000, lng: 43.6833),
  ),
  SearchItems(
    labelAr: 'بعقوبة',
    labelEn: 'Baqubah',
    coordinates: Coordinates(lat: 33.7500, lng: 44.6333),
  ),
  SearchItems(
    labelAr: 'الكوت',
    labelEn: 'Kut',
    coordinates: Coordinates(lat: 32.5128, lng: 45.8182),
  ),
  SearchItems(
    labelAr: 'العمارة',
    labelEn: 'Amarah',
    coordinates: Coordinates(lat: 31.8333, lng: 47.1500),
  ),
  SearchItems(
    labelAr: 'الناصرية',
    labelEn: 'Nasiriyah',
    coordinates: Coordinates(lat: 31.0439, lng: 46.2594),
  ),
  SearchItems(
    labelAr: 'الديوانية',
    labelEn: 'Diwaniyah',
    coordinates: Coordinates(lat: 31.9929, lng: 44.9255),
  ),
  SearchItems(
    labelAr: 'السماوة',
    labelEn: 'Samawah',
    coordinates: Coordinates(lat: 31.3199, lng: 45.2803),
  ),
  SearchItems(
    labelAr: 'حلبجة',
    labelEn: 'Halabja',
    coordinates: Coordinates(lat: 35.1833, lng: 45.9833),
  ),

  // Other cities
  SearchItems(
    labelAr: 'الفلوجة',
    labelEn: 'Fallujah',
    coordinates: Coordinates(lat: 33.3500, lng: 43.7833),
  ),
  SearchItems(
    labelAr: 'سامراء',
    labelEn: 'Samarra',
    coordinates: Coordinates(lat: 34.1979, lng: 43.8742),
  ),
  SearchItems(
    labelAr: 'زاخو',
    labelEn: 'Zakho',
    coordinates: Coordinates(lat: 37.1442, lng: 42.6872),
  ),

  // Baghdad
  SearchItems(
    labelAr: 'الكاظمية',
    labelEn: 'Kadhimiya',
    coordinates: Coordinates(lat: 33.3800, lng: 44.3400),
  ),
  SearchItems(
    labelAr: 'الكرادة',
    labelEn: 'Karrada',
    coordinates: Coordinates(lat: 33.3000, lng: 44.4200),
  ),
  SearchItems(
    labelAr: 'مطار بغداد الدولي',
    labelEn: 'Baghdad International Airport',
    coordinates: Coordinates(lat: 33.2625, lng: 44.2346),
  ),
];
