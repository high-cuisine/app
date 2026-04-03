import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/store_model.dart';
import '../../provider/store_repository.dart';

part 'goods_event.dart';
part 'goods_state.dart';

class GoodsBloc extends Bloc<GoodsEvent, GoodsState> {
  final GoodsRepository repository;

  GoodsBloc(this.repository) : super(GoodsInitial()) {
    on<FetchGoods>((event, emit) async {
      emit(GoodsLoading());
      try {
        final response = await repository.fetchGoods();
        emit(GoodsLoaded(goods: response.goods, next: response.next));
      } catch (e) {
        emit(GoodsError('Failed to load goods: $e'));
      }
    });

    on<FetchMoreGoods>((event, emit) async {
      if (state is GoodsLoaded) {
        final currentState = state as GoodsLoaded;
        // Если нет ссылки на следующую страницу, выходим
        if (currentState.next == null) return;
        try {
          final response = await repository.fetchGoods(url: currentState.next);
          emit(GoodsLoaded(
            goods: currentState.goods + response.goods,
            next: response.next,
          ));
        } catch (e) {
          emit(GoodsError('Failed to load more goods: $e'));
        }
      }
    });

    on<SearchGoods>((event, emit) async {
      emit(GoodsLoading());
      try {
        final response = await repository.searchGoods(event.query);
        emit(GoodsLoaded(goods: response.goods, next: response.next));
      } catch (e) {
        emit(GoodsError('Failed to search goods: $e'));
      }
    });
  }
}
