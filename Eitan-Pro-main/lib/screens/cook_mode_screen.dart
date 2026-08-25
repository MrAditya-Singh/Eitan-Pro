import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:cook_app/models/cook_mode_recipe.dart';
import 'package:cook_app/services/ai_service.dart';
import 'dart:async';

class CookModeScreen extends StatefulWidget {
  final String? videoTitle;
  final String? videoUrl;
  final CookModeRecipe? initialRecipe;

  const CookModeScreen({super.key, this.videoTitle, this.videoUrl, this.initialRecipe});

  @override
  State<CookModeScreen> createState() => _CookModeScreenState();
}

class _CookModeScreenState extends State<CookModeScreen> with TickerProviderStateMixin {
  final AiService _aiService = AiService();
  CookModeRecipe? _recipe;
  int _currentStepIndex = 0;
  bool _isLoading = true;
  
  // Voice & Timer
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  Timer? _activeTimer;
  int _timerSecondsRemaining = 0;

  // AI Chat
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _chatMessages = [];
  bool _isChatLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialRecipe != null) {
      _recipe = widget.initialRecipe;
      _isLoading = false;
      _speakInstruction();
    } else {
      _loadRecipe();
    }
    _initVoice();
  }

  void _initVoice() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _loadRecipe() async {
    // 1. Fetch recipe using AI (mock or real)
    final recipe = await _aiService.generateCookModeData(
      widget.videoTitle ?? 'Unknown Recipe', 
      'Recipe from ${widget.videoUrl ?? 'video'}'
    );
    
    if (mounted) {
      setState(() {
        _recipe = recipe;
        _isLoading = false;
      });
      _speakInstruction();
    }
  }

  Future<void> _speakInstruction() async {
    if (_recipe != null && _recipe!.steps.isNotEmpty) {
      await _flutterTts.speak(_recipe!.steps[_currentStepIndex].instruction);
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
             if (mounted) setState(() => _isListening = false);
          }
        },
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
             if (val.finalResult) {
               _processVoiceCommand(val.recognizedWords);
             }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _processVoiceCommand(String command) {
    command = command.toLowerCase();
    if (command.contains('next')) {
      _nextStep();
    } else if (command.contains('back') || command.contains('previous')) {
      _prevStep();
    } else if (command.contains('repeat')) {
      _speakInstruction();
    } else if (command.contains('timer')) {
      // Simple parsing "timer for 5 minutes"
      final RegExp regex = RegExp(r'(\d+) minute');
      final match = regex.firstMatch(command);
      if (match != null) {
        final minutes = int.tryParse(match.group(1)!) ?? 0;
        if (minutes > 0) _toggleTimer(minutes * 60);
      }
    }
  }

  void _nextStep() {
    if (_recipe != null && _currentStepIndex < _recipe!.steps.length - 1) {
      setState(() => _currentStepIndex++);
      _speakInstruction();
    }
  }

  void _prevStep() {
    if (_currentStepIndex > 0) {
      setState(() => _currentStepIndex--);
      _speakInstruction();
    }
  }

  void _toggleTimer(int duration) {
    if (_activeTimer != null) {
      _activeTimer!.cancel();
      _activeTimer = null;
      setState(() => _timerSecondsRemaining = 0);
    } else {
      setState(() => _timerSecondsRemaining = duration);
      _activeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            if (_timerSecondsRemaining > 0) {
              _timerSecondsRemaining--;
            } else {
              timer.cancel();
              _activeTimer = null;
              _flutterTts.speak("Timer finished!");
            }
          });
        }
      });
    }
  }

  void _openAiChat() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildAiChatPanel(),
    );
  }

  @override
  void dispose() {
    _activeTimer?.cancel();
    _chatController.dispose();
    _flutterTts.stop();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dark Mode Colors
    const Color bgCharcoal = Color(0xFF121212);
    const Color accentElectricBlue = Color(0xFF2979FF); // Electric Blue
    // const Color accentNeonPurple = Color(0xFFD500F9);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: bgCharcoal,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: accentElectricBlue),
              const SizedBox(height: 20),
              Text(
                'Consulting AI Chef...',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), letterSpacing: 1.5),
              ),
              const SizedBox(height: 10),
              Text(
                'Analyzing "${widget.videoTitle ?? 'Video'}"',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    final step = _recipe!.steps[_currentStepIndex];
    final totalSteps = _recipe!.steps.length;
    final progress = ( _currentStepIndex + 1 ) / totalSteps;

    return Scaffold(
      backgroundColor: bgCharcoal,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white54),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'STEP ${_currentStepIndex + 1} OF $totalSteps',
                        style: const TextStyle(
                          color: accentElectricBlue,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          fontSize: 12,
                        ),
                      ),
                      IconButton(
                        icon: Icon(_isListening ? Icons.mic : Icons.mic_none, 
                                   color: _isListening ? Colors.redAccent : Colors.white54),
                        onPressed: _listen,
                      ),
                    ],
                  ),
                ),

                // Progress Indicator
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white10,
                  color: accentElectricBlue,
                  minHeight: 2,
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Instruction
                        Text(
                          step.instruction,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28, // Large typography
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                            fontFamily: 'Roboto', // Or system default sans-serif
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Ingredients
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: step.ingredientsHighlighted.map((ing) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                              color: accentElectricBlue.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: accentElectricBlue.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              ing,
                              style: const TextStyle(
                                color: accentElectricBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          )).toList(),
                        ),

                        // Smart Timer
                        if (step.timerDurationSeconds != null) ...[
                          const SizedBox(height: 40),
                          Center(
                            child: GestureDetector(
                              onTap: () => _toggleTimer(step.timerDurationSeconds!),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                decoration: BoxDecoration(
                                  color: _activeTimer != null ? Colors.orangeAccent : Colors.white10,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    if (_activeTimer != null)
                                      BoxShadow(color: Colors.orangeAccent.withValues(alpha: 0.4), blurRadius: 20)
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _activeTimer != null ? Icons.timer_off : Icons.timer, 
                                      color: _activeTimer != null ? Colors.black : Colors.white
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      _activeTimer != null 
                                          ? '${(_timerSecondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_timerSecondsRemaining % 60).toString().padLeft(2, '0')}'
                                          : '${step.timerDurationSeconds! ~/ 60} MIN TIMER',
                                      style: TextStyle(
                                        color: _activeTimer != null ? Colors.black : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Navigation Controls
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white54),
                        onPressed: _currentStepIndex > 0 ? _prevStep : null,
                        iconSize: 30,
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                        onPressed: _currentStepIndex < totalSteps - 1 ? _nextStep : () => Navigator.pop(context),
                        iconSize: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // AI Chef Bubble
            Positioned(
              bottom: 100,
              right: 20,
              child: FloatingActionButton(
                onPressed: _openAiChat,
                backgroundColor: accentElectricBlue,
                child: const Icon(Icons.auto_awesome, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiChatPanel() {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 500,
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white10)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFF2979FF)),
                  SizedBox(width: 10),
                  Text(
                    'AI CHEF ASSISTANT',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                  ),
                  Spacer(),
                  CloseButton(color: Colors.white54),
                ],
              ),
            ),

            // Messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _chatMessages.length,
                itemBuilder: (context, index) {
                  final msg = _chatMessages[index];
                  final isUser = msg['role'] == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: isUser ? const Color(0xFF2979FF) : Colors.white10,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
                          bottomRight: isUser ? Radius.zero : const Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        msg['text']!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            if (_isChatLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: LinearProgressIndicator(color: Color(0xFF2979FF), backgroundColor: Colors.transparent),
              ),

            // Input
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Ask about this step...',
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF2979FF)),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _chatMessages.add({'role': 'user', 'text': text});
      _chatController.clear();
      _isChatLoading = true;
    });

    // Call AI
    final currentInstruction = _recipe?.steps[_currentStepIndex].instruction ?? '';
    final response = await _aiService.chatWithChef(text, 'Current step: $currentInstruction');

    if (mounted) {
      setState(() {
        _isChatLoading = false;
        _chatMessages.add({'role': 'assistant', 'text': response});
      });
    }
  }
}
