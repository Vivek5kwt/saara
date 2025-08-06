import 'package:flutter/material.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Video')),
      body: Center(
        child: Text('Yoga video placeholder'),
      ),
    );
  }
}

