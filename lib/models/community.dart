class Community{
  Community({
    required this.image,
    required this.about,
    required this.communityName,
    required this.createdAt,
    required this.communityID,
    required this.members,
    required this.admin,
    required this.pushToken,
  });
  late String image;
  late String about;
  late String communityName;
  late String createdAt;
  late String communityID;
  late List members;
  late String admin;
  late String pushToken;

  Community.fromJson(Map<String, dynamic> json){
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    communityName = json['community_Name'] ?? '';
    createdAt = json['created_at'] ?? '';
    communityID = json['community_ID'] ?? '';
    members = json['members'] ?? '';
    admin = json['admin'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson(){
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['community_Name'] = communityName;
    data['created_at'] = createdAt;
    data['community_ID'] = communityID;
    data['members'] = members;
    data['admin'] = admin;
    data['push_token'] = pushToken;
    return data;
  }

}