class AppExceptions implements Exception {
  static const Map<String, String> errors = {
    "EMAIL_EXISTS": "E-MAIL JÁ EXISTENTE!",
    "OPERATION_NOT_ALLOWED": "OPERAÇÃO NÃO PERMITIDA!",
    "TOO_MANY_ATTEMPTS_TRY_LATER": "TENTE MAIS TARDE!",
    "EMAIL_NOT_FOUND": "E-MAIL NÃO ENCONTRADO!",
    "INVALID_PASSWORD": "SENHA INVALIDA!",
    "USER_DISABLED": "USUÁRIO DESABILITADO!"
  };

  final String key;

  const AppExceptions(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key] as String;
    } else {
      return 'Ocorreu um erro na autenticação';
    }
  }
}
