// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dudi_placement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DudiPlacement {

 String get id; String get companyName; String get address; String get mentorName; double get latitude; double get longitude; double get allowedRadiusMeters; String get workStartTime; String get workEndTime;
/// Create a copy of DudiPlacement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DudiPlacementCopyWith<DudiPlacement> get copyWith => _$DudiPlacementCopyWithImpl<DudiPlacement>(this as DudiPlacement, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DudiPlacement&&(identical(other.id, id) || other.id == id)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.address, address) || other.address == address)&&(identical(other.mentorName, mentorName) || other.mentorName == mentorName)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.allowedRadiusMeters, allowedRadiusMeters) || other.allowedRadiusMeters == allowedRadiusMeters)&&(identical(other.workStartTime, workStartTime) || other.workStartTime == workStartTime)&&(identical(other.workEndTime, workEndTime) || other.workEndTime == workEndTime));
}


@override
int get hashCode => Object.hash(runtimeType,id,companyName,address,mentorName,latitude,longitude,allowedRadiusMeters,workStartTime,workEndTime);

@override
String toString() {
  return 'DudiPlacement(id: $id, companyName: $companyName, address: $address, mentorName: $mentorName, latitude: $latitude, longitude: $longitude, allowedRadiusMeters: $allowedRadiusMeters, workStartTime: $workStartTime, workEndTime: $workEndTime)';
}


}

/// @nodoc
abstract mixin class $DudiPlacementCopyWith<$Res>  {
  factory $DudiPlacementCopyWith(DudiPlacement value, $Res Function(DudiPlacement) _then) = _$DudiPlacementCopyWithImpl;
@useResult
$Res call({
 String id, String companyName, String address, String mentorName, double latitude, double longitude, double allowedRadiusMeters, String workStartTime, String workEndTime
});




}
/// @nodoc
class _$DudiPlacementCopyWithImpl<$Res>
    implements $DudiPlacementCopyWith<$Res> {
  _$DudiPlacementCopyWithImpl(this._self, this._then);

  final DudiPlacement _self;
  final $Res Function(DudiPlacement) _then;

/// Create a copy of DudiPlacement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? companyName = null,Object? address = null,Object? mentorName = null,Object? latitude = null,Object? longitude = null,Object? allowedRadiusMeters = null,Object? workStartTime = null,Object? workEndTime = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,mentorName: null == mentorName ? _self.mentorName : mentorName // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,allowedRadiusMeters: null == allowedRadiusMeters ? _self.allowedRadiusMeters : allowedRadiusMeters // ignore: cast_nullable_to_non_nullable
as double,workStartTime: null == workStartTime ? _self.workStartTime : workStartTime // ignore: cast_nullable_to_non_nullable
as String,workEndTime: null == workEndTime ? _self.workEndTime : workEndTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DudiPlacement].
extension DudiPlacementPatterns on DudiPlacement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DudiPlacement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DudiPlacement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DudiPlacement value)  $default,){
final _that = this;
switch (_that) {
case _DudiPlacement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DudiPlacement value)?  $default,){
final _that = this;
switch (_that) {
case _DudiPlacement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String companyName,  String address,  String mentorName,  double latitude,  double longitude,  double allowedRadiusMeters,  String workStartTime,  String workEndTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DudiPlacement() when $default != null:
return $default(_that.id,_that.companyName,_that.address,_that.mentorName,_that.latitude,_that.longitude,_that.allowedRadiusMeters,_that.workStartTime,_that.workEndTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String companyName,  String address,  String mentorName,  double latitude,  double longitude,  double allowedRadiusMeters,  String workStartTime,  String workEndTime)  $default,) {final _that = this;
switch (_that) {
case _DudiPlacement():
return $default(_that.id,_that.companyName,_that.address,_that.mentorName,_that.latitude,_that.longitude,_that.allowedRadiusMeters,_that.workStartTime,_that.workEndTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String companyName,  String address,  String mentorName,  double latitude,  double longitude,  double allowedRadiusMeters,  String workStartTime,  String workEndTime)?  $default,) {final _that = this;
switch (_that) {
case _DudiPlacement() when $default != null:
return $default(_that.id,_that.companyName,_that.address,_that.mentorName,_that.latitude,_that.longitude,_that.allowedRadiusMeters,_that.workStartTime,_that.workEndTime);case _:
  return null;

}
}

}

/// @nodoc


class _DudiPlacement implements DudiPlacement {
  const _DudiPlacement({required this.id, required this.companyName, required this.address, required this.mentorName, required this.latitude, required this.longitude, required this.allowedRadiusMeters, required this.workStartTime, required this.workEndTime});
  

@override final  String id;
@override final  String companyName;
@override final  String address;
@override final  String mentorName;
@override final  double latitude;
@override final  double longitude;
@override final  double allowedRadiusMeters;
@override final  String workStartTime;
@override final  String workEndTime;

/// Create a copy of DudiPlacement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DudiPlacementCopyWith<_DudiPlacement> get copyWith => __$DudiPlacementCopyWithImpl<_DudiPlacement>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DudiPlacement&&(identical(other.id, id) || other.id == id)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.address, address) || other.address == address)&&(identical(other.mentorName, mentorName) || other.mentorName == mentorName)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.allowedRadiusMeters, allowedRadiusMeters) || other.allowedRadiusMeters == allowedRadiusMeters)&&(identical(other.workStartTime, workStartTime) || other.workStartTime == workStartTime)&&(identical(other.workEndTime, workEndTime) || other.workEndTime == workEndTime));
}


@override
int get hashCode => Object.hash(runtimeType,id,companyName,address,mentorName,latitude,longitude,allowedRadiusMeters,workStartTime,workEndTime);

@override
String toString() {
  return 'DudiPlacement(id: $id, companyName: $companyName, address: $address, mentorName: $mentorName, latitude: $latitude, longitude: $longitude, allowedRadiusMeters: $allowedRadiusMeters, workStartTime: $workStartTime, workEndTime: $workEndTime)';
}


}

/// @nodoc
abstract mixin class _$DudiPlacementCopyWith<$Res> implements $DudiPlacementCopyWith<$Res> {
  factory _$DudiPlacementCopyWith(_DudiPlacement value, $Res Function(_DudiPlacement) _then) = __$DudiPlacementCopyWithImpl;
@override @useResult
$Res call({
 String id, String companyName, String address, String mentorName, double latitude, double longitude, double allowedRadiusMeters, String workStartTime, String workEndTime
});




}
/// @nodoc
class __$DudiPlacementCopyWithImpl<$Res>
    implements _$DudiPlacementCopyWith<$Res> {
  __$DudiPlacementCopyWithImpl(this._self, this._then);

  final _DudiPlacement _self;
  final $Res Function(_DudiPlacement) _then;

/// Create a copy of DudiPlacement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? companyName = null,Object? address = null,Object? mentorName = null,Object? latitude = null,Object? longitude = null,Object? allowedRadiusMeters = null,Object? workStartTime = null,Object? workEndTime = null,}) {
  return _then(_DudiPlacement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,mentorName: null == mentorName ? _self.mentorName : mentorName // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,allowedRadiusMeters: null == allowedRadiusMeters ? _self.allowedRadiusMeters : allowedRadiusMeters // ignore: cast_nullable_to_non_nullable
as double,workStartTime: null == workStartTime ? _self.workStartTime : workStartTime // ignore: cast_nullable_to_non_nullable
as String,workEndTime: null == workEndTime ? _self.workEndTime : workEndTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
