import 'package:flutter_blue_elves/flutter_blue_elves.dart';

class ConnectedItem {
  final Device device;
  final String? macAddress;
  final String? name;

  ConnectedItem(this.device, this.macAddress, this.name);
}