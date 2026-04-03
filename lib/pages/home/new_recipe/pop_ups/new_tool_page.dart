import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../widgets/base_pop_up.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/home/create_cocktail_widgets/new_tool_veiw.dart';

class NewToolPage extends StatefulWidget {
  const NewToolPage({super.key});

  @override
  NewToolPageState createState() => NewToolPageState();
}

class NewToolPageState extends State<NewToolPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: tr("new_recipe.tools"),
      onPressed: null,
      arrow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Отображаем ингредиенты
          const NewToolView(),
          SizedBox(
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
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
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
