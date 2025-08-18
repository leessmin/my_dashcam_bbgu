import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_dashcam/data/repositories/userSession/user_session_repository.dart';
import 'package:my_dashcam/data/repositories/videoDio/models/response.dart';
import 'package:my_dashcam/data/repositories/videoDio/video_dio_repository.dart';
import 'package:my_dashcam/ui/video/widgets/video_play_box.dart';
import 'package:my_dashcam/utils/loading_command.dart';
import 'package:video_player/video_player.dart';

class OnlineVideoViewModel extends ChangeNotifier {
  OnlineVideoViewModel({
    required VideoDioRepository videoDioRepository,
    required UserSessionRepository userSessionRepository,
    required this.dirId,
    required this.topBarTitle,
  }) : _videoDioRepository = videoDioRepository,
       _userSessionRepository = userSessionRepository {
    loadVideos();
  }

  final VideoDioRepository _videoDioRepository;
  final UserSessionRepository _userSessionRepository;

  // 目录名字
  final int dirId;

  // topBar标题
  final String topBarTitle;

  List<VideoResponse> _videos = [];

  List<VideoResponse> get videos => _videos;

  // 当前播放的视频索引
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  // 视频播放控制
  final ValueNotifier<ChewieController?> _chewieController = ValueNotifier(
    null,
  );
  VideoPlayerController? _videoPlayerController;

  ValueNotifier<ChewieController?> get chewieController => _chewieController;

  LoadingCommand loading = LoadingCommand();

  // 加载视频
  Future<void> loadVideos() async {
    loading.command(() async {
      final result = await _videoDioRepository.getVideos(dirId);
      if (result.code != 200) {
        return;
      }
      _videos = result.data;
      await _loadChewieController();
      notifyListeners();
    });
  }

  // 自动播放视频
  bool _isAutoPlay = false;

  // 设置播放视频
  void setCurrentPlay(int idx) async {
    _currentIndex = idx;
    _isAutoPlay = true;
    await _loadChewieController();
    notifyListeners();
  }

  // 播放下一个视频
  void _nextPlay() async {
    _currentIndex++;
    if (_currentIndex >= _videos.length) _currentIndex = 0;
    _isAutoPlay = true;
    await _loadChewieController();
    notifyListeners();
  }

  // 加载视频播放控制器
  Future<void> _loadChewieController() async {
    await _disposeChewieController();

    _videoPlayerController = VideoPlayerController.networkUrl(
      await _videoDioRepository.videoPlayUri(videos[currentIndex].id),
      httpHeaders: {
        "Authorization": "Bearer ${await _userSessionRepository.getToken()}",
      },
    );
    await _videoPlayerController?.initialize();

    // 防止重复操作
    void listener() {
      if (_videoPlayerController!.value.isCompleted) {
        _videoPlayerController!.removeListener(listener);
        _nextPlay();
      }
    }

    _videoPlayerController!.addListener(listener);

    _chewieController.value = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: _isAutoPlay,
      looping: false,
      routePageBuilder:
          (context, animation, secondaryAnimation, controllerProvider) {
            return VideoPlayBox(chewieController: _chewieController);
          },
    );
  }

  Future<void> _disposeChewieController() async {
    // 清理旧的控制器
    _chewieController.value?.dispose();
    await _videoPlayerController?.dispose();
    _chewieController.value = null;
  }

  // 是否为导出模式
  bool _isExportMode = false;

  bool get isExportMode => _isExportMode;

  // 设置导出模式
  void setExportMode(bool val) {
    _isExportMode = val;
    notifyListeners();
  }

  /// 导出的视频列表 存储视频的id
  final List<VideoResponse> _exportVideos = [];

  List<VideoResponse> get exportVideos => _exportVideos;

  /// 切换视频是否需要导出
  /// @params [video] 需要导出的视频
  /// [video]存在则删除，不存在则添加
  void switchExportVideo(VideoResponse video) {
    if (_exportVideos.contains(video)) {
      _exportVideos.remove(video);
    } else {
      _exportVideos.add(video);
    }
    notifyListeners();
  }

  /// 清空导出视频列表
  void cleanExportVideos() {
    _exportVideos.clear();
    _isExportMode = false;
    notifyListeners();
  }

  /// 视频导出进度
  ValueNotifier<String> exportProgress = ValueNotifier("0");

  /// 是否导出视频时进行视频合并
  final ValueNotifier<bool> _isMerge = ValueNotifier(false);

  ValueNotifier<bool> get isMerge => _isMerge;

  void setIsMerge(bool val) => _isMerge.value = val;

  /// 导出视频
  Future<void> exportVideoHandle() async {
    // 如果没有选择视频则全部导出
    final targetVideos = exportVideos.isEmpty ? videos : exportVideos;
    exportProgress.value = "0";
    try {
      if (isMerge.value) {
        // 合并视频并导出
        await _videoDioRepository.downloadConcatVideo(
          targetVideos.map((item) => item.id).toList(),
          progressFn: (value) {
            exportProgress.value = value;
          },
        );
      } else {
        for (final entry in targetVideos.asMap().entries) {
          final index = entry.key;
          final video = entry.value;
          await _videoDioRepository.downloadVideo(video);
          exportProgress.value =
              "${(index + 1).toDouble() / targetVideos.length * 100}";
        }
      }
    } catch (e) {
      debugPrint("exportVideoHandle: 导出出现错误: ${e.toString()}");
    }
  }

  @override
  void dispose() {
    _disposeChewieController();
    super.dispose();
  }
}
