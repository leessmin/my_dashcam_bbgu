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
  final FirstVideo firstVideo;
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
      firstVideo: FirstVideo.fromJson(json['first_video']),
      videoCount: json['video_count'] as int,
    );
  }
}

class FirstVideo {
  const FirstVideo({
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

  factory FirstVideo.fromJson(Map<String, dynamic> json) {
    return FirstVideo(
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
