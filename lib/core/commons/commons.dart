
import 'package:flutter/material.dart';


void navigate({required BuildContext context, required Widget screen}) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
}
class Config {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
}

