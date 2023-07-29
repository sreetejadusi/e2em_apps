String? getDeviceName(String code) {
  String? name;
  switch (code) {
    case 'tl':
      name = 'Tube Light';
      break;
    case 'l':
      name = 'Lamp';
      break;
    case 'sl':
      name = 'Smart Light';
      break;
    case 'b':
      name = 'Bulb';
      break;
    case 'sk':
      name = 'Socket';
      break;
    case 'sp':
      name = 'Smart Plug';
      break;
    case 'f':
      name = 'FAN';
      break;
    case 'ac':
      name = 'Air Conditioner';
      break;
    case 'o':
      name = 'Oven';
      break;
    case 'rf':
      name = 'Refrigerator';
      break;
    case 'tv':
      name = 'TV';
      break;
    case 'wm':
      name = 'WasHing Machine';
      break;
    case 'wh':
      name = 'Water Heater';
      break;
    default:
      break;
  }
  return name;
}
