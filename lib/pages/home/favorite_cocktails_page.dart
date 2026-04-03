import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import '../../provider/cocktail_list_get.dart';
import '../../widgets/cocktail_list/cocktail_card.dart';
import '../../widgets/custom_arrowback.dart';
import '../../widgets/home/search_bar_widget.dart';

class FavoriteCocktailsPage extends StatelessWidget {
  const FavoriteCocktailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CocktailListBloc(CocktailRepository())
          ..add(const FetchFavoriteCocktails());
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
            child: Column(
              children: [
                CustomAppBar(
                  auth: true,
                  text: tr('favorite_cocktails.title'),
                  // Локализация заголовка
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  secondIcon: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                const CustomSearchBar(
                  isFavorites: true,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<CocktailListBloc, CocktailListState>(
                    builder: (context, state) {
                      Widget content;
                      if (state is CocktailLoading) {
                        return content =
                            Center(child: CircularProgressIndicator());
                      } else if (state is CocktailLoaded) {
                        // Проверяем, есть ли избранные рецепты
                        if (state.cocktails.isEmpty) {
                          return content = Center(
                            child: Text(tr(
                                'favorite_cocktails.no_recipes')), // Локализация текста, если рецептов нет
                          );
                        }
                        return content = RefreshIndicator(
                          onRefresh: () async {
                            context
                                .read<CocktailListBloc>()
                                .add(FetchFavoriteCocktails());
                          },
                          child: ListView.builder(
                            itemCount: state.cocktails.length,
                            itemBuilder: (context, index) {
                              return CocktailCard(
                                cocktail: state.cocktails[index],
                                favoritePage: true,
                              );
                            },
                          ),
                        );
                      } else if (state is CocktailError) {
                        return content = Center(child: Text(state.message));
                      }
                      return Center(
                        child: content = Text(
                            tr('favorite_cocktails.no_recipes'),
                            style: context.text
                                .bodyText16White), // Локализация текста, если рецептов нет
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
