import 'dart:html';
import './src/model.dart';
import './src/dom.dart';

void main() {
  final Model model = Model();
  model.mutateHash(window.location.hash);
  DOM.addClickEvents(); //fixme
}
