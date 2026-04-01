class DateFormatter {
  String dateFormated(String dataIso) {
    final dt = DateTime.parse(dataIso);

    String doisDigitos(int n) => n.toString().padLeft(2, '0');

    final dia = doisDigitos(dt.day);
    final mes = doisDigitos(dt.month);
    final ano = dt.year;
    final hora = doisDigitos(dt.hour);
    final minuto = doisDigitos(dt.minute);

    return '$dia/$mes/$ano às ${hora}h:${minuto}m';
  }
}
