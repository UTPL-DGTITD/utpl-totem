class ValidatorsForm {
  // next three lines makes this class a Singleton
  static final ValidatorsForm _instance = ValidatorsForm._internal();
  ValidatorsForm._internal();
  factory ValidatorsForm() => _instance;

  /// Validate if string [value] has a minimum length of [min]
  /// and maximum length of [max].
  String? validateLength({
    required String? value,
    required int min,
    required int max,
  }) {
    if (value != null) {
      if (value.trim().length < min) {
        return "Min. $min caracteres";
      } else if (value.length > max) {
        return "Máx. $max caracteres";
      }
      return null;
    }
    return "*Campo necesario";
  }

  /// Validates if the [value] is a valid email.
  String? validateEmail(String? value) {
    if (value != null) {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern);
      if (value.isEmpty) {
        return "Campo necesario";
      } else if (!regExp.hasMatch(value)) {
        return "Correo incorrecto";
      } else {
        return null;
      }
    } else {
      return "Campo necesario";
    }
  }

  /// Validates if the trim string [value] has only letters,
  /// minimum length of [min] and maximum length of [max].
  String? validateStringLength(String? value, int min, int max) {
    if (value != null) {
      String pattern = r'(^[a-zA-Z ]*$)';
      RegExp regExp = RegExp(pattern);
      if (value.trim().length < min) {
        return "Min. $min caracteres";
      } else if (value.length > max) {
        return "Máx. $max caracteres";
      } else if (!regExp.hasMatch(value)) {
        return "Sólo se permiten letras";
      }
      return null;
    } else {
      return "Campo necesario";
    }
  }

  /// Validate if [value] is a valid Ecuadorian phone number.
  String? validateMobile(String? value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.trim().isEmpty) {
      return "Campo necesario";
    } else if (value.trim().length != 10) {
      return "Min. 10 dígitos";
    } else if (!regExp.hasMatch(value)) {
      return "Sólo puede contener números";
    }
    return null;
  }

  /// Validate if [password] and [confirmPassword] are equal.
  String? validateMatchPassword(String? password, String? confirmPassword) {
    if (password == null || password.trim().isEmpty) {
      return "Campo necesario";
    } else if (confirmPassword != password) {
      return "Las contraseñas no coinciden";
    } else {
      return null;
    }
  }

  /// Validate if [identify] is a valid Ecuadorian identification number.
  String? validateEcuadorianIdentify(String? identify) {
    if (identify == null || identify.trim().isEmpty) {
      return 'Este campo es necesario';
    } else {
      if (identify.length == 10) {
        int regionDigit = int.tryParse(identify.substring(0, 2)) ?? 0;

        if (regionDigit >= 1 && regionDigit <= 24) {
          int lastDigit = int.tryParse(identify.substring(9, 10)) ?? 0;

          int pairs = (int.tryParse(identify.substring(1, 2)) ?? 0) +
              (int.tryParse(identify.substring(3, 4)) ?? 0) +
              (int.tryParse(identify.substring(5, 6)) ?? 0) +
              (int.tryParse(identify.substring(7, 8)) ?? 0);

          int number1 = int.tryParse(identify.substring(0, 1)) ?? 0;
          number1 = (number1 * 2);
          if (number1 > 9) {
            number1 = (number1 - 9);
          }

          int number3 = (int.tryParse(identify.substring(2, 3)) ?? 0);
          number3 = (number3 * 2);
          if (number3 > 9) {
            number3 = (number3 - 9);
          }

          int number5 = int.tryParse(identify.substring(4, 5)) ?? 0;
          number5 = (number5 * 2);
          if (number5 > 9) {
            number5 = (number5 - 9);
          }

          int number7 = int.tryParse(identify.substring(6, 7)) ?? 0;
          number7 = (number7 * 2);
          if (number7 > 9) {
            number7 = (number7 - 9);
          }

          int number9 = int.tryParse(identify.substring(8, 9)) ?? 0;
          number9 = (number9 * 2);
          if (number9 > 9) {
            number9 = (number9 - 9);
          }

          int oddNumbers = number1 + number3 + number5 + number7 + number9;

          int totalSum = (pairs + oddNumbers);

          String sumFirstDigit = totalSum.toString().substring(0, 1);

          int decena = ((int.tryParse(sumFirstDigit) ?? 0) + 1) * 10;

          int validatorDigit = decena - totalSum;

          if (validatorDigit == 10) validatorDigit = 0;

          if (validatorDigit == lastDigit) {
            return null;
          } else {
            return 'Cédula incorrecta';
          }
        } else {
          return 'Esta cédula no pertenece a ninguna región';
        }
      } else {
        return 'Esta cédula tiene menos de 10 Dígitos';
      }
    }
  }
}
