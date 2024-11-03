// lib/services/audio_service.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ftpconnect/ftpconnect.dart';

class AudioService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  StreamSubscription? _timerSubscription;
  int _fileCount = 0;
  String? _lastFilePath;

  bool isRecorderInitialized = false;
  bool isPlaying = false;
  bool isRecording = false;

  Future<void> initialize() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception("Microphone permission denied");
    }

    await _recorder.openRecorder();
    await _player.openPlayer();
    isRecorderInitialized = true;
  }

  Future<void> startRecording(String meetingId, String participantCount,
      Function(String) onFileRecorded) async {
    if (!isRecorderInitialized) throw Exception("Recorder not initialized");

    Directory tempDir = await getTemporaryDirectory();
    String filePath =
        "${tempDir.path}/$meetingId%$participantCount%$_fileCount.wav";
    print("filePath: $filePath");
    await _recorder.startRecorder(toFile: filePath);
    isRecording = true;
    _lastFilePath = filePath;

    // 타이머 시작 (매 분마다 녹음 재시작)
    _timerSubscription = Stream.periodic(
      const Duration(minutes: 1),
      (timerCount) async {
        await restartRecording(meetingId, participantCount, onFileRecorded);
        print("녹음 다시 시작");
      },
    ).listen((_) {});
  }

  Future<void> restartRecording(String meetingId, String participantCount,
      Function(String) onFileRecorded) async {
    if (_recorder.isRecording ?? false) {
      await _recorder.stopRecorder();
      _fileCount++;
      String filePath =
          "${(await getTemporaryDirectory()).path}/$meetingId%$participantCount%$_fileCount.wav";
      _lastFilePath = filePath;
      onFileRecorded(filePath);
      print("녹음 다시 시작 Filepath: $filePath");
      await startRecording(meetingId, participantCount, onFileRecorded);
    }
  }

  Future<void> stopRecording(String meetingId, String participantCount,
      Function(String) onFileRecorded) async {
    if (_recorder.isRecording ?? false) {
      await _recorder.stopRecorder();
      isRecording = false;
    }
    _timerSubscription?.cancel();
    String filePath =
        "${(await getTemporaryDirectory()).path}/$meetingId%$participantCount%$_fileCount.wav";
    _lastFilePath = filePath;
    onFileRecorded(filePath);
  }

  Future<void> playRecording() async {
    if (_lastFilePath != null && await File(_lastFilePath!).exists()) {
      await _player.startPlayer(
          fromURI: _lastFilePath!,
          whenFinished: () {
            isPlaying = false;
          });
      isPlaying = true;
    } else {
      throw Exception("No recording found");
    }
  }

  Future<void> uploadToFTP(String filePath) async {
    FTPConnect ftpConnect = FTPConnect(
      '34.64.241.110',
      user: 'ftpuser',
      pass: 'Str0ngP@ssw0rd!',
      port: 2121,
    );
    try {
      bool connected = await ftpConnect.connect();
      if (connected) {
        bool uploaded = await ftpConnect.uploadFile(File(filePath));
        if (uploaded) {
          await deleteFile(filePath);
        }
        await ftpConnect.disconnect();
      }
    } catch (e) {
      throw Exception("FTP upload failed: $e");
    }
  }

  Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    _timerSubscription?.cancel();
  }
}
