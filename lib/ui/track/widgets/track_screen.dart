import 'package:amap_map/amap_map.dart';
import 'package:flutter/material.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:my_dashcam/ui/core/ui/default_child_app_bar.dart';
import 'package:my_dashcam/ui/track/view_models/track_viewmodel.dart';
import 'package:my_dashcam/utils/duration_ext.dart';
import 'package:my_dashcam/utils/timestamp_format.dart';
import 'package:x_amap_base/x_amap_base.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key, required this.viewModel});

  final TrackViewModel viewModel;

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  @override
  void dispose() {
    _mapController?.disponse();
    _mapController?.clearDisk();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultChildAppBar(
        context,
        title: TimestampFormat.timestampToTimeString(widget.viewModel.name),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          widget.viewModel,
          widget.viewModel.loading.status,
        ]),
        builder: (context, _) {
          if (widget.viewModel.loading.status.value) {
            return Center(child: CircularProgressIndicator());
          }

          final data = widget.viewModel.data;

          if (data.isEmpty) {
            return Center(child: Text("没有记录数据"));
          }

          final AMapWidget map = AMapWidget(
            initialCameraPosition: CameraPosition(
              target: LatLng(data.first.lat, data.first.lng),
              zoom: 12.0,
            ),
            onMapCreated: onMapCreated,
            polylines: widget.viewModel.polyline,
            markers: widget.viewModel.marker,
          );

          return Stack(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: map,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Card(
                    color: getCatppuccinByCtx(
                      context,
                    ).base.withValues(alpha: 0.5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoItem(
                            title: "时长",
                            content: widget.viewModel.totalTime.toChineseString,
                          ),
                          _infoItem(
                            title: "距离",
                            content: "${widget.viewModel.totalDistance}Km",
                          ),
                          _infoItem(
                            title: "平均时速",
                            content: "${widget.viewModel.avgSpeed}Km/h",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoItem({required String title, required String content}) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        Text(content),
      ],
    );
  }

  AMapController? _mapController;

  void onMapCreated(AMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }
}
