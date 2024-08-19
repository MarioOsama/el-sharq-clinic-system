part of 'owners_cubit.dart';

abstract class OwnersState {}

final class OwnersInitial extends OwnersState {}

final class OwnersLoading extends OwnersState {}

final class OwnersSuccess extends OwnersState {
  final List<OwnerModel?> owners;

  OwnersSuccess({required this.owners});
}

final class OwnersError extends OwnersState {
  final String errorMessage;

  OwnersError(this.errorMessage);
}

final class OwnersPetsChanged extends OwnersState {
  final int numberOfPets;

  OwnersPetsChanged(this.numberOfPets);
}

// Owner

final class OwnerAdded extends OwnersState {}

final class OwnerUpdated extends OwnersState {}

final class OwnerDeleted extends OwnersState {}
