import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer player = FlutterSoundPlayer();
  Timer? _timer;
  int _fileCount = 0;
  String? _lastFilePath;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _initializePlayer();
  }

  Future<void> _initializeRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _recorder.openRecorder();
    debugPrint('Recorder initialized');
  }

  Future<void> _initializePlayer() async {
    await player.openPlayer();
    debugPrint('Player initialized');
  }

  Future<void> _startRecording() async {
    Directory tempDir = await getTemporaryDirectory();
    await _recorder.startRecorder(
        toFile: "${tempDir.path}/audio_$_fileCount.wav");
    debugPrint('Recording started: audio_$_fileCount.wav');

    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) async {
        debugPrint('Timer triggered');
        String filePath = "${tempDir.path}/audio_$_fileCount.wav";
        _lastFilePath = filePath;
        _fileCount++;
        await _uploadToFTP(filePath);
        debugPrint('Recording started: audio_$_fileCount.wav');
      },
    );
  }

  Future<void> _stopRecording() async {
    if (_recorder.isRecording ?? false) {
      await _recorder.stopRecorder();
      debugPrint('Recording stopped');
    }
    _timer?.cancel();
    debugPrint('Timer cancelled');
    String filePath =
        "${(await getTemporaryDirectory()).path}/audio_$_fileCount.wav";
    _lastFilePath = filePath;
    await _uploadToFTP(filePath);
  }

  Future<void> _uploadToFTP(String filePath) async {
    debugPrint('Uploading file: $filePath');
    FTPConnect ftpConnect = FTPConnect(
      '10.0.2.2',
      user: 'ftpuser',
      pass: 'Str0ngP@ssw0rd!',
      port: 2121,
    );
    try {
      await ftpConnect.connect();
      await ftpConnect.uploadFile(File(filePath));
      await ftpConnect.disconnect();
      debugPrint('File uploaded: $filePath');
      await _deleteFile(filePath);
    } catch (e) {
      debugPrint('FTP upload failed: $e');
    }
  }

  Future<void> _deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('File deleted: $filePath');
      }
    } catch (e) {
      debugPrint('File delete failed: $e');
    }
  }

  Future<void> _playRecording() async {
    if (_lastFilePath != null && await File(_lastFilePath!).exists()) {
      await player.startPlayer(fromURI: _lastFilePath!);
      debugPrint('Playing recording: $_lastFilePath');
    } else {
      debugPrint("No recording found or file doesn't exist.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Recording')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _startRecording,
              child: const Text('Start Recording'),
            ),
            ElevatedButton(
              onPressed: _stopRecording,
              child: const Text('Stop Recording'),
            ),
            ElevatedButton(
              onPressed: _playRecording,
              child: const Text('Play Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
