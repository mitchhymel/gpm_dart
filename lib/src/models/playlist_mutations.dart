abstract class PlaylistMutation {
  Map<String, dynamic> toJson();

  static Map<String,dynamic> bodyFromMutationList(
      List<PlaylistMutation> mutations) {
    return {
      'mutations': mutations.map((p) => p.toJson())..toList(),
    };
  }

}

class CreatePlaylistMutation  extends PlaylistMutation{
  final String name;
  final String description;
  final bool isPublic;

  CreatePlaylistMutation(this.name, {
    this.description,
    this.isPublic=false
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'create': {
        'name': this.name,
        'deleted': false,
        'creationTimestamp': '-1',
        'lastModifiedTimestamp': '0',
        'type': 'USER_GENERATED',
        'shareState': this.isPublic ? "PUBLIC" : "PRIVATE",
        'description': this.description
      }
    };
  }
}

class UpdatePlaylistMutation extends PlaylistMutation {
  final String playlistId;
  final String name;
  final String description;
  final bool isPublic;

  UpdatePlaylistMutation(this.playlistId, {
    this.name=null,
    this.description=null,
    this.isPublic=null
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'update': {
        'id': this.playlistId,
        'name': this.name == null ? null : this.name,
        'shareState': this.isPublic == null ? null : (this.isPublic ? "PUBLIC" : "PRIVATE"),
        'description': this.description == null ? null : this.description
      }
    };
  }
}

class DeletePlaylistMutation extends PlaylistMutation{
  final String playlistId;
  DeletePlaylistMutation(this.playlistId);

  @override
  Map<String, dynamic> toJson() {
    return {
      'delete': this.playlistId
    };
  }
}
