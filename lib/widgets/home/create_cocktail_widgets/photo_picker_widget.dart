import 'dart:io';

import 'package:cocktails/widgets/home/create_cocktail_widgets/solid_add_photo_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../bloc/create_cocktail_bloc/create_cocktail_bloc.dart';

class PhotoPickerWidget extends StatelessWidget {
  const PhotoPickerWidget({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File file = File(image.path);
      // Отправляем фото в блок
      context.read<CocktailCreationBloc>().add(UpdatePhotoEvent(file));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CocktailCreationBloc, CocktailCreationState>(
      builder: (context, state) {
        if (state.photo != null) {
          return GestureDetector(
            onTap: () => _pickImage(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                state.photo!,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
          );
        }

        return SolidAddPhotoButton(
          onTap: () => _pickImage(context),
        );
      },
    );
  }
}
