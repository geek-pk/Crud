class Item {
  String? id;
  String? title;
  String? description;
  String? image;
  String? createdAt;

  Item({this.title, this.description, this.image, this.createdAt});

  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    image = json['image'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['createdAt'] = createdAt;
    return data;
  }

  @override
  String toString() {
    return 'Item{id: $id, title: $title, description: $description, image: $image, createdAt: $createdAt}';
  }
}
