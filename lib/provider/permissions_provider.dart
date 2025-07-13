import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_dashcam/data/repositories/permissions/permission_repository.dart';

final permissionsProvider = Provider((ref) => PermissionRepository());
