import 'package:cocktails/bloc/catalog_filter_bloc/catalog_filter_bloc.dart'
    as filter_bloc;
import 'package:cocktails/bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import 'package:cocktails/bloc/cocktail_setup_bloc/cocktail_setup_bloc.dart'
    as setup_bloc;
import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utilities/language_swich.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final supportedLocales = context.supportedLocales;

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Select Language', style: context.text.bodyText16White).tr(),
      ),
      body: ListView.builder(
        itemCount: supportedLocales.length,
        itemBuilder: (context, index) {
          final locale = supportedLocales[index];
          return ListTile(
            title: Text(
              locale.languageCode.toUpperCase(),
              style: context.text.bodyText16White,
            ),
            onTap: () async {
              context.setLocale(locale);

              String selectedLanguage =
                  locale.languageCode == 'ru' ? 'rus' : 'eng';
              await LanguageService.saveLanguage(selectedLanguage);

              if (!context.mounted) return;

              context.read<AlcoholicCocktailBloc>().add(
                    const FetchCocktails(page: 1, pageSize: 20, alc: true),
                  );
              context.read<NonAlcoholicCocktailBloc>().add(
                    const FetchCocktails(page: 1, pageSize: 20, alc: false),
                  );
              context.read<CocktailListBloc>().add(
                    const FetchCocktails(page: 1, pageSize: 20),
                  );

              context
                  .read<filter_bloc.IngredientSelectionBloc>()
                  .add(filter_bloc.LoadCategoriesEvent());
              context
                  .read<setup_bloc.CocktailSelectionBloc>()
                  .add(setup_bloc.LoadCategoriesEvent());

              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
