// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttendanceRecord {

 String get id; DateTime get date; AttendanceStatus get status; DateTime? get checkInTime; DateTime? get checkOutTime; double? get checkInDistanceMeters; double? get checkOutDistanceMeters; bool get isMockLocationFlagged; String? get selfieLabel; String? get notes;
/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceRecordCopyWith<AttendanceRecord> get copyWith => _$AttendanceRecordCopyWithImpl<AttendanceRecord>(this as AttendanceRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.checkInTime, checkInTime) || other.checkInTime == checkInTime)&&(identical(other.checkOutTime, checkOutTime) || other.checkOutTime == checkOutTime)&&(identical(other.checkInDistanceMeters, checkInDistanceMeters) || other.checkInDistanceMeters == checkInDistanceMeters)&&(identical(other.checkOutDistanceMeters, checkOutDistanceMeters) || other.checkOutDistanceMeters == checkOutDistanceMeters)&&(identical(other.isMockLocationFlagged, isMockLocationFlagged) || other.isMockLocationFlagged == isMockLocationFlagged)&&(identical(other.selfieLabel, selfieLabel) || other.selfieLabel == selfieLabel)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,id,date,status,checkInTime,checkOutTime,checkInDistanceMeters,checkOutDistanceMeters,isMockLocationFlagged,selfieLabel,notes);

@override
String toString() {
  return 'AttendanceRecord(id: $id, date: $date, status: $status, checkInTime: $checkInTime, checkOutTime: $checkOutTime, checkInDistanceMeters: $checkInDistanceMeters, checkOutDistanceMeters: $checkOutDistanceMeters, isMockLocationFlagged: $isMockLocationFlagged, selfieLabel: $selfieLabel, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $AttendanceRecordCopyWith<$Res>  {
  factory $AttendanceRecordCopyWith(AttendanceRecord value, $Res Function(AttendanceRecord) _then) = _$AttendanceRecordCopyWithImpl;
@useResult
$Res call({
 String id, DateTime date, AttendanceStatus status, DateTime? checkInTime, DateTime? checkOutTime, double? checkInDistanceMeters, double? checkOutDistanceMeters, bool isMockLocationFlagged, String? selfieLabel, String? notes
});




}
/// @nodoc
class _$AttendanceRecordCopyWithImpl<$Res>
    implements $AttendanceRecordCopyWith<$Res> {
  _$AttendanceRecordCopyWithImpl(this._self, this._then);

  final AttendanceRecord _self;
  final $Res Function(AttendanceRecord) _then;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? status = null,Object? checkInTime = freezed,Object? checkOutTime = freezed,Object? checkInDistanceMeters = freezed,Object? checkOutDistanceMeters = freezed,Object? isMockLocationFlagged = null,Object? selfieLabel = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,checkInTime: freezed == checkInTime ? _self.checkInTime : checkInTime // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOutTime: freezed == checkOutTime ? _self.checkOutTime : checkOutTime // ignore: cast_nullable_to_non_nullable
as DateTime?,checkInDistanceMeters: freezed == checkInDistanceMeters ? _self.checkInDistanceMeters : checkInDistanceMeters // ignore: cast_nullable_to_non_nullable
as double?,checkOutDistanceMeters: freezed == checkOutDistanceMeters ? _self.checkOutDistanceMeters : checkOutDistanceMeters // ignore: cast_nullable_to_non_nullable
as double?,isMockLocationFlagged: null == isMockLocationFlagged ? _self.isMockLocationFlagged : isMockLocationFlagged // ignore: cast_nullable_to_non_nullable
as bool,selfieLabel: freezed == selfieLabel ? _self.selfieLabel : selfieLabel // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceRecord].
extension AttendanceRecordPatterns on AttendanceRecord {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceRecord value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecord():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceRecord value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime date,  AttendanceStatus status,  DateTime? checkInTime,  DateTime? checkOutTime,  double? checkInDistanceMeters,  double? checkOutDistanceMeters,  bool isMockLocationFlagged,  String? selfieLabel,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that.id,_that.date,_that.status,_that.checkInTime,_that.checkOutTime,_that.checkInDistanceMeters,_that.checkOutDistanceMeters,_that.isMockLocationFlagged,_that.selfieLabel,_that.notes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime date,  AttendanceStatus status,  DateTime? checkInTime,  DateTime? checkOutTime,  double? checkInDistanceMeters,  double? checkOutDistanceMeters,  bool isMockLocationFlagged,  String? selfieLabel,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecord():
return $default(_that.id,_that.date,_that.status,_that.checkInTime,_that.checkOutTime,_that.checkInDistanceMeters,_that.checkOutDistanceMeters,_that.isMockLocationFlagged,_that.selfieLabel,_that.notes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime date,  AttendanceStatus status,  DateTime? checkInTime,  DateTime? checkOutTime,  double? checkInDistanceMeters,  double? checkOutDistanceMeters,  bool isMockLocationFlagged,  String? selfieLabel,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that.id,_that.date,_that.status,_that.checkInTime,_that.checkOutTime,_that.checkInDistanceMeters,_that.checkOutDistanceMeters,_that.isMockLocationFlagged,_that.selfieLabel,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _AttendanceRecord extends AttendanceRecord {
  const _AttendanceRecord({required this.id, required this.date, required this.status, this.checkInTime, this.checkOutTime, this.checkInDistanceMeters, this.checkOutDistanceMeters, this.isMockLocationFlagged = false, this.selfieLabel, this.notes}): super._();
  

@override final  String id;
@override final  DateTime date;
@override final  AttendanceStatus status;
@override final  DateTime? checkInTime;
@override final  DateTime? checkOutTime;
@override final  double? checkInDistanceMeters;
@override final  double? checkOutDistanceMeters;
@override@JsonKey() final  bool isMockLocationFlagged;
@override final  String? selfieLabel;
@override final  String? notes;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceRecordCopyWith<_AttendanceRecord> get copyWith => __$AttendanceRecordCopyWithImpl<_AttendanceRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.checkInTime, checkInTime) || other.checkInTime == checkInTime)&&(identical(other.checkOutTime, checkOutTime) || other.checkOutTime == checkOutTime)&&(identical(other.checkInDistanceMeters, checkInDistanceMeters) || other.checkInDistanceMeters == checkInDistanceMeters)&&(identical(other.checkOutDistanceMeters, checkOutDistanceMeters) || other.checkOutDistanceMeters == checkOutDistanceMeters)&&(identical(other.isMockLocationFlagged, isMockLocationFlagged) || other.isMockLocationFlagged == isMockLocationFlagged)&&(identical(other.selfieLabel, selfieLabel) || other.selfieLabel == selfieLabel)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,id,date,status,checkInTime,checkOutTime,checkInDistanceMeters,checkOutDistanceMeters,isMockLocationFlagged,selfieLabel,notes);

@override
String toString() {
  return 'AttendanceRecord(id: $id, date: $date, status: $status, checkInTime: $checkInTime, checkOutTime: $checkOutTime, checkInDistanceMeters: $checkInDistanceMeters, checkOutDistanceMeters: $checkOutDistanceMeters, isMockLocationFlagged: $isMockLocationFlagged, selfieLabel: $selfieLabel, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$AttendanceRecordCopyWith<$Res> implements $AttendanceRecordCopyWith<$Res> {
  factory _$AttendanceRecordCopyWith(_AttendanceRecord value, $Res Function(_AttendanceRecord) _then) = __$AttendanceRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime date, AttendanceStatus status, DateTime? checkInTime, DateTime? checkOutTime, double? checkInDistanceMeters, double? checkOutDistanceMeters, bool isMockLocationFlagged, String? selfieLabel, String? notes
});




}
/// @nodoc
class __$AttendanceRecordCopyWithImpl<$Res>
    implements _$AttendanceRecordCopyWith<$Res> {
  __$AttendanceRecordCopyWithImpl(this._self, this._then);

  final _AttendanceRecord _self;
  final $Res Function(_AttendanceRecord) _then;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? status = null,Object? checkInTime = freezed,Object? checkOutTime = freezed,Object? checkInDistanceMeters = freezed,Object? checkOutDistanceMeters = freezed,Object? isMockLocationFlagged = null,Object? selfieLabel = freezed,Object? notes = freezed,}) {
  return _then(_AttendanceRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,checkInTime: freezed == checkInTime ? _self.checkInTime : checkInTime // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOutTime: freezed == checkOutTime ? _self.checkOutTime : checkOutTime // ignore: cast_nullable_to_non_nullable
as DateTime?,checkInDistanceMeters: freezed == checkInDistanceMeters ? _self.checkInDistanceMeters : checkInDistanceMeters // ignore: cast_nullable_to_non_nullable
as double?,checkOutDistanceMeters: freezed == checkOutDistanceMeters ? _self.checkOutDistanceMeters : checkOutDistanceMeters // ignore: cast_nullable_to_non_nullable
as double?,isMockLocationFlagged: null == isMockLocationFlagged ? _self.isMockLocationFlagged : isMockLocationFlagged // ignore: cast_nullable_to_non_nullable
as bool,selfieLabel: freezed == selfieLabel ? _self.selfieLabel : selfieLabel // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
