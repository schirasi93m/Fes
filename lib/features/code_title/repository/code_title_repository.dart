import '../models/code_title_model.dart';

abstract class CodeTitleRepository {
  Future<List<CodeTitleModel>> getList();

  Future<List<CodeTitleModel>> getByCategoryId(int categoryId);
  Future<CodeTitleModel> getById(int id);
}
