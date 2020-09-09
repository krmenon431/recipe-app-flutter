class RecipeModel{
  String url;
  String label;
  String image;
  String source;

  RecipeModel({this.label, this.image, this.source, this.url});

  factory RecipeModel.fromMap(Map<String, dynamic> parsedJson){
    return RecipeModel(
      url: parsedJson["url"],
      label: parsedJson["label"],
      image: parsedJson["image"],
      source: parsedJson["source"]
    );
  }

  String toString() {
    String s = "url: $url \n label: $label \n image: $image \n source: $source \n";
    return s;
  }
}