// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HistoryViewState {

 int get year; int get month; HistoryFilter get filter; AttendanceRecap get recap;
/// Create a copy of HistoryViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryViewStateCopyWith<HistoryViewState> get copyWith => _$HistoryViewStateCopyWithImpl<HistoryViewState>(this as HistoryViewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryViewState&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.recap, recap) || other.recap == recap));
}


@override
int get hashCode => Object.hash(runtimeType,year,month,filter,recap);

@override
String toString() {
  return 'HistoryViewState(year: $year, month: $month, filter: $filter, recap: $recap)';
}


}

/// @nodoc
abstract mixin class $HistoryViewStateCopyWith<$Res>  {
  factory $HistoryViewStateCopyWith(HistoryViewState value, $Res Function(HistoryViewState) _then) = _$HistoryViewStateCopyWithImpl;
@useResult
$Res call({
 int year, int month, HistoryFilter filter, AttendanceRecap recap
});


$AttendanceRecapCopyWith<$Res> get recap;

}
/// @nodoc
class _$HistoryViewStateCopyWithImpl<$Res>
    implements $HistoryViewStateCopyWith<$Res> {
  _$HistoryViewStateCopyWithImpl(this._self, this._then);

  final HistoryViewState _self;
  final $Res Function(HistoryViewState) _then;

/// Create a copy of HistoryViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? filter = null,Object? recap = null,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as HistoryFilter,recap: null == recap ? _self.recap : recap // ignore: cast_nullable_to_non_nullable
as AttendanceRecap,
  ));
}
/// Create a copy of HistoryViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceRecapCopyWith<$Res> get recap {
  
  return $AttendanceRecapCopyWith<$Res>(_self.recap, (value) {
    return _then(_self.copyWith(recap: value));
  });
}
}


/// Adds pattern-matching-related methods to [HistoryViewState].
extension HistoryViewStatePatterns on HistoryViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryViewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryViewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryViewState value)  $default,){
final _that = this;
switch (_that) {
case _HistoryViewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryViewState value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryViewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  HistoryFilter filter,  AttendanceRecap recap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryViewState() when $default != null:
return $default(_that.year,_that.month,_that.filter,_that.recap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  HistoryFilter filter,  AttendanceRecap recap)  $default,) {final _that = this;
switch (_that) {
case _HistoryViewState():
return $default(_that.year,_that.month,_that.filter,_that.recap);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  HistoryFilter filter,  AttendanceRecap recap)?  $default,) {final _that = this;
switch (_that) {
case _HistoryViewState() when $default != null:
return $default(_that.year,_that.month,_that.filter,_that.recap);case _:
  return null;

}
}

}

/// @nodoc


class _HistoryViewState implements HistoryViewState {
  const _HistoryViewState({required this.year, required this.month, required this.filter, required this.recap});
  

@override final  int year;
@override final  int month;
@override final  HistoryFilter filter;
@override final  AttendanceRecap recap;

/// Create a copy of HistoryViewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryViewStateCopyWith<_HistoryViewState> get copyWith => __$HistoryViewStateCopyWithImpl<_HistoryViewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryViewState&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.recap, recap) || other.recap == recap));
}


@override
int get hashCode => Object.hash(runtimeType,year,month,filter,recap);

@override
String toString() {
  return 'HistoryViewState(year: $year, month: $month, filter: $filter, recap: $recap)';
}


}

/// @nodoc
abstract mixin class _$HistoryViewStateCopyWith<$Res> implements $HistoryViewStateCopyWith<$Res> {
  factory _$HistoryViewStateCopyWith(_HistoryViewState value, $Res Function(_HistoryViewState) _then) = __$HistoryViewStateCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, HistoryFilter filter, AttendanceRecap recap
});


@override $AttendanceRecapCopyWith<$Res> get recap;

}
/// @nodoc
class __$HistoryViewStateCopyWithImpl<$Res>
    implements _$HistoryViewStateCopyWith<$Res> {
  __$HistoryViewStateCopyWithImpl(this._self, this._then);

  final _HistoryViewState _self;
  final $Res Function(_HistoryViewState) _then;

/// Create a copy of HistoryViewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? filter = null,Object? recap = null,}) {
  return _then(_HistoryViewState(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as HistoryFilter,recap: null == recap ? _self.recap : recap // ignore: cast_nullable_to_non_nullable
as AttendanceRecap,
  ));
}

/// Create a copy of HistoryViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceRecapCopyWith<$Res> get recap {
  
  return $AttendanceRecapCopyWith<$Res>(_self.recap, (value) {
    return _then(_self.copyWith(recap: value));
  });
}
}

// dart format on
