String formatDate(DateTime date) {
  final monthNames = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final day = date.day.toString();
  final month = monthNames[date.month];
  final year = date.year.toString().substring(2);

  return '$day $month $year';
}
