import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/create_cocktail_bloc/create_cocktail_bloc.dart';
import '../../../../widgets/base_pop_up.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/home/create_cocktail_widgets/new_steps_view.dart';

class NewStepsPage extends StatefulWidget {
  const NewStepsPage({super.key});

  @override
  NewStepsPageState createState() => NewStepsPageState();
}

class NewStepsPageState extends State<NewStepsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: tr("new_recipe.steps"),
      onPressed: null,
      arrow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Отображаем ингредиенты
          BlocBuilder<CocktailCreationBloc, CocktailCreationState>(
            builder: (context, state) {
              return NewStepsView();
            },
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: CustomButton(
                    text: tr("buttons.cancel"),
                    grey: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    single: false,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: CustomButton(
                    text: tr("buttons.confirm"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    single: false,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
