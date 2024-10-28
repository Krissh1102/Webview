import 'package:flutter_riverpod/flutter_riverpod.dart';


final urlProvider = StateProvider<String>((ref) => 'https://flutter.dev');


final loadingStateProvider = StateProvider<bool>((ref) => true);
