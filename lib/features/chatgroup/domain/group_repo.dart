import '../models/group_model.dart';

abstract class GroupRepo {
  Future<List<GroupModel>> getGroups();
  Future<void> createGroup(
    String name,
    List<String> memberUids,
    String imageUrl,
  );
  Future<void> joinGroup(String groupId, String userId);
}
