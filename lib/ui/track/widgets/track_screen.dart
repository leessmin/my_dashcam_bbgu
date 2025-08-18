import 'package:amap_map/amap_map.dart';
import 'package:flutter/material.dart';
import 'package:my_dashcam/configuration/global_configuration.dart';
import 'package:my_dashcam/ui/core/ui/default_child_app_bar.dart';
import 'package:x_amap_base/x_amap_base.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(22.830130868564993, 108.25264222919941),
    zoom: 60.0,
  );

  @override
  Widget build(BuildContext context) {
    AMapInitializer.init(
      context,
      apiKey: AMapApiKey(androidKey: GlobalConfiguration.amapApiKeys),
    );

    AMapInitializer.updatePrivacyAgree(
      AMapPrivacyStatement(hasAgree: true, hasContains: true, hasShow: true),
    );

    final AMapWidget map = AMapWidget(
      initialCameraPosition: _kInitialPosition,
      onMapCreated: onMapCreated,
    );

    return Scaffold(
      appBar: defaultChildAppBar(context, title: "title"),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: map,
        ),
      ),
    );
  }

  late AMapController _mapController;

  void onMapCreated(AMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }
}
