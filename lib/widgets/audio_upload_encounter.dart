import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:MedicalShala/theme/app_colors.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({Key? key}) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _player = AudioPlayer();
  File? _audioFile;
  bool _isPlaying = false;

  Future<void> _pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      _audioFile = File(result.files.single.path!);
      await _player.setFilePath(_audioFile!.path);
      setState(() {});
    }
  }

  Future<void> _togglePlayPause() async {
    if (_player.playerState.playing) {
      await _player.pause();
      setState(() => _isPlaying = false);
    } else {
      await _player.play();
      setState(() => _isPlaying = true);
    }
  }

  Future<void> _uploadAudio() async {
    if (_audioFile == null) return;

    final dio = Dio();
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        _audioFile!.path,
        filename: _audioFile!.uri.pathSegments.last,
      ),
    });

    try {
      final response = await dio.post(
        'https://your-upload-endpoint.com/audio', // replace with real endpoint
        data: formData,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Uploaded: ${response.statusCode}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload failed")),
      );
    }
  }

  void _resetAudio() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Discard Audio?'),
      content: const Text('Are you sure you want to discard this audio file?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Discard'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    await _player.pause();
    await _player.seek(Duration.zero); // <- Resets timer
    _audioFile = null;
    _isPlaying = false;
    setState(() {});
  }
}


  Widget _buildWaveformMock() {
    return Row(
      children: List.generate(20, (index) {
        final height = (index % 5 + 1) * 6.0;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Container(
            width: 2,
            height: height,
            color: Colors.grey.shade700,
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Play / Pause or Upload
          InkWell(
            onTap: _audioFile != null ? _togglePlayPause : _pickAudioFile,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _audioFile != null ? Colors.blue : AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _audioFile == null
                    ? Icons.upload_file
                    : (_isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded),
                size: 32,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Waveform + Timer
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWaveformMock(),
                StreamBuilder<Duration>(
                  stream: _player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final minutes =
                        position.inMinutes.remainder(60).toString().padLeft(1, '0');
                    final seconds =
                        position.inSeconds.remainder(60).toString().padLeft(2, '0');
                    return Text(
                      "$minutes:$seconds",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Upload & Discard
          if (_audioFile != null)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.upload_rounded),
                  tooltip: 'Upload',
                  onPressed: _uploadAudio,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                  tooltip: 'Discard',
                  onPressed: _resetAudio,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
