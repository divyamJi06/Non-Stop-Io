class Places {
  late String country;
  late String name;
  late String wikipediaLink;
  late String googleMapsLink;
  late int id;
  late String asciiName;
  late String state;
  late String countryDigraph;

  Places(
      {required this.country,
      required this.name,
      required this.wikipediaLink,
      required this.googleMapsLink,
      required this.id,
      required this.asciiName,
      required this.state,
      required this.countryDigraph});

  Places.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    name = json['name'];
    wikipediaLink = json['wikipediaLink'];
    googleMapsLink = json['googleMapsLink'];
    id = json['id'];
    asciiName = json['asciiName'];
    state = json['state'];
    countryDigraph = json['countryDigraph'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    data['name'] = name;
    data['wikipediaLink'] = wikipediaLink;
    data['googleMapsLink'] = googleMapsLink;
    data['id'] = id;
    data['asciiName'] = asciiName;
    data['state'] = state;
    data['countryDigraph'] = countryDigraph;
    return data;
  }
}
