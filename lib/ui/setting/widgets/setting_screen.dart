import 'package:button_group/data_item.dart';
import 'package:flutter/material.dart';
import 'package:my_dashcam/common/frame_rate.dart';
import 'package:my_dashcam/common/quality.dart';
import 'package:my_dashcam/common/record_interval.dart';
import 'package:my_dashcam/common/rotation.dart';
import 'package:my_dashcam/common/save_size.dart';
import 'package:my_dashcam/domain/models/camera_activity_options.dart';
import 'package:my_dashcam/ui/core/ui/default_child_app_bar.dart';
import 'package:my_dashcam/ui/setting/view_models/setting_viewmodel.dart';
import 'package:my_dashcam/ui/setting/widgets/select_item.dart';
import 'package:my_dashcam/ui/setting/widgets/switch_item.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key, required this.viewmodel});

  final SettingViewModel viewmodel;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultChildAppBar(context, title: "设置"),
      body: ListenableBuilder(
        listenable: Listenable.merge([widget.viewmodel]),
        builder: (context, _) {
          final options = widget.viewmodel.options;
          if (options == null) {
            return Center();
          }
          return _settingFormBody(context, options, (value) {
            widget.viewmodel.updateOptions(value);
          });
        },
      ),
    );
  }

  Widget _settingFormBody(
    BuildContext context,
    CameraActivityOptions options,
    void Function(CameraActivityOptions) onChange,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        children: [
          SizedBox(height: 10),
          SelectItem(
            title: "视频质量:",
            label: "视频质量越高需要的存储空间越大, SD:480p|HD:720p|FHD:1080p|UHD:2160p",
            dataItem: [
              DataItem(key: Quality.sd.value, value: Quality.sd),
              DataItem(key: Quality.hd.value, value: Quality.hd),
              DataItem(key: Quality.fhd.value, value: Quality.fhd),
              DataItem(key: Quality.uhd.value, value: Quality.uhd),
            ],
            currentData: options.quality,
            onSelect: (data) {
              onChange(options.copyWith(quality: data));
            },
          ),
          SelectItem(
            title: "录制方向:",
            label: "视频录制的方向, 目前不支持自动调节, 请手动调节",
            dataItem: [
              DataItem(
                key: Rotation.rotation0.label,
                value: Rotation.rotation0,
              ),
              DataItem(
                key: Rotation.rotation90.label,
                value: Rotation.rotation90,
              ),
              DataItem(
                key: Rotation.rotation180.label,
                value: Rotation.rotation180,
              ),
              DataItem(
                key: Rotation.rotation270.label,
                value: Rotation.rotation270,
              ),
            ],
            currentData: options.rotation,
            onSelect: (data) {
              onChange(options.copyWith(rotation: data));
            },
          ),
          SelectItem(
            title: "录制帧率:",
            label: "帧率越高越流畅, 所需存储越多",
            dataItem: [
              DataItem(
                key: FrameRate.fps24.value.toString(),
                value: FrameRate.fps24,
              ),
              DataItem(
                key: FrameRate.fps30.value.toString(),
                value: FrameRate.fps30,
              ),
              DataItem(
                key: FrameRate.fps60.value.toString(),
                value: FrameRate.fps60,
              ),
            ],
            currentData: options.frameRate,
            onSelect: (data) {
              onChange(options.copyWith(frameRate: data));
            },
          ),
          SwitchItem(
            title: "记录车速:",
            label: "记录车辆的实时速度",
            value: options.recordSpeed,
            onChanged: (data) {
              onChange(options.copyWith(recordSpeed: data));
            },
          ),
          SwitchItem(
            title: "记录声音:",
            label: "记录外界的声音",
            value: options.recordVoice,
            onChanged: (data) {
              onChange(options.copyWith(recordVoice: data));
            },
          ),
          SwitchItem(
            title: "启用防抖:",
            label: "防止视频抖动,可能会出现画面裁剪",
            value: options.stabilization,
            onChanged: (data) {
              onChange(options.copyWith(stabilization: data));
            },
          ),
          SelectItem(
            title: "录制间隔:",
            label: "单次录制的视频时长",
            dataItem: [
              DataItem(
                key: "${RecordInterval.one.value}分钟",
                value: RecordInterval.one,
              ),
              DataItem(
                key: "${RecordInterval.three.value}分钟",
                value: RecordInterval.three,
              ),
              DataItem(
                key: "${RecordInterval.five.value}分钟",
                value: RecordInterval.five,
              ),
              DataItem(
                key: "${RecordInterval.ten.value}分钟",
                value: RecordInterval.ten,
              ),
            ],
            currentData: options.interval,
            onSelect: (data) {
              onChange(options.copyWith(interval: data));
            },
          ),
          SwitchItem(
            title: "相机页面锁定:",
            label: "在相机页面，禁止应用切换后台",
            value: options.lockScreen,
            onChanged: (data) {
              onChange(options.copyWith(lockScreen: data));
            },
          ),
          SelectItem(
            title: "存储空间:",
            label: "限制视频录制最多可以使用的空间",
            dataItem: [
              DataItem(key: "${SaveSize.one.value}GB", value: SaveSize.one),
              DataItem(key: "${SaveSize.five.value}GB", value: SaveSize.five),
              DataItem(key: "${SaveSize.ten.value}GB", value: SaveSize.ten),
              DataItem(
                key: "${SaveSize.twenty.value}GB",
                value: SaveSize.twenty,
              ),
              DataItem(key: "无上限", value: SaveSize.infinite),
            ],
            currentData: options.maxSaveSize,
            onSelect: (data) {
              onChange(options.copyWith(maxSaveSize: data));
            },
          ),
        ],
      ),
    );
  }
}
