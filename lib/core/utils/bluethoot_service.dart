import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';

class BluetoothService {
  BluetoothDevice? _device;

  BluetoothDevice? get device => _device;

  void setDevice(BluetoothDevice device) {
    _device = device;
  }
}
