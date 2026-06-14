import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme.dart';
import '../core/responsive.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final pad = Responsive.pagePadding(context);
    return isMobile ? _MobileHero(pad: pad) : _DesktopHero(pad: pad);
  }
}

class _DesktopHero extends StatelessWidget {
  final double pad;
  const _DesktopHero({required this.pad});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final bigFont = (screenW * 0.09).clamp(56.0, 128.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(pad, 24, pad, 60),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: bigFont * 0.1),
                child:
                    Text(
                          'SOFTWARE',
                          style: TextStyle(
                            fontSize: bigFont * 0.13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.mutedColor(context),
                            letterSpacing: 2,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 100.ms)
                        .slideY(begin: 0.4, end: 0),
              ),
              const SizedBox(width: 16),
              Expanded(
                child:
                    Text(
                          'DEVELOPER',
                          style: TextStyle(
                            fontSize: bigFont,
                            fontWeight: FontWeight.w900,
                            height: 0.92,
                            letterSpacing: -3,
                            color: AppTheme.textColor(context),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 800.ms, delay: 200.ms)
                        .slideY(begin: 0.3, end: 0),
              ),
            ],
          ),
          Text(
                'PORTFOLIO',
                style: TextStyle(
                  fontSize: bigFont,
                  fontWeight: FontWeight.w900,
                  height: 0.92,
                  letterSpacing: -3,
                  color: AppTheme.textColor(context).withOpacity(0.07),
                ),
              )
              .animate()
              .fadeIn(duration: 800.ms, delay: 350.ms)
              .slideY(begin: 0.3, end: 0),
          const SizedBox(height: 48),
          //My photo and bio section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PhotoCard()
                  .animate()
                  .fadeIn(duration: 700.ms, delay: 600.ms)
                  .slideX(begin: -0.08, end: 0),
              const SizedBox(width: 40),
              Expanded(
                child: _BioText().animate().fadeIn(
                  duration: 700.ms,
                  delay: 750.ms,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MobileHero extends StatelessWidget {
  final double pad;
  const _MobileHero({required this.pad});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(pad, 24, pad, 40),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SOFTWARE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.mutedColor(context),
              letterSpacing: 2,
            ),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 4),

          Text(
            'DEVELOPER',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              height: 0.9,
              letterSpacing: -2,
              color: AppTheme.textColor(context),
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),

          Text(
            'PORTFOLIO',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w900,
              height: 0.9,
              letterSpacing: -2,
              color: AppTheme.textColor(context).withOpacity(0.07),
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),

          const SizedBox(height: 28),

          _PhotoCard(
            fullWidth: true,
          ).animate().fadeIn(duration: 700.ms, delay: 500.ms),

          const SizedBox(height: 24),

          _BioText().animate().fadeIn(duration: 700.ms, delay: 650.ms),
        ],
      ),
    );
  }
}

class _PhotoCard extends StatefulWidget {
  final bool fullWidth;
  const _PhotoCard({this.fullWidth = false});

  @override
  State<_PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<_PhotoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        width: widget.fullWidth ? double.infinity : 220,
        height: widget.fullWidth ? 300 : 260,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedScale(
                scale: _hovered ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                child: Image.network(
                  'https://drive.google.com/file/d/1nxddhEm4ksbd82GPWKSsAupdvUFLi9CT/view?usp=drivesdk',
                  fit: BoxFit.cover,
                  loadingBuilder: (ctx, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: AppTheme.surfaceColor(context),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: AppTheme.mutedColor(context),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/image1.jpg',
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
              Positioned(bottom: 12, left: 20, child: _RotatingBadge()),
            ],
          ),
        ),
      ),
    );
  }
}

class _BioText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, I\'m Ilechukwu Thelma.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textColor(context),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'I\'m a digital craftsperson dedicated to building high-quality, high-performance mobile and we applications. '
            'Combining my expertise in flutter and python with a strong foundation in UI/UX design, I bridge the gap between '
            'complex engineering and beautiful, user-centered experiences. Whether it\'s archutecting a mobile app from '
            'scratch or designing seamless web interfaces, I focus on delivering clean, scalable, and highly functional code '
            'that drives real value. ',
            style: TextStyle(
              fontSize: 14,
              height: 1.85,
              color: AppTheme.mutedColor(context),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Flutter',
              'Python',
              'UI/UX',
              'Web Design',
              'Mobile Apps',
            ].map((skill) => _SkillChip(label: skill)).toList(),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor(context)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: AppTheme.mutedColor(context),
        ),
      ),
    );
  }
}

class _RotatingBadge extends StatefulWidget {
  @override
  State<_RotatingBadge> createState() => _RotatingBadgeState();
}

class _RotatingBadgeState extends State<_RotatingBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Transform.rotate(
          angle: _ctrl.value * 2 * math.pi,
          child: CustomPaint(
            painter: _CircleTextPainter(
              text: 'FLUTTER • PYTHON • UI/UX • ',
              color: AppTheme.accentColor(context),
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleTextPainter extends CustomPainter {
  final String text;
  final Color color;
  _CircleTextPainter({required this.text, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2 - 2;
    final center = Offset(size.width / 2, size.height / 2);
    final angleStep = (2 * math.pi) / text.length;

    for (int i = 0; i < text.length; i++) {
      final angle = i * angleStep - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      final tp = TextPainter(textDirection: TextDirection.ltr)
        ..text = TextSpan(
          text: text[i],
          style: TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        )
        ..layout();

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + math.pi / 2);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
