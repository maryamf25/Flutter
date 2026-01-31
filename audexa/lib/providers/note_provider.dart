import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:uuid/uuid.dart';
import '../models/voice_note.dart';

class NoteProvider extends ChangeNotifier {
  List<VoiceNote> _notes = [];
  bool _isLoading = true;
  String _searchQuery = '';

  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _keepAlive = false;

  bool _isListeningInternal = false;

  String _finalizedText = "";
  String _currentWords = "";

  Timer? _reconnectTimer;

  NoteProvider() {
    _loadNotes();
    _initSpeech();
  }

  String get currentText {
    if (_finalizedText.isEmpty) return _currentWords;
    if (_currentWords.isEmpty) return _finalizedText;

    if (_currentWords.toLowerCase().startsWith(_finalizedText.toLowerCase())) {
      return _currentWords;
    }

    return "$_finalizedText $_currentWords";
  }

  List<VoiceNote> get notes {
    if (_searchQuery.isEmpty) {
      return List.from(_notes)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      final q = _searchQuery.toLowerCase();
      return _notes.where((note) {
        return note.title.toLowerCase().contains(q) ||
            note.content.toLowerCase().contains(q);
      }).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
  }

  bool get isLoading => _isLoading;
  bool get isListening => _keepAlive;

  void _initSpeech() async {
    try {
      await _speech.initialize(
        onStatus: _onStatus,
        onError: _onError,
        debugLogging: true,
      );
    } catch (e) {
      print("Init Error: $e");
    }
    notifyListeners();
  }

  void _onStatus(String status) {
    if (status == 'listening') {
      _isListeningInternal = true;
      _reconnectTimer?.cancel();
    } else if (status == 'notListening' || status == 'done') {
      bool wasListening = _isListeningInternal;
      _isListeningInternal = false;

      if (_keepAlive) {
        if (wasListening) {
          _commitCurrentText();
        }
        _scheduleReconnect(delayMs: 150);
      }
    }
    notifyListeners();
  }

  void _onError(SpeechRecognitionError error) {
    if (_keepAlive) {
      bool isNoMatch = error.errorMsg.contains('error_no_match');
      int waitTime = error.errorMsg.contains('busy') ? 1000 : 200;

      _isListeningInternal = false;
      _scheduleReconnect(delayMs: isNoMatch ? 50 : waitTime);
    }
  }

  void _scheduleReconnect({required int delayMs}) {
    if (_reconnectTimer != null && _reconnectTimer!.isActive) return;

    _reconnectTimer = Timer(Duration(milliseconds: delayMs), () async {
      if (!_keepAlive) return;

      try {
        if (_isListeningInternal) {
          await _speech.stop();
        }
        await _startListeningInternal();
      } catch (e) {
        _scheduleReconnect(delayMs: 1000);
      }
    });
  }

  void startListening(Function(String) onResult) async {
    _keepAlive = true;
    _finalizedText = "";
    _currentWords = "";

    await _startListeningInternal();
    notifyListeners();
  }

  Future<void> _startListeningInternal() async {
    if (!_keepAlive) return;

    if (_currentWords.isNotEmpty) {
      _commitCurrentText();
    }

    _currentWords = "";
    notifyListeners();

    await _speech.listen(
      onResult: (result) {
        _currentWords = result.recognizedWords;
        if (result.finalResult) {
          _commitCurrentText();
        }
        notifyListeners();
      },
      listenFor: const Duration(minutes: 5),
      pauseFor: const Duration(seconds: 5),
      localeId: "en_US",
      onDevice: true,
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
        listenMode: stt.ListenMode.dictation,
      ),
    );
  }

  void stopListening() async {
    _keepAlive = false;
    _reconnectTimer?.cancel();

    await _speech.stop();
    _commitCurrentText();
    _currentWords = "";

    notifyListeners();
  }

  void _commitCurrentText() {
    if (_currentWords.isNotEmpty) {
      String newText = _currentWords.trim();
      String oldText = _finalizedText.trim();

      if (oldText.endsWith(newText)) {
        _currentWords = "";
        return;
      }

      if (newText.toLowerCase().startsWith(oldText.toLowerCase()) &&
          oldText.isNotEmpty) {
        _finalizedText = newText;
      }
      else {
        _finalizedText += (oldText.isEmpty ? "" : " ") + newText;
      }

      _currentWords = "";
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString('voice_notes_data');
    if (notesJson != null) {
      final List<dynamic> decoded = jsonDecode(notesJson);
      _notes = decoded.map((e) => VoiceNote.fromMap(e)).toList();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_notes.map((e) => e.toMap()).toList());
    await prefs.setString('voice_notes_data', encoded);
    notifyListeners();
  }

  void addNote(String title, String content, {String? audioFilePath}) {
    final newNote = VoiceNote(
      id: const Uuid().v4(),
      title: title.isEmpty ? "New Note" : title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      audioFilePath: audioFilePath,
    );
    _notes.add(newNote);
    _saveNotes();
  }

  void updateNote(String id, String newTitle, String newContent) {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notes[index].title = newTitle;
      _notes[index].content = newContent;
      _notes[index].updatedAt = DateTime.now();
      _saveNotes();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    _saveNotes();
  }

  void deleteAllNotes() {
    _notes.clear();
    _saveNotes();
  }
}
