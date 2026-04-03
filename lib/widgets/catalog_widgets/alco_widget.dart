import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import 'catalog_fetch_list.dart';
import 'catalog_search_list.dart';

class AlcoholicCocktailsView extends StatelessWidget {
  const AlcoholicCocktailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CocktailListBloc, CocktailListState>(
      builder: (context, state) {
        if (state is CocktailLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CocktailLoaded) {
          return CatalogFetchList(
            fetchList: state.cocktails,
            hasReachedMax: state.hasReachedMax,
          );
        } else if (state is CocktailSearchLoaded) {
          return CatalogSearchList(
            searchList: state.cocktails,
            hasReachedMax: state.hasReachedMax,
            query: '', // либо передавайте текущий query
            searchPage: true,
          );
        } else if (state is CocktailError) {
          return Center(child: Text(tr('errors.server_error')));
        }
        return Center(child: Text(tr('catalog_page.start_search')));
      },
    );
  }
}

class NonAlcoholicCocktailsView extends StatelessWidget {
  const NonAlcoholicCocktailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CocktailListBloc, CocktailListState>(
      builder: (context, state) {
        if (state is CocktailLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CocktailLoaded) {
          return CatalogFetchList(
            fetchList: state.cocktails,
            hasReachedMax: state.hasReachedMax,
          );
        } else if (state is CocktailSearchLoaded) {
          return CatalogSearchList(
            searchList: state.cocktails,
            hasReachedMax: state.hasReachedMax,
            query: '', // либо передавайте текущий query
            searchPage: true,
          );
        } else if (state is CocktailError) {
          return Center(child: Text(tr('errors.server_error')));
        }
        return Center(child: Text(tr('catalog_page.start_search')));
      },
    );
  }
}
