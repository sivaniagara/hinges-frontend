import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/so_loud.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/user_data_entity.dart';
import '../pages/profile_screen.dart';
import '../widgets/currency_bar.dart';

class TopUserBar extends StatelessWidget {
  final bool loading;
  final UserDataEntity? userData;
  final void Function()? onAddTap;

  /// Optional key placed around the CurrencyBar so callers (e.g.
  /// HomeScreen) can locate its exact on-screen position and target
  /// it with the coin-burst / "coins flying in" animation.
  final GlobalKey? currencyBarKey;

  const TopUserBar({
    super.key,
    required this.loading,
    required this.userData,
    required this.onAddTap,
    this.currencyBarKey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10,),
        GestureDetector(
          onTap: () {
            if (userData != null) {
              playSoundFromList(8);
              context.push('/profile');
            }
          },
          child: _ProfileCard(
            loading: loading,
            name: userData?.userName ?? "USER",
          ),
        ),

        const SizedBox(width: 20),

        KeyedSubtree(
          key: currencyBarKey,
          child: CurrencyBar(
            icon: AppImages.coinMenuIcon,
            value: userData?.coinWon ?? 0,
            onAddTap: onAddTap,
          ),
        ),
      ],
    );
  }
}

/// ================= PROFILE CARD =================
class _ProfileCard extends StatelessWidget {
  final bool loading;
  final String name;

  const _ProfileCard({
    required this.loading,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber),
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
      child: Row(
        children: [
          Image.asset(AppImages.user, width: 25,),
          // const Icon(Icons.person, color: Colors.amber),
          const SizedBox(width: 6),
          Text(
            loading ? "..." : name.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}