import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math';
import '../Widget/button_widget.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String result = '0';
  String userInput = '0';

  bool isExpanded = false; // Track expansion state
  bool showCursor = true;

  void toggleCursor() {
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          showCursor = !showCursor;
        });
        toggleCursor();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    toggleCursor();
  }

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        userInput = '0';
        result = '0';
      } else if (value == '⌫' || value == 'DEL') {
        if (userInput.isNotEmpty && userInput != '0') {
          userInput = userInput.substring(0, userInput.length - 1);
        }
        if (userInput.isEmpty) {
          userInput = '0';
        }
      } else if (value == '=') {
        try {
          String parsedInput = userInput
              .replaceAll('×', '*')
              .replaceAll('÷', '/')
              .replaceAll('π', '${pi}')
              .replaceAll('e', '${e}');

          Parser p = Parser();
          Expression exp = p.parse(parsedInput);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);

          if (eval.isInfinite || eval.isNaN) {
            result = "Error";
          } else {
            result = eval.toString();
          }
        } catch (e) {
          result = "Error";
        }
        userInput = '0';
      } else if (value == 'Expand') {
        isExpanded = !isExpanded; // Toggle expansion
      } else if (value == '√') {
        userInput += 'sqrt(';
      } else if (value == 'x!') {
        try {
          int number = int.parse(userInput);
          userInput = factorial(number).toString();
        } catch (e) {
          result = "Error";
        }
      } else if (value == 'sin^-1') {
        userInput += 'asin(';
      } else if (value == 'cos^-1') {
        userInput += 'acos(';
      } else if (value == 'tan^-1') {
        userInput += 'atan(';
      } else if (value == 'log') {
        userInput += 'log(';
      } else if (value == 'ln') {
        userInput += 'ln(';
      } else if (value == 'x^y') {
        userInput += '^';
      } else {
        if (userInput == '0') {
          userInput = value;
        } else {
          userInput += value;
        }
      }
    });
  }

  int factorial(int n) {
    if (n < 0) return 0; // Factorial is not defined for negative numbers
    if (n == 0 || n == 1) return 1;
    return n * factorial(n - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        children: [
          // ✅ Output (Result) should be at the top
          Expanded(
            flex: isExpanded ? 2 : 1,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5), // Adjust padding
              alignment: Alignment.bottomRight,
              child: Text(
                result,
                style: const TextStyle(
                  fontSize: 45,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            flex: isExpanded ? 5 : 1,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5), // Adjust padding
              alignment: Alignment.bottomRight,
              child: Text(
                userInput + (showCursor ? '|' : ''),
                style: const TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),

          // ✅ Buttons take up more space when expanded
          Expanded(
            flex: isExpanded ? 9 : 2,
            child: GridView.builder(
              padding: EdgeInsets.zero, // Removes extra spacing around buttons
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isExpanded ? 5 : 4,
                childAspectRatio: 1.27,
              ),
              itemCount: isExpanded ? expandedButtons.length : buttons.length,
              itemBuilder: (context, index) {
                String buttonText =
                    isExpanded ? expandedButtons[index] : buttons[index];

                final orangeButtons = {'AC', '⌫', '%', '/', '*', '-', '+', '='};

                return ButtonWidget(
                  text: buttonText,
                  onTap: () => onButtonPressed(buttonText),
                  color: orangeButtons.contains(buttonText)
                      ? Colors.orange
                      : Colors.white,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Default buttons (4 columns × 5 rows)
  final List<String> buttons = [
    'AC', '⌫', '%', '/',
    '7', '8', '9', '*',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    'Expand', '0', '.', '=' // Expand button
  ];

  // Expanded buttons (7 rows × 5 columns)
  final List<String> expandedButtons = [
    '2nd', 'deg', 'sin^-1', 'cos^-1', 'tan^-1',
    'x^y', 'log', 'ln', '(', ')',
    '√', 'AC', '⌫', '%', '/',
    'x!', '7', '8', '9', '*',
    '1/x', '4', '5', '6', '-',
    'π', '1', '2', '3', '+',
    'Expand', 'e', '0', '.', '=' // Expand button remains
  ];
}
