import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../bloc/avatar_cubit/avatar_cubit.dart';

class ProfileAvatar extends StatelessWidget {
  final double radius;

  const ProfileAvatar({super.key, this.radius = 55});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileImageCubit, String?>(
      builder: (context, imagePath) {
        return Container(
          width: radius * 2,
          height: radius * 2,
          decoration: const BoxDecoration(
            color: Color(0xff343434),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: imagePath != null
                ? Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    width: radius * 2,
                    height: radius * 2,
                  )
                : Padding(
                    padding: EdgeInsets.all(radius * 0.5), // Отступы для SVG
                    child: SvgPicture.asset(
                      'assets/images/default_avatar.svg',
                      width: radius * 0.5, // Размер SVG
                      height: radius * 0.5,
                      fit: BoxFit.contain,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
