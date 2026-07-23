import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Therapist extends Equatable {
  const Therapist({
    required this.id,
    required this.name,
    required this.specialty,
    required this.expertise,
    required this.priceInr,
    required this.online,
    required this.modes,
    required this.imageUrl,
    this.verified = true,
  });

  final String id;
  final String name;
  final String specialty;
  final List<String> expertise;
  final int priceInr;
  final bool online;
  final List<String> modes;
  final String imageUrl;
  final bool verified;

  @override
  List<Object?> get props => [id];
}

const _therapists = [
  Therapist(
    id: 't1',
    name: 'Dr. Ananya Sharma',
    specialty: 'Clinical Psychologist',
    expertise: ['Anxiety', 'Stress', 'Relationships'],
    priceInr: 799,
    online: true,
    modes: ['Video', 'Chat'],
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDWISqMplycW06kX4_ZSqNh15H_eLHz6luI1mub6ucWj-xS7OPWftooJPvrI43isvjrEYdNFhcWsrCxSt59C5RlwqRYrLSJwdNqcni5w0pIupeDVxNTZveZQCkYmhjyCcMZ-vieZpA06dHBMdJGOqdSm4zaaHm36Hw9ytdbm6S0F5ykzjDuFo1Nz8POt18tSg4M_7ANRavYtmo2eMgq9uomNvjQQdhD3XN9ZaNZ8HvZEGAPzPISJfI',
  ),
  Therapist(
    id: 't2',
    name: 'Dr. Rohan Mehta',
    specialty: 'Child Psychiatrist',
    expertise: ['ADHD', 'Behavior', 'Emotions'],
    priceInr: 899,
    online: true,
    modes: ['Video', 'Chat'],
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDWlGxsOZRYTKGmofJHRp_GM1INvoPN8kk-F8i_D0BMnSmcgCbEu78-TeWL6hT-a_CM-MXUnn9E3REwZONlBv7U1S5KJQrpfa2fmv14U_i1DW2SVTCUiMeqgiBOwKuAFywGJHyP-0rkdZ2ZQDkRO-4WQBrHonbUrR7-7wgDgzkyFxluoIOPmtLL1Kc7eMFh0NW5Cb_hnFkkRhf9cpUP9pH3xb-IQZpk4Wjqcb942SrI7iA7pLVa7tw',
  ),
  Therapist(
    id: 't3',
    name: 'Dr. Neha Kapoor',
    specialty: 'Counselling Psychologist',
    expertise: ['Depression', 'Self-esteem', 'Healing'],
    priceInr: 799,
    online: true,
    modes: ['Video', 'Chat'],
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBkoC1WNJ0NPFyPjo8wEliRwW7q9byv5VBOok2RFhb1G1sUmxYCSBFypabgCeoyY3ZROKMdA6qPPL4st8MEVWBg_DWZhs4vwASLa81dVH939KyPOYZto3-OXoPWcSnsPRomKtbmvG2tlzfG-qLRkSGX7jpCRD8Z9ea0cRA2jnz8--hGzGlC8dKpF6tDk7FNO619eIGFBw3SMchJ-TIVAnovOYrMf6Qar_Gymk1QFTTJ_gaPwO0vFso',
  ),
  Therapist(
    id: 't4',
    name: 'Dr. Priya Iyer',
    specialty: 'Psychiatrist',
    expertise: ['Mood', 'Trauma', 'OCD'],
    priceInr: 999,
    online: false,
    modes: ['Clinic Visit', 'Chat'],
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC_RGHC0pcvs-DV6k3x5CTnNkqYK5HFchnSwPK3fal2byBeXy3aBc591ySlPzpuaAQQYmR-AP0yGg-4AcfPyCJczZlKUKHmaj44uX_WdILj_-ClJdUi00Ey7_YYptMkwradlYg6e0AAY26DH1zURe7NRIXFMlfEqsr_uNBR696pUOxX2PJj2qZw1a6iOn704AAu4TvPbo1AhH0nqElhYuEOd3hkaowQu5JTr7ncgtk1_ucwkSb5loA',
  ),
];

class ProfessionalSupportPage extends StatefulWidget {
  const ProfessionalSupportPage({super.key});

  @override
  State<ProfessionalSupportPage> createState() => _ProfessionalSupportPageState();
}

class _ProfessionalSupportPageState extends State<ProfessionalSupportPage> {
  bool _onlineOnly = true;

  @override
  Widget build(BuildContext context) {
    final list = _therapists.where((t) => _onlineOnly ? t.online : !t.online).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Therapist',
                            style: TextStyle(
                              fontFamily: 'Hanken Grotesk',
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.eco, color: Colors.teal[600], size: 28),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Find the right support when you're ready.",
                        style: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          fontSize: 15,
                          color: Color(0xFF414751),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0x4DC1C7D3)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF414751)),
                      onPressed: () => context.push('/support/chat/general'),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            
            // Online/In-Person Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0x33C1C7D3)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x05000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    Expanded(
                      child: _Toggle(
                        label: 'Online',
                        icon: Icons.wifi,
                        selected: _onlineOnly,
                        onTap: () => setState(() => _onlineOnly = true),
                      ),
                    ),
                    Expanded(
                      child: _Toggle(
                        label: 'In-Person',
                        icon: Icons.location_on,
                        selected: !_onlineOnly,
                        onTap: () => setState(() => _onlineOnly = false),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Directory List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                itemCount: list.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, i) {
                  if (i == list.length) {
                    return Container(
                      margin: const EdgeInsets.only(top: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3EE),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFD1E7DD)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFB7DACB),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.verified_user, color: Color(0xFF2D6A4F), size: 20),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Why choose a verified therapist?',
                                  style: TextStyle(
                                    fontFamily: 'Hanken Grotesk',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'All our therapists are verified professionals committed to your well-being and privacy.',
                                  style: TextStyle(
                                    fontFamily: 'Hanken Grotesk',
                                    fontSize: 12,
                                    color: Color(0xFF414751),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  final t = list[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0x1AC1C7D3)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: ColorFiltered(
                                      colorFilter: t.online 
                                          ? const ColorFilter.mode(Colors.transparent, BlendMode.saturation)
                                          : const ColorFilter.matrix([
                                              0.2126, 0.7152, 0.0722, 0, 0,
                                              0.2126, 0.7152, 0.0722, 0, 0,
                                              0.2126, 0.7152, 0.0722, 0, 0,
                                              0, 0, 0, 1, 0,
                                            ]), // Grayscale for offline/in-person
                                      child: Image.network(
                                        t.imageUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: t.online ? Colors.green[500] : Colors.grey[300],
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    t.name,
                                                    style: const TextStyle(
                                                      fontFamily: 'Hanken Grotesk',
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF1F2937),
                                                    ),
                                                  ),
                                                ),
                                                if (t.verified) ...[
                                                  const SizedBox(width: 4),
                                                  Icon(Icons.verified, color: Colors.teal[600], size: 18),
                                                ],
                                              ],
                                            ),
                                            Text(
                                              t.specialty,
                                              style: const TextStyle(
                                                fontFamily: 'Hanken Grotesk',
                                                fontSize: 12,
                                                color: Color(0xFF414751),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              t.expertise.join(' • '),
                                              style: const TextStyle(
                                                fontFamily: 'Hanken Grotesk',
                                                fontSize: 12,
                                                color: Color(0xFF414751),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          const Text(
                                            'STARTS AT',
                                            style: TextStyle(
                                              fontFamily: 'Hanken Grotesk',
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.1,
                                              color: Color(0xFF717783),
                                            ),
                                          ),
                                          Text(
                                            '₹${t.priceInr}',
                                            style: const TextStyle(
                                              fontFamily: 'Hanken Grotesk',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1F2937),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: t.modes.map((m) {
                                      IconData iconData = Icons.chat;
                                      if (m == 'Video') iconData = Icons.videocam;
                                      if (m == 'Clinic Visit') iconData = Icons.location_on;
                                      
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 16),
                                        child: Row(
                                          children: [
                                            Icon(iconData, size: 18, color: const Color(0xFF414751)),
                                            const SizedBox(width: 6),
                                            Text(
                                              m,
                                              style: const TextStyle(
                                                fontFamily: 'Hanken Grotesk',
                                                fontSize: 12,
                                                color: Color(0xFF414751),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t.online ? 'Online' : 'In-Person',
                              style: TextStyle(
                                fontFamily: 'Hanken Grotesk',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: t.online ? Colors.green[600] : const Color(0xFF414751),
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () => context.push('/support/chat/${t.id}'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF2D6A4F),
                                  ),
                                  child: const Text('Chat', style: TextStyle(fontFamily: 'Hanken Grotesk', fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2D6A4F),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => _book(t),
                                  child: const Text('Book Now', style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 14, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _book(Therapist t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Book with ${t.name}',
                style: const TextStyle(
                  fontFamily: 'Hanken Grotesk',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose a slot that feels right. You can reschedule anytime.',
                style: TextStyle(
                  fontFamily: 'Hanken Grotesk',
                  fontSize: 15,
                  color: Color(0xFF414751),
                ),
              ),
              const SizedBox(height: 24),
              ...['Tomorrow · 10:00 AM', 'Tomorrow · 4:00 PM', 'Friday · 11:30 AM'].map(
                (slot) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x1AC1C7D3)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Appointment requested: $slot')),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Text(
                        slot,
                        style: const TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1F8F5) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? const Color(0xFF2D6A4F) : const Color(0xFF414751),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: selected ? const Color(0xFF2D6A4F) : const Color(0xFF414751),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TherapistChatPage extends StatefulWidget {
  const TherapistChatPage({super.key, required this.therapistId});

  final String therapistId;

  @override
  State<TherapistChatPage> createState() => _TherapistChatPageState();
}

class _TherapistChatPageState extends State<TherapistChatPage> {
  final _controller = TextEditingController();
  final _messages = <String>[
    'Hi — you can message your therapist here. Responses are not monitored by FreeMind AI.',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Therapist Chat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (_, i) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: i == 0 ? const Color(0xFFF2F0F7) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0x1AC1C7D3)),
                ),
                child: Text(
                  _messages[i],
                  style: const TextStyle(fontFamily: 'Hanken Grotesk'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0x1AC1C7D3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Write a message…',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF2D6A4F),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: () {
                        if (_controller.text.trim().isEmpty) return;
                        setState(() {
                          _messages.add(_controller.text.trim());
                          _controller.clear();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
