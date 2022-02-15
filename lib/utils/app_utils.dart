import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Muestra un cuadro de confirmacion con el [mensaje] suministrado
Future<bool> confirmaraviso(BuildContext context, String mensaje,
    {String? btnok, String? btncancel}) async {
  var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmacion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text(mensaje)],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(btncancel ?? 'Cancelar'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text(btnok ?? 'Aceptar'),
              onPressed: () => Navigator.pop(context, true),
            )
          ],
        );
      });
  return result;
}

/// Muestra un cuadro de informacion con el [mensaje] suministrado
mensaje(BuildContext context, String mensaje,
    {String? title, String? buttontext}) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5.0,
          title: Text(title ?? 'Mensaje'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text(mensaje)],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(buttontext ?? "ACEPTAR"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      });
}

Future<double> numericInputDialog(
    BuildContext buildContext, String title, double defaultvalue) async {
  final valueController = TextEditingController(text: defaultvalue.toString());
  final result = await showDialog<double>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          elevation: 5.0,
          title: Text(title),
          content: TextField(
            controller: valueController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(hintText: 'Digite el valor'),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(
                      context, double.tryParse(valueController.text) ?? 0);
                },
                child: const Text('Aceptar'))
          ],
        );
      });
  return result ?? 0;
}

Future<String> memoInputDialog(BuildContext buildContext, String title) async {
  final valueController = TextEditingController(text: '');
  final result = await showDialog<String>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          elevation: 5.0,
          title: Text(title),
          content: TextField(
            controller: valueController,
            maxLines: 2,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(hintText: 'Escriba un texto'),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(
              width: 20.0,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, valueController.text);
                },
                child: const Text('Aceptar'))
          ],
        );
      });
  return result ?? '';
}

/*Future<bool> haveconnection(String url) async {
  try {
    var uri = Uri.parse(url);
    final result = await InternetAddress.lookup(uri.host);
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
}*/

/// Devuelvo [len] cantidad de caracteres hacia la derecha de [value] suministrado
String right(String value, int len) {
  return value.substring(value.length - len);
}

/// Convierte [date] a String en el formato yyyy-MM-dd
String dtos(DateTime date) {
  var format = DateFormat("yyyy/MM/dd");
  return format.format(date);
}

/// Convierte [date] a String en el formato dd-MM-yyyy
String dtos2(DateTime date) {
  var format = DateFormat("dd-MM-yyyy");
  return format.format(date);
}

/// Convierte [date] a String en el formato hh:mm a
String dtost(DateTime date) {
  var format = DateFormat("hh:mm a");
  return format.format(date);
}

/// Convierte un string [fecha] a fecha, el string suministrado debe tener formato yyyy-MM-dd
DateTime stod(String fecha) {
  var format = DateFormat("yyyy-MM-dd");
  return format.parse(fecha);
}

/// Convierte un string [fecha] a fecha, el string suministrado debe tener formato dd-MM-yyyy
DateTime stod2(String fecha) {
  var format = DateFormat("dd-MM-yyyy");
  return format.parse(fecha);
}

/// Convierte un munero [value] a un string con el formato ###,###,##0.00
String ntos(double value) {
  NumberFormat _numberFormat = NumberFormat("###,###,##0.00");
  return _numberFormat.format(value);
}

class SelectedListItem<T> {
  bool isSelected = false;
  T data;
  SelectedListItem(this.data);
}
