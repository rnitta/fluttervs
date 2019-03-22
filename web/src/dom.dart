import 'dart:html';

// actions related to control DOM.
class DOM {
  static final _validator = NodeValidatorBuilder()
    ..allowHtml5(uriPolicy: AllowAllUrlPolicy())
    ..allowElement('a', attributes: ['href', 'target']);

  static void replaceHistory(String opponentName, String path) {
    window.history.replaceState(null, 'Flutter vs $opponentName', path);
  }

  static void startLoading() {
    document.getElementById('app').classes.add('isLoading');
  }

  static void endLoading() {
    document.getElementById('app').classes.remove('isLoading');
  }

  static void mutateCriteriaTitle(String criteria) {
    document.getElementById("criteria-title").text = 'Comparing the number of Github $criteria,';
  }

  static void setSummaryText(int flutterCount, int opponentCount) {
    String text;
    final int diff = flutterCount - opponentCount;
    if (diff > 0) {
      text = '$diff above.';
    } else if (diff == 0) {
      text = 'equal.';
    } else {
      text = '${-diff} to get.';
    }
    document.getElementById("summary").text = text;
  }

  static void mutateCriteriaClass(List<String> criteriaCandidates, String criteria) {
    final elm = document.getElementById('criteria-icon');
    criteriaCandidates.forEach((classStr) {
      elm.classes.remove('i$classStr');
    });
    elm.classes.add('i$criteria');
  }

  static void mutateOpponentName(String name, String repo) {
    document
        .getElementById('header-opponent')
        .setInnerHtml('<a href="https://github.com/${repo}" target="_blank">${name}</a>', validator: _validator);
  }

  static void mutateMyCount(String count) {
    document.getElementById('footer-me').text = count;
  }

  static void mutateOpponentCount(String count) {
    document.getElementById('footer-opponent').text = count;
  }
}

// fixme:
class AllowAllUrlPolicy implements UriPolicy {
  bool allowsUri(String uri) {
    return true;
  }
}
