import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart' show Factory;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CocktailCardSlider extends StatefulWidget {
  final List<String> imageUrls;
  /// Legacy S3 object key (prepended with [_s3BaseUrl]).
  final String? videoAvsKey;
  final String? videoUrl;
  /// Uploaded recipe video (absolute URL from API `video_file_url`).
  final String? videoFileUrl;
  final bool isImageAvailable;

  const CocktailCardSlider({
    super.key,
    required this.imageUrls,
    this.videoAvsKey,
    this.videoUrl,
    this.videoFileUrl,
    this.isImageAvailable = true,
  });

  @override
  State<CocktailCardSlider> createState() => _CocktailCardSliderState();
}

class _CocktailCardSliderState extends State<CocktailCardSlider> {
  static const _s3BaseUrl =
      'https://cocktails-video-bucket.s3.eu-central-1.amazonaws.com/';

  VideoPlayerController? _videoController;
  String? _youtubeVideoId;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _bindMediaFromWidget();
  }

  @override
  void didUpdateWidget(CocktailCardSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoFileUrl == oldWidget.videoFileUrl &&
        widget.videoUrl == oldWidget.videoUrl &&
        widget.videoAvsKey == oldWidget.videoAvsKey) {
      return;
    }
    _bindMediaFromWidget();
    setState(() {});
  }

  void _bindMediaFromWidget() {
    _videoController?.dispose();
    _videoController = null;
    _youtubeVideoId = null;

    final fileUrl = widget.videoFileUrl?.trim();
    final url = widget.videoUrl?.trim();
    final legacyKey = widget.videoAvsKey?.trim();

    if (fileUrl != null && fileUrl.isNotEmpty) {
      _initNetworkVideoUri(_resolvePlaybackUri(fileUrl));
    } else if (url != null && url.isNotEmpty) {
      if (_isYouTubeUrl(url)) {
        final videoId = _extractYouTubeVideoId(url);
        if (videoId != null && videoId.isNotEmpty) {
          _youtubeVideoId = videoId;
          debugPrint('YouTube video ID: $videoId');
        } else {
          debugPrint(
              'Failed to extract YouTube video ID from URL: ${widget.videoUrl}');
        }
      } else {
        _initNetworkVideoUri(_resolvePlaybackUri(url));
      }
    } else if (legacyKey != null && legacyKey.isNotEmpty) {
      _initNetworkVideoUri(Uri.parse('$_s3BaseUrl$legacyKey'));
    }
  }

  Uri _resolvePlaybackUri(String raw) {
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return Uri.parse(raw);
    }
    return Uri.parse('$_s3BaseUrl$raw');
  }

  void _initNetworkVideoUri(Uri videoUri) {
    try {
      debugPrint('Initializing video player with URL: $videoUri');
      _videoController = VideoPlayerController.networkUrl(videoUri)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
          }
        }).catchError((error) {
          debugPrint('Video initialization error: $error');
        });
    } catch (e) {
      debugPrint('Error creating video controller: $e');
    }
  }

  Future<void> _openYoutubeExternally() async {
    final url = widget.videoUrl?.trim();
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(content: Text('Не удалось открыть ссылку')),
        );
      }
    } catch (e, st) {
      debugPrint('launchUrl YouTube: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }
  }

  bool _isYouTubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  /// Same patterns as former `YoutubePlayer.convertUrlToId` plus query `v` / shorts.
  String? _extractYouTubeVideoId(String url) {
    final trimmed = url.trim();
    for (final exp in [
      RegExp(
          r'^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11})'),
      RegExp(
          r'^https:\/\/(?:music\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11})'),
      RegExp(
          r'^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11})'),
      RegExp(
          r'^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11})'),
      RegExp(r'^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11})'),
    ]) {
      final m = exp.firstMatch(trimmed);
      if (m != null && m.groupCount >= 1) return m.group(1);
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null) return null;
    if (uri.host.contains('youtube.com')) {
      if (uri.queryParameters.containsKey('v')) {
        return uri.queryParameters['v'];
      }
      if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == 'shorts') {
        return uri.pathSegments[1];
      }
    }
    if (uri.host.contains('youtu.be') && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.first;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> mediaWidgets = [];

    debugPrint('=== CocktailCardSlider Debug Info ===');
    debugPrint('ImageUrls count: ${widget.imageUrls.length}');
    debugPrint('VideoFileUrl: ${widget.videoFileUrl}');
    debugPrint('VideoUrl: ${widget.videoUrl}');
    debugPrint('YouTube video id: $_youtubeVideoId');
    debugPrint('VideoController initialized: ${_videoController != null}');

    if (widget.imageUrls.isNotEmpty) {
      for (final url in widget.imageUrls) {
        mediaWidgets.add(
          Image.network(
            url,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey[800],
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: Colors.white,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Error loading image: $error');
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported,
                      color: Colors.white,
                      size: 50,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Изображение недоступно',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }
    }

    if (_videoController != null && _videoController!.value.isInitialized) {
      mediaWidgets.add(GestureDetector(
        onTap: () {
          if (_videoController == null ||
              !_videoController!.value.isInitialized) {
            return;
          }
          _videoController!.value.isPlaying
              ? _videoController!.pause()
              : _videoController!.play();
          setState(() {});
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
            CircleAvatar(
              backgroundColor: Colors.black54,
              radius: 30,
              child: Icon(
                _videoController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ));
    }

    if (_youtubeVideoId != null && _youtubeVideoId!.isNotEmpty) {
      mediaWidgets.add(
        LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;
            final maxH = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : MediaQuery.sizeOf(context).height * 0.4;
            final h = (w * 9 / 16).clamp(180.0, maxH);
            return ColoredBox(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: w,
                    height: h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: _RecipeYoutubeWebView(
                        key: ValueKey<String>(_youtubeVideoId!),
                        videoId: _youtubeVideoId!,
                      ),
                    ),
                  ),
                  if (widget.videoUrl != null &&
                      widget.videoUrl!.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: TextButton.icon(
                        onPressed: _openYoutubeExternally,
                        icon: const Icon(Icons.open_in_new,
                            color: Colors.white70, size: 20),
                        label: const Text(
                          'Открыть в YouTube',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      );
    }

    debugPrint('⚡️ mediaWidgets.length = ${mediaWidgets.length}');

    if (mediaWidgets.isEmpty) {
      return const ColoredBox(
        color: Color(0xFF1C1C1E),
        child: Center(
          child: Icon(Icons.local_bar, color: Colors.white24, size: 48),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: CarouselSlider.builder(
            itemCount: mediaWidgets.length,
            itemBuilder: (ctx, idx, real) => SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: mediaWidgets[idx],
            ),
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              onPageChanged: (i, _) {
                setState(() => _current = i);
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              mediaWidgets.length,
              (i) => Container(
                    width: 8,
                    height: 8,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _current ? Colors.white : Colors.grey,
                    ),
                  )),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}

/// Встроенный YouTube через стандартный WebView: стабильнее InAppWebView внутри Sliver + карусели.
class _RecipeYoutubeWebView extends StatefulWidget {
  const _RecipeYoutubeWebView({super.key, required this.videoId});

  final String videoId;

  @override
  State<_RecipeYoutubeWebView> createState() => _RecipeYoutubeWebViewState();
}

class _RecipeYoutubeWebViewState extends State<_RecipeYoutubeWebView> {
  late final WebViewController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    final embedUri = Uri.https(
      'www.youtube-nocookie.com',
      '/embed/${widget.videoId}',
      const {
        'playsinline': '1',
        'rel': '0',
      },
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError e) {
            if (mounted) {
              setState(() => _error = e.description);
            }
            debugPrint('YouTube WebView error: ${e.description}');
          },
        ),
      )
      ..loadRequest(embedUri);
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ),
      );
    }

    return WebViewWidget(
      controller: _controller,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(EagerGestureRecognizer.new),
      },
    );
  }
}
