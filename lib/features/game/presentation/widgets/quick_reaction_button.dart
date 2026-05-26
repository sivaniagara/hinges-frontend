import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hinges_frontend/features/game/presentation/bloc/game_bloc.dart';
import '../../../home/presentation/bloc/home_bloc.dart';

class QuickReactionButton extends StatefulWidget {
  const QuickReactionButton({super.key});

  @override
  State<QuickReactionButton> createState() => _QuickReactionButtonState();
}

class _QuickReactionButtonState extends State<QuickReactionButton> {
  OverlayEntry? _overlayEntry;

  final List<Map<String, String>> quickMessages = [
    {"emoji": "🔥", "text": "War started!!"},
    {"emoji": "😎", "text": "Easy win!"},
    {"emoji": "💯", "text": "Let’s go!"},
    {"emoji": "😂", "text": "Too funny!"},
    {"emoji": "😡", "text": "Come on!!"},
    {"emoji": "👏", "text": "Nice move!"},
  ];

  void _togglePopup() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var position = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          /// 🔹 Background tap to close
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

          /// 🔹 Popup
          Positioned(
            left: position.dx - 250,
            top: position.dy - 180,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 300,
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
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: quickMessages.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 3,
                  ),
                  itemBuilder: (context, index) {
                    final item = quickMessages[index];
                    return _quickItem(item["emoji"]!, item["text"]!);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickItem(String emoji, String text) {
    return GestureDetector(
      onTap: () {
        final message = "$emoji $text";

        print("Selected: $message");

        _overlayEntry?.remove();
        _overlayEntry = null;

        final homeLoaded = context.read<HomeBloc>().state as HomeLoaded;

        context.read<GameBloc>().add(
          ReactEvent(homeLoaded.userData.userId, message),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.greenAccent),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePopup,
      child: const Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          '💬',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}