// import 'dart:async'; // 비동기 프로그래밍을 위한 라이브러리
// import 'dart:io'; // 파일 입출력을 위한 라이브러리
// import 'package:flutter/material.dart'; // Flutter의 UI 프레임워크
// import 'package:flutter_sound/flutter_sound.dart'; // 오디오 녹음 및 재생을 위한 패키지
// import 'package:path_provider/path_provider.dart'; // 경로를 제공하는 패키지
// import 'package:ftpconnect/ftpconnect.dart'; // FTP 연결을 위한 패키지
// import 'package:permission_handler/permission_handler.dart'; // 권한 요청을 위한 패키지

// void main() => runApp(const MyApp()); // 앱 실행의 진입점

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: MyHomePage(), // 홈 페이지 설정
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder(); // 녹음기 객체
//   final FlutterSoundPlayer player = FlutterSoundPlayer(); // 플레이어 객체
//   StreamSubscription? _timerSubscription; // 타이머 스트림 구독자
//   int _fileCount = 0; // 파일 카운터
//   String? _lastFilePath; // 마지막 파일 경로 저장

//   final _recordingController = StreamController<void>(); // 녹음 시작 컨트롤러
//   final _stopController = StreamController<void>(); // 녹음 정지 컨트롤러
//   final _playController = StreamController<void>(); // 재생 컨트롤러

//   @override
//   void initState() {
//     super.initState();
//     _initializeRecorder(); // 녹음기 초기화
//     _initializePlayer(); // 플레이어 초기화
//     _startListening(); // 스트림 리스닝 시작
//   }

//   @override
//   void dispose() {
//     _recordingController.close(); // 컨트롤러 닫기
//     _stopController.close();
//     _playController.close();
//     _timerSubscription?.cancel(); // 타이머 구독 취소
//     _recorder.closeRecorder(); // 녹음기 닫기
//     player.closePlayer(); // 플레이어 닫기
//     super.dispose();
//   }

//   Future<void> _initializeRecorder() async {
//     var status = await Permission.microphone.request(); // 마이크 권한 요청
//     if (status != PermissionStatus.granted) {
//       throw RecordingPermissionException(
//           'Microphone permission not granted'); // 권한 거부 시 예외 발생
//     }
//     await _recorder.openRecorder(); // 녹음기 열기
//     print('Recorder initialized'); // 초기화 완료 메시지 출력
//   }

//   Future<void> _initializePlayer() async {
//     await player.openPlayer(); // 플레이어 열기
//     print('Player initialized'); // 초기화 완료 메시지 출력
//   }

//   void _startListening() {
//     _recordingController.stream.listen((_) => _startRecording()); // 녹음 시작 리스닝
//     _stopController.stream.listen((_) => _stopRecording()); // 녹음 정지 리스닝
//     _playController.stream.listen((_) => _playRecording()); // 재생 리스닝
//   }

//   Future<void> _startRecording() async {
//     Directory tempDir = await getTemporaryDirectory(); // 임시 디렉토리 가져오기
//     await _recorder.startRecorder(
//         toFile: "${tempDir.path}/audio_$_fileCount.wav"); // 녹음 시작

//     print('Recording started: audio_$_fileCount.wav'); // 녹음 시작 메시지 출력

//     _timerSubscription = Stream.periodic(
//       const Duration(minutes: 1), // 5분마다 트리거
//       (timerCount) async {
//         print('Timer triggered'); // 타이머 트리거 메시지 출력
//         String filePath = "${tempDir.path}/audio_$_fileCount.wav";
//         _lastFilePath = filePath;
//         _fileCount++;
//         await _uploadToFTP(filePath); // FTP 업로드
//         print('Recording started: audio_$_fileCount.wav');
//       },
//     ).listen((_) {}); // 타이머 스트림 리스닝
//   }

//   Future<void> _stopRecording() async {
//     if (_recorder.isRecording ?? false) {
//       await _recorder.stopRecorder(); // 녹음 중지
//       print('Recording stopped'); // 녹음 중지 메시지 출력
//     }
//     _timerSubscription?.cancel(); // 타이머 구독 취소
//     print('Timer cancelled'); // 타이머 취소 메시지 출력
//     String filePath =
//         "${(await getTemporaryDirectory()).path}/audio_$_fileCount.wav";
//     _lastFilePath = filePath;
//     await _uploadToFTP(filePath); // FTP 업로드
//   }

//   Future<void> _playRecording() async {
//     if (_lastFilePath != null && await File(_lastFilePath!).exists()) {
//       await player.startPlayer(fromURI: _lastFilePath!); // 녹음 파일 재생
//       print('Playing recording: $_lastFilePath'); // 재생 메시지 출력
//     } else {
//       print("No recording found or file doesn't exist."); // 파일 없음 메시지 출력
//     }
//   }

//   Future<void> _uploadToFTP(String filePath) async {
//     print('Uploading file: $filePath'); // 파일 업로드 메시지 출력
//     FTPConnect ftpConnect = FTPConnect(
//       '10.0.2.2',
//       user: 'ftpuser',
//       pass: 'Str0ngP@ssw0rd!',
//       port: 2121,
//     );
//     try {
//       await ftpConnect.connect(); // FTP 연결
//       await ftpConnect.uploadFile(File(filePath)); // 파일 업로드
//       await ftpConnect.disconnect(); // FTP 연결 해제
//       print('File uploaded: $filePath'); // 파일 업로드 완료 메시지 출력
//       await _deleteFile(filePath); // 파일 삭제
//     } catch (e) {
//       print('FTP upload failed: $e'); // 업로드 실패 메시지 출력
//     }
//   }

//   Future<void> _deleteFile(String filePath) async {
//     try {
//       final file = File(filePath);
//       if (await file.exists()) {
//         await file.delete(); // 파일 삭제
//         print('File deleted: $filePath'); // 파일 삭제 메시지 출력
//       }
//     } catch (e) {
//       print('File delete failed: $e'); // 삭제 실패 메시지 출력
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Audio Recording')), // 앱바 설정
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () => _recordingController.add(null), // 녹음 시작
//               child: const Text('Start Recording'),
//             ),
//             ElevatedButton(
//               onPressed: () => _stopController.add(null), // 녹음 정지
//               child: const Text('Stop Recording'),
//             ),
//             ElevatedButton(
//               onPressed: () => _playController.add(null), // 재생 시작
//               child: const Text('Play Recording'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async'; // 비동기 프로그래밍을 위한 라이브러리
// import 'dart:io'; // 파일 입출력을 위한 라이브러리
// import 'package:flutter/material.dart'; // Flutter의 UI 프레임워크
// import 'package:flutter_sound/flutter_sound.dart'; // 오디오 녹음 및 재생을 위한 패키지
// import 'package:path_provider/path_provider.dart'; // 경로를 제공하는 패키지
// import 'package:ftpconnect/ftpconnect.dart'; // FTP 연결을 위한 패키지
// import 'package:permission_handler/permission_handler.dart'; // 권한 요청을 위한 패키지

// void main() => runApp(const MyApp()); // 앱 실행의 진입점

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: MyHomePage(), // 홈 페이지 설정
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder(); // 녹음기 객체
//   final FlutterSoundPlayer player = FlutterSoundPlayer(); // 플레이어 객체
//   StreamSubscription? _timerSubscription; // 타이머 스트림 구독자
//   int _fileCount = 0; // 파일 카운터
//   String? _lastFilePath; // 마지막 파일 경로 저장

//   final _recordingController = StreamController<void>(); // 녹음 시작 컨트롤러
//   final _stopController = StreamController<void>(); // 녹음 정지 컨트롤러
//   final _playController = StreamController<void>(); // 재생 컨트롤러
//   final _ftpUploadController = StreamController<String>(); // FTP 업로드 컨트롤러

//   @override
//   void initState() {
//     super.initState();
//     _initializeRecorder(); // 녹음기 초기화
//     _initializePlayer(); // 플레이어 초기화
//     _startListening(); // 스트림 리스닝 시작
//     _startFTPListening(); // FTP 업로드 스트림 리스닝 시작
//   }

//   @override
//   void dispose() {
//     _recordingController.close(); // 컨트롤러 닫기
//     _stopController.close();
//     _playController.close();
//     _ftpUploadController.close();
//     _timerSubscription?.cancel(); // 타이머 구독 취소
//     _recorder.closeRecorder(); // 녹음기 닫기
//     player.closePlayer(); // 플레이어 닫기
//     super.dispose();
//   }

//   Future<void> _initializeRecorder() async {
//     var status = await Permission.microphone.request(); // 마이크 권한 요청
//     if (status != PermissionStatus.granted) {
//       throw RecordingPermissionException(
//           'Microphone permission not granted'); // 권한 거부 시 예외 발생
//     }
//     await _recorder.openRecorder(); // 녹음기 열기
//     print('Recorder initialized'); // 초기화 완료 메시지 출력
//   }

//   Future<void> _initializePlayer() async {
//     await player.openPlayer(); // 플레이어 열기
//     print('Player initialized'); // 초기화 완료 메시지 출력
//   }

//   void _startListening() {
//     _recordingController.stream.listen((_) => _handleRecording()); // 녹음 시작 리스닝
//     _stopController.stream.listen((_) => _handleStop()); // 녹음 정지 리스닝
//     _playController.stream.listen((_) => _handlePlay()); // 재생 리스닝
//   }

//   void _startFTPListening() {
//     _ftpUploadController.stream
//         .listen((filePath) => _uploadToFTP(filePath)); // FTP 업로드 리스닝
//   }

//   //녹음 시작
//   Future<void> _handleRecording() async {
//     Directory tempDir = await getTemporaryDirectory(); // 임시 디렉토리 가져오기
//     await _recorder.startRecorder(
//         toFile: "${tempDir.path}/audio_$_fileCount.wav"); // 녹음 시작

//     print('Recording started: audio_$_fileCount.wav'); // 녹음 시작 메시지 출력

//     _timerSubscription = Stream.periodic(
//       const Duration(minutes: 2), // 5분마다 트리거
//       (timerCount) async {
//         print('Timer triggered'); // 타이머 트리거 메시지 출력
//         String filePath = "${tempDir.path}/audio_$_fileCount.wav";
//         _lastFilePath = filePath;
//         _fileCount++;
//         _ftpUploadController.add(filePath); // FTP 업로드 요청
//         print('Recording started: audio_$_fileCount.wav');
//       },
//     ).listen((_) {}); // 타이머 스트림 리스닝
//   }

//   //녹음 중지
//   Future<void> _handleStop() async {
//     if (_recorder.isRecording ?? false) {
//       await _recorder.stopRecorder(); // 녹음 중지
//       print('Recording stopped'); // 녹음 중지 메시지 출력
//     }
//     _timerSubscription?.cancel(); // 타이머 구독 취소
//     print('Timer cancelled'); // 타이머 취소 메시지 출력
//     String filePath =
//         "${(await getTemporaryDirectory()).path}/audio_$_fileCount.wav";
//     _lastFilePath = filePath;
//     _ftpUploadController.add(filePath); // FTP 업로드 요청
//   }

//   // 녹음본 실행
//   Future<void> _handlePlay() async {
//     if (_lastFilePath != null && await File(_lastFilePath!).exists()) {
//       await player.startPlayer(fromURI: _lastFilePath!); // 녹음 파일 재생
//       print('Playing recording: $_lastFilePath'); // 재생 메시지 출력
//     } else {
//       print("No recording found or file doesn't exist."); // 파일 없음 메시지 출력
//     }
//   }

//   //업로드
//   Future<void> _uploadToFTP(String filePath) async {
//     print('Uploading file: $filePath'); // 파일 업로드 메시지 출력
//     FTPConnect ftpConnect = FTPConnect(
//       '10.0.2.2',
//       user: 'ftpuser',
//       pass: 'Str0ngP@ssw0rd!',
//       port: 2121,
//     );
//     try {
//       bool connected = await ftpConnect.connect(); // FTP 연결
//       if (connected) {
//         print('FTP connection established');
//         bool uploaded = await ftpConnect.uploadFile(File(filePath)); // 파일 업로드
//         if (uploaded) {
//           print('File uploaded: $filePath'); // 파일 업로드 완료 메시지 출력
//           await _deleteFile(filePath); // 파일 삭제
//         } else {
//           print('File upload failed'); // 업로드 실패 메시지 출력
//         }
//         bool disconnected = await ftpConnect.disconnect(); // FTP 연결 해제
//         if (disconnected) {
//           print('FTP connection closed');
//         } else {
//           print('FTP disconnection failed');
//         }
//       } else {
//         print('FTP connection failed'); // 연결 실패 메시지 출력
//       }
//     } catch (e) {
//       print('FTP operation failed: $e'); // 예외 처리 메시지 출력
//     }
//   }

//   Future<void> _deleteFile(String filePath) async {
//     try {
//       final file = File(filePath);
//       if (await file.exists()) {
//         await file.delete(); // 파일 삭제
//         print('File deleted: $filePath'); // 파일 삭제 메시지 출력
//       }
//     } catch (e) {
//       print('File delete failed: $e'); // 삭제 실패 메시지 출력
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Audio Recording')), // 앱바 설정
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () => _recordingController.add(null), // 녹음 시작
//               child: const Text('Start Recording'),
//             ),
//             ElevatedButton(
//               onPressed: () => _stopController.add(null), // 녹음 정지
//               child: const Text('Stop Recording'),
//             ),
//             ElevatedButton(
//               onPressed: () => _playController.add(null), // 재생 시작
//               child: const Text('Play Recording'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async'; // 비동기 프로그래밍을 위한 라이브러리
import 'dart:io'; // 파일 입출력을 위한 라이브러리
import 'package:flutter/material.dart'; // Flutter의 UI 프레임워크
import 'package:flutter_sound/flutter_sound.dart'; // 오디오 녹음 및 재생을 위한 패키지
import 'package:path_provider/path_provider.dart'; // 경로를 제공하는 패키지
import 'package:ftpconnect/ftpconnect.dart'; // FTP 연결을 위한 패키지
import 'package:permission_handler/permission_handler.dart'; // 권한 요청을 위한 패키지

void main() => runApp(const MyApp()); // 앱 실행의 진입점

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(), // 홈 페이지 설정
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder(); // 녹음기 객체
  final FlutterSoundPlayer player = FlutterSoundPlayer(); // 플레이어 객체
  StreamSubscription? _timerSubscription; // 타이머 스트림 구독자
  int _fileCount = 0; // 파일 카운터
  String? _lastFilePath; // 마지막 파일 경로 저장

  final _recordingController = StreamController<void>(); // 녹음 시작 컨트롤러
  final _stopController = StreamController<void>(); // 녹음 정지 컨트롤러
  final _playController = StreamController<void>(); // 재생 컨트롤러
  final _ftpUploadController = StreamController<String>(); // FTP 업로드 컨트롤러

  @override
  void initState() {
    super.initState();
    _initializeRecorder(); // 녹음기 초기화
    _initializePlayer(); // 플레이어 초기화
    _startListening(); // 스트림 리스닝 시작
    _startFTPListening(); // FTP 업로드 스트림 리스닝 시작
  }

  @override
  void dispose() {
    _recordingController.close(); // 컨트롤러 닫기
    _stopController.close();
    _playController.close();
    _ftpUploadController.close();
    _timerSubscription?.cancel(); // 타이머 구독 취소
    _recorder.closeRecorder(); // 녹음기 닫기
    player.closePlayer(); // 플레이어 닫기
    super.dispose();
  }

  Future<void> _initializeRecorder() async {
    var status = await Permission.microphone.request(); // 마이크 권한 요청
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException(
          'Microphone permission not granted'); // 권한 거부 시 예외 발생
    }
    await _recorder.openRecorder(); // 녹음기 열기
    print('Recorder initialized'); // 초기화 완료 메시지 출력
  }

  Future<void> _initializePlayer() async {
    await player.openPlayer(); // 플레이어 열기
    print('Player initialized'); // 초기화 완료 메시지 출력
  }

  void _startListening() {
    _recordingController.stream.listen((_) => _handleRecording()); // 녹음 시작 리스닝
    _stopController.stream.listen((_) => _handleStop()); // 녹음 정지 리스닝
    _playController.stream.listen((_) => _handlePlay()); // 재생 리스닝
  }

  void _startFTPListening() {
    _ftpUploadController.stream
        .listen((filePath) => _uploadToFTP(filePath)); // FTP 업로드 리스닝
  }

  Future<void> _handleRecording() async {
    await _startRecording();
    _timerSubscription = Stream.periodic(
      const Duration(minutes: 2), // 2분마다 트리거
      (timerCount) async {
        print('Timer triggered'); // 타이머 트리거 메시지 출력
        await _restartRecording();
      },
    ).listen((_) {});
  }

  Future<void> _startRecording() async {
    Directory tempDir = await getTemporaryDirectory(); // 임시 디렉토리 가져오기
    String filePath = "${tempDir.path}/audio_$_fileCount.wav";
    await _recorder.startRecorder(toFile: filePath); // 녹음 시작
    print('Recording started: audio_$_fileCount.wav'); // 녹음 시작 메시지 출력
  }

  Future<void> _restartRecording() async {
    if (_recorder.isRecording ?? false) {
      await _recorder.stopRecorder(); // 녹음 중지
      print('Recording stopped for restart'); // 녹음 중지 메시지 출력
      String filePath =
          "${(await getTemporaryDirectory()).path}/audio_$_fileCount.wav";
      _lastFilePath = filePath;
      _ftpUploadController.add(filePath); // FTP 업로드 요청
      _fileCount++;
      await _startRecording(); // 녹음 다시 시작
    }
  }

  Future<void> _handleStop() async {
    if (_recorder.isRecording ?? false) {
      await _recorder.stopRecorder(); // 녹음 중지
      print('Recording stopped'); // 녹음 중지 메시지 출력
    }
    _timerSubscription?.cancel(); // 타이머 구독 취소
    print('Timer cancelled'); // 타이머 취소 메시지 출력
    String filePath =
        "${(await getTemporaryDirectory()).path}/audio_$_fileCount.wav";
    _lastFilePath = filePath;
    _ftpUploadController.add(filePath); // FTP 업로드 요청
  }

  Future<void> _handlePlay() async {
    if (_lastFilePath != null && await File(_lastFilePath!).exists()) {
      await player.startPlayer(fromURI: _lastFilePath!); // 녹음 파일 재생
      print('Playing recording: $_lastFilePath'); // 재생 메시지 출력
    } else {
      print("No recording found or file doesn't exist."); // 파일 없음 메시지 출력
    }
  }

  Future<void> _uploadToFTP(String filePath) async {
    print('Uploading file: $filePath'); // 파일 업로드 메시지 출력
    FTPConnect ftpConnect = FTPConnect(
      '10.0.2.2',
      user: 'ftpuser',
      pass: 'Str0ngP@ssw0rd!',
      port: 2121,
    );
    try {
      bool connected = await ftpConnect.connect(); // FTP 연결
      if (connected) {
        print('FTP connection established');
        bool uploaded = await ftpConnect.uploadFile(File(filePath)); // 파일 업로드
        if (uploaded) {
          print('File uploaded: $filePath'); // 파일 업로드 완료 메시지 출력
          await _deleteFile(filePath); // 파일 삭제
        } else {
          print('File upload failed'); // 업로드 실패 메시지 출력
        }
        bool disconnected = await ftpConnect.disconnect(); // FTP 연결 해제
        if (disconnected) {
          print('FTP connection closed');
        } else {
          print('FTP disconnection failed');
        }
      } else {
        print('FTP connection failed'); // 연결 실패 메시지 출력
      }
    } catch (e) {
      print('FTP operation failed: $e'); // 예외 처리 메시지 출력
    }
  }

  Future<void> _deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete(); // 파일 삭제
        print('File deleted: $filePath'); // 파일 삭제 메시지 출력
      }
    } catch (e) {
      print('File delete failed: $e'); // 삭제 실패 메시지 출력
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Recording')), // 앱바 설정
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _recordingController.add(null), // 녹음 시작
              child: const Text('Start Recording'),
            ),
            ElevatedButton(
              onPressed: () => _stopController.add(null), // 녹음 정지
              child: const Text('Stop Recording'),
            ),
            ElevatedButton(
              onPressed: () => _playController.add(null), // 재생 시작
              child: const Text('Play Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
