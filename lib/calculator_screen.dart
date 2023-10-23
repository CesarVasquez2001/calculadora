import 'package:calculadora/button_values.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String equation = "0"; // La expresión matemática actual
  String result = "0"; // El resultado de la evaluación
  String expression = ""; // La expresión que se evaluará
  double equationFontSize = 28.0; // Tamaño de fuente para la expresión
  double resultFontSize = 38.0; // Tamaño de fuente para el resultado

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Pantalla de operación
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    equation,
                    style: TextStyle(
                      fontSize: equationFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            // Resultado
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(16),
              child: Text(
                result,
                style: TextStyle(
                  fontSize: resultFontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.end,
              ),
            ),

            // Botones
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : (screenSize.width / 4),
                      height: (screenSize.width / 5),
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Construye los botones
  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.zero,
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Función llamada cuando se toca un botón
  void onBtnTap(String value) {
    setState(() {
      if (value == Btn.clr) {
        // Limpiar todo
        equation = "0";
        result = "0";
        equationFontSize = 28.0;
        resultFontSize = 38.0;
      } else if (value == Btn.del) {
        // Eliminar último carácter
        equationFontSize = 38.0;
        resultFontSize = 28.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (value == Btn.calculate) {
        // Calcular el resultado
        equationFontSize = 28.0;
        resultFontSize = 38.0;

        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = "Error";
        }
      } else {
        // Agregar valor a la expresión
        equationFontSize = 38.0;
        resultFontSize = 28.0;
        if (equation == "0") {
          equation = value;
        } else {
          equation = equation + value;
        }
      }
    });
  }

  // Obtiene el color del botón
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.redAccent
        : [
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
          ].contains(value)
            ? Colors.orange
            : Colors.lightBlue;
  }
}
