import 'package:log_aqua_app/features/home/domain/typedefs/home_typedefs.dart';

abstract class HomeRepository {
  FutureClientList getAllUsers();
}
