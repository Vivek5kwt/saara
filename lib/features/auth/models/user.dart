class User {
  const User({required this.email, this.name = '', this.isMember = false});

  final String email;
  final String name;
  final bool isMember;
}

