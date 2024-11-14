import 'package:flutter/material.dart';

class DropdownField extends StatefulWidget {
  final String label;
  final List<String> options;
  final String hintText;

  const DropdownField({
    required this.label,
    required this.options,
    required this.hintText,
    super.key,
  });

  @override
  DropdownFieldState createState() => DropdownFieldState();
}

class DropdownFieldState extends State<DropdownField> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontSize: 18, color:
         Colors.white,),),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          dropdownColor: const Color.fromARGB(255, 10, 167, 219),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.white), 
          ),
          value: selectedOption,
          style: const TextStyle(color: Colors.white), 
          iconEnabledColor: Colors.white,
          items: widget.options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedOption = newValue;
            });
          },
        ),
      ],
    );
  }
}
