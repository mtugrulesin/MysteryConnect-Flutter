import 'package:flutter/material.dart';

class RangeWidget extends StatefulWidget {
  const RangeWidget({super.key});

  @override
  State<RangeWidget> createState() => _RangeWidgetState();
}

class _RangeWidgetState extends State<RangeWidget> {
  RangeValues _currentRangeValues = const RangeValues(18, 50);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SliderTheme(data: SliderThemeData(
          
            valueIndicatorColor: Colors.blue,
            disabledThumbColor: Colors.black,
            // valueIndicatorTextStyle: TextStyle(color: valueIndicatorColor, fontWeight: FontWeight.bold),
            valueIndicatorTextStyle: TextStyle(color:  Colors.white, fontWeight: FontWeight.bold)
        ), child: RangeSlider(
          values: _currentRangeValues,
          min: 18,
          max: 50,
                  activeColor: Colors.blue,
                  overlayColor: MaterialStateProperty.all(Colors.amber),
                  inactiveColor: Colors.lightBlueAccent,
          divisions: 32,
          labels: RangeLabels(
            _currentRangeValues.start.round().toString(),
            _currentRangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        ))
      ],
    );
  }
}
