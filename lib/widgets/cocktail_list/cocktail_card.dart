import 'package:cocktails/pages/cocktail_card_page/cocktail_card_screen.dart';
import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../models/cocktail_list_model.dart';

class CocktailCard extends StatelessWidget {
  final bool favoritePage;
  final bool myCocktailPage;
  final bool catalogPage;
  final bool alcoholPage;
  final Cocktail cocktail;

  const CocktailCard({
    super.key,
    required this.cocktail,
    this.favoritePage = false,
    this.myCocktailPage = false,
    this.catalogPage = false,
    this.alcoholPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        int? userId;

        if (profileState is ProfileLoaded) {
          userId = profileState.profileData['id']; // Получаем id пользователя
        }
        return BlocBuilder<CocktailListBloc, CocktailListState>(
          builder: (context, state) {
            bool isLoading = false;
            if (myCocktailPage && state is UserCocktailLoaded) {
              isLoading = state.loadingStates[cocktail.id] ?? false;
            } else if (state is CocktailLoaded) {
              print(
                  "${state.loadingStates[cocktail.id].toString()} CocktailLoaded");
              isLoading = state.loadingStates[cocktail.id] ?? false;
            } else if (state is CocktailSearchLoaded) {
              print(
                  "${state.loadingStates[cocktail.id].toString()} CocktailSearchLoaded");
              isLoading = state.loadingStates[cocktail.id] ?? false;
            }

            return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => CocktailCardScreen(
                      catalogPage: catalogPage,
                      alcoholPage: alcoholPage,
                      cocktail: cocktail,
                      userId: userId,
                      myCocktails: myCocktailPage,
                      favoritePage: favoritePage,
                    ),
                  ),
                )
                    .then((result) {
                  if (result == true) {
                    if (myCocktailPage == true)
                      context
                          .read<CocktailListBloc>()
                          .add(const FetchUserCocktails());
                    if (favoritePage == true)
                      context
                          .read<CocktailListBloc>()
                          .add(const FetchFavoriteCocktails());
                  }
                });
                print(state.toString());
              },
              child: Stack(
                children: [
                  Card(
                    color: const Color(0xff1C1C1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xff343434)),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: cocktail.imageUrl != null &&
                                  cocktail.imageUrl!.isNotEmpty
                              ? Image.network(
                                  cocktail
                                      .imageUrl!, // Сервер уже вернул готовую ссылку!
                                  width: double.infinity,
                                  height: 190,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Container(
                                      width: double.infinity,
                                      height: 190,
                                      color: Colors.grey[800],
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(Colors.white),
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    // Заглушка на случай ошибки загрузки изображения
                                    cocktail.isImageAvailable = false;
                                    print(
                                        'Error loading image for cocktail ${cocktail.id}: $error');
                                    print('Original URL: ${cocktail.imageUrl}');
                                    print('Direct URL: ${cocktail.imageUrl}');

                                    return Container(
                                      width: double.infinity,
                                      height: 190,
                                      color: Colors.grey,
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_not_supported,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Изображение недоступно',
                                            style: TextStyle(
                                                color: Colors.white54),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: double.infinity,
                                  height: 190,
                                  color: Colors.grey,
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(cocktail.name,
                              style: context.text.headline24White
                                  .copyWith(fontSize: 18)),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(12.0),
                        //   child: Text(
                        //     "Не хватает из ${cocktail.ingredients.length} ингредиентов",
                        //     style: context.text.bodyText16White,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  if (userId != null &&
                      userId.toString() != cocktail.user.toString())
                    Positioned(
                      top: 20,
                      right: 20,
                      child: GestureDetector(
                        onTap: isLoading
                            ? null
                            : () async {
                                if (favoritePage == true)
                                  context.read<CocktailListBloc>().add(
                                        ToggleFavoriteCocktail(cocktail.id,
                                            cocktail.isFavorite, favoritePage),
                                      );
                                if (favoritePage == false)
                                  context.read<AlcoholicCocktailBloc>().add(
                                        ToggleFavoriteCocktail(cocktail.id,
                                            cocktail.isFavorite, favoritePage),
                                      );
                                context.read<NonAlcoholicCocktailBloc>().add(
                                      ToggleFavoriteCocktail(cocktail.id,
                                          cocktail.isFavorite, favoritePage),
                                    );
                              },
                        child: isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
                                strokeWidth: 2,
                              )
                            : Icon(
                                cocktail.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: cocktail.isFavorite
                                    ? Colors.red
                                    : Colors.white,
                                size: 30,
                              ),
                      ),
                    ),
                  if (userId != null &&
                      userId.toString() != cocktail.user.toString())
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            vertical: 7.0, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: cocktail.claimed
                              ? Colors.grey.withOpacity(0.3)
                              : const Color(0xFFF6B402),
                        ),
                        child: cocktail.claimed
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff68C248),
                                    ),
                                    child: const Icon(Icons.check,
                                        size: 15, color: Colors.white),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Text(tr("catalog_page.prepared"),
                                      style: context.text.bodyText14White),
                                ],
                              )
                            : Text(
                                tr('bonus_screen.points',
                                    namedArgs: {'points': '15'}),
                                style: context.text.buttonText18Brown
                                    .copyWith(fontSize: 14.0),
                              ),
                      ),
                    ),
                  if (myCocktailPage) // Проверяем, что мы на странице "Мои коктейли"
                    Positioned(
                      top: 20,
                      left: 20,
                      child: _buildModerationStatus(context, cocktail),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModerationStatus(BuildContext context, Cocktail cocktail) {
    // Определяем текст, иконку и цвет обводки в зависимости от статуса модерации
    IconData statusIcon;
    String statusText;
    Color borderColor;

    switch (cocktail.moderationStatus) {
      case "Draft":
        statusIcon = Icons.edit;
        statusText = tr("moderation_status.draft");
        borderColor = Colors.grey;
        break;
      case "Rejected":
        statusIcon = Icons.cancel;
        statusText = tr("moderation_status.rejected");
        borderColor = Colors.red;
        break;
      case "Pending":
        statusIcon = Icons.hourglass_empty;
        statusText = tr("moderation_status.pending");
        borderColor = Colors.orange;
        break;
      case "Approved":
        statusIcon = Icons.check;
        statusText = tr("moderation_status.approved");
        borderColor = Colors.green;
        break;
      default:
        statusIcon = Icons.help_outline;
        statusText = tr("moderation_status.unknown");
        borderColor = Colors.grey;
    }

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.2), // Полупрозрачный фон
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: borderColor, // Цвет иконки
            ),
            child: Icon(statusIcon, size: 15, color: Colors.white),
          ),
          const SizedBox(width: 10.0),
          Text(statusText, style: context.text.bodyText14White),
        ],
      ),
    );
  }
}
