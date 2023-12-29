String getEmoji(int condition) {
  String emoji = "";
  print(condition.toString()[0]);
  switch (int.parse(condition.toString()[0])) {
    case 2 || 3 || 5:
      emoji = '☂️';
      break;
    case 6:
      emoji = '🧥';
      break;
    case 7:
      emoji = '🥽';
      break;
    case 8:
      emoji = '🕶️';
      break;

    default:
      emoji = '';
  }

  return emoji;
}
