class RulesTexts {
  final String tooltipText;
  final String appBarTitle;
  final String gameDescription;
  final String section1Title;
  final String section2Title;
  final String section1Text;
  final String section2Text;
  final String section3Title;
  final String section3Text;
  final String bombSmallLabel;
  final String bombLargeLabel;

  const RulesTexts({
    required this.tooltipText,
    required this.appBarTitle,
    required this.gameDescription,
    required this.section1Title,
    required this.section2Title,
    required this.section1Text,
    required this.section2Text,
    required this.section3Title,
    required this.section3Text,
    required this.bombSmallLabel,
    required this.bombLargeLabel,
  });
}

const ruText = RulesTexts(
  tooltipText: 'Русский',
  appBarTitle: "Falling Fusion (правила)",
  gameDescription:
      "Аркадная 2D-головоломка, объединяющая механику Тетриса и 2048",
  section1Title: "1. Цель игры",
  section2Title: "2. Тройное слияние",
  section1Text:
      "Соединяйте блоки с одинаковыми значениями, чтобы "
      "получить легендарный блок 2048. Каждое удачное "
      "слияние делает число сильнее!",
  section2Text:
      "Поставьте три одинаковых блока в один ряд - и в центре "
      "появится блок на 2 порядка выше.\n"
      "Мощный способ ускорить процесс!",
  section3Title: "3. Бомбы",
  section3Text:
      "Бомбы разрушают блоки вокруг себя.\nРадиус маленькой бомбы - 1, "
      "большой - 2 блока вокруг себя.\n"
      "Не забывай: бомбы активируются со временем!",
  bombSmallLabel: "Малая",
  bombLargeLabel: "Большая",
);

const enText = RulesTexts(
  tooltipText: 'English',
  appBarTitle: "Falling Fusion (rules)",
  gameDescription:
      "An arcade 2D puzzle game combining the mechanics of Tetris and 2048",
  section1Title: "1. Objective",
  section2Title: "2. Triple Fusion",
  section1Text:
      "Connect blocks with the same values to "
      "get the legendary block 2048. Each successful "
      "merge makes the number stronger!",
  section2Text:
      "Put three identical blocks in one row - and in the center "
      "a block will appear 2 order of magnitude higher.\n"
      "A powerful way to speed up the process!",
  section3Title: "3. Bombs",
  section3Text:
      "Bombs destroy the blocks around them.\nThe radius of a small bomb is 1, "
      "a large one has 2 blocks around it.\n"
      "Don't forget: bombs activate over time!",
  bombSmallLabel: "Small",
  bombLargeLabel: "Large",
);
