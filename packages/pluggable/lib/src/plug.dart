
import 'package:flutter/cupertino.dart';

abstract class Plug<T extends Plug<T>> {
  Future<Plug> init();
  Future<Plug> dispose();
}