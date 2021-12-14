class GuideLink {
  String description;
  String url;

  GuideLink({required this.description, required this.url});

  factory GuideLink.fromMap(Map<String, dynamic> data) {
    return GuideLink(
      description: data['description'],
      url: data['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'url': url,
    };
  }
}
