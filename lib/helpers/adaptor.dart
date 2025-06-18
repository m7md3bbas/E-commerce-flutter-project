class NameAdaptor {
  final String fullName;
  NameAdaptor({required this.fullName});
  String get firstName => fullName.split(' ')[0];
  String get lastName => fullName.split(' ')[1];
}
