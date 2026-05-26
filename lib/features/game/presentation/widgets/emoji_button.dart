import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hinges_frontend/features/game/presentation/bloc/game_bloc.dart';

import '../../../home/presentation/bloc/home_bloc.dart';

class EmojiButton extends StatefulWidget {
  const EmojiButton({super.key});

  @override
  State<EmojiButton> createState() => _EmojiButtonState();
}

class _EmojiButtonState extends State<EmojiButton> {
  OverlayEntry? _overlayEntry;

  void _toggleEmojiPopup() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var position = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          /// 👇 FULL SCREEN TAP DETECTOR (BACKGROUND)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
              },
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),

          /// 👇 YOUR EMOJI POPUP
          Positioned(
            left: position.dx - 80,
            top: position.dy - 100,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 160,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.greenAccent),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.4),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    _emoji("😀"),
                    _emoji("😂"),
                    _emoji("😍"),
                    _emoji("😎"),
                    _emoji("🔥"),
                    _emoji("👍"),
                    _emoji("🎯"),
                    _emoji("💯"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emoji(String emoji) {
    return GestureDetector(
      onTap: () {
        print("Selected: $emoji");

        // 👉 your logic (send to backend / UI update)

        _overlayEntry?.remove();
        _overlayEntry = null;
        final homeLoaded = context.read<HomeBloc>().state as HomeLoaded;
        context.read<GameBloc>().add(ReactEvent(homeLoaded.userData.userId, emoji));
      },
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleEmojiPopup,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          '😊',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}