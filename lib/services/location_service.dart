import '../core/result/result.dart';

/// Service for location-related operations
class LocationService {
  /// Get current location
  Future<Result<Map<String, double>>> getCurrentLocation() async {
    try {
      // Mock implementation - in real app, this would use geolocator package
      await Future.delayed(const Duration(milliseconds: 1000));
      
      final location = {
        'latitude': 37.7749,
        'longitude': -122.4194,
      };
      
      return Success(location);
    } catch (e) {
      return Failure(Exception('Failed to get current location: $e'));
    }
  }

  /// Get nearby restaurants
  Future<Result<List<Map<String, dynamic>>>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    try {
      // Mock implementation - in real app, this would call Google Places API
      await Future.delayed(const Duration(milliseconds: 800));
      
      final restaurants = [
        {
          'id': 'rest_1',
          'name': 'Tasty Bites',
          'address': '123 Main St, San Francisco, CA',
          'rating': 4.5,
          'distance': 0.5,
          'cuisine': 'Italian',
        },
        {
          'id': 'rest_2',
          'name': 'Fresh Kitchen',
          'address': '456 Oak Ave, San Francisco, CA',
          'rating': 4.2,
          'distance': 1.2,
          'cuisine': 'Mediterranean',
        },
        {
          'id': 'rest_3',
          'name': 'Spice Garden',
          'address': '789 Pine St, San Francisco, CA',
          'rating': 4.7,
          'distance': 0.8,
          'cuisine': 'Indian',
        },
      ];
      
      return Success(restaurants);
    } catch (e) {
      return Failure(Exception('Failed to get nearby restaurants: $e'));
    }
  }

  /// Calculate distance between two points
  double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    // Simple distance calculation using Haversine formula
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    
    final a = (dLat / 2).sin() * (dLat / 2).sin() +
        _degreesToRadians(lat1).cos() *
            _degreesToRadians(lat2).cos() *
            (dLon / 2).sin() *
            (dLon / 2).sin();
    
    final c = 2 * a.sqrt().asin();
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }
}
