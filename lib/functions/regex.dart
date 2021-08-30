String getRegexMatch(String originalText, String ex) {
  RegExp regExp = RegExp(ex);
  return regExp.stringMatch(originalText);
}

bool isRegexMatched(String originalText, String ex) {
  RegExp regExp = RegExp(ex);
  return regExp.hasMatch(originalText);
}
