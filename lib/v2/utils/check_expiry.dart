checkExpiry(DateTime expiresAt) {
  final now = DateTime.now();
  return now.isAfter(expiresAt);
}
