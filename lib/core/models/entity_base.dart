import '../enums/entity_state.dart';

abstract class EntityBase {
  final EntityState entityState;

  const EntityBase({
    this.entityState = EntityState.unchanged,
  });
}