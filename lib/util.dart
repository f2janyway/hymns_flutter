import 'package:flutter/material.dart';

import 'arr.dart';

int getCurrentPage(int songNum) {
  String title = indexPairList[songNum]!;
  // debugPrint("getCurrentPage title:$title");
  String fileName = titlePairList[title]!;
  // debugPrint("getCurrentPage filename:$fileName");
  return pageFileNameOrderedList.indexOf(fileName);
}

int? getSongNumFromPage(int current) {
  String fileName = pageFileNameOrderedList[current];
  debugPrint("getSongNumFromPage::fileName:$fileName");
  RegExp findNumberInFileNameRegex = RegExp(r'\d*');
  Iterable<Match> matches = findNumberInFileNameRegex.allMatches(fileName);
  for (Match i in matches) {
    return int.tryParse(i.group(0)!);
  }
  return current;
}
