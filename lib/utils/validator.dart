class Validator {
  static String mailValidator(String text) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(text))
      return 'Inserta un email valido';
    else
      return null;
  }

  static String passValidator(String value) {
    if (value.length == 0)
      return 'Campo requerido';
    else
      return null;
  }
}
