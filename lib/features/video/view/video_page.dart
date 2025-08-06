import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  bool _showVideos = true;
  bool _showControls = true;
  bool _isBuffering = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    )
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _startHideTimer();
      });
    _controller.addListener(_videoListener);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  void _videoListener() {
    final buffering = _controller.value.isBuffering;
    if (buffering != _isBuffering) {
      setState(() {
        _isBuffering = buffering;
      });
    } else {
      // Rebuild to update position for slider
      setState(() {});
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text('Download'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Download tapped')), );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share tapped')), );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: () {
        setState(() => _showControls = !_showControls);
        if (_showControls && _controller.value.isPlaying) {
          _startHideTimer();
        }
      },
      child: AspectRatio(
        aspectRatio:
            _controller.value.isInitialized ? _controller.value.aspectRatio : 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_controller.value.isInitialized)
              VideoPlayer(_controller)
            else
              Container(
                color: Colors.black12,
                child: const Center(child: CircularProgressIndicator()),
              ),
            if (_showControls) ...[
              Positioned(
                top: 12,
                left: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.black38,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
              ),
              Positioned(
                top: 12,
                right: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.black38,
                    child: IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: _showOptions,
                    ),
                  ),
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black38,
                      child: IconButton(
                        icon: const Icon(Icons.replay_10, color: Colors.white),
                        onPressed: () async {
                          final current = _controller.value.position;
                          setState(() => _isBuffering = true);
                          await _controller.seekTo(
                            current - const Duration(seconds: 10),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      backgroundColor: Colors.black38,
                      child: _isBuffering
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : IconButton(
                              icon: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                    _hideTimer?.cancel();
                                    _showControls = true;
                                  } else {
                                    _controller.play();
                                    _startHideTimer();
                                  }
                                });
                              },
                            ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      backgroundColor: Colors.black38,
                      child: IconButton(
                        icon: const Icon(Icons.forward_10, color: Colors.white),
                        onPressed: () async {
                          final current = _controller.value.position;
                          setState(() => _isBuffering = true);
                          await _controller.seekTo(
                            current + const Duration(seconds: 10),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4,
                          activeTrackColor: const Color(0xFF9B65DE),
                          inactiveTrackColor: Colors.white30,
                          thumbColor: const Color(0xFF9B65DE),
                          overlayColor: const Color(0x559B65DE),
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                        ),
                        child: Slider(
                          value: _controller.value.position.inMilliseconds
                              .toDouble()
                              .clamp(0.0, _controller.value.duration.inMilliseconds.toDouble()),
                          max: _controller.value.duration.inMilliseconds.toDouble(),
                          onChangeStart: (_) {
                            _hideTimer?.cancel();
                            if (!_showControls) {
                              setState(() => _showControls = true);
                            }
                          },
                          onChanged: (v) {
                            _controller.seekTo(Duration(milliseconds: v.toInt()));
                          },
                          onChangeEnd: (_) {
                            if (_controller.value.isPlaying) {
                              _startHideTimer();
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Text(
                              '${_format(_controller.value.position)} / ${_format(_controller.value.duration)}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.fullscreen, color: Colors.white),
                              onPressed: () async {
                                final wasPlaying = _controller.value.isPlaying;
                                _hideTimer?.cancel();
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => FullScreenVideo(controller: _controller),
                                  ),
                                );
                                if (wasPlaying) {
                                  _controller.play();
                                  _startHideTimer();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentButtons() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 1),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _showVideos = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _showVideos ? const Color(0xFF9B65DE) : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow,
                            color: _showVideos ? Colors.white : Colors.black54),
                        const SizedBox(width: 8),
                        Text('Videos',
                            style: TextStyle(
                              color: _showVideos ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _showVideos = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !_showVideos
                          ? const Color(0xFF9B65DE)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.comment,
                            color:
                                !_showVideos ? Colors.white : Colors.black54),
                        const SizedBox(width: 8),
                        Text('Comments',
                            style: TextStyle(
                              color:
                                  !_showVideos ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpNextList() {
    final items = List.generate(5, (i) => i + 1);
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final day = index + 1;
        final locked = index != 0;
        final duration = '${(8 + index * 2).toString().padLeft(2, '0')}:${(30 + index * 4 % 60).toString().padLeft(2, '0')}';
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://picsum.photos/seed/video$index/120/70',
                    width: 120,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                if (locked)
                  const Positioned(
                    left: 6,
                    bottom: 6,
                    child: Icon(Icons.lock, size: 16, color: Colors.white),
                  ),
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      duration,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              'Day $day ${day == 1 ? 'legs & Butt Strength Pilates' : 'ABS + Arms Mat Pilates'}',
              style: const TextStyle(fontSize: 16),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _showOptions,
            ),
            onTap: locked ? null : () {},
          ),
        );
      },
    );
  }

  Widget _buildCommentsList() {
    final comments = List.generate(3, (i) => 'This is comment #${i + 1}.');
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: comments.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${index + 1}'),
          ),
          title: Text('User${index + 1}'),
          subtitle: Text(comments[index]),
          trailing: const Text('2h ago'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '*Start Here*\nWelcome to Saara & Define',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Welcome to Saara & Define – Your 14-Day Pilates & Strength Challenge!',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text('...More'),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Up Next',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child:
                            _showVideos ? _buildUpNextList() : _buildCommentsList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildSegmentButtons(),
        ),
      ),
    );
  }
}

class FullScreenVideo extends StatelessWidget {
  const FullScreenVideo({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: AspectRatio(
            aspectRatio:
                controller.value.isInitialized ? controller.value.aspectRatio : 16 / 9,
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }
}
