//@dart=2.9
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

class AppSlider extends StatefulWidget {
  AppSlider(
      {Key key,
      this.focusNode,
      this.autofocus = false,
      this.value = 0,
      this.min = 0.0,
      this.max = 1.0,
      this.onChanged,
      this.onChangeStart,
      this.onChangeEnd,
      this.divisions})
      : assert(value != null && min != null && max != null),
        super(key: key);

  final FocusNode focusNode;
  final bool autofocus;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;
  final double value;
  final double min;
  final double max;
  final int divisions;

  @override
  _AppSliderState createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.TRANSPARENT,
      child: SliderTheme(
        data: SliderThemeData(
          thumbColor: AppColors.ACCENT_MAIN,
          activeTickMarkColor: AppColors.BLUE_VIOLET_500_8_WO,
          inactiveTickMarkColor: AppColors.BLUE_VIOLET_500_38_WO,
          disabledThumbColor: AppColors.BLACK_24_WO,
          disabledActiveTrackColor: AppColors.BLACK_24_WO,
          disabledInactiveTrackColor: AppColors.BLACK_8_WO,
          activeTrackColor: AppColors.ACCENT_MAIN,
          inactiveTrackColor: AppColors.BLUE_VIOLET_500_8_WO,
          disabledActiveTickMarkColor: AppColors.BLACK_8_WO,
          disabledInactiveTickMarkColor: AppColors.BLACK_24_WO,
          overlayColor: AppColors.BLUE_VIOLET_500_16,
          tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 2),
        ),
        child: Slider(
          focusNode: widget.focusNode ?? FocusNode(),
          autofocus: widget.autofocus,
          value: widget.value,
          onChanged: widget.onChanged,
          onChangeStart: widget.onChangeStart,
          onChangeEnd: widget.onChangeEnd,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
        ),
      ),
    );
  }
}

class AppRangeSlider extends StatefulWidget {
  AppRangeSlider(
      {Key key,
      @required this.values,
      this.min = 0.0,
      this.max = 1.0,
      this.onChanged,
      this.onChangeStart,
      this.onChangeEnd,
      this.divisions})
      : assert(values != null && min != null && max != null),
        super(key: key);

  final ValueChanged<RangeValues> onChanged;
  final ValueChanged<RangeValues> onChangeStart;
  final ValueChanged<RangeValues> onChangeEnd;

  final RangeValues values;
  final double min;
  final double max;
  final int divisions;

  @override
  _AppRangeSliderState createState() => _AppRangeSliderState();
}

class _AppRangeSliderState extends State<AppRangeSlider> {
  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        thumbColor: AppColors.ACCENT_MAIN,
        activeTickMarkColor: AppColors.BLUE_VIOLET_500_8_WO,
        inactiveTickMarkColor: AppColors.BLUE_VIOLET_500_38_WO,
        disabledThumbColor: AppColors.BLACK_24_WO,
        disabledActiveTrackColor: AppColors.BLACK_24_WO,
        disabledInactiveTrackColor: AppColors.BLACK_8_WO,
        activeTrackColor: AppColors.ACCENT_MAIN,
        inactiveTrackColor: AppColors.BLUE_VIOLET_500_8_WO,
        disabledActiveTickMarkColor: AppColors.BLACK_8_WO,
        disabledInactiveTickMarkColor: AppColors.BLACK_24_WO,
        overlayColor: AppColors.BLUE_VIOLET_500_16,
        rangeTickMarkShape: RoundRangeSliderTickMarkShape(tickMarkRadius: 2),
      ),
      child: RangeSlider(
        values: widget.values,
        onChanged: widget.onChanged,
        onChangeStart: widget.onChangeStart,
        onChangeEnd: widget.onChangeEnd,
        min: widget.min,
        max: widget.max,
        divisions: widget.divisions,
      ),
    );
  }
}
