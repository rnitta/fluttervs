import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './dom.dart';

class Model with Decorator {
  static const List<String> criteriaCandidates = ['stargazers', 'forks', 'watchers'];
  static const Map<String, String> opponentCandidates = {
    'facebook/react-native': 'React Native',
    'appcelerator/titanium_mobile': 'Titanium Mobile',
    'ionic-team/ionic': 'Ionic'
  };
  static const githuRepoApiUri = 'https://api.github.com/repos';
  final flutterApiUri = '$githuRepoApiUri/flutter/flutter';
  String hash;
  String criteria;
  String opponentRepo;
  String opponentApiUri;
  int opponentCount;
  int flutterCount;

  // singleton (necessary?)
  static final Model _model = Model._();

  Model._();

  factory Model() {
    return _model;
  }

  void mutateHash(String newHash) {
    if (newHash == null || newHash == '') {
      hash = '#';
    } else {
      hash = newHash;
    }
    reload();
  }

  void reload() async {
    DOM.startLoading();
    criteria = _parseCriteria();
    opponentRepo = _parseOpponent();
    opponentApiUri = '$githuRepoApiUri/$opponentRepo';
    DOM.mutateOpponentName(_opponentName(), opponentRepo);
    DOM.mutateCriteriaClass(criteriaCandidates, criteria);
    DOM.mutateCriteriaTitle(criteria);
    await Future.wait([_fetchCount(opponentApiUri), _fetchCount(flutterApiUri)]).then((results) {
      opponentCount = results[0];
      flutterCount = results[1];
    });
    DOM.setSummaryText(flutterCount, opponentCount);
    DOM.mutateMyCount(formattedFlutterCount());
    DOM.mutateOpponentCount(formattedOpponentCount());
    // todo
    DOM.endLoading();
  }

  // API access
  // returns nullable int
  Future<int> _fetchCount(String uri) async {
    // for debug (regarding API limit
    await Future.delayed(Duration(seconds: 1));
    return 4000;
    // for debug (regarding API limit

    final http.Response res = await http.get(uri);
    var json = jsonDecode(res.body);
    final parsed = json['${criteria}_count'];
    if (parsed is int) {
      return parsed;
    } else {
      return null;
    }
  }

  // Split "#criteria.opponent" and return criteria if it is expected, otherwise return "stargazers"
  String _parseCriteria() {
    final List<String> splitted = hash.substring(1).split('.');
    if (criteriaCandidates.indexOf(splitted[0]) > -1) {
      return splitted[0];
    } else {
      return criteriaCandidates[0];
    }
  }

  // Split "#criteria.opponent" and return opponent if it is expected, otherwise return "facebook/react-native"
  String _parseOpponent() {
    final List<String> splitted = hash.split('.');
    if (splitted.length == 2 && opponentCandidates[splitted[1]] != null) {
      return splitted[1];
    } else {
      return 'facebook/react-native';
    }
  }

  // returns opponent fw's name
  //todo: memonize _parseOpponent
  String _opponentName() {
    return opponentCandidates[_parseOpponent()];
  }
}

// decorate model members
mixin Decorator {
  int opponentCount;
  int flutterCount;

  String formattedOpponentCount() => _toLocaleString(opponentCount);

  String formattedFlutterCount() => _toLocaleString(flutterCount);

  // return formatted string like "000,000,000" or "Error"
  String _toLocaleString(int count) {
    if (count == null) {
      return 'Error';
    }
    return count.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}
