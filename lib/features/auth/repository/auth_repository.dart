import 'package:new_project_fes/features/auth/model/login_request_model.dart';
import 'package:new_project_fes/features/auth/model/login_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(LoginRequestModel request);
}
