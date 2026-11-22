import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/motion_widgets.dart';
import '../../domain/entities/geofence_evaluation.dart';

bool get _isWidgetTestBinding =>
    WidgetsBinding.instance.runtimeType.toString().contains('Test');

/// Interactive real-world map powered by flutter_map (CartoDB Voyager / Dark)
/// with metric geofence radius, DUDI marker, live student GPS pin & controls.
class GeofenceVectorMap extends StatefulWidget {
  const GeofenceVectorMap({
    super.key,
    required this.companyName,
    required this.companyLatitude,
    required this.companyLongitude,
    required this.evaluation,
    required this.allowedRadiusMeters,
  });

  final String companyName;
  final double companyLatitude;
  final double companyLongitude;
  final GeofenceEvaluation? evaluation;
  final double allowedRadiusMeters;

  @override
  State<GeofenceVectorMap> createState() => _GeofenceVectorMapState();
}

class _GeofenceVectorMapState extends State<GeofenceVectorMap>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  AnimationController? _cameraAnimController;
  bool _mapReady = false;
  bool _isSatellite = false;

  LatLng get _companyPoint =>
      LatLng(widget.companyLatitude, widget.companyLongitude);

  LatLng? get _studentPoint {
    final loc = widget.evaluation?.location;
    if (loc == null) return null;
    return LatLng(loc.latitude, loc.longitude);
  }

  @override
  void didUpdateWidget(covariant GeofenceVectorMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldLoc = oldWidget.evaluation?.location;
    final newLoc = widget.evaluation?.location;
    final moved = oldLoc?.latitude != newLoc?.latitude ||
        oldLoc?.longitude != newLoc?.longitude ||
        oldWidget.companyLatitude != widget.companyLatitude ||
        oldWidget.companyLongitude != widget.companyLongitude;
    if (moved && _mapReady) {
      _recenterMap(animated: true);
    }
  }

  @override
  void dispose() {
    _cameraAnimController?.dispose();
    _mapController.dispose();
    super.dispose();
  }

  (LatLng center, double zoom) _idealCamera() {
    final company = _companyPoint;
    final student = _studentPoint;
    if (student == null) {
      return (company, 17.2);
    }

    final dist = widget.evaluation?.distanceMeters ?? 0;
    final midLat = (company.latitude + student.latitude) / 2;
    final midLng = (company.longitude + student.longitude) / 2;
    final zoom = switch (dist) {
      <= 90 => 17.2,
      <= 180 => 16.4,
      <= 400 => 15.6,
      <= 900 => 14.8,
      _ => 13.8,
    };
    return (LatLng(midLat, midLng), zoom);
  }

  void _recenterMap({bool animated = true}) {
    final (target, zoom) = _idealCamera();
    if (!animated || _isWidgetTestBinding) {
      _mapController.move(target, zoom);
      return;
    }
    _animateCameraTo(target, zoom);
  }

  void _stepZoom(double delta) {
    if (!_mapReady) return;
    final camera = _mapController.camera;
    final nextZoom = (camera.zoom + delta).clamp(11.0, 20.0);
    if (_isWidgetTestBinding) {
      _mapController.move(camera.center, nextZoom);
      return;
    }
    _animateCameraTo(camera.center, nextZoom);
  }

  void _animateCameraTo(LatLng destCenter, double destZoom) {
    _cameraAnimController?.dispose();
    final camera = _mapController.camera;
    final latTween = Tween<double>(
      begin: camera.center.latitude,
      end: destCenter.latitude,
    );
    final lngTween = Tween<double>(
      begin: camera.center.longitude,
      end: destCenter.longitude,
    );
    final zoomTween = Tween<double>(
      begin: camera.zoom,
      end: destZoom,
    );

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _cameraAnimController = controller;
    final curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutExpo,
    );

    controller.addListener(() {
      if (!mounted) return;
      _mapController.move(
        LatLng(latTween.evaluate(curve), lngTween.evaluate(curve)),
        zoomTween.evaluate(curve),
      );
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        if (_cameraAnimController == controller) {
          _cameraAnimController = null;
        }
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final current = widget.evaluation;
    final company = _companyPoint;
    final student = _studentPoint;

    final isMocked = current?.isMocked ?? false;
    final isValid = current != null && current.canSubmitAttendance;
    final fenceColor = (isMocked || (current != null && !isValid))
        ? AppColors.rose
        : AppColors.lightPrimary;
    final (initialCenter, initialZoom) = _idealCamera();

    final tileUrl = _isSatellite
        ? 'https://mt{s}.google.com/vt/lyrs=y&hl=id&x={x}&y={y}&z={z}'
        : 'https://mt{s}.google.com/vt/lyrs=m&hl=id&x={x}&y={y}&z={z}';

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF16181D) : const Color(0xFFEDF2F7),
          border: Border.all(
            color: colorScheme.outline,
            width: AppSpacing.hairlineBorder,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: initialZoom,
                minZoom: 11,
                maxZoom: 20,
                backgroundColor:
                    isDark ? const Color(0xFF16181D) : const Color(0xFFEDF2F7),
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
                onMapReady: () {
                  _mapReady = true;
                },
              ),
              children: <Widget>[
                if (!_isWidgetTestBinding)
                  TileLayer(
                    key: ValueKey<bool>(_isSatellite),
                    urlTemplate: tileUrl,
                    subdomains: const <String>['0', '1', '2', '3'],
                    userAgentPackageName: 'id.fanajalh.absensipkl',
                    maxNativeZoom: 20,
                    maxZoom: 20,
                  ),
                CircleLayer(
                  circles: <CircleMarker>[
                    CircleMarker(
                      point: company,
                      radius: math.max(widget.allowedRadiusMeters, 10),
                      useRadiusInMeter: true,
                      color: fenceColor.withValues(alpha: 0.14),
                      borderColor: fenceColor.withValues(alpha: 0.78),
                      borderStrokeWidth: 2,
                    ),
                    if (student != null && current != null)
                      CircleMarker(
                        point: student,
                        radius: current.location.accuracyMeters.clamp(5, 45),
                        useRadiusInMeter: true,
                        color: (isMocked ? AppColors.rose : AppColors.lightPrimary)
                            .withValues(alpha: 0.14),
                        borderColor: Colors.transparent,
                        borderStrokeWidth: 0,
                      ),
                  ],
                ),
                if (student != null)
                  PolylineLayer(
                    polylines: <Polyline>[
                      Polyline(
                        points: <LatLng>[company, student],
                        color: (isDark || _isSatellite)
                            ? Colors.white.withValues(alpha: 0.82)
                            : AppColors.lightCharcoal.withValues(alpha: 0.62),
                        strokeWidth: 2,
                        pattern: StrokePattern.dashed(
                          segments: const <double>[6, 5],
                        ),
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: <Marker>[
                    Marker(
                      point: company,
                      width: 190,
                      height: 62,
                      alignment: Alignment.center,
                      child: _DudiMarker(companyName: widget.companyName),
                    ),
                    if (student != null && current != null)
                      Marker(
                        point: student,
                        width: 120,
                        height: 54,
                        alignment: Alignment.center,
                        child: _StudentMarker(
                          distanceLabel: '${current.distanceMeters.round()} m',
                          color: isMocked
                              ? AppColors.rose
                              : isValid
                                  ? AppColors.emerald
                                  : AppColors.rose,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: AppSpacing.md,
              top: AppSpacing.md,
              child: _MapOverlayPill(
                dotColor: isMocked ? AppColors.rose : AppColors.emerald,
                label: isMocked ? 'Mock GPS' : 'GPS Asli',
              ),
            ),
            Positioned(
              right: AppSpacing.md,
              top: AppSpacing.md,
              child: _MapOverlayPill(
                label: current != null
                    ? 'Akurasi ${current.location.accuracyMeters.round()} m'
                    : 'Akurasi -- m',
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _MapControlButton(
                    icon: _isSatellite
                        ? Icons.map_rounded
                        : Icons.satellite_alt_rounded,
                    tooltip: _isSatellite ? 'Mode Peta' : 'Mode Satelit',
                    onTap: () => setState(() => _isSatellite = !_isSatellite),
                  ),
                  const SizedBox(height: 6),
                  _MapControlButton(
                    icon: Icons.add_rounded,
                    tooltip: 'Perbesar',
                    onTap: () => _stepZoom(1.0),
                  ),
                  const SizedBox(height: 6),
                  _MapControlButton(
                    icon: Icons.remove_rounded,
                    tooltip: 'Perkecil',
                    onTap: () => _stepZoom(-1.0),
                  ),
                  const SizedBox(height: 6),
                  _MapControlButton(
                    icon: Icons.my_location_rounded,
                    tooltip: 'Pusatkan Peta',
                    accent: true,
                    onTap: () => _recenterMap(animated: true),
                  ),
                ],
              ),
            ),
            Positioned(
              left: AppSpacing.md + 48,
              bottom: 8,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.82),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Google Maps',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DudiMarker extends StatelessWidget {
  const _DudiMarker({required this.companyName});

  final String companyName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          constraints: const BoxConstraints(maxWidth: 180),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: colorScheme.outline,
              width: AppSpacing.hairlineBorder,
            ),
          ),
          child: Text(
            companyName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 10.5,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.lightCharcoal,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5),
          ),
          child: Center(
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: AppColors.lightYellow,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StudentMarker extends StatelessWidget {
  const _StudentMarker({
    required this.distanceLabel,
    required this.color,
  });

  final String distanceLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            distanceLabel,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 10.5,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(height: 3),
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.35), width: 1.5),
          ),
          child: Center(
            child: LivePulseDot(color: color, size: 10),
          ),
        ),
      ],
    );
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.accent = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: BouncyTap(
        onTap: onTap,
        scaleDown: 0.90,
        hoverScale: 1.06,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline,
              width: AppSpacing.hairlineBorder,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: accent ? colorScheme.primary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _MapOverlayPill extends StatelessWidget {
  const _MapOverlayPill({
    required this.label,
    this.dotColor,
  });

  final String label;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface.withAlpha(242),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: colorScheme.outline,
          width: AppSpacing.hairlineBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (dotColor != null) ...<Widget>[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.xs + 2),
          ],
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
