import "package:cocktails/theme/theme_extensions.dart";
import "package:cocktails/widgets/custom_button.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../bloc/profile_bloc/profile_bloc.dart";
import "../../bloc/promo_bloc/promo_bloc.dart";
import "../../provider/promo_repository.dart";
import "../../widgets/custom_arrowback.dart";

class BonusScreen extends StatefulWidget {
  const BonusScreen({super.key});

  @override
  State<BonusScreen> createState() => _BonusScreenState();
}

class _BonusScreenState extends State<BonusScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PromoBloc(PromoRepository())..add(LoadPromoCodes()),
      child: SafeArea(
        minimum: const EdgeInsets.only(top: 40),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                CustomAppBar(
                  auth: true,
                  text: tr('bonus_screen.title'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 46.0),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    String points = tr('bonus_screen.no_points');

                    if (state is ProfileLoaded) {
                      final profile = state.profileData;
                      final pointsCount =
                          profile['points'] ?? 0; // Количество баллов

                      points = tr('bonus_screen.points',
                          namedArgs: {'points': pointsCount.toString()});
                    }

                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        points,
                        textAlign: TextAlign.center,
                        style: context.text.headline24White
                            .copyWith(fontSize: 40.0),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 45.0),
                // Добавляем BlocBuilder для отображения промокодов
                BlocBuilder<PromoBloc, PromoState>(
                  builder: (context, state) {
                    if (state is PromoLoaded || state is PromoLoadedWithError) {
                      // Определяем список промокодов
                      final promoCodes = state is PromoLoaded
                          ? state.promoCodes
                          : (state as PromoLoadedWithError).promoCodes;

                      return Expanded(
                        child: ListView.builder(
                          itemCount: promoCodes.length,
                          itemBuilder: (context, index) {
                            final promo = promoCodes[index];

                            // Проверяем, если текущее состояние содержит ошибку для этого промокода
                            final bool hasError = state
                                    is PromoLoadedWithError &&
                                (state as PromoLoadedWithError).failedPromoId ==
                                    promo.id;

                            return Card(
                              color: Colors.white.withOpacity(0.06),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      promo.name,
                                      style: context.text.bodyText16White
                                          .copyWith(fontSize: 18.0),
                                    ),
                                    const SizedBox(height: 11.0),
                                    Text(
                                      promo.code != null
                                          ? tr('bonus_screen.purchased')
                                          : tr('bonus_screen.points',
                                              namedArgs: {
                                                  'points':
                                                      promo.cost.toString()
                                                }),
                                      style: context.text.bodyText16White
                                          .copyWith(fontSize: 15),
                                    ),
                                    const SizedBox(height: 11.0),
                                    Text(
                                      promo.description,
                                      style: context.text.bodyText12Grey
                                          .copyWith(fontSize: 15.0),
                                    ),
                                    const SizedBox(height: 11.0),
                                    CustomButton(
                                      text: promo.code != null
                                          ? promo.code!
                                          : tr(
                                              'bonus_screen.redeem_points_button'),
                                      buttonHeight: 50,
                                      single: true,
                                      haveIcon:
                                          promo.code != null ? true : false,
                                      onPressed: () {
                                        if (promo.code != null) {
                                          Clipboard.setData(
                                              ClipboardData(text: promo.code!));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    tr('bonus_screen.copied'))),
                                          );
                                        } else {
                                          context
                                              .read<PromoBloc>()
                                              .add(BuyPromoCode(promo.id));
                                          context
                                              .read<ProfileBloc>()
                                              .add(FetchProfile());
                                        }
                                      },
                                    ),
                                    // Отображаем ошибку, если есть
                                    if (hasError)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          tr('bonus_screen.not_enough_points'),
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is PromoError) {
                      return Center(
                          child: Text(tr("errors.server_error"),
                              style: context.text.bodyText16White));
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//Вручную обновить баллы void onPointsUpdated() {
//   context.read<ProfileBloc>().add(UpdatePoints());
// }
