class User {
  final String fullName;
  final int userID;

  const User({required this.fullName, required this.userID});

  String getFullName() {
    return fullName;
  }

  int getUserID() {
    return userID;
  }

  static const List<User> users = [
    User(fullName: 'John Doe', userID: 1000),
    User(fullName: 'James Smith', userID: 1001),
    User(fullName: 'David Johnson', userID: 1002),
    User(fullName: 'Mariah Yu', userID: 1003),
    User(fullName: 'Sam Hammond', userID: 1004),
    User(fullName: 'Allen Phan', userID: 1005),
    User(fullName: 'Maria Garcia', userID: 1006),
    User(fullName: 'Jeremiah Carson', userID: 1007),
    User(fullName: 'Peter Miller', userID: 1008),
    User(fullName: 'Lucca Burns', userID: 1009),
  ];

  List<User> setUsers() => List<User>.of(users);
}
