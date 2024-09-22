import 'package:flutter/material.dart';

class GenderSelectionWidget extends StatefulWidget {
  final Function(Gender) onGenderSelected;

  const GenderSelectionWidget({Key? key, required this.onGenderSelected})
      : super(key: key);
  @override
  _GenderSelectionWidgetState createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  Gender _selectedGender = Gender.male;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildGenderButton(Gender.male),
          SizedBox(width: 20),
          _buildGenderButton(Gender.female),
        ],
      ),
    );
  }

  Widget _buildGenderButton(Gender gender) {
    final isSelected = _selectedGender == gender;

    return GestureDetector(
      onTap: () => setState(() => {
            _selectedGender = gender,
            widget.onGenderSelected(gender)
          }),
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isSelected ? Colors.blue : Colors.grey[300],
        ),
        child: Center(
          child: Text(
            gender == Gender.male ? 'Male' : 'Female',
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

enum Gender { male, female }
