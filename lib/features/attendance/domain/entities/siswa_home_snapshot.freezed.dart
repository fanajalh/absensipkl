// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'siswa_home_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SiswaHomeSnapshot {

 DudiPlacement? get placement; AttendanceRecord? get todayRecord; int get approvedJournalsCount; int get targetDays; List<Announcement> get announcements;
/// Create a copy of SiswaHomeSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiswaHomeSnapshotCopyWith<SiswaHomeSnapshot> get copyWith => _$SiswaHomeSnapshotCopyWithImpl<SiswaHomeSnapshot>(this as SiswaHomeSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiswaHomeSnapshot&&(identical(other.placement, placement) || other.placement == placement)&&(identical(other.todayRecord, todayRecord) || other.todayRecord == todayRecord)&&(identical(other.approvedJournalsCount, approvedJournalsCount) || other.approvedJournalsCount == approvedJournalsCount)&&(identical(other.targetDays, targetDays) || other.targetDays == targetDays)&&const DeepCollectionEquality().equals(other.announcements, announcements));
}


@override
int get hashCode => Object.hash(runtimeType,placement,todayRecord,approvedJournalsCount,targetDays,const DeepCollectionEquality().hash(announcements));

@override
String toString() {
  return 'SiswaHomeSnapshot(placement: $placement, todayRecord: $todayRecord, approvedJournalsCount: $approvedJournalsCount, targetDays: $targetDays, announcements: $announcements)';
}


}

/// @nodoc
abstract mixin class $SiswaHomeSnapshotCopyWith<$Res>  {
  factory $SiswaHomeSnapshotCopyWith(SiswaHomeSnapshot value, $Res Function(SiswaHomeSnapshot) _then) = _$SiswaHomeSnapshotCopyWithImpl;
@useResult
$Res call({
 DudiPlacement? placement, AttendanceRecord? todayRecord, int approvedJournalsCount, int targetDays, List<Announcement> announcements
});


$DudiPlacementCopyWith<$Res>? get placement;$AttendanceRecordCopyWith<$Res>? get todayRecord;

}
/// @nodoc
class _$SiswaHomeSnapshotCopyWithImpl<$Res>
    implements $SiswaHomeSnapshotCopyWith<$Res> {
  _$SiswaHomeSnapshotCopyWithImpl(this._self, this._then);

  final SiswaHomeSnapshot _self;
  final $Res Function(SiswaHomeSnapshot) _then;

/// Create a copy of SiswaHomeSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? placement = freezed,Object? todayRecord = freezed,Object? approvedJournalsCount = null,Object? targetDays = null,Object? announcements = null,}) {
  return _then(_self.copyWith(
placement: freezed == placement ? _self.placement : placement // ignore: cast_nullable_to_non_nullable
as DudiPlacement?,todayRecord: freezed == todayRecord ? _self.todayRecord : todayRecord // ignore: cast_nullable_to_non_nullable
as AttendanceRecord?,approvedJournalsCount: null == approvedJournalsCount ? _self.approvedJournalsCount : approvedJournalsCount // ignore: cast_nullable_to_non_nullable
as int,targetDays: null == targetDays ? _self.targetDays : targetDays // ignore: cast_nullable_to_non_nullable
as int,announcements: null == announcements ? _self.announcements : announcements // ignore: cast_nullable_to_non_nullable
as List<Announcement>,
  ));
}
/// Create a copy of SiswaHomeSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DudiPlacementCopyWith<$Res>? get placement {
    if (_self.placement == null) {
    return null;
  }

  return $DudiPlacementCopyWith<$Res>(_self.placement!, (value) {
    return _then(_self.copyWith(placement: value));
  });
}/// Create a copy of SiswaHomeSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceRecordCopyWith<$Res>? get todayRecord {
    if (_self.todayRecord == null) {
    return null;
  }

  return $AttendanceRecordCopyWith<$Res>(_self.todayRecord!, (value) {
    return _then(_self.copyWith(todayRecord: value));
  });
}
}


/// Adds pattern-matching-related methods to [SiswaHomeSnapshot].
extension SiswaHomeSnapshotPatterns on SiswaHomeSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiswaHomeSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiswaHomeSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiswaHomeSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _SiswaHomeSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiswaHomeSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _SiswaHomeSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DudiPlacement? placement,  AttendanceRecord? todayRecord,  int approvedJournalsCount,  int targetDays,  List<Announcement> announcements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiswaHomeSnapshot() when $default != null:
return $default(_that.placement,_that.todayRecord,_that.approvedJournalsCount,_that.targetDays,_that.announcements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DudiPlacement? placement,  AttendanceRecord? todayRecord,  int approvedJournalsCount,  int targetDays,  List<Announcement> announcements)  $default,) {final _that = this;
switch (_that) {
case _SiswaHomeSnapshot():
return $default(_that.placement,_that.todayRecord,_that.approvedJournalsCount,_that.targetDays,_that.announcements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DudiPlacement? placement,  AttendanceRecord? todayRecord,  int approvedJournalsCount,  int targetDays,  List<Announcement> announcements)?  $default,) {final _that = this;
switch (_that) {
case _SiswaHomeSnapshot() when $default != null:
return $default(_that.placement,_that.todayRecord,_that.approvedJournalsCount,_that.targetDays,_that.announcements);case _:
  return null;

}
}

}

/// @nodoc


class _SiswaHomeSnapshot implements SiswaHomeSnapshot {
  const _SiswaHomeSnapshot({this.placement, this.todayRecord, this.approvedJournalsCount = 0, this.targetDays = 120, final  List<Announcement> announcements = const <Announcement>[]}): _announcements = announcements;
  

@override final  DudiPlacement? placement;
@override final  AttendanceRecord? todayRecord;
@override@JsonKey() final  int approvedJournalsCount;
@override@JsonKey() final  int targetDays;
 final  List<Announcement> _announcements;
@override@JsonKey() List<Announcement> get announcements {
  if (_announcements is EqualUnmodifiableListView) return _announcements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_announcements);
}


/// Create a copy of SiswaHomeSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiswaHomeSnapshotCopyWith<_SiswaHomeSnapshot> get copyWith => __$SiswaHomeSnapshotCopyWithImpl<_SiswaHomeSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiswaHomeSnapshot&&(identical(other.placement, placement) || other.placement == placement)&&(identical(other.todayRecord, todayRecord) || other.todayRecord == todayRecord)&&(identical(other.approvedJournalsCount, approvedJournalsCount) || other.approvedJournalsCount == approvedJournalsCount)&&(identical(other.targetDays, targetDays) || other.targetDays == targetDays)&&const DeepCollectionEquality().equals(other._announcements, _announcements));
}


@override
int get hashCode => Object.hash(runtimeType,placement,todayRecord,approvedJournalsCount,targetDays,const DeepCollectionEquality().hash(_announcements));

@override
String toString() {
  return 'SiswaHomeSnapshot(placement: $placement, todayRecord: $todayRecord, approvedJournalsCount: $approvedJournalsCount, targetDays: $targetDays, announcements: $announcements)';
}


}

/// @nodoc
abstract mixin class _$SiswaHomeSnapshotCopyWith<$Res> implements $SiswaHomeSnapshotCopyWith<$Res> {
  factory _$SiswaHomeSnapshotCopyWith(_SiswaHomeSnapshot value, $Res Function(_SiswaHomeSnapshot) _then) = __$SiswaHomeSnapshotCopyWithImpl;
@override @useResult
$Res call({
 DudiPlacement? placement, AttendanceRecord? todayRecord, int approvedJournalsCount, int targetDays, List<Announcement> announcements
});


@override $DudiPlacementCopyWith<$Res>? get placement;@override $AttendanceRecordCopyWith<$Res>? get todayRecord;

}
/// @nodoc
class __$SiswaHomeSnapshotCopyWithImpl<$Res>
    implements _$SiswaHomeSnapshotCopyWith<$Res> {
  __$SiswaHomeSnapshotCopyWithImpl(this._self, this._then);

  final _SiswaHomeSnapshot _self;
  final $Res Function(_SiswaHomeSnapshot) _then;

/// Create a copy of SiswaHomeSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? placement = freezed,Object? todayRecord = freezed,Object? approvedJournalsCount = null,Object? targetDays = null,Object? announcements = null,}) {
  return _then(_SiswaHomeSnapshot(
placement: freezed == placement ? _self.placement : placement // ignore: cast_nullable_to_non_nullable
as DudiPlacement?,todayRecord: freezed == todayRecord ? _self.todayRecord : todayRecord // ignore: cast_nullable_to_non_nullable
as AttendanceRecord?,approvedJournalsCount: null == approvedJournalsCount ? _self.approvedJournalsCount : approvedJournalsCount // ignore: cast_nullable_to_non_nullable
as int,targetDays: null == targetDays ? _self.targetDays : targetDays // ignore: cast_nullable_to_non_nullable
as int,announcements: null == announcements ? _self._announcements : announcements // ignore: cast_nullable_to_non_nullable
as List<Announcement>,
  ));
}

/// Create a copy of SiswaHomeSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DudiPlacementCopyWith<$Res>? get placement {
    if (_self.placement == null) {
    return null;
  }

  return $DudiPlacementCopyWith<$Res>(_self.placement!, (value) {
    return _then(_self.copyWith(placement: value));
  });
}/// Create a copy of SiswaHomeSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceRecordCopyWith<$Res>? get todayRecord {
    if (_self.todayRecord == null) {
    return null;
  }

  return $AttendanceRecordCopyWith<$Res>(_self.todayRecord!, (value) {
    return _then(_self.copyWith(todayRecord: value));
  });
}
}

// dart format on
