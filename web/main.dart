import 'dart:html';
import './src/model.dart';

void main() {
  final Model model = Model();
  model.mutateHash(window.location.hash);
}
