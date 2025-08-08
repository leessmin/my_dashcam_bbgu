
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_dashcam/data/repositories/userSession/user_session_repository.dart';
import 'package:my_dashcam/data/repositories/videoDio/models/response.dart';
import 'package:my_dashcam/data/repositories/videoDio/video_dio_repository.dart';
import 'package:my_dashcam/ui/video/widgets/video_play_box.dart';
import 'package:video_player/video_player.dart';

class OnlineVideoViewModel extends ChangeNotifier {
  OnlineVideoViewModel({
    required VideoDioRepository videoDioRepository,
    required UserSessionRepository userSessionRepository,
    required this.dirId,
  }) : _videoDioRepository = videoDioRepository,
       _userSessionRepository = userSessionRepository {
    loadVideos();
    loadDirInfo();
  }

  final VideoDioRepository _videoDioRepository;
  final UserSessionRepository _userSessionRepository;

  // 目录名字
  final int dirId;

  List<VideoResponse> _videos = [];

  List<VideoResponse> get videos => _videos;

  VideoDirResponse _dirInfo = VideoDirResponse.empty();

  VideoDirResponse get dirInfo => _dirInfo;

  // 当前播放的视频索引
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  // 视频播放控制
  final ValueNotifier<ChewieController?> _chewieController = ValueNotifier(
    null,
  );
  VideoPlayerController? _videoPlayerController;

  ValueNotifier<ChewieController?> get chewieController => _chewieController;

  // 加载目录信息
  Future<void> loadDirInfo() async {
    final result = await _videoDioRepository.videoDirInfo(dirId);
    if (result.code != 200) {
      return;
    }
    _dirInfo = result.data!;
    notifyListeners();
  }

  // 加载视频
  Future<void> loadVideos() async {
    final result = await _videoDioRepository.getVideos(dirId);
    if (result.code != 200) {
      return;
    }
    _videos = result.data;
    await _loadChewieController();
    notifyListeners();
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

  /// 导出的视频列表 存储[_videos]的下表
  final List<int> _exportVideos = [];

  List<int> get exportVideos => _exportVideos;

  /// 切换视频是否需要导出
  /// @params [idx] 需要导出的视频索引
  /// [idx]存在则删除，不存在则添加
  void switchExportVideo(int idx) {
    if (_exportVideos.contains(idx)) {
      _exportVideos.remove(idx);
    } else {
      _exportVideos.add(idx);
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
  ValueNotifier<String> get exportProgress => ValueNotifier("10/22");

  /// 是否导出视频时进行视频合并
  final ValueNotifier<bool> _isMerge = ValueNotifier(false);

  ValueNotifier<bool> get isMerge => _isMerge;

  void setIsMerge(bool val) => _isMerge.value = val;

  /// 导出视频
  Future<void> exportVideoHandle() async {
    List<String> videos = [];
    try {
      // if (exportVideos.isEmpty) {
      //   /// 没有选择视频，则全部导出
      //   videos = _videos.map((v) => v.path).toList();
      // } else {
      //   for (var (idx, video) in _videos.indexed) {
      //     if (!_exportVideos.contains(idx)) {
      //       continue;
      //     }
      //     videos.add(video.path);
      //   }
      // }

      if (isMerge.value) {
        // 合并视频并导出
        // await _videoExportRepository.exportVideosMerge(videos);
      } else {
        // await _videoExportRepository.exportVideosOneByOne(videos);
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
