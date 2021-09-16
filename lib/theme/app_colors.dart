import 'package:flutter/painting.dart';

class AppColors {
  AppColors._();

  //basic
  static const Color TRANSPARENT = Color(0x00FFFFFF);
  static const Color TRANSPARENT_LIGHT = Color(0x00FFFFFF);
  static const Color TRANSPARENT_DARK = Color(0x00000000);

  //primary
  static const Color BOUND_100_0 = const Color(0x00FFFFFF);

  static const Color BLACKOUT_700_80 = const Color(0xCC000000);

  static const Color BLACK = const Color(0xFF000000);
  static const Color BLACK_54 = const Color(0x8A000000);
  static const Color BLACK_38 = const Color(0x61000000);
  static const Color BLACK_24 = const Color(0x3D000000);
  static const Color BLACK_16 = const Color(0x29000000);
  static const Color BLACK_8 = const Color(0x14000000);
  static const Color BLACK_54_WO = const Color(0xFF757575);
  static const Color BLACK_38_WO = const Color(0xFF9E9E9E);
  static const Color BLACK_24_WO = const Color(0xFFC2C2C2);
  static const Color BLACK_16_WO = const Color(0xFFD6D6D6);
  static const Color BLACK_8_WO = const Color(0xFFEBEBEB);

  static const Color WHITE = const Color(0xFFFFFFFF);
  static const Color WHITE_54 = const Color(0x8AFFFFFF);
  static const Color WHITE_38 = const Color(0x61FFFFFF);
  static const Color WHITE_24 = const Color(0x3DFFFFFF);
  static const Color WHITE_16 = const Color(0x29FFFFFF);
  static const Color WHITE_8 = const Color(0x14FFFFFF);

  static const Color BLUE_VIOLET_500 = const Color(0xFF773DF3);
  static const Color BLUE_VIOLET_500_54 = const Color(0x8A773DF3);
  static const Color BLUE_VIOLET_500_38 = const Color(0x61773DF3);
  static const Color BLUE_VIOLET_500_24 = const Color(0x3D773DF3);
  static const Color BLUE_VIOLET_500_16 = const Color(0x29773DF3);
  static const Color BLUE_VIOLET_500_8 = const Color(0x14773DF3);
  static const Color BLUE_VIOLET_500_8_WO = const Color(0xFFF5F0FE);
  static const Color BLUE_VIOLET_500_16_WO = const Color(0xFFE9E0FD);
  static const Color BLUE_VIOLET_500_24_WO = const Color(0xFFDFD1FC);
  static const Color BLUE_VIOLET_500_38_WO = const Color(0xFFCBB5FA);
  static const Color BLUE_VIOLET_500_HOVERED = const Color(0xFF6D38E0);
  static const Color BLUE_VIOLET_500_FOCUSED = const Color(0xFF6433CC);
  static const Color BLUE_VIOLET_500_PRESSED = const Color(0xFF5A2EB9);

  static const Color ORANGE_PEEL_500 = const Color(0xFFFFBC0F);
  static const Color ORANGE_PEEL_500_54 = const Color(0x8AFFBC0F);
  static const Color ORANGE_PEEL_500_38 = const Color(0x61FFBC0F);
  static const Color ORANGE_PEEL_500_24 = const Color(0x3DFFBC0F);
  static const Color ORANGE_PEEL_500_16 = const Color(0x29FFBC0F);
  static const Color ORANGE_PEEL_500_8 = const Color(0x14FFBC0F);

  static const Color CYBER_YELLOW_400 = const Color(0xFFFDD000);
  static const Color CYBER_YELLOW_400_54 = const Color(0x8AFDD000);
  static const Color CYBER_YELLOW_400_38 = const Color(0x61FDD000);
  static const Color CYBER_YELLOW_400_24 = const Color(0x3DFDD000);
  static const Color CYBER_YELLOW_400_16 = const Color(0x29FDD000);
  static const Color CYBER_YELLOW_400_8 = const Color(0x14FDD000);

  static const Color SONIC_GRAY_500 = const Color(0xFF666666);
  static const Color SONIC_GRAY_500_54 = const Color(0x8A666666);
  static const Color SONIC_GRAY_500_38 = const Color(0x61666666);
  static const Color SONIC_GRAY_500_24 = const Color(0x3D666666);
  static const Color SONIC_GRAY_500_16 = const Color(0x29666666);
  static const Color SONIC_GRAY_500_8 = const Color(0x14666666);

  //secondary

  static const Color RED_PIGMENT_500 = const Color(0xFFFD3030);
  static const Color RED_PIGMENT_500_54 = const Color(0x8AFD3030);
  static const Color RED_PIGMENT_500_38 = const Color(0x61FD3030);
  static const Color RED_PIGMENT_500_24 = const Color(0x3DFD3030);
  static const Color RED_PIGMENT_500_16 = const Color(0x29FD3030);
  static const Color RED_PIGMENT_500_8 = const Color(0x14FD3030);

  static const Color KELLY_GREEN_500 = const Color(0xFF12B20E);
  static const Color KELLY_GREEN_500_54 = const Color(0x8A12B20E);
  static const Color KELLY_GREEN_500_38 = const Color(0x6112B20E);
  static const Color KELLY_GREEN_500_24 = const Color(0x3D12B20E);
  static const Color KELLY_GREEN_500_16 = const Color(0x2912B20E);
  static const Color KELLY_GREEN_500_8 = const Color(0x1412B20E);

  static const Color COOL_GRAY_500 = const Color(0xFF9296B9);
  static const Color COOL_GRAY_500_54 = const Color(0x8A9296B9);
  static const Color COOL_GRAY_500_38 = const Color(0x619296B9);
  static const Color COOL_GRAY_500_24 = const Color(0x3D9296B9);
  static const Color COOL_GRAY_500_16 = const Color(0x299296B9);
  static const Color COOL_GRAY_500_8 = const Color(0x149296B9);

  static const Color MEDIUM_PURPLE_500 = const Color(0xFFA378FF);
  static const Color MEDIUM_PURPLE_500_54 = const Color(0x8AA378FF);
  static const Color MEDIUM_PURPLE_500_38 = const Color(0x61A378FF);
  static const Color MEDIUM_PURPLE_500_24 = const Color(0x3DA378FF);
  static const Color MEDIUM_PURPLE_500_16 = const Color(0x29A378FF);
  static const Color MEDIUM_PURPLE_500_8 = const Color(0x14A378FF);

  //states

  static const Color HOVER_8 = const Color(0x14000000);
  static const Color FOCUSED_16 = const Color(0x29000000);
  static const Color PRESSED_24 = const Color(0x3D000000);

  // text
  static const Color TEXT_PRIMARY_LIGHT = const Color(0xE0000000);
  static const Color TEXT_PRIMARY_DARK = const Color(0xFFFFFFFF);

  static const Color TEXT_SECONDARY_LIGHT = const Color(0x8A0000000);
  static const Color TEXT_SECONDARY_DARK = const Color(0xB3FFFFFF);

  static const Color TEXT_PLACEHOLDER_LIGHT = const Color(0x61000000);
  static const Color TEXT_PLACEHOLDER_DARK = const Color(0x80FFFFFF);

  static const Color TEXT_DISABLED_LIGHT = const Color(0x3D000000);
  static const Color TEXT_DISABLED_DARK = const Color(0x4DFFFFFF);

// background

  static const Color BACKGROUND_MAIN_LIGHT = WHITE;
  static const Color BACKGROUND_MAIN_DARK = BLACK;

  static const Color BACKGROUND_BUTTON_DISABLED_LIGHT = const Color(0x08000000);

  static const Color BACKGROUND_CARD_COMMON_LIGHT = const Color(0x0F000000);
  static const Color BACKGROUND_CARD_COMMON_DARK = const Color(0x0FFFFFFF);

  static const Color BACKGROUND_TOAST_LIGHT = const Color(0xFF2C2E3D);
  static const Color BACKGROUND_TOAST_DARK = const Color(0xFF2C2E3D);

  // background

  static const Color BORDER_COMMON_UNDERLINED_LIGHT = const Color(0x14000000);
  static const Color BORDER_COMMON_UNDERLINED_DARK = const Color(0x14FFFFFF);

  static const Color BORDER_INPUT_DISABLED_UNDERLINED_LIGHT =
      const Color(0x06000000);
  static const Color BORDER_INPUT_DISABLED_UNDERLINED_DARK =
      const Color(0x06FFFFFF);

//shadow colors

  static const Color COMMON_BUTTON_SHADOW_54_LIGHT = const Color(0x8A6D38E0);

  static const Color SHADOW_54_LIGHT = const Color(0x8A9296B9);
  static const Color SHADOW_24_LIGHT = const Color(0x3D9296B9);
  static const Color SHADOW_16_LIGHT = const Color(0x299296B9);

  static const Color BORDER_INPUT_UNDERLINED_LIGHT =
      BORDER_COMMON_UNDERLINED_LIGHT;
  static const Color BORDER_INPUT_UNDERLINED_DARK =
      BORDER_COMMON_UNDERLINED_DARK;

  // button
  static const Color BUTTON_BACKGROUND_COMMON_LIGHT = BLUE_VIOLET_500;
  static const Color BUTTON_BACKGROUND_COMMON_DARK = BLUE_VIOLET_500;

  static const Color SNACKBAR_BACKGROUND = Color(0xFF2B1657);
  static const Color ACCENT_MAIN = BLUE_VIOLET_500;
}
