class TeamPairing {
  List matches = [];

  List allPossiblePairing(matchList) {
    for (var i = 0; i < matchList.length; i++) {
      String initialTeam = matchList[i];
      for (var j = 0; j < matchList.length; j++) {
        if (matchList[j] != initialTeam) {
          matches.add([initialTeam, matchList[j]]);
        }
      }
    }
    return removeDuplicatePairing(matches);
  }

  List removeDuplicatePairing(matches) {
    for (var i = 0; i < matches.length; i++) {
      int initialIndex = i;
      var firstElement = matches[i][0];
      var secElement = matches[i][1];
      for (var j = 0; j < matches.length; j++) {
        if (initialIndex == j) {
          continue;
        } else {
          if ((firstElement == matches[j][0] && secElement == matches[j][1]) ||
              (firstElement == matches[j][1] && secElement == matches[j][0])) {
            matches.removeAt(j);
          }
        }
      }
    }
    return matches;
  }
}
