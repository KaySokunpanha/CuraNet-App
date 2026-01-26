import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NearbyService {
  Future<List<Map<String, dynamic>>> getNearbyFacilities(String type) async {
    // 1. Get Real User Position
    Position position;
    try {
      position = await _determinePosition();
    } catch (e) {
      position = Position(
        longitude: 77.2090,
        latitude: 28.6139,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }

    // 2. Try Fetching from Google Places API (New)
    // If API is disabled or fails, we fall back to mock data.
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];

    if (apiKey != null && apiKey.isNotEmpty) {
      try {
        // Mapping internal types to New Places API types
        String includedType = 'hospital';
        if (type == 'pharmacy') includedType = 'pharmacy';
        if (type == 'lab') includedType = 'medical_lab';

        const url = 'https://places.googleapis.com/v1/places:searchNearby';

        final body = {
          "includedTypes": [includedType],
          "maxResultCount": 10,
          "locationRestriction": {
            "circle": {
              "center": {
                "latitude": position.latitude,
                "longitude": position.longitude,
              },
              "radius": 5000.0,
            },
          },
        };

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': apiKey,
            // Requesting specific fields to save data/cost
            'X-Goog-FieldMask':
                'places.displayName,places.formattedAddress,places.location,places.regularOpeningHours,places.rating',
          },
          body: json.encode(body),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          // New API returns 'places' array
          final List<dynamic> places = data['places'] ?? [];

          if (places.isNotEmpty) {
            return places.map<Map<String, dynamic>>((place) {
              final loc = place['location'];
              final isOpen = place['regularOpeningHours']?['openNow'] ?? false;

              // Calculate straight-line distance
              final distMeters = Geolocator.distanceBetween(
                position.latitude,
                position.longitude,
                loc['latitude'],
                loc['longitude'],
              );

              // Extract name from displayName object
              final nameText = place['displayName'] != null
                  ? place['displayName']['text']
                  : 'Unknown';

              return {
                'name': nameText,
                'address': place['formattedAddress'] ?? 'No address',
                'distance': (distMeters / 1000).toStringAsFixed(1),
                'isOpen': isOpen,
                'rating': (place['rating'] ?? 0.0).toDouble(),
                'phone': 'N/A',
                'type': type,
                'lat': loc['latitude'],
                'lng': loc['longitude'],
              };
            }).toList();
          }
        } else {
          print(
            'Places API Error (Using Mock): ${response.statusCode} - ${response.body}',
          );
        }
      } catch (e) {
        print('Exception fetching places (Using Mock): $e');
      }
    }

    // 3. Fallback to Mock Data
    return _getMockFacilities(type, position);
  }

  List<Map<String, dynamic>> _getMockFacilities(
    String type,
    Position position,
  ) {
    final List<Map<String, dynamic>> facilities = [];
    final random = Random();

    double getLat() => position.latitude + (random.nextDouble() - 0.5) * 0.02;
    double getLng() => position.longitude + (random.nextDouble() - 0.5) * 0.02;

    if (type == 'hospital') {
      facilities.addAll([
        {
          'name': 'City General Hospital',
          'address': '124 Medical Plaza',
          'distance': '1.2',
          'isOpen': true,
          'rating': 4.5,
          'phone': '102',
          'type': 'Hospital',
          'lat': getLat(),
          'lng': getLng(),
        },
        {
          'name': 'St. Mary’s Emergency',
          'address': '45 West Avenue',
          'distance': '2.8',
          'isOpen': true,
          'rating': 4.8,
          'phone': '102',
          'type': 'Emergency',
          'lat': getLat(),
          'lng': getLng(),
        },
        {
          'name': 'Community Health Clinic',
          'address': '89 Northend Road',
          'distance': '4.1',
          'isOpen': false,
          'rating': 3.9,
          'phone': '102',
          'type': 'Clinic',
          'lat': getLat(),
          'lng': getLng(),
        },
      ]);
    } else if (type == 'pharmacy') {
      facilities.addAll([
        {
          'name': 'Green Cross Pharmacy',
          'address': '12 Main Street',
          'distance': '0.3',
          'isOpen': true,
          'rating': 4.2,
          'phone': '555-0123',
          'type': 'Pharmacy',
          'lat': getLat(),
          'lng': getLng(),
        },
        {
          'name': 'Apollo 24/7 Pharmacy',
          'address': '45 Market Road',
          'distance': '0.8',
          'isOpen': true,
          'rating': 4.6,
          'phone': '555-0124',
          'type': 'Pharmacy',
          'lat': getLat(),
          'lng': getLng(),
        },
      ]);
    } else if (type == 'lab') {
      facilities.addAll([
        {
          'name': 'Dr. Lal PathLabs',
          'address': 'Sector 4',
          'distance': '1.1',
          'isOpen': true,
          'rating': 4.4,
          'phone': '555-0126',
          'type': 'Pathology',
          'lat': getLat(),
          'lng': getLng(),
        },
        {
          'name': 'City X-Ray Center',
          'address': 'Near City Hospital',
          'distance': '1.3',
          'isOpen': true,
          'rating': 4.3,
          'phone': '555-0127',
          'type': 'Radiology',
          'lat': getLat(),
          'lng': getLng(),
        },
      ]);
    }
    return facilities;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }
}
