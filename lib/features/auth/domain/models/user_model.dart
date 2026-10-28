import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String id;
  final String label;
  final String street;
  final String city;
  final String area;
  final String building;
  final String floor;
  final String apartment;
  final bool isDefault;

  const Address({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.area,
    required this.building,
    required this.floor,
    required this.apartment,
    this.isDefault = false,
  });

  String get fullAddress {
    return '$building, Floor $floor, Apt $apartment\n$street, $area\n$city';
  }

  Address copyWith({
    String? id,
    String? label,
    String? street,
    String? city,
    String? area,
    String? building,
    String? floor,
    String? apartment,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      street: street ?? this.street,
      city: city ?? this.city,
      area: area ?? this.area,
      building: building ?? this.building,
      floor: floor ?? this.floor,
      apartment: apartment ?? this.apartment,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [id, label, street, city, area, building, floor, apartment, isDefault];
}

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final List<Address> addresses;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
    this.addresses = const [],
  });

  Address? get defaultAddress {
    try {
      return addresses.firstWhere((addr) => addr.isDefault);
    } catch (_) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    List<Address>? addresses,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      addresses: addresses ?? this.addresses,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, avatarUrl, addresses];
}
