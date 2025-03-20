import 'package:equatable/equatable.dart';

class School extends Equatable {
  final String id;
  final String name;
  final String? address;
  final String? county;
  final String? phoneNumber;
  final String? email;
  final String? logoUrl;
  final String? motto;
  final String? website;
  final DateTime createdAt;
  final DateTime updatedAt;

  const School({
    required this.id,
    required this.name,
    this.address,
    this.county,
    this.phoneNumber,
    this.email,
    this.logoUrl,
    this.motto,
    this.website,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    county,
    phoneNumber,
    email,
    logoUrl,
    motto,
    website,
    createdAt,
    updatedAt,
  ];

  School copyWith({
    String? id,
    String? name,
    String? address,
    String? county,
    String? phoneNumber,
    String? email,
    String? logoUrl,
    String? motto,
    String? website,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return School(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      county: county ?? this.county,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      logoUrl: logoUrl ?? this.logoUrl,
      motto: motto ?? this.motto,
      website: website ?? this.website,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
