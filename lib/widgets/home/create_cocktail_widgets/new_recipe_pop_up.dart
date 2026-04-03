import 'package:cocktails/pages/home/new_recipe/pop_ups/new_alco_page.dart';
import 'package:flutter/material.dart';

import '../../../pages/home/new_recipe/pop_ups/new_non_alco_page.dart';
import '../../../pages/home/new_recipe/pop_ups/new_product_page.dart';
import '../../../pages/home/new_recipe/pop_ups/new_steps_page.dart';
import '../../../pages/home/new_recipe/pop_ups/new_tool_page.dart';

void openIngredientModal(BuildContext context, Widget ingredientPage) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85, // Limit height
        ),
        child: SingleChildScrollView(
          child: ingredientPage,
        ),
      );
    },
  );
}

void openAlcoholicModal(BuildContext context) {
  openIngredientModal(context, const NewRecipeAlcoholicPage());
}

void openNonAlcoholicModal(BuildContext context) {
  openIngredientModal(context, const NewRecipeNonAlcoholicPage());
}

// Открытие продуктов
void openProductModal(BuildContext context) {
  openIngredientModal(context, const NewRecipeProductPage());
}

void openToolModal(BuildContext context) {
  openIngredientModal(context, const NewToolPage());
}

void openStepsModal(BuildContext context) {
  openIngredientModal(context, const NewStepsPage());
}
