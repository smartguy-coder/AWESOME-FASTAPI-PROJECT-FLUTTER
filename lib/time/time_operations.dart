bool isTimeExpired(targetTime) {
  try {
    if (targetTime is DateTime) {
      DateTime currentTime = DateTime.now();
      return currentTime.isAfter(targetTime);
    }
    return false;
  } catch (e) {
    return false;
  }
}

DateTime calculateRefreshTokenExpireTime({required int number}) {
  DateTime dateTimeNow = DateTime.now().toUtc();
  return dateTimeNow.add(Duration(seconds: number));
}
