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
  StreamSubscription? _timerSubscription;
  int _fileCount = 0;
  String? _lastFilePath;

  final _recordingController = StreamController<void>();
  final _stopController = StreamController<void>();
  final _playController = StreamController<void>();
  final _ftpUploadController = StreamController<String>();

  final TextEditingController _meetingIdController = TextEditingController();
  final TextEditingController _participantCountController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _initializePlayer();
    _startListening();
    _startFTPListening();
  }

  @override
  void dispose() {
    _recordingController.close();
    _stopController.close();
    _playController.close();
    _ftpUploadController.close();
    _timerSubscription?.cancel();
    _recorder.closeRecorder();
    player.closePlayer();
    _meetingIdController.dispose();
    _participantCountController.dispose();
    super.dispose();
  }

  Future<void> _initializeRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // 권한이 거부된 경우 사용자에게 안내 메시지를 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('마이크 권한 필요'),
            content:
                const Text('녹음을 시작하려면 마이크 권한이 필요합니다. 설정에서 마이크 권한을 허용해주세요.'),
            actions: [
              TextButton(
                child: const Text('설정으로 이동'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  // 설정 페이지로 이동
                  await openAppSettings();
                },
              ),
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return; // 권한이 없으면 초기화 중단
    }

    await _recorder.openRecorder();
    print('Recorder initialized');
  }

  Future<void> _initializePlayer() async {
    await player.openPlayer();
    print('Player initialized');
  }

  void _startListening() {
    _recordingController.stream.listen((_) => _handleRecording());
    _stopController.stream.listen((_) => _handleStop());
    _playController.stream.listen((_) => _handlePlay());
  }

  void _startFTPListening() {
    _ftpUploadController.stream.listen((filePath) => _uploadToFTP(filePath));
  }

  Future<void> _handleRecording() async {
    await _startRecording();
    _timerSubscription = Stream.periodic(
      const Duration(minutes: 1),
      (timerCount) async {
        print('Timer triggered');
        await _restartRecording();
      },
    ).listen((_) {});
  }

  Future<void> _startRecording() async {
    Directory tempDir = await getTemporaryDirectory();
    String meetingId = _meetingIdController.text; //response에서 받은 값으로 설정
    String participantCount =
        _participantCountController.text; //사용자에게 입력 받아야 한다
    String filePath =
        "${tempDir.path}/$meetingId%$participantCount%$_fileCount.wav";
    await _recorder.startRecorder(toFile: filePath);
    print('Recording started: $filePath');
  }

  Future<void> _restartRecording() async {
    if (_recorder.isRecording ?? false) {
      await _recorder.stopRecorder();
      print('Recording stopped for restart');
      String meetingId = _meetingIdController.text;
      String participantCount = _participantCountController.text;
      String filePath =
          "${(await getTemporaryDirectory()).path}/$meetingId%$participantCount%$_fileCount.wav";
      _lastFilePath = filePath;
      _ftpUploadController.add(filePath);
      _fileCount++;
      await _startRecording();
    }
  }

  Future<void> _handleStop() async {
    if (_recorder.isRecording ?? false) {
      await _recorder.stopRecorder();
      print('Recording stopped');
    }
    _timerSubscription?.cancel();
    print('Timer cancelled');
    String meetingId = _meetingIdController.text;
    String participantCount = _participantCountController.text;
    String filePath =
        "${(await getTemporaryDirectory()).path}/$meetingId%$participantCount%$_fileCount.wav";
    _lastFilePath = filePath;
    _ftpUploadController.add(filePath);
  }

  Future<void> _handlePlay() async {
    if (_lastFilePath != null && await File(_lastFilePath!).exists()) {
      await player.startPlayer(fromURI: _lastFilePath!);
      print('Playing recording: $_lastFilePath');
    } else {
      print("No recording found or file doesn't exist.");
    }
  }

  Future<void> _uploadToFTP(String filePath) async {
    print('Uploading file: $filePath');
    FTPConnect ftpConnect = FTPConnect(
      '34.64.241.110',
      user: 'ftpuser',
      pass: 'Str0ngP@ssw0rd!',
      port: 2121,
    );
    try {
      bool connected = await ftpConnect.connect();
      if (connected) {
        print('FTP connection established');
        bool uploaded = await ftpConnect.uploadFile(File(filePath));
        if (uploaded) {
          print('File uploaded: $filePath');
          await _deleteFile(filePath);
        } else {
          print('File upload failed');
        }
        bool disconnected = await ftpConnect.disconnect();
        if (disconnected) {
          print('FTP connection closed');
        } else {
          print('FTP disconnection failed');
        }
      } else {
        print('FTP connection failed');
      }
    } catch (e) {
      print('FTP operation failed: $e');
    }
  }

  Future<void> _deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        print('File deleted: $filePath');
      }
    } catch (e) {
      print('File delete failed: $e');
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _meetingIdController,
                decoration: const InputDecoration(
                  labelText: 'Meeting ID',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _participantCountController,
                decoration: const InputDecoration(
                  labelText: 'Participant Count',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            ElevatedButton(
              onPressed: () => _recordingController.add(null),
              child: const Text('Start Recording'),
            ),
            ElevatedButton(
              onPressed: () => _stopController.add(null),
              child: const Text('Stop Recording'),
            ),
            ElevatedButton(
              onPressed: () => _playController.add(null),
              child: const Text('Play Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
