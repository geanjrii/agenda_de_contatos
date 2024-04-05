mixin ValidationsMixin {
  String? isNotEmpty(String? value, [String? message]) {
    if (value!.isEmpty) {
      return message ?? 'Este campo é obrigatorio';
    } else {
      return null;
    }
  }

  String? contains(String? value, [String? message]) {
    if (value!.contains('@')) {
      return null;
    } else {
      return message ?? 'Preencha o E-mail utilizando @';
    }
  }

  String? hasFiveChars(String? value, [String? message]) {
    if (value!.length < 5) {
      return message ?? 'Você deve usar pelo menos 5 caracteres';
    } else {
      return null;
    }
  }

  String? isNumeric(String? value, [String? message]) {
    if (value == null || value == '') {
      value = '0';
    }
    if (double.tryParse(value) == null) {
      return message ?? 'Este campo deve conter somente números';
    } else {
      return null;
    }
  }

  String? combine(List<String? Function()> validators) {
    for (final func in validators) {
      final validation = func();
      if (validation != null) {
        return validation;
      }
    }
    return null;
  }
}
