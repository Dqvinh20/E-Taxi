import 'dart:convert';

import 'package:grab_clone/models/Driver.dart';
import 'package:grab_clone/models/Location.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class TopHistory {
  String? id;
  String? phoneNumber;
  String? vehicleType;
  Location? pickupAddr;
  Location? destAddr;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? pickupAddrFull;
  String? destAddrFull;
  DriverModel? driver;

  TopHistory(
      {this.id,
      this.phoneNumber,
      this.vehicleType,
      this.pickupAddr,
      this.destAddr,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.pickupAddrFull,
      this.destAddrFull,
      this.driver});

  TopHistory copyWith(
      {String? id,
      String? phoneNumber,
      String? vehicleType,
      Location? pickupAddr,
      Location? destAddr,
      String? status,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? pickupAddrFull,
      String? destAddrFull,
      DriverModel? driver}) {
    return TopHistory(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      pickupAddr: pickupAddr ?? this.pickupAddr,
      destAddr: destAddr ?? this.destAddr,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      destAddrFull: destAddrFull ?? this.destAddrFull,
      pickupAddrFull: pickupAddrFull ?? this.pickupAddrFull,
      driver: driver ?? this.driver,
    );
  }

  TopHistory deepCopyWith(
      {String? id,
      String? phoneNumber,
      String? vehicleType,
      Location? pickupAddr,
      Location? destAddr,
      String? status,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? pickupAddrFull,
      String? destAddrFull,
      DriverModel? driver}) {
    return TopHistory(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      pickupAddr: pickupAddr ?? this.pickupAddr!.copyWith(),
      destAddr: destAddr ?? this.destAddr!.copyWith(),
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      destAddrFull: destAddrFull ?? this.destAddrFull,
      pickupAddrFull: pickupAddrFull ?? this.pickupAddrFull,
      driver: driver ?? this.driver!.copyWith(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'phoneNumber': phoneNumber,
      'vehicleType': vehicleType,
      'pickupAddr': pickupAddr?.toMap(),
      'destAddr': destAddr?.toMap(),
      'status': status,
      'createdAt': createdAt?.toString(),
      'updatedAt': updatedAt?.toString,
      "destAddrFull": destAddrFull,
      "pickupAddrFull": pickupAddrFull,
      'driver': driver?.toMap(),
    };
  }

  factory TopHistory.fromMap(Map<String, dynamic> map) {
    return TopHistory(
      id: map['_id'] != null ? map['_id'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      vehicleType:
          map['vehicleType'] != null ? map['vehicleType'] as String : null,
      pickupAddr: map['pickupAddr'] != null
          ? Location.fromMap(map['pickupAddr'] as Map<String, dynamic>)
          : null,
      destAddr: map['destAddr'] != null
          ? Location.fromMap(map['destAddr'] as Map<String, dynamic>)
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      pickupAddrFull: map['pickupAddrFull'] != null
          ? map['pickupAddrFull'] as String
          : null,
      destAddrFull:
          map['destAddrFull'] != null ? map['destAddrFull'] as String : null,
      driver: map['driver'] != null
          ? DriverModel.fromMap(map['driver'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TopHistory.fromJson(String source) =>
      TopHistory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TopHistory(id: $id, phoneNumber: $phoneNumber, vehicleType: $vehicleType, pickupAddr: $pickupAddr, destAddr: $destAddr, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, pickupAddrFull: $pickupAddrFull, destAddrFull: $destAddrFull, driver: $driver)';
  }

  @override
  bool operator ==(covariant TopHistory other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.phoneNumber == phoneNumber &&
        other.vehicleType == vehicleType &&
        other.pickupAddr == pickupAddr &&
        other.destAddr == destAddr &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.pickupAddrFull == pickupAddrFull &&
        other.destAddrFull == destAddrFull &&
        other.driver == driver;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        phoneNumber.hashCode ^
        vehicleType.hashCode ^
        pickupAddr.hashCode ^
        destAddr.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        destAddrFull.hashCode ^
        pickupAddrFull.hashCode ^
        driver.hashCode;
  }
}
//   String phoneNumber;
//   String addressId;
//   Location address;
//   int count;
//   TopAddress({
//     this.id,
//     required this.phoneNumber,
//     required this.addressId,
//     required this.address,
//     required this.count,
//   });

//   TopAddress copyWith({
//     String? id,
//     String? phoneNumber,
//     String? addressId,
//     Location? address,
//     int? count,
//   }) {
//     return TopAddress(
//       id: id ?? this.id,
//       phoneNumber: phoneNumber ?? this.phoneNumber,
//       addressId: addressId ?? this.addressId,
//       address: address ?? this.address,
//       count: count ?? this.count,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'phoneNumber': phoneNumber,
//       'addressId': addressId,
//       'address': address.toMap(),
//       'count': count,
//     };
//   }

//   factory TopAddress.fromMap(Map<String, dynamic> map) {
//     return TopAddress(
//       id: map['_id'] != null ? map['_id'] as String : null,
//       phoneNumber: map['phoneNumber'] as String,
//       addressId: map['addressId'] as String,
//       address: Location.fromMap(map['address'] as Map<String, dynamic>),
//       count: map['count'] as int,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory TopAddress.fromJson(String source) =>
//       TopAddress.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'TopAddress(id: $id, phoneNumber: $phoneNumber, addressId: $addressId, address: $address, count: $count)';
//   }

//   @override
//   bool operator ==(covariant TopAddress other) {
//     if (identical(this, other)) return true;

//     return other.id == id &&
//         other.phoneNumber == phoneNumber &&
//         other.addressId == addressId &&
//         other.address == address &&
//         other.count == count;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//         phoneNumber.hashCode ^
//         addressId.hashCode ^
//         address.hashCode ^
//         count.hashCode;
//   }
// }
