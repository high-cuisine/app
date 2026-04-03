import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../bloc/goods_bloc/goods_bloc.dart';

class GoodsSearchBar extends StatefulWidget {
  final TextEditingController? controller;

  const GoodsSearchBar({super.key, this.controller});

  @override
  _GoodsSearchBarState createState() => _GoodsSearchBarState();
}

class _GoodsSearchBarState extends State<GoodsSearchBar> {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _showRecordingDialog();

      _speech.listen(onResult: (result) {
        setState(() {
          widget.controller?.text = result.recognizedWords;
        });
        _onSearchChanged(result.recognizedWords);
      }).then((_) => _closeRecordingDialog());
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
    _closeRecordingDialog();
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      context.read<GoodsBloc>().add(SearchGoods(query: query));
    } else {
      context.read<GoodsBloc>().add(FetchGoods());
    }
  }

  void _showRecordingDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          content: Row(
            children: [
              Icon(Icons.mic, color: Colors.red, size: 30),
              const SizedBox(width: 10),
              Text(
                tr("search.recording"), // Локализованная строка для "Запись"
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      if (_isListening) _stopListening();
    });
  }

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
                // Локализованная строка для "Поиск"
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
