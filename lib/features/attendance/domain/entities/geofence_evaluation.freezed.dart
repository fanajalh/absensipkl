// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence_evaluation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GeofenceEvaluation {

 double get distanceMeters; double get allowedRadiusMeters; bool get isWithinRadius; bool get isMocked; DateTime get evaluatedAt; LocationReading get location;
/// Create a copy of GeofenceEvaluation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeofenceEvaluationCopyWith<GeofenceEvaluation> get copyWith => _$GeofenceEvaluationCopyWithImpl<GeofenceEvaluation>(this as GeofenceEvaluation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeofenceEvaluation&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.allowedRadiusMeters, allowedRadiusMeters) || other.allowedRadiusMeters == allowedRadiusMeters)&&(identical(other.isWithinRadius, isWithinRadius) || other.isWithinRadius == isWithinRadius)&&(identical(other.isMocked, isMocked) || other.isMocked == isMocked)&&(identical(other.evaluatedAt, evaluatedAt) || other.evaluatedAt == evaluatedAt)&&(identical(other.location, location) || other.location == location));
}


@override
int get hashCode => Object.hash(runtimeType,distanceMeters,allowedRadiusMeters,isWithinRadius,isMocked,evaluatedAt,location);

@override
String toString() {
  return 'GeofenceEvaluation(distanceMeters: $distanceMeters, allowedRadiusMeters: $allowedRadiusMeters, isWithinRadius: $isWithinRadius, isMocked: $isMocked, evaluatedAt: $evaluatedAt, location: $location)';
}


}

/// @nodoc
abstract mixin class $GeofenceEvaluationCopyWith<$Res>  {
  factory $GeofenceEvaluationCopyWith(GeofenceEvaluation value, $Res Function(GeofenceEvaluation) _then) = _$GeofenceEvaluationCopyWithImpl;
@useResult
$Res call({
 double distanceMeters, double allowedRadiusMeters, bool isWithinRadius, bool isMocked, DateTime evaluatedAt, LocationReading location
});


$LocationReadingCopyWith<$Res> get location;

}
/// @nodoc
class _$GeofenceEvaluationCopyWithImpl<$Res>
    implements $GeofenceEvaluationCopyWith<$Res> {
  _$GeofenceEvaluationCopyWithImpl(this._self, this._then);

  final GeofenceEvaluation _self;
  final $Res Function(GeofenceEvaluation) _then;

/// Create a copy of GeofenceEvaluation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? distanceMeters = null,Object? allowedRadiusMeters = null,Object? isWithinRadius = null,Object? isMocked = null,Object? evaluatedAt = null,Object? location = null,}) {
  return _then(_self.copyWith(
distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,allowedRadiusMeters: null == allowedRadiusMeters ? _self.allowedRadiusMeters : allowedRadiusMeters // ignore: cast_nullable_to_non_nullable
as double,isWithinRadius: null == isWithinRadius ? _self.isWithinRadius : isWithinRadius // ignore: cast_nullable_to_non_nullable
as bool,isMocked: null == isMocked ? _self.isMocked : isMocked // ignore: cast_nullable_to_non_nullable
as bool,evaluatedAt: null == evaluatedAt ? _self.evaluatedAt : evaluatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LocationReading,
  ));
}
/// Create a copy of GeofenceEvaluation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationReadingCopyWith<$Res> get location {
  
  return $LocationReadingCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [GeofenceEvaluation].
extension GeofenceEvaluationPatterns on GeofenceEvaluation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeofenceEvaluation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeofenceEvaluation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeofenceEvaluation value)  $default,){
final _that = this;
switch (_that) {
case _GeofenceEvaluation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeofenceEvaluation value)?  $default,){
final _that = this;
switch (_that) {
case _GeofenceEvaluation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double distanceMeters,  double allowedRadiusMeters,  bool isWithinRadius,  bool isMocked,  DateTime evaluatedAt,  LocationReading location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeofenceEvaluation() when $default != null:
return $default(_that.distanceMeters,_that.allowedRadiusMeters,_that.isWithinRadius,_that.isMocked,_that.evaluatedAt,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double distanceMeters,  double allowedRadiusMeters,  bool isWithinRadius,  bool isMocked,  DateTime evaluatedAt,  LocationReading location)  $default,) {final _that = this;
switch (_that) {
case _GeofenceEvaluation():
return $default(_that.distanceMeters,_that.allowedRadiusMeters,_that.isWithinRadius,_that.isMocked,_that.evaluatedAt,_that.location);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double distanceMeters,  double allowedRadiusMeters,  bool isWithinRadius,  bool isMocked,  DateTime evaluatedAt,  LocationReading location)?  $default,) {final _that = this;
switch (_that) {
case _GeofenceEvaluation() when $default != null:
return $default(_that.distanceMeters,_that.allowedRadiusMeters,_that.isWithinRadius,_that.isMocked,_that.evaluatedAt,_that.location);case _:
  return null;

}
}

}

/// @nodoc


class _GeofenceEvaluation extends GeofenceEvaluation {
  const _GeofenceEvaluation({required this.distanceMeters, required this.allowedRadiusMeters, required this.isWithinRadius, required this.isMocked, required this.evaluatedAt, required this.location}): super._();
  

@override final  double distanceMeters;
@override final  double allowedRadiusMeters;
@override final  bool isWithinRadius;
@override final  bool isMocked;
@override final  DateTime evaluatedAt;
@override final  LocationReading location;

/// Create a copy of GeofenceEvaluation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeofenceEvaluationCopyWith<_GeofenceEvaluation> get copyWith => __$GeofenceEvaluationCopyWithImpl<_GeofenceEvaluation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeofenceEvaluation&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.allowedRadiusMeters, allowedRadiusMeters) || other.allowedRadiusMeters == allowedRadiusMeters)&&(identical(other.isWithinRadius, isWithinRadius) || other.isWithinRadius == isWithinRadius)&&(identical(other.isMocked, isMocked) || other.isMocked == isMocked)&&(identical(other.evaluatedAt, evaluatedAt) || other.evaluatedAt == evaluatedAt)&&(identical(other.location, location) || other.location == location));
}


@override
int get hashCode => Object.hash(runtimeType,distanceMeters,allowedRadiusMeters,isWithinRadius,isMocked,evaluatedAt,location);

@override
String toString() {
  return 'GeofenceEvaluation(distanceMeters: $distanceMeters, allowedRadiusMeters: $allowedRadiusMeters, isWithinRadius: $isWithinRadius, isMocked: $isMocked, evaluatedAt: $evaluatedAt, location: $location)';
}


}

/// @nodoc
abstract mixin class _$GeofenceEvaluationCopyWith<$Res> implements $GeofenceEvaluationCopyWith<$Res> {
  factory _$GeofenceEvaluationCopyWith(_GeofenceEvaluation value, $Res Function(_GeofenceEvaluation) _then) = __$GeofenceEvaluationCopyWithImpl;
@override @useResult
$Res call({
 double distanceMeters, double allowedRadiusMeters, bool isWithinRadius, bool isMocked, DateTime evaluatedAt, LocationReading location
});


@override $LocationReadingCopyWith<$Res> get location;

}
/// @nodoc
class __$GeofenceEvaluationCopyWithImpl<$Res>
    implements _$GeofenceEvaluationCopyWith<$Res> {
  __$GeofenceEvaluationCopyWithImpl(this._self, this._then);

  final _GeofenceEvaluation _self;
  final $Res Function(_GeofenceEvaluation) _then;

/// Create a copy of GeofenceEvaluation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? distanceMeters = null,Object? allowedRadiusMeters = null,Object? isWithinRadius = null,Object? isMocked = null,Object? evaluatedAt = null,Object? location = null,}) {
  return _then(_GeofenceEvaluation(
distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,allowedRadiusMeters: null == allowedRadiusMeters ? _self.allowedRadiusMeters : allowedRadiusMeters // ignore: cast_nullable_to_non_nullable
as double,isWithinRadius: null == isWithinRadius ? _self.isWithinRadius : isWithinRadius // ignore: cast_nullable_to_non_nullable
as bool,isMocked: null == isMocked ? _self.isMocked : isMocked // ignore: cast_nullable_to_non_nullable
as bool,evaluatedAt: null == evaluatedAt ? _self.evaluatedAt : evaluatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LocationReading,
  ));
}

/// Create a copy of GeofenceEvaluation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationReadingCopyWith<$Res> get location {
  
  return $LocationReadingCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

// dart format on
