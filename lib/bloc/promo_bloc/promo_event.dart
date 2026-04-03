part of 'promo_bloc.dart';

@immutable
abstract class PromoEvent {}

class LoadPromoCodes extends PromoEvent {}

class BuyPromoCode extends PromoEvent {
  final int promoId;

  BuyPromoCode(this.promoId);
}
