import 'package:cocktails/pages/home/popups/cocktail_filter_pop_up.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import '../../bloc/cocktail_setup_bloc/cocktail_setup_bloc.dart';
import '../../provider/cocktail_list_get.dart';
import '../../widgets/catalog_widgets/catalog_fetch_list.dart';
import '../../widgets/catalog_widgets/catalog_search_list.dart';
import '../../widgets/cocktail_list/selected_items_carousel_widget.dart';
import '../../widgets/custom_arrowback.dart';

class SearchCocktailPage extends StatefulWidget {
  const SearchCocktailPage({super.key});

  @override
  SearchCocktailPageState createState() => SearchCocktailPageState();
}

class SearchCocktailPageState extends State<SearchCocktailPage> {
  late CocktailListBloc cocktailListBloc;

  /// Centralized search logic to avoid code duplication
  void _triggerSearch(List<int> ingredientIds) {
    cocktailListBloc.add(SearchCocktails(
      ingredients: ingredientIds.isNotEmpty ? ingredientIds.join(',') : null,
      // Remove otherIngredients parameter to prevent overly restrictive filtering
    ));
  }

  @override
  void initState() {
    super.initState();
    cocktailListBloc = CocktailListBloc(CocktailRepository());

    final cocktailSelectionBloc =
        BlocProvider.of<CocktailSelectionBloc>(context);

    // Check current state immediately upon initialization
    final currentSelectedIds = cocktailSelectionBloc.getSelectedIngredientIds();
    if (currentSelectedIds.isNotEmpty) {
      _triggerSearch(currentSelectedIds);
    }

    cocktailSelectionBloc.stream.listen((selectionState) {
      // Get ALL selected ingredients as unified group (no step separation)
      final allSelectedIngredientIds =
          cocktailSelectionBloc.getSelectedIngredientIds();

      _triggerSearch(allSelectedIngredientIds);
    });
  }

  @override
  void dispose() {
    cocktailListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cocktailListBloc,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
            child: Column(
              children: [
                BlocBuilder<CocktailListBloc, CocktailListState>(
                  builder: (context, state) {
                    String titleText = "0 ${tr('cocktail_selection.recipes')}";

                    if (state is CocktailSearchLoaded) {
                      final count = state.count;
                      titleText = "$count ${tr('cocktail_selection.recipes')}";
                    }
                    return CustomAppBar(
                      text: titleText,
                      onPressed: null,
                      secondIcon: true,
                      onSecondIconTap: () {
                        cocktailFilterPopUp(context);
                      },
                    );
                  },
                ),
                const SizedBox(height: 6),
                const SelectedItemsCarousel(),
                const SizedBox(height: 6),
                Expanded(
                  child: BlocBuilder<CocktailListBloc, CocktailListState>(
                      builder: (context, state) {
                    if (state is CocktailLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CocktailLoaded) {
                      return CatalogFetchList(
                          fetchList: state.cocktails,
                          hasReachedMax: state.hasReachedMax);
                    } else if (state is CocktailSearchLoaded) {
                      return CatalogSearchList(
                        catalogPage: true,
                        searchList: state.cocktails,
                        hasReachedMax: state.hasReachedMax,
                        query: '',
                        searchPage: false,
                      );
                    } else if (state is CocktailError) {
                      return Center(
                        child: Text(tr('errors.server_error')),
                      );
                    }
                    return Center(
                      child: Text(tr('catalog_page.start_search')),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
