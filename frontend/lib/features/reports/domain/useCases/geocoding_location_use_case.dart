import 'package:CivicPulse/features/reports/domain/repositories/report_repository.dart';

class GeocodingLocationUseCase {
  final ReportRepository repository;

  // In-memory cache using coordinates rounded to 5 decimal places (~1.1 meter accuracy)
  static final Map<String, String> _geocodeCache = {};

  GeocodingLocationUseCase({required this.repository});

  Future<String> call({
    required double latitude,
    required double longitude,
  }) async {
    final key = "${latitude.toStringAsFixed(5)},${longitude.toStringAsFixed(5)}";
    if (_geocodeCache.containsKey(key)) {
      return _geocodeCache[key]!;
    }

    final result = await repository.reverseGeocode(lat: latitude, lng: longitude);
    _geocodeCache[key] = result;
    return result;
  }
}
