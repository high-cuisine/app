import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/promo_model.dart';
import '../../provider/promo_repository.dart';

part 'promo_event.dart';
part 'promo_state.dart';

class PromoBloc extends Bloc<PromoEvent, PromoState> {
  final PromoRepository promoRepository;

  PromoBloc(this.promoRepository) : super(PromoInitial()) {
    on<LoadPromoCodes>((event, emit) async {
      emit(PromoLoading());
      try {
        final promoCodes = await promoRepository.fetchPromoCodes();
        emit(PromoLoaded(promoCodes));
      } catch (e) {
        emit(PromoError('Failed to load promo codes'));
      }
    });
    on<BuyPromoCode>((event, emit) async {
      final currentState = state;
      if (currentState is PromoLoaded) {
        try {
          // Выполняем запрос на покупку промокода
          final promoCode = await promoRepository.buyPromoCode(event.promoId);

          // Обновляем состояние: заменяем промокод в списке на купленный
          final updatedPromoCodes = currentState.promoCodes.map((promo) {
            if (promo.id == event.promoId) {
              return promo.copyWith(code: promoCode); // Обновляем код
            }
            return promo;
          }).toList();

          emit(PromoLoaded(updatedPromoCodes));
        } catch (e) {
          // В случае ошибки при покупке, добавляем информацию об ошибке
          emit(PromoLoadedWithError(currentState.promoCodes, event.promoId,
              'Недостаточно баллов для покупки промокода'));
        }
      }
    });
  }
}
