import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class PhoneFieldLocalizationImplPl extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplPl([String locale = 'pl']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Nieprawidłowy numer telefonu';

  @override
  String get invalidCountry => 'Nieprawidłowy kraj';

  @override
  String get invalidMobilePhoneNumber =>
      'Nieprawidłowy numer telefonu komórkowego';

  @override
  String get invalidFixedLinePhoneNumber =>
      'Nieprawidłowy numer telefonu stacjonarnego';

  @override
  String get requiredPhoneNumber => 'Wymagany numer telefonu';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Wybierz kraj. Obecny wybór: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Numer telefonu';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Obecna wartość: $currentValue';
  }
}
