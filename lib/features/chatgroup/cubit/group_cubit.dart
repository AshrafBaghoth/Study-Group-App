import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../domain/group_repo.dart';
import '../models/group_model.dart';

part 'group_states.dart';

class GroupCubit extends Cubit<GroupState> {
  final GroupRepo repo;

  List<GroupModel> _allGroups = [];

  GroupCubit(this.repo) : super(GroupLoading());

  Future<void> loadGroups() async {
    try {
      emit(GroupLoading());
      final groups = await repo.getGroups();
      _allGroups = groups;
      emit(GroupLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> createGroup(
    String name,
    List<String> memberUids,
    String imageUrl,
  ) async {
    emit(GroupLoading());
    try {
      await repo.createGroup(name, memberUids, imageUrl);
      await loadGroups();
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> joinGroup(String groupId, String userId) async {
    try {
      await repo.joinGroup(groupId, userId);
      await loadGroups();
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> refreshGroups() async {
    try {
      final groups = await repo.getGroups();
      _allGroups = groups;
      emit(GroupLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  void searchGroups(String query) {
    if (state is! GroupLoaded) return;
    if (query.isEmpty) {
      emit(GroupLoaded(_allGroups));
      return;
    }
    final filtered = _allGroups
        .where(
          (g) =>
              g.name.toLowerCase().contains(query.toLowerCase()) ||
              (g.description?.toLowerCase().contains(query.toLowerCase()) ??
                  false),
        )
        .toList();
    emit(GroupLoaded(filtered));
  }
}
