import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/so_loud.dart';
import 'package:hinges_frontend/features/game/domain/entities/game_data_entity.dart';
import 'package:hinges_frontend/features/game/presentation/bloc/game_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../mini_auction/presentation/pages/mini_auction_screen.dart';

class _Instruction {
  final String text;
  final int audioIndex;
  const _Instruction(this.text, this.audioIndex);
}

class _Slide {
  final List<_Instruction> instructions;
  const _Slide(this.instructions);
}

const List<_Slide> _slides = [
  _Slide([
    _Instruction('WELCOME TO INDIAN BIDDING LEAGUE', 0),
    _Instruction('YOU GUYS HAVE ENTERED', 1),
    _Instruction('MINI AUCTION LITE', 2),
    _Instruction('CLASSIC ROOM', 3),
  ]),
  _Slide([
    _Instruction('READ THE RULE BOOK CLEARLY', 4),
    _Instruction('USE YOUR PURSE AMOUNT WISELY', 5),
    _Instruction('ALWAYS HAVE A LOOK ON YOUR MY SQUAD', 6),
    _Instruction('ONLY QUALIFIED USERS ARE ELIGIBLE FOR PRIZE REWARDS', 7),
  ]),
  _Slide([
    _Instruction("DON'T RUSH FOR THE BID", 8),
    _Instruction("YOU CAN ALWAYS MANAGE THE UNFILLED SLOTS IN THE ACCELERATED SET. SO, PLAN YOUR AUCTION STRATEGIES CAREFULLY", 9),
  ]),
  // Last slide: audio plays but text is NOT shown — _buildDoneScreen shows instead
  _Slide([
    _Instruction('AUCTION STARTS IN', 10),
  ]),
];

// Total slides minus the last (which is silent/done screen)
int _visibleSlides = _slides.length - 1;

class StrategicBreakWidget extends StatefulWidget {
  final MiniAuctionLiteMode mode;
  const StrategicBreakWidget({super.key, required this.mode});

  @override
  State<StrategicBreakWidget> createState() => _StrategicBreakWidgetState();
}

class _StrategicBreakWidgetState extends State<StrategicBreakWidget>
    with TickerProviderStateMixin {

  int _slideIndex = 0;
  int _instrIndex = 0;
  bool _showDoneScreen = false; // true when last slide starts
  bool _isPlaying = false;

  final List<String> _visibleTexts = [];

  // Fade animation for each incoming instruction line
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _playNext();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _playNext() async {
    if (!mounted || _isPlaying) return;

    // All slides done
    if (_slideIndex >= _slides.length) return;

    final slide = _slides[_slideIndex];

    // All instructions in this slide done → move to next slide
    if (_instrIndex >= slide.instructions.length) {
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() {
        _slideIndex++;
        _instrIndex = 0;
        _visibleTexts.clear();
      });

      // If we just entered the last slide → show done screen immediately
      // and play the audio in background
      if (_slideIndex == _slides.length - 1) {
        setState(() => _showDoneScreen = true);
        _playLastSlideAudio();
        return;
      }

      _playNext();
      return;
    }

    _isPlaying = true;
    final instruction = slide.instructions[_instrIndex];

    // Add text and fade it in
    setState(() => _visibleTexts.add(instruction.text));
    _fadeController.forward(from: 0);

    await playInstruction(
      instruction.audioIndex,
      onComplete: () {
        _isPlaying = false;
        if (mounted) {
          setState(() => _instrIndex++);
          _playNext();
        }
      },
    );
  }

  /// Plays last slide audio silently while done screen is already visible.
  void _playLastSlideAudio() {
    final lastInstruction = _slides.last.instructions.first;
    playInstruction(
      lastInstruction.audioIndex,
      onComplete: () {}, // nothing to do after
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      listener: (context, state) {},
      child: _showDoneScreen ? _buildDoneScreen() : _buildSlideScreen(),
    );
  }

  Widget _buildSlideScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < _visibleTexts.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: i == _visibleTexts.length - 1
                // Latest line: fade in
                    ? FadeTransition(
                  opacity: _fadeAnimation,
                  child: _textLine(_visibleTexts[i]),
                )
                // Previous lines: fully visible, static
                    : _textLine(_visibleTexts[i]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _textLine(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppImages.goldenStarLine, width: 20),
        Flexible(
          child: Text(
            '  $text  ',
            textAlign: TextAlign.center,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                color: AppTheme.borderGold,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Image.asset(AppImages.goldenStarLine, width: 20),
        ),
      ],
    );
  }

  Widget _buildDoneScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHeader(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppImages.indianBiddingLeague, width: 100, height: 100),
        const SizedBox(width: 20),
        Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(AppImages.goldenFrame),
                ),
              ),
              child: Text(
                'MINI AUCTION LITE',
                style: GoogleFonts.rajdhani(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.borderGold,
                ),
              ),
            ),
            _starRow('${widget.mode.miniAuctionItem.name} ROOM'),
            _buildCountdown(),
          ],
        ),
      ],
    );
  }

  Widget _starRow(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppImages.goldenStarLine, width: 30),
        Text(
          '  $label  ',
          style: GoogleFonts.rajdhani(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Image.asset(AppImages.goldenStarLine, width: 30),
        ),
      ],
    );
  }

  Widget _buildCountdown() {
    return Column(
      spacing: 5,
      children: [
        Text(
          'AUCTION STARTS IN',
          style: GoogleFonts.rajdhani(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: Colors.cyan),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<GameBloc, GameState>(
                builder: (context, state) {
                  if (state is GameLoaded) {
                    return Text(
                      '${state.remainingSecondsToExpireBreak!.toInt() - 5}',
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          color: AppTheme.borderGold,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              Text(
                'Sec',
                style: GoogleFonts.rajdhani(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}