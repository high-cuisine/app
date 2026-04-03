import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/coctail_card_widgets/cocktail_instruction_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/cocktail_list_model.dart';

class CocktailInstructionBuilder extends StatefulWidget {
  const CocktailInstructionBuilder({super.key, required this.cocktail});

  final Cocktail cocktail;

  @override
  State<CocktailInstructionBuilder> createState() =>
      _CocktailInstructionBuilderState();
}

class _CocktailInstructionBuilderState
    extends State<CocktailInstructionBuilder> {
  /// Enhanced key detection method to handle multiple instruction key formats
  /// Supports Russian ("Шаг N"), English ("Step N"), and numeric ("N") formats
  String? getInstructionStep(Map<String, String?> instructions, int stepIndex) {
    // Try Russian format first (most common in API)
    String russianKey = "Шаг $stepIndex";
    if (instructions.containsKey(russianKey) &&
        instructions[russianKey]?.isNotEmpty == true) {
      return instructions[russianKey];
    }

    // Try English format
    String englishKey = "Step $stepIndex";
    if (instructions.containsKey(englishKey) &&
        instructions[englishKey]?.isNotEmpty == true) {
      return instructions[englishKey];
    }

    // Try numeric format (legacy support)
    String numericKey = stepIndex.toString();
    if (instructions.containsKey(numericKey) &&
        instructions[numericKey]?.isNotEmpty == true) {
      return instructions[numericKey];
    }

    return null;
  }

  /// Get all valid instruction steps with proper sequencing
  List<MapEntry<int, String>> getValidInstructionSteps() {
    final instructions = widget.cocktail.instruction;
    if (instructions == null || instructions.isEmpty) return [];

    List<MapEntry<int, String>> validSteps = [];

    // Try to get steps sequentially starting from 1
    for (int i = 1; i <= instructions.length + 5; i++) {
      // +5 buffer for non-sequential steps
      final step = getInstructionStep(instructions, i);
      if (step != null && step.isNotEmpty) {
        validSteps.add(MapEntry(i, step));
      } else {
        // Break if we have found some steps and now hit a gap
        if (validSteps.isNotEmpty && i > validSteps.length + 2) {
          break;
        }
      }
    }

    return validSteps;
  }

  @override
  Widget build(BuildContext context) {
    // Get valid instruction steps using enhanced detection
    final instructionSteps = getValidInstructionSteps();
    final hasInstructions = instructionSteps.isNotEmpty;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              tr('cocktail_instructions.title'),
              overflow: TextOverflow.clip,
              style: context.text.bodyText16White.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: 12.0),
          Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10.0)),
            child: hasInstructions
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: instructionSteps.length,
                    itemBuilder: (context, index) {
                      final stepEntry = instructionSteps[index];
                      return CocktailInstructionCard(
                        index: stepEntry.key, // Use actual step number
                        text: stepEntry.value,
                      );
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      tr('cocktail_instructions.no_instructions'),
                      style: context.text.bodyText14White,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
