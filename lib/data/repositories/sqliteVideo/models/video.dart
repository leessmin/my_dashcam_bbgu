class Video {
  const Video({
    this.id,
    required this.dirName,
    required this.videoPath,
    required this.upload,
  });

  final int? id;
  final String dirName;
  final String videoPath;
  final int upload; // 是否上传成功到服务器,上传成功1, 未上传服务器0

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'dir_name': dirName,
      'video_path': videoPath,
      'upload': upload,
    };
  }

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as int,
      dirName: json['dir_name'] as String,
      videoPath: json['video_path'] as String,
      upload: json['upload'] as int,
    );
  }
}
