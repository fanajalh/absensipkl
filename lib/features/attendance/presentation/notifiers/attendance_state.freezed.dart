// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttendanceDashboardState {

 DudiPlacement? get placement; AttendanceRecord? get todayRecord; GeofenceEvaluation? get geofence; int get approvedJournalsCount; int get targetDays; List<Announcement> get announcements; bool get isRefreshingLocation; bool get isSubmitting; DemoLocationPreset get demoPreset; bool get supportsDemoPreset; AppError? get actionError; String? get actionSuccessMessage;
/// Create a copy of AttendanceDashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceDashboardStateCopyWith<AttendanceDashboardState> get copyWith => _$AttendanceDashboardStateCopyWithImpl<AttendanceDashboardState>(this as AttendanceDashboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceDashboardState&&(identical(other.placement, placement) || other.placement == placement)&&(identical(other.todayRecord, todayRecord) || other.todayRecord == todayRecord)&&(identical(other.geofence, geofence) || other.geofence == geofence)&&(identical(other.approvedJournalsCount, approvedJournalsCount) || other.approvedJournalsCount == approvedJournalsCount)&&(identical(other.targetDays, targetDays) || other.targetDays == targetDays)&&const DeepCollectionEquality().equals(other.announcements, announcements)&&(identical(other.isRefreshingLocation, isRefreshingLocation) || other.isRefreshingLocation == isRefreshingLocation)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.demoPreset, demoPreset) || other.demoPreset == demoPreset)&&(identical(other.supportsDemoPreset, supportsDemoPreset) || other.supportsDemoPreset == supportsDemoPreset)&&(identical(other.actionError, actionError) || other.actionError == actionError)&&(identical(other.actionSuccessMessage, actionSuccessMessage) || other.actionSuccessMessage == actionSuccessMessage));
}


@override
int get hashCode => Object.hash(runtimeType,placement,todayRecord,geofence,approvedJournalsCount,targetDays,const DeepCollectionEquality().hash(announcements),isRefreshingLocation,isSubmitting,demoPreset,supportsDemoPreset,actionError,actionSuccessMessage);

@override
String toString() {
  return 'AttendanceDashboardState(placement: $placement, todayRecord: $todayRecord, geofence: $geofence, approvedJournalsCount: $approvedJournalsCount, targetDays: $targetDays, announcements: $announcements, isRefreshingLocation: $isRefreshingLocation, isSubmitting: $isSubmitting, demoPreset: $demoPreset, supportsDemoPreset: $supportsDemoPreset, actionError: $actionError, actionSuccessMessage: $actionSuccessMessage)';
}


}

/// @nodoc
abstract mixin class $AttendanceDashboardStateCopyWith<$Res>  {
  factory $AttendanceDashboardStateCopyWith(AttendanceDashboardState value, $Res Function(AttendanceDashboardState) _then) = _$AttendanceDashboardStateCopyWithImpl;
@useResult
$Res call({
 DudiPlacement? placement, AttendanceRecord? todayRecord, GeofenceEvaluation? geofence, int approvedJournalsCount, int targetDays, List<Announcement> announcements, bool isRefreshingLocation, bool isSubmitting, DemoLocationPreset demoPreset, bool supportsDemoPreset, AppError? actionError, String? actionSuccessMessage
});


$DudiPlacementCopyWith<$Res>? get placement;$AttendanceRecordCopyWith<$Res>? get todayRecord;$GeofenceEvaluationCopyWith<$Res>? get geofence;$AppErrorCopyWith<$Res>? get actionError;

}
/// @nodoc
class _$AttendanceDashboardStateCopyWithImpl<$Res>
    implements $AttendanceDashboardStateCopyWith<$Res> {
  _$AttendanceDashboardStateCopyWithImpl(this._self, this._then);

  final AttendanceDashboardState _self;
  final $Res Function(AttendanceDashboardState) _then;

/// Create a copy of AttendanceDashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? placement = freezed,Object? todayRecord = freezed,Object? geofence = freezed,Object? approvedJournalsCount = null,Object? targetDays = null,Object? announcements = null,Object? isRefreshingLocation = null,Object? isSubmitting = null,Object? demoPreset = null,Object? supportsDemoPreset = null,Object? actionError = freezed,Object? actionSuccessMessage = freezed,}) {
  return _then(_self.copyWith(
placement: freezed == placement ? _self.placement : placement // ignore: cast_nullable_to_non_nullable
as DudiPlacement?,todayRecord: freezed == todayRecord ? _self.todayRecord : todayRecord // ignore: cast_nullable_to_non_nullable
as AttendanceRecord?,geofence: freezed == geofence ? _self.geofence : geofence // ignore: cast_nullable_to_non_nullable
as GeofenceEvaluation?,approvedJournalsCount: null == approvedJournalsCount ? _self.approvedJournalsCount : approvedJournalsCount // ignore: cast_nullable_to_non_nullable
as int,targetDays: null == targetDays ? _self.targetDays : targetDays // ignore: cast_nullable_to_non_nullable
as int,announcements: null == announcements ? _self.announcements : announcements // ignore: cast_nullable_to_non_nullable
as List<Announcement>,isRefreshingLocation: null == isRefreshingLocation ? _self.isRefreshingLocation : isRefreshingLocation // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,demoPreset: null == demoPreset ? _self.demoPreset : demoPreset // ignore: cast_nullable_to_non_nullable
as DemoLocationPreset,supportsDemoPreset: null == supportsDemoPreset ? _self.supportsDemoPreset : supportsDemoPreset // ignore: cast_nullable_to_non_nullable
as bool,actionError: freezed == actionError ? _self.actionError : actionError // ignore: cast_nullable_to_non_nullable
as AppError?,actionSuccessMessage: freezed == actionSuccessMessage ? _self.actionSuccessMessage : actionSuccessMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AttendanceDashboardState
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
}/// Create a copy of AttendanceDashboardState
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
}/// Create a copy of AttendanceDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeofenceEvaluationCopyWith<$Res>? get geofence {
    if (_self.geofence == null) {
    return null;
  }

  return $GeofenceEvaluationCopyWith<$Res>(_self.geofence!, (value) {
    return _then(_self.copyWith(geofence: value));
  });
}/// Create a copy of AttendanceDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppErrorCopyWith<$Res>? get actionError {
    if (_self.actionError == null) {
    return null;
  }

  return $AppErrorCopyWith<$Res>(_self.actionError!, (value) {
    return _then(_self.copyWith(actionError: value));
  });
}
}


/// Adds pattern-matching-related methods to [AttendanceDashboardState].
extension AttendanceDashboardStatePatterns on AttendanceDashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceDashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceDashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceDashboardState value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceDashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceDashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceDashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DudiPlacement? placement,  AttendanceRecord? todayRecord,  GeofenceEvaluation? geofence,  int approvedJournalsCount,  int targetDays,  List<Announcement> announcements,  bool isRefreshingLocation,  bool isSubmitting,  DemoLocationPreset demoPreset,  bool supportsDemoPreset,  AppError? actionError,  String? actionSuccessMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceDashboardState() when $default != null:
return $default(_that.placement,_that.todayRecord,_that.geofence,_that.approvedJournalsCount,_that.targetDays,_that.announcements,_that.isRefreshingLocation,_that.isSubmitting,_that.demoPreset,_that.supportsDemoPreset,_that.actionError,_that.actionSuccessMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DudiPlacement? placement,  AttendanceRecord? todayRecord,  GeofenceEvaluation? geofence,  int approvedJournalsCount,  int targetDays,  List<Announcement> announcements,  bool isRefreshingLocation,  bool isSubmitting,  DemoLocationPreset demoPreset,  bool supportsDemoPreset,  AppError? actionError,  String? actionSuccessMessage)  $default,) {final _that = this;
switch (_that) {
case _AttendanceDashboardState():
return $default(_that.placement,_that.todayRecord,_that.geofence,_that.approvedJournalsCount,_that.targetDays,_that.announcements,_that.isRefreshingLocation,_that.isSubmitting,_that.demoPreset,_that.supportsDemoPreset,_that.actionError,_that.actionSuccessMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DudiPlacement? placement,  AttendanceRecord? todayRecord,  GeofenceEvaluation? geofence,  int approvedJournalsCount,  int targetDays,  List<Announcement> announcements,  bool isRefreshingLocation,  bool isSubmitting,  DemoLocationPreset demoPreset,  bool supportsDemoPreset,  AppError? actionError,  String? actionSuccessMessage)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceDashboardState() when $default != null:
return $default(_that.placement,_that.todayRecord,_that.geofence,_that.approvedJournalsCount,_that.targetDays,_that.announcements,_that.isRefreshingLocation,_that.isSubmitting,_that.demoPreset,_that.supportsDemoPreset,_that.actionError,_that.actionSuccessMessage);case _:
  return null;

}
}

}

/// @nodoc


class _AttendanceDashboardState implements AttendanceDashboardState {
  const _AttendanceDashboardState({this.placement, this.todayRecord, this.geofence, this.approvedJournalsCount = 0, this.targetDays = 120, final  List<Announcement> announcements = const <Announcement>[], this.isRefreshingLocation = false, this.isSubmitting = false, this.demoPreset = DemoLocationPreset.insideRadius, this.supportsDemoPreset = false, this.actionError, this.actionSuccessMessage}): _announcements = announcements;
  

@override final  DudiPlacement? placement;
@override final  AttendanceRecord? todayRecord;
@override final  GeofenceEvaluation? geofence;
@override@JsonKey() final  int approvedJournalsCount;
@override@JsonKey() final  int targetDays;
 final  List<Announcement> _announcements;
@override@JsonKey() List<Announcement> get announcements {
  if (_announcements is EqualUnmodifiableListView) return _announcements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_announcements);
}

@override@JsonKey() final  bool isRefreshingLocation;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  DemoLocationPreset demoPreset;
@override@JsonKey() final  bool supportsDemoPreset;
@override final  AppError? actionError;
@override final  String? actionSuccessMessage;

/// Create a copy of AttendanceDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceDashboardStateCopyWith<_AttendanceDashboardState> get copyWith => __$AttendanceDashboardStateCopyWithImpl<_AttendanceDashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceDashboardState&&(identical(other.placement, placement) || other.placement == placement)&&(identical(other.todayRecord, todayRecord) || other.todayRecord == todayRecord)&&(identical(other.geofence, geofence) || other.geofence == geofence)&&(identical(other.approvedJournalsCount, approvedJournalsCount) || other.approvedJournalsCount == approvedJournalsCount)&&(identical(other.targetDays, targetDays) || other.targetDays == targetDays)&&const DeepCollectionEquality().equals(other._announcements, _announcements)&&(identical(other.isRefreshingLocation, isRefreshingLocation) || other.isRefreshingLocation == isRefreshingLocation)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.demoPreset, demoPreset) || other.demoPreset == demoPreset)&&(identical(other.supportsDemoPreset, supportsDemoPreset) || other.supportsDemoPreset == supportsDemoPreset)&&(identical(other.actionError, actionError) || other.actionError == actionError)&&(identical(other.actionSuccessMessage, actionSuccessMessage) || other.actionSuccessMessage == actionSuccessMessage));
}


@override
int get hashCode => Object.hash(runtimeType,placement,todayRecord,geofence,approvedJournalsCount,targetDays,const DeepCollectionEquality().hash(_announcements),isRefreshingLocation,isSubmitting,demoPreset,supportsDemoPreset,actionError,actionSuccessMessage);

@override
String toString() {
  return 'AttendanceDashboardState(placement: $placement, todayRecord: $todayRecord, geofence: $geofence, approvedJournalsCount: $approvedJournalsCount, targetDays: $targetDays, announcements: $announcements, isRefreshingLocation: $isRefreshingLocation, isSubmitting: $isSubmitting, demoPreset: $demoPreset, supportsDemoPreset: $supportsDemoPreset, actionError: $actionError, actionSuccessMessage: $actionSuccessMessage)';
}


}

/// @nodoc
abstract mixin class _$AttendanceDashboardStateCopyWith<$Res> implements $AttendanceDashboardStateCopyWith<$Res> {
  factory _$AttendanceDashboardStateCopyWith(_AttendanceDashboardState value, $Res Function(_AttendanceDashboardState) _then) = __$AttendanceDashboardStateCopyWithImpl;
@override @useResult
$Res call({
 DudiPlacement? placement, AttendanceRecord? todayRecord, GeofenceEvaluation? geofence, int approvedJournalsCount, int targetDays, List<Announcement> announcements, bool isRefreshingLocation, bool isSubmitting, DemoLocationPreset demoPreset, bool supportsDemoPreset, AppError? actionError, String? actionSuccessMessage
});


@override $DudiPlacementCopyWith<$Res>? get placement;@override $AttendanceRecordCopyWith<$Res>? get todayRecord;@override $GeofenceEvaluationCopyWith<$Res>? get geofence;@override $AppErrorCopyWith<$Res>? get actionError;

}
/// @nodoc
class __$AttendanceDashboardStateCopyWithImpl<$Res>
    implements _$AttendanceDashboardStateCopyWith<$Res> {
  __$AttendanceDashboardStateCopyWithImpl(this._self, this._then);

  final _AttendanceDashboardState _self;
  final $Res Function(_AttendanceDashboardState) _then;

/// Create a copy of AttendanceDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? placement = freezed,Object? todayRecord = freezed,Object? geofence = freezed,Object? approvedJournalsCount = null,Object? targetDays = null,Object? announcements = null,Object? isRefreshingLocation = null,Object? isSubmitting = null,Object? demoPreset = null,Object? supportsDemoPreset = null,Object? actionError = freezed,Object? actionSuccessMessage = freezed,}) {
  return _then(_AttendanceDashboardState(
placement: freezed == placement ? _self.placement : placement // ignore: cast_nullable_to_non_nullable
as DudiPlacement?,todayRecord: freezed == todayRecord ? _self.todayRecord : todayRecord // ignore: cast_nullable_to_non_nullable
as AttendanceRecord?,geofence: freezed == geofence ? _self.geofence : geofence // ignore: cast_nullable_to_non_nullable
as GeofenceEvaluation?,approvedJournalsCount: null == approvedJournalsCount ? _self.approvedJournalsCount : approvedJournalsCount // ignore: cast_nullable_to_non_nullable
as int,targetDays: null == targetDays ? _self.targetDays : targetDays // ignore: cast_nullable_to_non_nullable
as int,announcements: null == announcements ? _self._announcements : announcements // ignore: cast_nullable_to_non_nullable
as List<Announcement>,isRefreshingLocation: null == isRefreshingLocation ? _self.isRefreshingLocation : isRefreshingLocation // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,demoPreset: null == demoPreset ? _self.demoPreset : demoPreset // ignore: cast_nullable_to_non_nullable
as DemoLocationPreset,supportsDemoPreset: null == supportsDemoPreset ? _self.supportsDemoPreset : supportsDemoPreset // ignore: cast_nullable_to_non_nullable
as bool,actionError: freezed == actionError ? _self.actionError : actionError // ignore: cast_nullable_to_non_nullable
as AppError?,actionSuccessMessage: freezed == actionSuccessMessage ? _self.actionSuccessMessage : actionSuccessMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AttendanceDashboardState
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
}/// Create a copy of AttendanceDashboardState
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
}/// Create a copy of AttendanceDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeofenceEvaluationCopyWith<$Res>? get geofence {
    if (_self.geofence == null) {
    return null;
  }

  return $GeofenceEvaluationCopyWith<$Res>(_self.geofence!, (value) {
    return _then(_self.copyWith(geofence: value));
  });
}/// Create a copy of AttendanceDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppErrorCopyWith<$Res>? get actionError {
    if (_self.actionError == null) {
    return null;
  }

  return $AppErrorCopyWith<$Res>(_self.actionError!, (value) {
    return _then(_self.copyWith(actionError: value));
  });
}
}

// dart format on
