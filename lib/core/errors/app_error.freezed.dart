// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppError {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppError()';
}


}

/// @nodoc
class $AppErrorCopyWith<$Res>  {
$AppErrorCopyWith(AppError _, $Res Function(AppError) __);
}


/// Adds pattern-matching-related methods to [AppError].
extension AppErrorPatterns on AppError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NetworkError value)?  network,TResult Function( UnauthorizedError value)?  unauthorized,TResult Function( ValidationError value)?  validation,TResult Function( StorageError value)?  storage,TResult Function( LocationDisabledError value)?  locationDisabled,TResult Function( LocationPermissionDeniedError value)?  locationPermissionDenied,TResult Function( MockLocationDetectedError value)?  mockLocationDetected,TResult Function( OutOfGeofenceError value)?  outOfGeofence,TResult Function( CameraUnavailableError value)?  cameraUnavailable,TResult Function( UnexpectedError value)?  unexpected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NetworkError() when network != null:
return network(_that);case UnauthorizedError() when unauthorized != null:
return unauthorized(_that);case ValidationError() when validation != null:
return validation(_that);case StorageError() when storage != null:
return storage(_that);case LocationDisabledError() when locationDisabled != null:
return locationDisabled(_that);case LocationPermissionDeniedError() when locationPermissionDenied != null:
return locationPermissionDenied(_that);case MockLocationDetectedError() when mockLocationDetected != null:
return mockLocationDetected(_that);case OutOfGeofenceError() when outOfGeofence != null:
return outOfGeofence(_that);case CameraUnavailableError() when cameraUnavailable != null:
return cameraUnavailable(_that);case UnexpectedError() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NetworkError value)  network,required TResult Function( UnauthorizedError value)  unauthorized,required TResult Function( ValidationError value)  validation,required TResult Function( StorageError value)  storage,required TResult Function( LocationDisabledError value)  locationDisabled,required TResult Function( LocationPermissionDeniedError value)  locationPermissionDenied,required TResult Function( MockLocationDetectedError value)  mockLocationDetected,required TResult Function( OutOfGeofenceError value)  outOfGeofence,required TResult Function( CameraUnavailableError value)  cameraUnavailable,required TResult Function( UnexpectedError value)  unexpected,}){
final _that = this;
switch (_that) {
case NetworkError():
return network(_that);case UnauthorizedError():
return unauthorized(_that);case ValidationError():
return validation(_that);case StorageError():
return storage(_that);case LocationDisabledError():
return locationDisabled(_that);case LocationPermissionDeniedError():
return locationPermissionDenied(_that);case MockLocationDetectedError():
return mockLocationDetected(_that);case OutOfGeofenceError():
return outOfGeofence(_that);case CameraUnavailableError():
return cameraUnavailable(_that);case UnexpectedError():
return unexpected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NetworkError value)?  network,TResult? Function( UnauthorizedError value)?  unauthorized,TResult? Function( ValidationError value)?  validation,TResult? Function( StorageError value)?  storage,TResult? Function( LocationDisabledError value)?  locationDisabled,TResult? Function( LocationPermissionDeniedError value)?  locationPermissionDenied,TResult? Function( MockLocationDetectedError value)?  mockLocationDetected,TResult? Function( OutOfGeofenceError value)?  outOfGeofence,TResult? Function( CameraUnavailableError value)?  cameraUnavailable,TResult? Function( UnexpectedError value)?  unexpected,}){
final _that = this;
switch (_that) {
case NetworkError() when network != null:
return network(_that);case UnauthorizedError() when unauthorized != null:
return unauthorized(_that);case ValidationError() when validation != null:
return validation(_that);case StorageError() when storage != null:
return storage(_that);case LocationDisabledError() when locationDisabled != null:
return locationDisabled(_that);case LocationPermissionDeniedError() when locationPermissionDenied != null:
return locationPermissionDenied(_that);case MockLocationDetectedError() when mockLocationDetected != null:
return mockLocationDetected(_that);case OutOfGeofenceError() when outOfGeofence != null:
return outOfGeofence(_that);case CameraUnavailableError() when cameraUnavailable != null:
return cameraUnavailable(_that);case UnexpectedError() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message)?  network,TResult Function( String message)?  unauthorized,TResult Function( String message)?  validation,TResult Function( String message)?  storage,TResult Function( String message)?  locationDisabled,TResult Function( String message)?  locationPermissionDenied,TResult Function( String message)?  mockLocationDetected,TResult Function( double distanceMeters,  double radiusMeters)?  outOfGeofence,TResult Function( String message)?  cameraUnavailable,TResult Function( String message)?  unexpected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NetworkError() when network != null:
return network(_that.message);case UnauthorizedError() when unauthorized != null:
return unauthorized(_that.message);case ValidationError() when validation != null:
return validation(_that.message);case StorageError() when storage != null:
return storage(_that.message);case LocationDisabledError() when locationDisabled != null:
return locationDisabled(_that.message);case LocationPermissionDeniedError() when locationPermissionDenied != null:
return locationPermissionDenied(_that.message);case MockLocationDetectedError() when mockLocationDetected != null:
return mockLocationDetected(_that.message);case OutOfGeofenceError() when outOfGeofence != null:
return outOfGeofence(_that.distanceMeters,_that.radiusMeters);case CameraUnavailableError() when cameraUnavailable != null:
return cameraUnavailable(_that.message);case UnexpectedError() when unexpected != null:
return unexpected(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message)  network,required TResult Function( String message)  unauthorized,required TResult Function( String message)  validation,required TResult Function( String message)  storage,required TResult Function( String message)  locationDisabled,required TResult Function( String message)  locationPermissionDenied,required TResult Function( String message)  mockLocationDetected,required TResult Function( double distanceMeters,  double radiusMeters)  outOfGeofence,required TResult Function( String message)  cameraUnavailable,required TResult Function( String message)  unexpected,}) {final _that = this;
switch (_that) {
case NetworkError():
return network(_that.message);case UnauthorizedError():
return unauthorized(_that.message);case ValidationError():
return validation(_that.message);case StorageError():
return storage(_that.message);case LocationDisabledError():
return locationDisabled(_that.message);case LocationPermissionDeniedError():
return locationPermissionDenied(_that.message);case MockLocationDetectedError():
return mockLocationDetected(_that.message);case OutOfGeofenceError():
return outOfGeofence(_that.distanceMeters,_that.radiusMeters);case CameraUnavailableError():
return cameraUnavailable(_that.message);case UnexpectedError():
return unexpected(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message)?  network,TResult? Function( String message)?  unauthorized,TResult? Function( String message)?  validation,TResult? Function( String message)?  storage,TResult? Function( String message)?  locationDisabled,TResult? Function( String message)?  locationPermissionDenied,TResult? Function( String message)?  mockLocationDetected,TResult? Function( double distanceMeters,  double radiusMeters)?  outOfGeofence,TResult? Function( String message)?  cameraUnavailable,TResult? Function( String message)?  unexpected,}) {final _that = this;
switch (_that) {
case NetworkError() when network != null:
return network(_that.message);case UnauthorizedError() when unauthorized != null:
return unauthorized(_that.message);case ValidationError() when validation != null:
return validation(_that.message);case StorageError() when storage != null:
return storage(_that.message);case LocationDisabledError() when locationDisabled != null:
return locationDisabled(_that.message);case LocationPermissionDeniedError() when locationPermissionDenied != null:
return locationPermissionDenied(_that.message);case MockLocationDetectedError() when mockLocationDetected != null:
return mockLocationDetected(_that.message);case OutOfGeofenceError() when outOfGeofence != null:
return outOfGeofence(_that.distanceMeters,_that.radiusMeters);case CameraUnavailableError() when cameraUnavailable != null:
return cameraUnavailable(_that.message);case UnexpectedError() when unexpected != null:
return unexpected(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class NetworkError implements AppError {
  const NetworkError({required this.message});
  

 final  String message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkErrorCopyWith<NetworkError> get copyWith => _$NetworkErrorCopyWithImpl<NetworkError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.network(message: $message)';
}


}

/// @nodoc
abstract mixin class $NetworkErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $NetworkErrorCopyWith(NetworkError value, $Res Function(NetworkError) _then) = _$NetworkErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$NetworkErrorCopyWithImpl<$Res>
    implements $NetworkErrorCopyWith<$Res> {
  _$NetworkErrorCopyWithImpl(this._self, this._then);

  final NetworkError _self;
  final $Res Function(NetworkError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(NetworkError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnauthorizedError implements AppError {
  const UnauthorizedError({required this.message});
  

 final  String message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnauthorizedErrorCopyWith<UnauthorizedError> get copyWith => _$UnauthorizedErrorCopyWithImpl<UnauthorizedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnauthorizedError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.unauthorized(message: $message)';
}


}

/// @nodoc
abstract mixin class $UnauthorizedErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $UnauthorizedErrorCopyWith(UnauthorizedError value, $Res Function(UnauthorizedError) _then) = _$UnauthorizedErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UnauthorizedErrorCopyWithImpl<$Res>
    implements $UnauthorizedErrorCopyWith<$Res> {
  _$UnauthorizedErrorCopyWithImpl(this._self, this._then);

  final UnauthorizedError _self;
  final $Res Function(UnauthorizedError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(UnauthorizedError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ValidationError implements AppError {
  const ValidationError({required this.message});
  

 final  String message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationErrorCopyWith<ValidationError> get copyWith => _$ValidationErrorCopyWithImpl<ValidationError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.validation(message: $message)';
}


}

/// @nodoc
abstract mixin class $ValidationErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $ValidationErrorCopyWith(ValidationError value, $Res Function(ValidationError) _then) = _$ValidationErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ValidationErrorCopyWithImpl<$Res>
    implements $ValidationErrorCopyWith<$Res> {
  _$ValidationErrorCopyWithImpl(this._self, this._then);

  final ValidationError _self;
  final $Res Function(ValidationError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ValidationError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class StorageError implements AppError {
  const StorageError({required this.message});
  

 final  String message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageErrorCopyWith<StorageError> get copyWith => _$StorageErrorCopyWithImpl<StorageError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.storage(message: $message)';
}


}

/// @nodoc
abstract mixin class $StorageErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $StorageErrorCopyWith(StorageError value, $Res Function(StorageError) _then) = _$StorageErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$StorageErrorCopyWithImpl<$Res>
    implements $StorageErrorCopyWith<$Res> {
  _$StorageErrorCopyWithImpl(this._self, this._then);

  final StorageError _self;
  final $Res Function(StorageError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(StorageError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LocationDisabledError implements AppError {
  const LocationDisabledError({required this.message});
  

 final  String message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationDisabledErrorCopyWith<LocationDisabledError> get copyWith => _$LocationDisabledErrorCopyWithImpl<LocationDisabledError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationDisabledError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.locationDisabled(message: $message)';
}


}

/// @nodoc
abstract mixin class $LocationDisabledErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $LocationDisabledErrorCopyWith(LocationDisabledError value, $Res Function(LocationDisabledError) _then) = _$LocationDisabledErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$LocationDisabledErrorCopyWithImpl<$Res>
    implements $LocationDisabledErrorCopyWith<$Res> {
  _$LocationDisabledErrorCopyWithImpl(this._self, this._then);

  final LocationDisabledError _self;
  final $Res Function(LocationDisabledError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(LocationDisabledError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LocationPermissionDeniedError implements AppError {
  const LocationPermissionDeniedError({required this.message});
  

 final  String message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationPermissionDeniedErrorCopyWith<LocationPermissionDeniedError> get copyWith => _$LocationPermissionDeniedErrorCopyWithImpl<LocationPermissionDeniedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationPermissionDeniedError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.locationPermissionDenied(message: $message)';
}


}

/// @nodoc
abstract mixin class $LocationPermissionDeniedErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $LocationPermissionDeniedErrorCopyWith(LocationPermissionDeniedError value, $Res Function(LocationPermissionDeniedError) _then) = _$LocationPermissionDeniedErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$LocationPermissionDeniedErrorCopyWithImpl<$Res>
    implements $LocationPermissionDeniedErrorCopyWith<$Res> {
  _$LocationPermissionDeniedErrorCopyWithImpl(this._self, this._then);

  final LocationPermissionDeniedError _self;
  final $Res Function(LocationPermissionDeniedError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(LocationPermissionDeniedError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MockLocationDetectedError implements AppError {
  const MockLocationDetectedError({required this.message});
  

 final  String message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MockLocationDetectedErrorCopyWith<MockLocationDetectedError> get copyWith => _$MockLocationDetectedErrorCopyWithImpl<MockLocationDetectedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MockLocationDetectedError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.mockLocationDetected(message: $message)';
}


}

/// @nodoc
abstract mixin class $MockLocationDetectedErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $MockLocationDetectedErrorCopyWith(MockLocationDetectedError value, $Res Function(MockLocationDetectedError) _then) = _$MockLocationDetectedErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$MockLocationDetectedErrorCopyWithImpl<$Res>
    implements $MockLocationDetectedErrorCopyWith<$Res> {
  _$MockLocationDetectedErrorCopyWithImpl(this._self, this._then);

  final MockLocationDetectedError _self;
  final $Res Function(MockLocationDetectedError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(MockLocationDetectedError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class OutOfGeofenceError implements AppError {
  const OutOfGeofenceError({required this.distanceMeters, required this.radiusMeters});
  

 final  double distanceMeters;
 final  double radiusMeters;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutOfGeofenceErrorCopyWith<OutOfGeofenceError> get copyWith => _$OutOfGeofenceErrorCopyWithImpl<OutOfGeofenceError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutOfGeofenceError&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters));
}


@override
int get hashCode => Object.hash(runtimeType,distanceMeters,radiusMeters);

@override
String toString() {
  return 'AppError.outOfGeofence(distanceMeters: $distanceMeters, radiusMeters: $radiusMeters)';
}


}

/// @nodoc
abstract mixin class $OutOfGeofenceErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $OutOfGeofenceErrorCopyWith(OutOfGeofenceError value, $Res Function(OutOfGeofenceError) _then) = _$OutOfGeofenceErrorCopyWithImpl;
@useResult
$Res call({
 double distanceMeters, double radiusMeters
});




}
/// @nodoc
class _$OutOfGeofenceErrorCopyWithImpl<$Res>
    implements $OutOfGeofenceErrorCopyWith<$Res> {
  _$OutOfGeofenceErrorCopyWithImpl(this._self, this._then);

  final OutOfGeofenceError _self;
  final $Res Function(OutOfGeofenceError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? distanceMeters = null,Object? radiusMeters = null,}) {
  return _then(OutOfGeofenceError(
distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class CameraUnavailableError implements AppError {
  const CameraUnavailableError({required this.message});
  

 final  String message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CameraUnavailableErrorCopyWith<CameraUnavailableError> get copyWith => _$CameraUnavailableErrorCopyWithImpl<CameraUnavailableError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CameraUnavailableError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.cameraUnavailable(message: $message)';
}


}

/// @nodoc
abstract mixin class $CameraUnavailableErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $CameraUnavailableErrorCopyWith(CameraUnavailableError value, $Res Function(CameraUnavailableError) _then) = _$CameraUnavailableErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CameraUnavailableErrorCopyWithImpl<$Res>
    implements $CameraUnavailableErrorCopyWith<$Res> {
  _$CameraUnavailableErrorCopyWithImpl(this._self, this._then);

  final CameraUnavailableError _self;
  final $Res Function(CameraUnavailableError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CameraUnavailableError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnexpectedError implements AppError {
  const UnexpectedError({required this.message});
  

 final  String message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnexpectedErrorCopyWith<UnexpectedError> get copyWith => _$UnexpectedErrorCopyWithImpl<UnexpectedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnexpectedError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.unexpected(message: $message)';
}


}

/// @nodoc
abstract mixin class $UnexpectedErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $UnexpectedErrorCopyWith(UnexpectedError value, $Res Function(UnexpectedError) _then) = _$UnexpectedErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UnexpectedErrorCopyWithImpl<$Res>
    implements $UnexpectedErrorCopyWith<$Res> {
  _$UnexpectedErrorCopyWithImpl(this._self, this._then);

  final UnexpectedError _self;
  final $Res Function(UnexpectedError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(UnexpectedError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
