String getRoomImage(String code) {
  String image;
  switch (code) {
    case 'k':
      image = 'assets/rooms/kitchen.png';
      break;
    case 'lr':
      image = 'assets/rooms/hall.png';
      break;
    case 'g':
      image = 'assets/rooms/garden.png';
      break;
    case 'br':
      image = 'assets/rooms/bathroom.png';
      break;
    case 'b1':
      image = 'assets/rooms/bedroom1.png';
      break;
    case 'b2':
      image = 'assets/rooms/bedroom2.png';
      break;
    case 'b3':
      image = 'assets/rooms/bedroom3.png';
      break;
    default:
      break;
  }
  return image;
}

String getDeviceImage(String code) {
  String image;
  switch (code) {
    case 'tl':
      image = 'assets/devices/tube_light.png';
      break;
    case 'l':
      image = 'assets/devices/lamp.png';
      break;
    case 'sl':
      image = 'assets/devices/smart_light.png';
      break;
    case 'b':
      image = 'assets/devices/bulb.png';
      break;
    case 'sk':
      image = 'assets/devices/socket.png';
      break;
    case 'sp':
      image = 'assets/devices/smart_plug.png';
      break;
    case 'f':
      image = 'assets/devices/fan.png';
      break;
    case 'ac':
      image = 'assets/devices/ac.png';
      break;
    case 'o':
      image = 'assets/devices/oven.png';
      break;
    case 'rf':
      image = 'assets/devices/refrigerator.png';
      break;
    case 'tv':
      image = 'assets/devices/tv.png';
      break;
    case 'wm':
      image = 'assets/devices/washing_machine.png';
      break;
    case 'wh':
      image = 'assets/devices/water_heater.png';
      break;
    default:
      break;
  }
  return image;
}
