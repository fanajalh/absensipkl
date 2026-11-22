// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocationReading {

 double get latitude; double get longitude; double get accuracyMeters; bool get isMocked; DateTime get recordedAt;
/// Create a copy of LocationReading
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationReadingCopyWith<LocationReading> get copyWith => _$LocationReadingCopyWithImpl<LocationReading>(this as LocationReading, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationReading&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.accuracyMeters, accuracyMeters) || other.accuracyMeters == accuracyMeters)&&(identical(other.isMocked, isMocked) || other.isMocked == isMocked)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,accuracyMeters,isMocked,recordedAt);

@override
String toString() {
  return 'LocationReading(latitude: $latitude, longitude: $longitude, accuracyMeters: $accuracyMeters, isMocked: $isMocked, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class $LocationReadingCopyWith<$Res>  {
  factory $LocationReadingCopyWith(LocationReading value, $Res Function(LocationReading) _then) = _$LocationReadingCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, double accuracyMeters, bool isMocked, DateTime recordedAt
});




}
/// @nodoc
class _$LocationReadingCopyWithImpl<$Res>
    implements $LocationReadingCopyWith<$Res> {
  _$LocationReadingCopyWithImpl(this._self, this._then);

  final LocationReading _self;
  final $Res Function(LocationReading) _then;

/// Create a copy of LocationReading
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? accuracyMeters = null,Object? isMocked = null,Object? recordedAt = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracyMeters: null == accuracyMeters ? _self.accuracyMeters : accuracyMeters // ignore: cast_nullable_to_non_nullable
as double,isMocked: null == isMocked ? _self.isMocked : isMocked // ignore: cast_nullable_to_non_nullable
as bool,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationReading].
extension LocationReadingPatterns on LocationReading {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationReading value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationReading() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationReading value)  $default,){
final _that = this;
switch (_that) {
case _LocationReading():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationReading value)?  $default,){
final _that = this;
switch (_that) {
case _LocationReading() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude,  double accuracyMeters,  bool isMocked,  DateTime recordedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationReading() when $default != null:
return $default(_that.latitude,_that.longitude,_that.accuracyMeters,_that.isMocked,_that.recordedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude,  double accuracyMeters,  bool isMocked,  DateTime recordedAt)  $default,) {final _that = this;
switch (_that) {
case _LocationReading():
return $default(_that.latitude,_that.longitude,_that.accuracyMeters,_that.isMocked,_that.recordedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude,  double accuracyMeters,  bool isMocked,  DateTime recordedAt)?  $default,) {final _that = this;
switch (_that) {
case _LocationReading() when $default != null:
return $default(_that.latitude,_that.longitude,_that.accuracyMeters,_that.isMocked,_that.recordedAt);case _:
  return null;

}
}

}

/// @nodoc


class _LocationReading implements LocationReading {
  const _LocationReading({required this.latitude, required this.longitude, required this.accuracyMeters, required this.isMocked, required this.recordedAt});
  

@override final  double latitude;
@override final  double longitude;
@override final  double accuracyMeters;
@override final  bool isMocked;
@override final  DateTime recordedAt;

/// Create a copy of LocationReading
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationReadingCopyWith<_LocationReading> get copyWith => __$LocationReadingCopyWithImpl<_LocationReading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationReading&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.accuracyMeters, accuracyMeters) || other.accuracyMeters == accuracyMeters)&&(identical(other.isMocked, isMocked) || other.isMocked == isMocked)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,accuracyMeters,isMocked,recordedAt);

@override
String toString() {
  return 'LocationReading(latitude: $latitude, longitude: $longitude, accuracyMeters: $accuracyMeters, isMocked: $isMocked, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class _$LocationReadingCopyWith<$Res> implements $LocationReadingCopyWith<$Res> {
  factory _$LocationReadingCopyWith(_LocationReading value, $Res Function(_LocationReading) _then) = __$LocationReadingCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude, double accuracyMeters, bool isMocked, DateTime recordedAt
});




}
/// @nodoc
class __$LocationReadingCopyWithImpl<$Res>
    implements _$LocationReadingCopyWith<$Res> {
  __$LocationReadingCopyWithImpl(this._self, this._then);

  final _LocationReading _self;
  final $Res Function(_LocationReading) _then;

/// Create a copy of LocationReading
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? accuracyMeters = null,Object? isMocked = null,Object? recordedAt = null,}) {
  return _then(_LocationReading(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracyMeters: null == accuracyMeters ? _self.accuracyMeters : accuracyMeters // ignore: cast_nullable_to_non_nullable
as double,isMocked: null == isMocked ? _self.isMocked : isMocked // ignore: cast_nullable_to_non_nullable
as bool,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
