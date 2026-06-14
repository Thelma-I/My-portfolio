import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/theme.dart';
import '../core/responsive.dart';
import '../core/models.dart';

class HelpSection extends StatelessWidget {
  const HelpSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(pad, 80, pad, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HelpHeading(
            isMobile: isMobile,
          ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 48),
          isMobile ? _MobileContent() : _DesktopContent(),
        ],
      ),
    );
  }
}

class _HelpHeading extends StatelessWidget {
  final bool isMobile;
  const _HelpHeading({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final fontSize = isMobile ? 36.0 : 60.0;
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          letterSpacing: -1,
          height: 1,
        ),
        children: [
          TextSpan(
            text: 'HOW ',
            style: TextStyle(color: AppTheme.textColor(context)),
          ),
          TextSpan(
            text: 'CAN',
            style: TextStyle(
              color: AppTheme.accentColor(context),
              decoration: TextDecoration.underline,
              decorationColor: AppTheme.accentColor(context),
              decorationThickness: 3,
            ),
          ),
          TextSpan(
            text: ' I HELP?',
            style: TextStyle(color: AppTheme.textColor(context)),
          ),
        ],
      ),
    );
  }
}

class _DesktopContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _BioParagraphs()
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideX(begin: -0.05, end: 0),
        ),
        const SizedBox(width: 48),
        Expanded(
          child: _SkillsPassion()
              .animate()
              .fadeIn(duration: 600.ms, delay: 350.ms)
              .slideX(begin: 0.05, end: 0),
        ),
      ],
    );
  }
}

class _MobileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BioParagraphs().animate().fadeIn(duration: 600.ms, delay: 200.ms),
        const SizedBox(height: 32),
        _SkillsPassion().animate().fadeIn(duration: 600.ms, delay: 350.ms),
      ],
    );
  }
}

class _BioParagraphs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Great software should solve complex, real world problelms in the simplest way possible. I bring value'
          '  to teams by bridging the gap between design and engineering ensuring that the underlying code is just '
          'as clean and efficient as the user interface.',
          style: TextStyle(
            fontSize: 13,
            height: 1.85,
            color: AppTheme.mutedColor(context),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Fron architecting cross platform mobile appswith Flutter to building reliable backends powered by python, Firebase and REST APIs'
          '  I focus on delivering quality at every stage of the development cycle.',
          style: TextStyle(
            fontSize: 13,
            height: 1.85,
            color: AppTheme.mutedColor(context),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'I am always excited to take on fresh challenges.  '
          'Lets\'s collaborate to bring your next product to life.'
          ' I am currently open to both freelance projects and full time roles',
          style: TextStyle(
            fontSize: 13,
            height: 1.85,
            color: AppTheme.mutedColor(context),
          ),
        ),
        const SizedBox(height: 28),
        _GitHubBtn()
            .animate()
            .fadeIn(duration: 500.ms, delay: 400.ms)
            .slideY(begin: 0.1, end: 0),
      ],
    );
  }
}

class _GitHubBtn extends StatefulWidget {
  @override
  State<_GitHubBtn> createState() => _GitHubBtnState();
}

class _GitHubBtnState extends State<_GitHubBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse('https://github.com/Thelma-I');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, webOnlyWindowName: '_blank');
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered ? AppTheme.textColor(context) : Colors.transparent,
            border: Border.all(color: AppTheme.borderColor(context)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.code,
                size: 16,
                color: _hovered
                    ? AppTheme.bgColor(context)
                    : AppTheme.textColor(context),
              ),
              const SizedBox(width: 8),
              Text(
                'View GitHub — Thelma-I',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: _hovered
                      ? AppTheme.bgColor(context)
                      : AppTheme.textColor(context),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.north_east,
                size: 13,
                color: _hovered
                    ? AppTheme.bgColor(context)
                    : AppTheme.textColor(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillsPassion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          color: AppTheme.borderColor(context),
          margin: const EdgeInsets.only(bottom: 24),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SKILLS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: AppTheme.textColor(context),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...skills.map((s) => _Item(text: s)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PASSION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: AppTheme.textColor(context),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...passions.map((p) => _Item(text: p)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final String text;
  const _Item({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.accentColor(context),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppTheme.mutedColor(context),
            ),
          ),
        ],
      ),
    );
  }
}
