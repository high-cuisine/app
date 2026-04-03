part of 'goods_bloc.dart';

abstract class GoodsEvent extends Equatable {
  const GoodsEvent();

  @override
  List<Object?> get props => [];
}

class FetchGoods extends GoodsEvent {}

class FetchMoreGoods extends GoodsEvent {}

class SearchGoods extends GoodsEvent {
  final String query;

  const SearchGoods({required this.query});

  @override
  List<Object?> get props => [query];
}
