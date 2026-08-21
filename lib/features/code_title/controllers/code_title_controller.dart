import '../models/code_title_model.dart';
import '../repository/code_title_repository.dart';

class CodeTitleController {
  final CodeTitleRepository _repository;

  CodeTitleController(this._repository);

  Future<List<CodeTitleModel>> getList() async {
    return await _repository.getList();
  }

  Future<List<CodeTitleModel>> getByCategoryId(int categoryId) async {
    return await _repository.getByCategoryId(categoryId);
  }

  Future<CodeTitleModel> getById(int id) async {
    return await _repository.getById(id);
  }
}
