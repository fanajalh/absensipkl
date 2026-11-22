// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_recap.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttendanceRecap {

 int get totalDays; int get presentCount; int get lateCount; int get leaveCount; int get absentCount; double get attendancePercentage; List<AttendanceRecord> get records;
/// Create a copy of AttendanceRecap
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceRecapCopyWith<AttendanceRecap> get copyWith => _$AttendanceRecapCopyWithImpl<AttendanceRecap>(this as AttendanceRecap, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceRecap&&(identical(other.totalDays, totalDays) || other.totalDays == totalDays)&&(identical(other.presentCount, presentCount) || other.presentCount == presentCount)&&(identical(other.lateCount, lateCount) || other.lateCount == lateCount)&&(identical(other.leaveCount, leaveCount) || other.leaveCount == leaveCount)&&(identical(other.absentCount, absentCount) || other.absentCount == absentCount)&&(identical(other.attendancePercentage, attendancePercentage) || other.attendancePercentage == attendancePercentage)&&const DeepCollectionEquality().equals(other.records, records));
}


@override
int get hashCode => Object.hash(runtimeType,totalDays,presentCount,lateCount,leaveCount,absentCount,attendancePercentage,const DeepCollectionEquality().hash(records));

@override
String toString() {
  return 'AttendanceRecap(totalDays: $totalDays, presentCount: $presentCount, lateCount: $lateCount, leaveCount: $leaveCount, absentCount: $absentCount, attendancePercentage: $attendancePercentage, records: $records)';
}


}

/// @nodoc
abstract mixin class $AttendanceRecapCopyWith<$Res>  {
  factory $AttendanceRecapCopyWith(AttendanceRecap value, $Res Function(AttendanceRecap) _then) = _$AttendanceRecapCopyWithImpl;
@useResult
$Res call({
 int totalDays, int presentCount, int lateCount, int leaveCount, int absentCount, double attendancePercentage, List<AttendanceRecord> records
});




}
/// @nodoc
class _$AttendanceRecapCopyWithImpl<$Res>
    implements $AttendanceRecapCopyWith<$Res> {
  _$AttendanceRecapCopyWithImpl(this._self, this._then);

  final AttendanceRecap _self;
  final $Res Function(AttendanceRecap) _then;

/// Create a copy of AttendanceRecap
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalDays = null,Object? presentCount = null,Object? lateCount = null,Object? leaveCount = null,Object? absentCount = null,Object? attendancePercentage = null,Object? records = null,}) {
  return _then(_self.copyWith(
totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as int,presentCount: null == presentCount ? _self.presentCount : presentCount // ignore: cast_nullable_to_non_nullable
as int,lateCount: null == lateCount ? _self.lateCount : lateCount // ignore: cast_nullable_to_non_nullable
as int,leaveCount: null == leaveCount ? _self.leaveCount : leaveCount // ignore: cast_nullable_to_non_nullable
as int,absentCount: null == absentCount ? _self.absentCount : absentCount // ignore: cast_nullable_to_non_nullable
as int,attendancePercentage: null == attendancePercentage ? _self.attendancePercentage : attendancePercentage // ignore: cast_nullable_to_non_nullable
as double,records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<AttendanceRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceRecap].
extension AttendanceRecapPatterns on AttendanceRecap {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceRecap value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceRecap() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceRecap value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecap():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceRecap value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecap() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalDays,  int presentCount,  int lateCount,  int leaveCount,  int absentCount,  double attendancePercentage,  List<AttendanceRecord> records)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceRecap() when $default != null:
return $default(_that.totalDays,_that.presentCount,_that.lateCount,_that.leaveCount,_that.absentCount,_that.attendancePercentage,_that.records);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalDays,  int presentCount,  int lateCount,  int leaveCount,  int absentCount,  double attendancePercentage,  List<AttendanceRecord> records)  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecap():
return $default(_that.totalDays,_that.presentCount,_that.lateCount,_that.leaveCount,_that.absentCount,_that.attendancePercentage,_that.records);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalDays,  int presentCount,  int lateCount,  int leaveCount,  int absentCount,  double attendancePercentage,  List<AttendanceRecord> records)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecap() when $default != null:
return $default(_that.totalDays,_that.presentCount,_that.lateCount,_that.leaveCount,_that.absentCount,_that.attendancePercentage,_that.records);case _:
  return null;

}
}

}

/// @nodoc


class _AttendanceRecap implements AttendanceRecap {
  const _AttendanceRecap({required this.totalDays, required this.presentCount, required this.lateCount, required this.leaveCount, required this.absentCount, required this.attendancePercentage, required final  List<AttendanceRecord> records}): _records = records;
  

@override final  int totalDays;
@override final  int presentCount;
@override final  int lateCount;
@override final  int leaveCount;
@override final  int absentCount;
@override final  double attendancePercentage;
 final  List<AttendanceRecord> _records;
@override List<AttendanceRecord> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}


/// Create a copy of AttendanceRecap
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceRecapCopyWith<_AttendanceRecap> get copyWith => __$AttendanceRecapCopyWithImpl<_AttendanceRecap>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceRecap&&(identical(other.totalDays, totalDays) || other.totalDays == totalDays)&&(identical(other.presentCount, presentCount) || other.presentCount == presentCount)&&(identical(other.lateCount, lateCount) || other.lateCount == lateCount)&&(identical(other.leaveCount, leaveCount) || other.leaveCount == leaveCount)&&(identical(other.absentCount, absentCount) || other.absentCount == absentCount)&&(identical(other.attendancePercentage, attendancePercentage) || other.attendancePercentage == attendancePercentage)&&const DeepCollectionEquality().equals(other._records, _records));
}


@override
int get hashCode => Object.hash(runtimeType,totalDays,presentCount,lateCount,leaveCount,absentCount,attendancePercentage,const DeepCollectionEquality().hash(_records));

@override
String toString() {
  return 'AttendanceRecap(totalDays: $totalDays, presentCount: $presentCount, lateCount: $lateCount, leaveCount: $leaveCount, absentCount: $absentCount, attendancePercentage: $attendancePercentage, records: $records)';
}


}

/// @nodoc
abstract mixin class _$AttendanceRecapCopyWith<$Res> implements $AttendanceRecapCopyWith<$Res> {
  factory _$AttendanceRecapCopyWith(_AttendanceRecap value, $Res Function(_AttendanceRecap) _then) = __$AttendanceRecapCopyWithImpl;
@override @useResult
$Res call({
 int totalDays, int presentCount, int lateCount, int leaveCount, int absentCount, double attendancePercentage, List<AttendanceRecord> records
});




}
/// @nodoc
class __$AttendanceRecapCopyWithImpl<$Res>
    implements _$AttendanceRecapCopyWith<$Res> {
  __$AttendanceRecapCopyWithImpl(this._self, this._then);

  final _AttendanceRecap _self;
  final $Res Function(_AttendanceRecap) _then;

/// Create a copy of AttendanceRecap
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalDays = null,Object? presentCount = null,Object? lateCount = null,Object? leaveCount = null,Object? absentCount = null,Object? attendancePercentage = null,Object? records = null,}) {
  return _then(_AttendanceRecap(
totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as int,presentCount: null == presentCount ? _self.presentCount : presentCount // ignore: cast_nullable_to_non_nullable
as int,lateCount: null == lateCount ? _self.lateCount : lateCount // ignore: cast_nullable_to_non_nullable
as int,leaveCount: null == leaveCount ? _self.leaveCount : leaveCount // ignore: cast_nullable_to_non_nullable
as int,absentCount: null == absentCount ? _self.absentCount : absentCount // ignore: cast_nullable_to_non_nullable
as int,attendancePercentage: null == attendancePercentage ? _self.attendancePercentage : attendancePercentage // ignore: cast_nullable_to_non_nullable
as double,records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<AttendanceRecord>,
  ));
}


}

// dart format on
