class AppUser {
  String displayName = '';
  String? address = '';
  String phoneNumber = '';
  String email = '';
  String uid = '';
  String? birthDate = '';

  AppUser(
      {required this.displayName,
      this.address,
      required this.phoneNumber,
      required this.email,
      required this.uid,
      this.birthDate});

  AppUser.fromMap(Map<String, dynamic> map) {
    displayName = map['displayName'];
    address = map['address'];
    phoneNumber = map['phoneNumber'];
    email = map['email'];
    uid = map['uid'];
    birthDate = map['birthDate'];
  }

  Map<String,dynamic> toMap()=> {
    'displayName':displayName,
    'address':address,
    'phoneNumber':phoneNumber,
    'email':email,
    'uid':uid,
    'birthDate':birthDate,
  };
}
