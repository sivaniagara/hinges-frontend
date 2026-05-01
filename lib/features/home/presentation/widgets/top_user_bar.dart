import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/user_data_entity.dart';
import '../pages/profile_screen.dart';
import '../widgets/currency_bar.dart';

class TopUserBar extends StatelessWidget {
  final bool loading;
  final UserDataEntity? userData;

  const TopUserBar({
    super.key,
    required this.loading,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (userData != null) {
              context.push('/profile');
            }
          },
          child: _ProfileCard(
            loading: loading,
            name: userData?.userName ?? "USER",
          ),
        ),

        const SizedBox(width: 20),

        CurrencyBar(
          icon: AppImages.coinMenuIcon,
          value: userData?.coinWon ?? 0,
          onAddTap: () {
            // handle coin add
          },
        ),

        const SizedBox(width: 20),

        CurrencyBar(
          icon: AppImages.diamondMenuIcon,
          value: userData?.coinWon ?? 0,
          onAddTap: () {
            // handle diamond add
          },
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
          const Icon(Icons.person, color: Colors.amber),
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