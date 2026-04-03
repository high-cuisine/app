import 'package:easy_localization/easy_localization.dart';

String localizedText(String key,
    {List<String>? args, Map<String, String>? namedArgs}) {
  return key.tr(args: args, namedArgs: namedArgs);
}
