import 'package:password_strength/password_strength.dart';

class Config {
  /// The name of the app
  static const String appName = 'Disaster Relief Aid';

  /// The list of languages to choose from when registering
  static final languages = [
    "English",
    "Afrikanns",
    "Albanian",
    "Arabic",
    "Armenian",
    "Basque",
    "Bengali",
    "Bulgarian",
    "Catalan",
    "Cambodian",
    "Chinese (Mandarin)",
    "Croation",
    "Czech",
    "Danish",
    "Dutch",
    "Estonian",
    "Fiji",
    "Finnish",
    "French",
    "Georgian",
    "German",
    "Greek",
    "Gujarati",
    "Hebrew",
    "Hindi",
    "Hungarian",
    "Icelandic",
    "Indonesian",
    "Irish",
    "Italian",
    "Japanese",
    "Javanese",
    "Korean",
    "Latin",
    "Latvian",
    "Lithuanian",
    "Macedonian",
    'Malay',
    "Malayalam",
    "Maltese",
    "Maori",
    "Marathi",
    "Mongolian",
    "Nepali",
    "Norwegian",
    "Persian",
    "Polish",
    "Portuguese",
    "Punjabi",
    "Quechua",
    "Romanian",
    "Russian",
    "Samoan",
    "Serbian",
    "Slovak",
    "Slovenian",
    "Spanish",
    "Swahili",
    "Swedish",
    "Tamil",
    "Tatar",
    "Telugu",
    "Thai",
    "Tibetan",
    "Tonga",
    "Turkish",
    "Ukranian",
    "Urdu",
    "Uzbek",
    "Vietnamese",
    "Welsh",
    "Xhosa"
  ];

  /// The list of vulnerabilities to choose from when registering
  static final vulnerabilities = [
    'Chronic Back Pain',
    'something',
    'something else'
  ];

  static String passwordWeakMessage = "Password is too weak";

  static passwordValidator(String value) {
    /// used when validating passwords
    /// returns null if valid, otherwise returns a string with the error message

    /// all values given are guaranteed to be non-null
    /// the value is guaranteed to be non-empty

    // if (value.length < 8) {
    //   return 'Password must be at least 8 characters';
    // }

    double strength = estimatePasswordStrength(value);
    if (strength < 0.3) {
      return passwordWeakMessage;
    }

    // TODO: add more checks?

    return null;
  }
}
