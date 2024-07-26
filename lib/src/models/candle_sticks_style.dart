import 'dart:ui';

class CandleSticksStyle {
  final Color borderColor;

  final Color background;

  final Color primaryBull;

  final Color secondaryBull;

  final Color primaryBear;

  final Color secondaryBear;

  final Color hoverIndicatorBackgroundColor;

  final Color mobileCandleHoverColor;

  final Color primaryTextColor;

  final Color secondaryTextColor;

  final Color loadingColor;

  final Color toolBarColor;
  final Color lineColor;


  final Color macdColor ;
  final  Color difColor;
  final Color deaColor;

  final  Color kColor;
  final Color dColor;
  final Color jColor ;
  final Color rsiColor ;


  CandleSticksStyle({
    required this.borderColor,
    required this.background,
    required this.primaryBull,
    required this.secondaryBull,
    required this.primaryBear,
    required this.secondaryBear,
    required this.hoverIndicatorBackgroundColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.mobileCandleHoverColor,
    required this.loadingColor,
    required this.toolBarColor,
    required this.lineColor,
    required this.dColor,
    required this.deaColor,
    required this.difColor,
    required this.jColor,
    required this.kColor,
    required this.macdColor,
    required this.rsiColor
  });

  factory CandleSticksStyle.dark({
    Color? borderColor,
    Color? background,
    Color? primaryBull,
    Color? secondaryBull,
    Color? primaryBear,
    Color? secondaryBear,
    Color? hoverIndicatorBackgroundColor,
    Color? primaryTextColor,
    Color? secondaryTextColor,
    Color? mobileCandleHoverColor,
    Color? loadingColor,
    Color? toolBarColor,
    Color? lineColor,
   Color? macdColor ,
    Color? difColor ,
   Color? deaColor ,

    Color? kColor ,
   Color? dColor ,
   Color? jColor ,
   Color? rsiColor ,
  }) {
    return CandleSticksStyle(
      borderColor: borderColor ?? Color(0xFF848E9C),
      background: background ?? Color(0xFF191B20),
      primaryBull: primaryBull ?? Color(0xFF26A69A),
      secondaryBull: secondaryBull ?? Color(0xFF005940),
      primaryBear: primaryBear ?? Color(0xFFEF5350),
      secondaryBear: secondaryBear ?? Color(0xFF82122B),
      hoverIndicatorBackgroundColor:
          hoverIndicatorBackgroundColor ?? Color(0xFF4C525E),
      primaryTextColor: primaryTextColor ?? Color(0xFF848E9C),
      secondaryTextColor: secondaryTextColor ?? Color(0XFFFFFFFF),
      mobileCandleHoverColor:
          mobileCandleHoverColor ?? Color(0xFFF0B90A).withOpacity(0.2),
      loadingColor: loadingColor ?? Color(0xFFF0B90A),
      toolBarColor: toolBarColor ?? Color(0xFF191B20),
      lineColor: lineColor?? Color(0xFF191B20),
      macdColor:macdColor?? Color(0xffC9B885),
     difColor :difColor?? Color(0xffC9B885),
     deaColor :deaColor?? Color(0xff6CB0A6),

     kColor :kColor?? Color(0xffC9B885),
     dColor :dColor?? Color(0xff6CB0A6),
     jColor :jColor?? Color(0xff9979C6),
     rsiColor :rsiColor?? Color(0xffC9B885),
    );
  }

  factory CandleSticksStyle.light({
    Color? borderColor,
    Color? background,
    Color? primaryBull,
    Color? secondaryBull,
    Color? primaryBear,
    Color? secondaryBear,
    Color? hoverIndicatorBackgroundColor,
    Color? primaryTextColor,
    Color? secondaryTextColor,
    Color? mobileCandleHoverColor,
    Color? loadingColor,
    Color? toolBarColor,
    Color? lineColor,
    Color? macdColor ,
    Color? difColor ,
    Color? deaColor ,

    Color? kColor ,
    Color? dColor ,
    Color? jColor ,
    Color? rsiColor ,
  }) {
    return CandleSticksStyle(
      borderColor: borderColor ?? Color(0xFF848E9C),
      background: background ?? Color(0xFFFAFAFA),
      primaryBull: primaryBull ?? Color(0xFF026A69A),
      secondaryBull: secondaryBull ?? Color(0xFF8CCCC6),
      primaryBear: primaryBear ?? Color(0xFFEF5350),
      secondaryBear: secondaryBear ?? Color(0xFFF1A3A1),
      hoverIndicatorBackgroundColor:
          hoverIndicatorBackgroundColor ?? Color(0xFF131722),
      primaryTextColor: primaryTextColor ?? Color(0XFF000000),
      secondaryTextColor: secondaryTextColor ?? Color(0XFFFFFFFF),
      mobileCandleHoverColor:
          mobileCandleHoverColor ?? Color(0xFFF0B90A).withOpacity(0.2),
      loadingColor: loadingColor ?? Color(0xFFF0B90A),
      toolBarColor: toolBarColor ?? Color(0xFFFAFAFA),
      lineColor: lineColor?? Color(0xFF848E9C),
      macdColor:macdColor?? Color(0xffC9B885),
      difColor :difColor?? Color(0xffC9B885),
      deaColor :deaColor?? Color(0xff6CB0A6),

      kColor :kColor?? Color(0xffC9B885),
      dColor :dColor?? Color(0xff6CB0A6),
      jColor :jColor?? Color(0xff9979C6),
      rsiColor :rsiColor?? Color(0xffC9B885),
    );
  }
}
