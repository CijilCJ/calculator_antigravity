import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'widgets/calculator_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';
  String _result = '0';
  String _expression = '';

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _input = '';
        _result = '0';
        _expression = '';
      } else if (buttonText == '⌫') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (buttonText == '=') {
        _calculateResult();
      } else {
        if (_input == '0' && buttonText != '.') {
          _input = buttonText;
        } else {
          _input += buttonText;
        }
      }
    });
  }

  void _calculateResult() {
    try {
      _expression = _input;
      _expression = _expression.replaceAll('×', '*');
      _expression = _expression.replaceAll('÷', '/');

      Parser p = Parser();
      Expression exp = p.parse(_expression);

      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      
      // Check if result is an integer
      if (eval % 1 == 0) {
        _result = eval.toInt().toString();
      } else {
        _result = eval.toString();
      }
    } catch (e) {
      _result = 'Error';
    }
  }

  Widget _buildButton(String text, {Color? bgColor, Color? textColor}) {
    return Expanded(
      child: CalculatorButton(
        text: text,
        backgroundColor: bgColor ?? const Color(0xFF2D2D2D),
        textColor: textColor ?? Colors.white,
        onPressed: () => _onButtonPressed(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Display Area
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(24.0),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _input,
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.5),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        _result,
                        key: ValueKey<String>(_result),
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: Colors.grey),
            // Keypad Area
            Expanded(
              flex: 4,
              child: Column(
                children: [
                   Expanded(
                    child: Row(
                      children: [
                        _buildButton('C', bgColor: Colors.grey.shade800, textColor: Colors.redAccent),
                        _buildButton('⌫', bgColor: Colors.grey.shade800),
                        _buildButton('%', bgColor: Colors.grey.shade800),
                        _buildButton('÷', bgColor: Colors.orange, textColor: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('7'),
                        _buildButton('8'),
                        _buildButton('9'),
                        _buildButton('×', bgColor: Colors.orange, textColor: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('4'),
                        _buildButton('5'),
                        _buildButton('6'),
                        _buildButton('-', bgColor: Colors.orange, textColor: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('1'),
                        _buildButton('2'),
                        _buildButton('3'),
                        _buildButton('+', bgColor: Colors.orange, textColor: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('.'),
                        _buildButton('0'),
                        _buildButton('00'),
                        _buildButton('=', bgColor: Colors.orange, textColor: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
