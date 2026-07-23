import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/circle_icon_button.dart';

class ToolkitPage extends StatelessWidget {
  const ToolkitPage({super.key, this.onOpenDrawer});

  final VoidCallback? onOpenDrawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 120),
              children: [
                const Text(
                  'Simple tools for a calmer, healthier you.',
                  style: TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 17,
                    color: Color(0xFF414751),
                  ),
                ),
                const SizedBox(height: 40),
                
                // Mind & Body Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mind & Body',
                      style: TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191C21),
                      ),
                    ),
                    const Icon(Icons.eco, color: Color(0x992D6A4F)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Move, breathe and reset.',
                  style: TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 15,
                    color: Color(0xFF414751),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Categories Tags
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTag(
                        icon: Icons.directions_run,
                        label: 'Exercise',
                        isSelected: true,
                      ),
                      const SizedBox(width: 8),
                      _buildTag(
                        icon: Icons.self_improvement,
                        label: 'Meditation',
                      ),
                      const SizedBox(width: 8),
                      _buildTag(
                        icon: Icons.self_improvement,
                        label: 'Yoga',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Quick Picks
                const Text(
                  'Quick Picks',
                  style: TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191C21),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: [
                      _buildQuickPickCard(
                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuALiCS-lBP-x5yZf_sT0L42tkAGm8jkrsogvDUSWf0Bo8EIeZu0yebEsdouKnOoQZEzmr8Aa-l6COkSurpf-tsOHPVKnIfGzDzhH-zwrBHoE0EYVtQq6PKkbaNmjFdhh2_7tAZK93lPczqZDooa7Ww87etBoG5csfiKMA8rXYEBOpxfPntHNIE8wH1LPInUie7Jgl9hmY5MTatEELmrQ6GUfgPoDpHC6BIGdls51hvJmR4OLz3-hRYlFupbO_mfmr46CzNrnTkpTA',
                        time: '12 min',
                        title: 'Morning Energy',
                        subtitle: 'A quick routine to boost your energy.',
                      ),
                      const SizedBox(width: 16),
                      _buildQuickPickCard(
                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDpIWnem-MEXtVraOWfRhMGqIsmZb0OIXgYTzoaWTskdXQJZGeDPH1Cc9R2TyJZ4nTJtLBsnng0VjTJkcJkNBEMolZAc_pUcR3DEq7M4y04af0kbkM_zu4rjZc2zAC3dV0Ykg6uhNL7ngwgY7rWuVPFKv2hFJMB1Thg-YOtq6kxymJHbHdG60XUEyFJ8vo5TI9cZg_-VjMkzDsUt6y3Niaeg6L6-4vJHxK7hOJ2k6z_uFzEZCt6v2CeUpLP3Er1S0sRCJUtXKIwig',
                        time: '15 min',
                        title: 'Strength Builder',
                        subtitle: 'Build strength with simple moves.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                
                // Resources Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Resources',
                      style: TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191C21),
                      ),
                    ),
                    const Icon(Icons.auto_stories, color: Color(0x99005DA7)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Learn, explore and grow.',
                  style: TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 15,
                    color: Color(0xFF414751),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Tabs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildResourceTab(icon: Icons.menu_book, label: 'Books', isSelected: true),
                    _buildResourceTab(icon: Icons.play_circle, label: 'Videos'),
                    _buildResourceTab(icon: Icons.chat_bubble, label: 'Stories'),
                    _buildResourceTab(icon: Icons.music_note, label: 'Sounds'),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Resource List
                _buildResourceItem(
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCqZ0Q9VMiSYXOSj1x2OQXR_fjQDQt2A1L_sY6q9qThy_LltAuh79SkmRjvt6j6JkHIPpIXKAZAF9wn9BBGivuQV0VmculUuV2eqCL0tIItWO3zTWg187oPbuxxwGYL9-SePhApln7DJJKly27P959tQ2KC5n2jLNNLrhQN4IXZ7rStuDqk2uusG3XYzsUFtL-Z14aPCLbCp6roJiI878jH_j514VbQhxyW8ynhFspT1p45qqnw0FEhyPxbYxhmDg54y1TFShX05Q',
                  title: 'The Power of Now',
                  subtitle: 'A guide to living in the present and finding peace within.',
                  type: 'Book',
                  bgColor: const Color(0xFFE8F5E9),
                ),
                const SizedBox(height: 16),
                _buildResourceItem(
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB54RpgtCL2unXpzGq1MPC41rxaGZ5nHD_8K0Gtntg_nKbO5NSwIpSzU2xf02mfrdoA4TQvsYtTVba_ChOnmPY1gF2zH8ZqC3cI87HVXrmYfP7nMySeYCM-A5tN7vBkT292UNIR6m47gBdOAISNRWdXluPEFz56HC5jZm1REBwT9MHJyBoIAHHCnVSMPw_UUc38CNi66Q2SCRj7rnVQMPOCNRCTC-uCkQbcp6Ghc8Kie0Nfu-uL-QcNpE_GXRpTiUIujfTiBHwooQ',
                  title: 'Why We Sleep',
                  subtitle: 'The new science of sleep and dreams.',
                  type: 'Book',
                  bgColor: const Color(0xFFF3E5F5),
                ),
                const SizedBox(height: 40),
                
                // Routine Card
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F3FB),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0x1AC1C7D3)),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x0A000000),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: const Icon(Icons.calendar_today, color: Color(0xFF2D6A4F)),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Stay Consistent',
                              style: TextStyle(
                                fontFamily: 'Hanken Grotesk',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF191C21),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Small steps every day lead to big changes.',
                              style: TextStyle(
                                fontFamily: 'Hanken Grotesk',
                                fontSize: 13,
                                color: Color(0xFF414751),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: Container(
                  color: const Color(0xD9F8F9FF),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      CircleIconButton(
                        icon: Icons.menu_rounded,
                        onPressed: onOpenDrawer ?? () {},
                        backgroundColor: Colors.transparent,
                        shadow: false,
                        iconColor: const Color(0xFF44474E),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Wellness Toolkit',
                        style: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191C21),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.eco, color: Color(0x992D6A4F), size: 24),
                      const Spacer(),
                      CircleIconButton(
                        icon: Icons.favorite_border_rounded,
                        onPressed: () {},
                        backgroundColor: Colors.white,
                        shadow: true,
                        iconColor: const Color(0xFF414751),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Start Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D6A4F),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x332D6A4F),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Start Your Routine',
                            style: TextStyle(
                              fontFamily: 'Hanken Grotesk',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.chevron_right, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag({required IconData icon, required String label, bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2D6A4F) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: isSelected ? null : Border.all(color: const Color(0x4DC1C7D3)),
        boxShadow: isSelected
            ? const [
                BoxShadow(
                  color: Color(0x332D6A4F),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : const Color(0xFF414751),
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Hanken Grotesk',
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF414751),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPickCard({
    required String imageUrl,
    required String time,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1AC1C7D3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      time,
                      style: const TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191C21),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          fontSize: 13,
                          color: Color(0xFF414751),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF414751)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceTab({required IconData icon, required String label, bool isSelected = false}) {
    return Column(
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFF005DA7) : const Color(0x99414751),
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Hanken Grotesk',
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFF005DA7) : const Color(0x99414751),
          ),
        ),
        const SizedBox(height: 12),
        if (isSelected)
          Container(
            width: 48,
            height: 2,
            color: const Color(0xFF005DA7),
          )
        else
          const SizedBox(height: 2),
      ],
    );
  }

  Widget _buildResourceItem({
    required String imageUrl,
    required String title,
    required String subtitle,
    required String type,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1AC1C7D3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 80,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x1AC1C7D3)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191C21),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 13,
                    color: Color(0xFF414751),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  type,
                  style: const TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF005DA7),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFFC1C7D3)),
        ],
      ),
    );
  }
}
