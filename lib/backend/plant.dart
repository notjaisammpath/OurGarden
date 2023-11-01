import 'package:ourgarden/backend/plantdata.dart';

class Plant {
  List<Data> data = [];

  Plant({required this.data});

  @override
  String toString() {
    return "${data[0].commonName}";
  }

  Plant.fromJson(Map<String, dynamic> jsonData) {
    data.add(Data.fromJson(jsonData));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data.map((v) => v.toJson()).toList();
//
    return data;
  }
}
