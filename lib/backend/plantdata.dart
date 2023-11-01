class Data {
  int? id;
  String? commonName;
  String? slug;
  String? scientificName;
  int? year;
  String? bibliography;
  String? author;
  String? status;
  String? rank;
  String? familyCommonName;
  int? genusId;
  String? imageUrl;
  List<String>? synonyms;
  String? genus;
  String? family;

  Data({
    this.id,
    this.commonName,
    this.slug,
    this.scientificName,
    this.year,
    this.bibliography,
    this.author,
    this.status,
    this.rank,
    this.familyCommonName,
    this.genusId,
    this.imageUrl,
    this.synonyms,
    this.genus,
    this.family,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commonName = json['common_name'];
    slug = json['slug'];
    scientificName = json['scientific_name'];
    year = json['year'];
    bibliography = json['bibliography'];
    author = json['author'];
    status = json['status'];
    rank = json['rank'];
    familyCommonName = json['family_common_name'];
    genusId = json['genus_id'];
    imageUrl = json['image_url'];
    genus = json['genus'];
    family = json['family'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['common_name'] = commonName;
    data['slug'] = slug;
    data['scientific_name'] = scientificName;
    data['year'] = year;
    data['bibliography'] = bibliography;
    data['author'] = author;
    data['status'] = status;
    data['rank'] = rank;
    data['family_common_name'] = familyCommonName;
    data['genus_id'] = genusId;
    data['image_url'] = imageUrl;
    data['synonyms'] = synonyms;
    data['genus'] = genus;
    data['family'] = family;

    return data;
  }
}
