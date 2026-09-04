import '../models/app_user_model.dart';

abstract class UserRepository {
  Future<List<AppUserModel>> getList();

  Future<AppUserModel> insert(AppUserModel user);

  Future<AppUserModel> update(AppUserModel user);

  Future<void> delete(AppUserModel user);
}
