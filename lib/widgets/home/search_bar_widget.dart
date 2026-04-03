import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../bloc/cocktail_list_bloc/cocktail_list_bloc.dart';

class CustomSearchBar extends StatefulWidget {
  final bool isFavorites;
  final TextEditingController? controller;
  final bool userRecipes;

  const CustomSearchBar({
    super.key,
    this.isFavorites = false,
    this.controller,
    this.userRecipes = false,
  });

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  Timer? _inactivityTimer;
  Timer? _searchDebouncer; // Добавляем debouncer для поиска

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel(); // Сбрасываем текущий таймер
    _inactivityTimer = Timer(const Duration(seconds: 2), () {
      // Закрываем окно после 2 секунд бездействия
      if (_isListening) {
        _stopListening();
      }
    });
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel(); // Очищаем таймер при удалении виджета
    _searchDebouncer?.cancel(); // Очищаем debouncer
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _startListening() async {
    final locale = EasyLocalization.of(context)?.locale.languageCode ??
        'en'; // Язык локализации
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _showRecordingDialog();

      _speech
          .listen(
            localeId: locale,
            // Используем локализацию приложения
            onResult: (result) {
              setState(() {
                widget.controller?.text = result.recognizedWords;
              });
              _performSearch(result.recognizedWords);
            },
            listenFor: const Duration(seconds: 10),
            // Максимальное время прослушивания
            onSoundLevelChange: (level) {
              _resetInactivityTimer(); // Сбрасываем таймер при активности
            },
          )
          .then((_) => _closeRecordingDialog());
    }
  }

  void _stopListening() {
    _speech.stop();
    _inactivityTimer?.cancel(); // Останавливаем таймер
    setState(() => _isListening = false);
    _closeRecordingDialog();
  }

  void _onSearchChanged(String query) {
    // Отменяем предыдущий таймер если есть
    _searchDebouncer?.cancel();

    // Устанавливаем новый таймер на 500ms
    _searchDebouncer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      if (widget.isFavorites) {
        context.read<CocktailListBloc>().add(
              SearchFavoriteCocktails(
                query: query,
                page: 1,
                pageSize: 50,
              ),
            );
      } else if (widget.userRecipes) {
        context.read<CocktailListBloc>().add(
              FetchUserCocktails(
                query: query,
                page: 1,
                pageSize: 50,
              ),
            );
      } else {
        // Если не для избранного и не для рецептов пользователя — ищем сразу в обоих bloc-ах:
        context.read<AlcoholicCocktailBloc>().add(
              SearchCocktails(
                query: query,
                page: 1,
                pageSize: 20,
                alc: true,
              ),
            );
        context.read<NonAlcoholicCocktailBloc>().add(
              SearchCocktails(
                query: query,
                page: 1,
                pageSize: 20,
                alc: false,
              ),
            );
      }
    } else {
      if (widget.isFavorites) {
        context.read<CocktailListBloc>().add(const FetchFavoriteCocktails());
      } else if (widget.userRecipes) {
        context.read<CocktailListBloc>().add(const FetchUserCocktails());
      } else {
        // Если поле пустое — сбрасываем поиск для обоих bloc-ов:
        context.read<AlcoholicCocktailBloc>().add(
              const FetchCocktails(page: 1, pageSize: 20, alc: true),
            );
        context.read<NonAlcoholicCocktailBloc>().add(
              const FetchCocktails(page: 1, pageSize: 20, alc: false),
            );
      }
    }
  }

  // Метод для показа диалога записи
  void _showRecordingDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // Разрешить закрытие по нажатию вне диалога
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          content: Row(
            children: [
              const Icon(Icons.mic, color: Colors.red, size: 30),
              const SizedBox(width: 10),
              Text(
                tr("search.recording"),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // Убедимся, что запись остановлена, если диалог закрыт вручную
      if (_isListening) _stopListening();
    });
  }

  // Метод для закрытия диалога записи
  void _closeRecordingDialog() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white54),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: tr('search.search'),
                hintStyle: const TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: _onSearchChanged,
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/microphone_icon.svg',
              color: Colors.white54,
              width: 24,
              height: 24,
            ),
            onPressed: _isListening ? _stopListening : _startListening,
          ),
        ],
      ),
    );
  }
}
