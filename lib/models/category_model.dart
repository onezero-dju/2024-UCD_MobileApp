class Category{
  final int category_Id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final int channelId;

  Category({
    required this.category_Id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.channelId,
  });

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      category_Id: json['category_id'],
     createdAt: DateTime.parse(json['created_at']), 
     updatedAt: DateTime.parse(json['updated_at']),
      name: json['name'], 
      channelId: json['channel_id']);
  }


  Map<String, dynamic> toJson(){
    return {
      'category_id': category_Id,
      'created_at': createdAt,
      'updated_at':updatedAt,
      'name': name,
      'channel_id': channelId,
    };
  }
}