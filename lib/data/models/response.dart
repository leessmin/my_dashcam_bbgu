class Response<T> {
  const Response({required this.code, required this.msg, required this.data});

  final int code;
  final String msg;
  final T data;

  factory Response.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return Response<T>(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: fromJsonT(json['data']),
    );
  }

  Map<String, Object?> toMap() {
    return {'code': code, 'msg': msg, 'data': data};
  }
}
