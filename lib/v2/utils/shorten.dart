String shorten(String input, int nr) {
  if (input.length > nr) {
    return '${input.substring(0, nr)}...';
  }
  return input;
}
