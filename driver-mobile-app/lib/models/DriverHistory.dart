// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:grab_eat_ui/models/Booking.dart';

class DriverHistory {
  DateTime? bookingDate;
  int? count;
  double? totalEarning;
  List<BookingModel>? bookings;

  DriverHistory({
    this.bookingDate,
    this.count,
    this.bookings,
    this.totalEarning,
  });

  DriverHistory copyWith({
    DateTime? bookingDate,
    int? count,
    List<BookingModel>? bookings,
  }) {
    return DriverHistory(
      bookingDate: bookingDate ?? this.bookingDate,
      count: count ?? this.count,
      bookings: bookings ?? this.bookings,
      totalEarning: totalEarning ?? this.totalEarning,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bookingDate': bookingDate?.millisecondsSinceEpoch,
      'count': count,
      'bookings': bookings?.map((x) => x?.toMap()).toList(),
      'totalEarning': totalEarning
    };
  }

  factory DriverHistory.fromMap(Map<String, dynamic> map) {
    return DriverHistory(
      bookingDate: map['bookingDate'] != null
          ? DateTime.parse(map['bookingDate'])
          : null,
      count: map['count'] != null ? map['count'] as int : null,
      bookings: map['bookings'] != null
          ? List<BookingModel>.from(
              (map['bookings'] as List<dynamic>).map<BookingModel?>(
                (x) {
                  print(x);
                  return BookingModel.fromMap(x as Map<String, dynamic>);
                },
              ),
            )
          : null,
      totalEarning: map['totalEarning'] != null
          ? map['totalEarning'] * 1.0 as double
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DriverHistory.fromJson(String source) =>
      DriverHistory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DriverHistory(bookingDate: $bookingDate, count: $count, bookings: $bookings, totalEarning: $totalEarning)';

  @override
  bool operator ==(covariant DriverHistory other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.bookingDate == bookingDate &&
        other.count == count &&
        listEquals(other.bookings, bookings) &&
        other.totalEarning == totalEarning;
  }

  @override
  int get hashCode =>
      bookingDate.hashCode ^
      count.hashCode ^
      bookings.hashCode ^
      totalEarning.hashCode;
}
