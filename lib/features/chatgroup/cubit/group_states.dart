part of 'group_cubit.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  final List<GroupModel> groups;

  const GroupLoaded(this.groups);

  @override
  List<Object?> get props => [groups];
}

class GroupError extends GroupState {
  final String message;

  const GroupError(this.message);

  @override
  List<Object?> get props => [message];
}
