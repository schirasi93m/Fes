import '../models/extinguishers_model.dart';
import '../repository/extinguisher_repository.dart';

class ExtinguisherController {
  final ExtinguisherRepository _repository;

  ExtinguisherController(this._repository);

  Future<List<ExtinguisherModel>> getAll() {
    return _repository.getList();
  }

  Future<ExtinguisherModel> add(ExtinguisherModel extinguisher) {
    return _repository.insert(extinguisher);
  }

  Future<ExtinguisherModel> update(ExtinguisherModel extinguisher) {
    return _repository.update(extinguisher);
  }

  Future<void> remove(ExtinguisherModel extinguisher) {
    return _repository.delete(extinguisher);
  }
}
