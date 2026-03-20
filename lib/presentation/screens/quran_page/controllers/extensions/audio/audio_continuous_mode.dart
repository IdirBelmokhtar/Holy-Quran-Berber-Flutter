import 'dart:async';
import 'dart:developer' show log;
import 'dart:io' show Directory, File;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:quran_library/quran_library.dart';

extension AudioContinuousMode on AudioCtrl {
  static StreamSubscription<PlayerState>? _continuousSubscription;
  static bool _continuousModeEnabled = false;
  static Completer<void>? _ayahCompleter;
  static int _sessionId = 0;

  /// Helper to get URL for any given ayah UQ number based on current reader
  String _getAyahUrlByUqNumber(int ayahUqNumber) {
    try {
      final surahData = QuranCtrl.instance.getSurahDataByAyahUQ(ayahUqNumber);
      final ayah = surahData.ayahs.firstWhere(
        (a) => a.ayahUQNumber == ayahUqNumber,
      );

      final fileName =
          ReadersConstants.activeAyahReaders[state.ayahReaderIndex.value].url ==
              ReadersConstants.ayahs1stSource
          ? '$ayahUqNumber.mp3'
          : '${surahData.surahNumber.toString().padLeft(3, "0")}${ayah.ayahNumber.toString().padLeft(3, "0")}.mp3';

      return '$ayahDownloadSource${join(ayahReaderValue, fileName)}';
    } catch (e) {
      log(
        'Error generating URL for Ayah UQ $ayahUqNumber: $e',
        name: 'AudioContinuousMode',
      );
      return '';
    }
  }

  /// Helper to get local file path for any given ayah UQ number
  Future<String> _getAyahLocalPathByUqNumber(int ayahUqNumber) async {
    try {
      final surahData = QuranCtrl.instance.getSurahDataByAyahUQ(ayahUqNumber);
      final ayah = surahData.ayahs.firstWhere(
        (a) => a.ayahUQNumber == ayahUqNumber,
      );

      final fileName =
          ReadersConstants.activeAyahReaders[state.ayahReaderIndex.value].url ==
              ReadersConstants.ayahs1stSource
          ? '$ayahUqNumber.mp3'
          : '${surahData.surahNumber.toString().padLeft(3, "0")}${ayah.ayahNumber.toString().padLeft(3, "0")}.mp3';

      return join((await state.dir).path, ayahReaderValue, fileName);
    } catch (e) {
      log(
        'Error generating local path for Ayah UQ $ayahUqNumber: $e',
        name: 'AudioContinuousMode',
      );
      return '';
    }
  }

  /// Downloads the next `count` ayahs in the background silently
  Future<void> _downloadLookaheadAyahs(
    int currentAyahUqNumber, {
    int count = 3,
  }) async {
    if (kIsWeb)
      return; // Background caching via File API is mostly unnecessary/complex on Web

    int maxAyahNumber = 6236; // Total ayahs in the Quran

    for (int i = 1; i <= count; i++) {
      int targetAyahUq = currentAyahUqNumber + i;
      if (targetAyahUq > maxAyahNumber) break;

      final path = await _getAyahLocalPathByUqNumber(targetAyahUq);
      final url = _getAyahUrlByUqNumber(targetAyahUq);

      if (path.isEmpty || url.isEmpty) continue;

      var file = File(path);
      if (!await file.exists()) {
        log(
          'Downloading lookahead ayah: $targetAyahUq',
          name: 'AudioContinuousMode',
        );
        try {
          // Ensure directory exists
          await Directory(dirname(path)).create(recursive: true);

          Dio dio = Dio();
          await dio.download(url, path);

          // Mark as downloaded in library state
          state.ayahsDownloadStatus[targetAyahUq] = true;
          log(
            'Downloaded lookahead ayah: $targetAyahUq successfully',
            name: 'AudioContinuousMode',
          );
        } catch (e) {
          log(
            'Failed to download lookahead ayah $targetAyahUq: $e',
            name: 'AudioContinuousMode',
          );
        }
      } else {
        log(
          'Lookahead ayah $targetAyahUq already exists locally',
          name: 'AudioContinuousMode',
        );
        state.ayahsDownloadStatus[targetAyahUq] = true;
      }
    }
  }

  /// Starts continuous single ayah playback and manages lookahead downloads
  Future<void> playContinuousWithLookahead(
    BuildContext initialContext,
    int startAyahUqNumber,
  ) async {
    _continuousModeEnabled = true;
    _sessionId++;
    final int mySession = _sessionId;
    int currentAyahUqNumber = startAyahUqNumber;

    // 1. Reset old listener to avoid duplicates
    _continuousSubscription?.cancel();
    
    // Complete any hanging completers from a previous session
    if (_ayahCompleter != null && !_ayahCompleter!.isCompleted) {
        _ayahCompleter!.complete();
    }
    _ayahCompleter = null;

    // 2. Setup a single global listener for this continuous loop
    _continuousSubscription = state.audioPlayer.playerStateStream.listen((d) {
      if (d.processingState == ProcessingState.completed && _continuousModeEnabled) {
        log('Session [$mySession]: Ayah completed. Firing completer...', name: 'AudioContinuousMode');
        if (_ayahCompleter != null && !_ayahCompleter!.isCompleted) {
            _ayahCompleter!.complete();
        }
      }
    });

    log('Session [$mySession]: Starting continuous mode at Ayah $currentAyahUqNumber', name: 'AudioContinuousMode');

    // 3. Robust loop based on the track completer
    while (_continuousModeEnabled && currentAyahUqNumber <= 6236 && _sessionId == mySession) {
      log('Session [$mySession]: Processing Ayah $currentAyahUqNumber', name: 'AudioContinuousMode');
      
      // Start background lookahead caching immediately
      unawaited(_downloadLookaheadAyahs(currentAyahUqNumber, count: 3));

      // Fetch a highly robust mounted context to prevent silent crashes in `playAyah`
      BuildContext safeContext = Get.key.currentContext ?? Get.context ?? Get.overlayContext ?? initialContext;

      _ayahCompleter = Completer<void>();

      // Trigger normal play single ayah without await inside the loop.
      playAyah(safeContext, currentAyahUqNumber, playSingleAyah: true);

      // We wait for the ayah to finish playing.
      // Unlike `await playAyah`, this strictly waits for the `ProcessingState.completed` event
      // from `just_audio`, bypassing any recursive callback depths!
      await _ayahCompleter!.future;

      if (!_continuousModeEnabled || _sessionId != mySession) {
         log('Session [$mySession]: Loop manually aborted or superceded.', name: 'AudioContinuousMode');
         break;
      }

      log('Session [$mySession]: Advanced through Ayah $currentAyahUqNumber', name: 'AudioContinuousMode');

      // Wait a tiny bit to let UI sync / just_audio stop() tasks to process
      await Future.delayed(const Duration(milliseconds: 200));

      currentAyahUqNumber++;
      
      if (currentAyahUqNumber <= 6236) {
          // Address visual page jumps before the next loop starts
          if (isLastAyahInPageButNotInSurah) {
              await moveToNextPage();
          } else if (isLastAyahInSurahAndPage) {
              await moveToNextPage();
          }
      }
    }
    
    log('Session [$mySession]: Continuous loop exited cleanly.', name: 'AudioContinuousMode');
  }

  /// Stop continuous playback
  void stopContinuousPlayback() {
    _continuousModeEnabled = false;
    _continuousSubscription?.cancel();
    _continuousSubscription = null;
    if (_ayahCompleter != null && !_ayahCompleter!.isCompleted) {
        _ayahCompleter!.complete();
    }
    pausePlayer();
  }
}
