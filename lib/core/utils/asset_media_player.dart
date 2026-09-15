import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AssetMediaPlayer extends StatefulWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool autoPlay;
  final bool looping;

  const AssetMediaPlayer({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.autoPlay = true,
    this.looping = false,
  });

  @override
  State<AssetMediaPlayer> createState() => _AssetMediaPlayerState();
}

class _AssetMediaPlayerState extends State<AssetMediaPlayer> {
  VideoPlayerController? _controller;

  bool get _isVideo {
    final path = widget.assetPath.toLowerCase();

    return path.endsWith('.mp4') ||
        path.endsWith('.mov') ||
        path.endsWith('.webm');
  }

  @override
  void initState() {
    super.initState();

    if (_isVideo) {
      _initializeVideo();
    }
  }

  @override
  void didUpdateWidget(covariant AssetMediaPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If asset changes from image → video or video → another video
    if (oldWidget.assetPath != widget.assetPath) {
      _disposeVideo();

      if (_isVideo) {
        _initializeVideo();
      } else {
        setState(() {});
      }
    }
  }

  Future<void> _initializeVideo() async {
    final controller = VideoPlayerController.asset(widget.assetPath);

    _controller = controller;

    try {
      await controller.initialize();

      await controller.setLooping(widget.looping);

      if (widget.autoPlay) {
        await controller.play();
      }

      if (mounted && _controller == controller) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Video initialization error: $e');
    }
  }

  void _disposeVideo() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _disposeVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVideo) {
      return Image.asset(
        widget.assetPath,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: FittedBox(
        fit: widget.fit,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      ),
    );
  }
}