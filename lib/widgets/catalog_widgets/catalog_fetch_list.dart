import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import '../../models/cocktail_list_model.dart';
import '../cocktail_list/cocktail_card.dart';

class CatalogFetchList extends StatefulWidget {
  const CatalogFetchList({
    super.key,
    required this.fetchList,
    required this.hasReachedMax,
    this.catalogPage = false,
    this.alcoholPage = false,
  });

  final List<Cocktail> fetchList;
  final bool hasReachedMax;
  final bool catalogPage;
  final bool alcoholPage;

  @override
  State<CatalogFetchList> createState() => _CatalogFetchListState();
}

class _CatalogFetchListState extends State<CatalogFetchList> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    // Добавляем обработчик скролла для подгрузки новых страниц
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _currentPage++;
        // Когда дошли до конца списка и если еще есть данные для загрузки
        if (widget.catalogPage) {
          // В каталоге есть две вкладки: alco/non‑alco.
          // Подгружаем через соответствующий блок и с нужным alc-флагом.
          if (widget.alcoholPage) {
            final bloc = context.read<AlcoholicCocktailBloc>();
            if (bloc.state is CocktailLoaded &&
                !(bloc.state as CocktailLoaded).hasReachedMax) {
              bloc.add(FetchCocktails(page: _currentPage, alc: true));
            }
          } else {
            final bloc = context.read<NonAlcoholicCocktailBloc>();
            if (bloc.state is CocktailLoaded &&
                !(bloc.state as CocktailLoaded).hasReachedMax) {
              bloc.add(FetchCocktails(page: _currentPage, alc: false));
            }
          }
        } else {
          if (!(context.read<CocktailListBloc>().state as CocktailLoaded)
              .hasReachedMax) {
            context
                .read<CocktailListBloc>()
                .add(FetchCocktails(page: _currentPage));
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.hasReachedMax
          ? widget.fetchList.length
          : widget.fetchList.length + 1,
      itemBuilder: (context, index) {
        if (index == widget.fetchList.length) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return CocktailCard(
            catalogPage: widget.catalogPage,
            alcoholPage: widget.alcoholPage,
            cocktail: widget.fetchList[index],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
