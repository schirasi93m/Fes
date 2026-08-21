import '../models/extinguishers_model.dart';

abstract class ExtinguisherRepository {
  Future<List<ExtinguisherModel>> getList();

  Future<ExtinguisherModel> insert(ExtinguisherModel extinguisher);

  Future<ExtinguisherModel> update(ExtinguisherModel extinguisher);

  Future<void> delete(ExtinguisherModel extinguisher);
}
