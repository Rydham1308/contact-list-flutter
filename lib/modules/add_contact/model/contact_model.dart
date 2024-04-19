class ContactModel {
  final String fName;
  final String lName;
  final String number;
  final int id;

  ContactModel({
    required this.fName,
    required this.lName,
    required this.number,
    required this.id,
  });

  ContactModel.fromJson(Map<String, dynamic> json)
      : fName = json['fName'],
        lName = json['lName'],
        number = json['number'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
        "fName": fName,
        "lName": lName,
        "number": number,
        "id": id,
      };
}
