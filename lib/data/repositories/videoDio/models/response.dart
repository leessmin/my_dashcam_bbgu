class VideoDirResponse {
  const VideoDirResponse({
    required this.id,
    required this.dirName,
    required this.dirPath,
    required this.createdTime,
    required this.userId,
    required this.deviceId,
    required this.firstVideo,
    required this.videoCount,
  });

  final int id;
  final String dirName;
  final String dirPath;
  final String createdTime;
  final int userId;
  final String deviceId;
  final VideoResponse firstVideo;
  final int videoCount;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'dir_name': dirName,
      'dir_path': dirPath,
      'created_time': createdTime,
      'user_id': userId,
      'device_id': deviceId,
      'first_video': firstVideo,
      'video_count': videoCount,
    };
  }

  factory VideoDirResponse.fromJson(Map<String, dynamic> json) {
    return VideoDirResponse(
      id: json['id'] as int,
      dirName: json['dir_name'] as String,
      dirPath: json['dir_path'] as String,
      createdTime: json['created_time'] as String,
      userId: json['user_id'] as int,
      deviceId: json['device_id'] as String,
      firstVideo: VideoResponse.fromJson(json['first_video']),
      videoCount: json['video_count'] as int,
    );
  }

  factory VideoDirResponse.empty() {
    return VideoDirResponse(
      id: 0,
      dirName: "",
      dirPath: "",
      createdTime: "",
      userId: 0,
      deviceId: "",
      firstVideo: VideoResponse(
        id: 0,
        videoDirId: 0,
        deviceId: "",
        userId: 0,
        videoPath: "",
        videoName: "",
        videoThumbnail: "",
        duration: 0,
        resolution: "",
        videoType: "",
        videoSize: 0,
        createdTime: "",
        fileHash256: "",
      ),
      videoCount: 0,
    );
  }
}

class VideoResponse {
  const VideoResponse({
    required this.id,
    required this.videoDirId,
    required this.deviceId,
    required this.userId,
    required this.videoPath,
    required this.videoName,
    required this.videoThumbnail,
    required this.duration,
    required this.resolution,
    required this.videoType,
    required this.videoSize,
    required this.createdTime,
    required this.fileHash256,
  });

  final int id;
  final int videoDirId;
  final String deviceId;
  final int userId;
  final String videoPath;
  final String videoName;
  final String videoThumbnail;
  final double duration;
  final String resolution;
  final String videoType;
  final double videoSize;
  final String createdTime;
  final String fileHash256;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'video_dir_id': videoDirId,
      'device_id': deviceId,
      'user_id': userId,
      'video_path': videoPath,
      'video_name': videoName,
      'video_thumbnail': videoThumbnail,
      'duration': duration,
      'resolution': resolution,
      'video_type': videoType,
      'video_size': videoSize,
      'created_time': createdTime,
      'file_hash256': fileHash256,
    };
  }

  factory VideoResponse.fromJson(Map<String, dynamic> json) {
    return VideoResponse(
      id: json['id'] as int,
      videoDirId: json['video_dir_id'] as int,
      deviceId: json['device_id'] as String,
      userId: json['user_id'] as int,
      videoPath: json['video_path'] as String,
      videoName: json['video_name'] as String,
      videoThumbnail: json['video_thumbnail'] as String,
      duration: (json['duration'] as num).toDouble(),
      resolution: json['resolution'] as String,
      videoType: json['video_type'] as String,
      videoSize: (json['video_size'] as num).toDouble(),
      createdTime: json['created_time'] as String,
      fileHash256: json['file_hash256'] as String,
    );
  }
}
