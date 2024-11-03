import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';

class BluetoothService {

  ValueNotifier<bool> isConnectedNotifier = ValueNotifier<bool>(false);
  
   void connect() {
    isConnectedNotifier.value = true;
  }

  void disconnect() {
    isConnectedNotifier.value = false;
  }

  BluetoothDevice? _device;

  BluetoothDevice? get device => _device;

  void setDevice(BluetoothDevice device) {
    _device = device;
    connect();
  }
}
