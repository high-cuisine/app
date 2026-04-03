import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CocktailCardSlider extends StatefulWidget {
  final List<String> imageUrls;
  final String? videoAvsKey;
  final String? videoUrl;
  final bool isImageAvailable;

  const CocktailCardSlider({
    super.key,
    required this.imageUrls,
    this.videoAvsKey,
    this.videoUrl,
    this.isImageAvailable = true,
  });

  @override
  State<CocktailCardSlider> createState() => _CocktailCardSliderState();
}

class _CocktailCardSliderState extends State<CocktailCardSlider> {
  static const _s3BaseUrl =
      'https://cocktails-video-bucket.s3.eu-central-1.amazonaws.com/';

  VideoPlayerController?
      _videoController; // Made nullable to avoid late initialization error
  YoutubePlayerController? _youtubeController;
  int _current = 0;

  @override
  void initState() {
    super.initState();

    if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
      // Check if the video URL is a YouTube URL
      if (_isYouTubeUrl(widget.videoUrl!)) {
        final videoId = _extractYouTubeVideoId(widget.videoUrl!);
        if (videoId != null) {
          _initYouTubePlayerWithId(videoId);
        } else {
          debugPrint(
              'Failed to extract YouTube video ID from URL: ${widget.videoUrl}');
        }
      } else {
        // It's a direct video URL (S3, etc.)
        _initVideoPlayer();
      }
    } else {
      debugPrint('Video URL is empty or null');
    }

    if (widget.videoAvsKey != null && widget.videoAvsKey!.isNotEmpty) {
      _initYouTubePlayer();
    } else {
      debugPrint('YouTube video key is empty or null');
    }
  }

  void _initVideoPlayer() {
    try {
      // Check if the URL is already a complete URL or just a path
      final videoUrl = widget.videoUrl!;
      final Uri videoUri;

      if (videoUrl.startsWith('http://') || videoUrl.startsWith('https://')) {
        // Already a complete URL
        videoUri = Uri.parse(videoUrl);
      } else {
        // Relative path, append to S3 base URL
        videoUri = Uri.parse(_s3BaseUrl + videoUrl);
      }

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

  void _initYouTubePlayer() {
    try {
      _youtubeController = YoutubePlayerController(
        initialVideoId: widget.videoAvsKey!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          showLiveFullscreenButton: false,
        ),
      );
    } catch (e) {
      debugPrint('Error creating YouTube controller: $e');
    }
  }

  void _initYouTubePlayerWithId(String videoId) {
    try {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          showLiveFullscreenButton: false,
        ),
      );
      debugPrint('YouTube player initialized with video ID: $videoId');
    } catch (e) {
      debugPrint('Error creating YouTube controller with video ID: $e');
    }
  }

  bool _isYouTubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  String? _extractYouTubeVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    // Handle youtube.com URLs
    if (uri.host.contains('youtube.com')) {
      // Handle /watch?v= format (regular videos)
      if (uri.queryParameters.containsKey('v')) {
        return uri.queryParameters['v'];
      }

      // Handle /shorts/VIDEO_ID format (YouTube Shorts)
      if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == 'shorts') {
        return uri.pathSegments[1];
      }
    }

    // Handle youtu.be/VIDEO_ID format (short links)
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> mediaWidgets = [];

    debugPrint('=== CocktailCardSlider Debug Info ===');
    debugPrint('ImageUrls count: ${widget.imageUrls.length}');
    debugPrint('ImageUrls: ${widget.imageUrls}');
    debugPrint('VideoUrl: ${widget.videoUrl}');
    debugPrint('VideoAvsKey: ${widget.videoAvsKey}');
    debugPrint(
        'IsYouTubeUrl: ${widget.videoUrl != null ? _isYouTubeUrl(widget.videoUrl!) : false}');
    debugPrint('VideoController initialized: ${_videoController != null}');
    debugPrint('YouTubeController initialized: ${_youtubeController != null}');
    // — картинки
    if (widget.imageUrls.isNotEmpty) {
      for (final url in widget.imageUrls) {
        // Server now provides direct URLs, no client-side conversion needed
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
              debugPrint('Image URL: $url');
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

    // — видео S3
    if (_videoController != null && _videoController!.value.isInitialized) {
      mediaWidgets.add(GestureDetector(
        onTap: () {
          if (_videoController == null ||
              !_videoController!.value.isInitialized) return;
          _videoController!.value.isPlaying
              ? _videoController!.pause()
              : _videoController!.play();
          setState(() {});
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_videoController != null &&
                _videoController!.value.isInitialized)
              AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              )
            else
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey,
                child: const Center(child: CircularProgressIndicator()),
              ),
            if (_videoController != null &&
                _videoController!.value.isInitialized)
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
    // — или видео YouTube
    else if (_youtubeController != null) {
      mediaWidgets.add(
        GestureDetector(
          onTap: () {
            // No specific hint needed for YouTube as it's handled by the player
          },
          child: YoutubePlayer(
            controller: _youtubeController!,
            showVideoProgressIndicator: true,
            bottomActions: const [
              CurrentPosition(),
              ProgressBar(isExpanded: true),
              RemainingDuration(),
            ],
          ),
        ),
      );
    }

    // индикатор всего
    debugPrint('⚡️ mediaWidgets.length = ${mediaWidgets.length}');

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
                // No hint needed for video on last slide as it's handled by the player
              },
            ),
          ),
        ),
        // точки
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
    _videoController?.dispose(); // Safe disposal with null check
    _youtubeController?.dispose();
    super.dispose();
  }
}
