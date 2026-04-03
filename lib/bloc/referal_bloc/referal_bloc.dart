import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../provider/profile_repository.dart';

part 'referal_event.dart';
part 'referal_state.dart';

class ReferralBloc extends Bloc<ReferralEvent, ReferralState> {
  final ProfileRepository repository;

  ReferralBloc(this.repository) : super(ReferralInitial()) {
    on<FetchReferralCode>(_onFetchReferralCode);
  }

  Future<void> _onFetchReferralCode(
      FetchReferralCode event, Emitter<ReferralState> emit) async {
    try {
      final referralCode = await repository.fetchReferralCode();
      emit(ReferralCodeLoaded(referralCode)); // Передаем код в состояние
    } catch (e) {
      emit(ReferralError('Failed to fetch referral code: ${e.toString()}'));
    }
  }
}
