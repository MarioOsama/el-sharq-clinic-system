part of 'owners_cubit.dart';

abstract class OwnersState {}

final class OwnersInitial extends OwnersState {}

final class OwnersPetsChanged extends OwnersState {
  final int numberOfPets;

  OwnersPetsChanged(this.numberOfPets);
}
