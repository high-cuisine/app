import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/create_cocktail_bloc/create_cocktail_bloc.dart';
import '../../../models/create_cocktail_model.dart';

class NewStepsView extends StatelessWidget {
  const NewStepsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BlocBuilder будет отслеживать изменения состояния шагов
        BlocBuilder<CocktailCreationBloc, CocktailCreationState>(
          builder: (context, state) {
            final steps = state.steps;

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: StepItem(
                      stepNumber: step.number,
                      stepText: step.description,
                      canRemove: steps.length > 1 && index > 0,
                      onRemove: () {
                        // Генерируем событие удаления шага
                        context.read<CocktailCreationBloc>().add(
                              RemoveStepEvent(step.number),
                            );
                      },
                      onTextChanged: (newText) {
                        // Генерируем событие обновления шага
                        context.read<CocktailCreationBloc>().add(
                              UpdateStepEvent(RecipeStep(
                                  number: step.number, description: newText)),
                            );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        // Кнопка добавления нового шага
        BlocBuilder<CocktailCreationBloc, CocktailCreationState>(
          builder: (context, state) {
            if (state.steps.length < 10) {
              return Center(
                child: IntrinsicWidth(
                  child: GestureDetector(
                    onTap: () {
                      // Генерируем событие добавления нового шага
                      context.read<CocktailCreationBloc>().add(
                            AddStepEvent(RecipeStep(
                              number: state.steps.length + 1,
                              description: '',
                            )),
                          );
                    },
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 23.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: const BoxDecoration(
                                color: Color(0xff68C248),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Добавить шаг',
                              style: context.text.bodyText14White.copyWith(
                                  color: const Color(0xff68C248), fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox
                  .shrink(); // Не отображаем кнопку, если шагов больше 10
            }
          },
        ),
      ],
    );
  }
}

class StepItem extends StatelessWidget {
  final int stepNumber;
  final String stepText;
  final bool canRemove; // To control whether the remove button is visible
  final VoidCallback onRemove;
  final ValueChanged<String> onTextChanged;

  const StepItem({
    required this.stepNumber,
    required this.stepText,
    required this.canRemove,
    required this.onRemove,
    required this.onTextChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Шаг $stepNumber',
                style: context.text.bodyText16White.copyWith(fontSize: 18),
              ),
              if (canRemove) // Показываем кнопку удаления только если шаг можно удалить
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF343434), width: 1),
          ),
          child: TextFormField(
            initialValue: stepText,
            maxLines: 3,
            style: context.text.bodyText16White,
            onChanged: onTextChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.all(8),
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
