import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/theme.dart';
import '../core/responsive.dart';
import '../core/email_service.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.borderColor(context), width: 1),
        ),
      ),
      child: Column(
        children: [
          _ContactHeading(
            isMobile: isMobile,
            pad: pad,
          ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.15, end: 0),

          Padding(
            padding: EdgeInsets.fromLTRB(pad, 40, pad, 40),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _ContactForm(),
                      const SizedBox(height: 48),
                      _ContactInfo(isMobile: isMobile),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: _ContactForm()),
                      const SizedBox(width: 64),
                      Expanded(child: _ContactInfo(isMobile: isMobile)),
                    ],
                  ),
          ),

          _BottomRow(
            isMobile: isMobile,
            pad: pad,
          ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
        ],
      ),
    );
  }
}

class _ContactHeading extends StatelessWidget {
  final bool isMobile;
  final double pad;
  const _ContactHeading({required this.isMobile, required this.pad});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final fontSize = (screenW * 0.14).clamp(60.0, 200.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(pad, 60, pad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CONTACT',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              height: 0.9,
              letterSpacing: -4,
              color: AppTheme.textColor(context),
            ),
          ),
          Text(
            'ME',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              height: 0.9,
              letterSpacing: -4,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = AppTheme.textColor(context).withOpacity(0.25),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _ContactForm extends StatefulWidget {
  const _ContactForm();

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  bool _isSending = false;
  String? _statusMessage;
  bool _statusIsError = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSending = true;
      _statusMessage = null;
    });

    final success = await EmailService.sendMessage(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      message: _messageCtrl.text.trim(),
    );

    setState(() {
      _isSending = false;
      if (success) {
        _statusMessage = 'Message sent! I\'ll get back to you soon 🎉';
        _statusIsError = false;
        _nameCtrl.clear();
        _emailCtrl.clear();
        _messageCtrl.clear();
        _formKey.currentState!.reset();
      } else {
        _statusMessage =
            'Something went wrong. Please try again or email me directly.';
        _statusIsError = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SEND A MESSAGE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: AppTheme.textColor(context),
            ),
          ),
          const SizedBox(height: 20),

          _FormField(
            controller: _nameCtrl,
            hint: 'Your Name',
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Please enter your name'
                : null,
          ),
          const SizedBox(height: 16),

          _FormField(
            controller: _emailCtrl,
            hint: 'Your Email',
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty)
                return 'Please enter your email';
              if (!v.contains('@') || !v.contains('.'))
                return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16),

          _FormField(
            controller: _messageCtrl,
            hint: 'Your Message',
            maxLines: 6,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Please enter a message'
                : null,
          ),
          const SizedBox(height: 20),

          _SubmitButton(
            isLoading: _isSending,
            onTap: _isSending ? null : _submit,
          ),

          if (_statusMessage != null) ...[
            const SizedBox(height: 16),
            AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _statusIsError
                        ? Colors.red.withOpacity(0.4)
                        : AppTheme.accentColor(context).withOpacity(0.4),
                  ),
                  borderRadius: BorderRadius.circular(4),
                  color: _statusIsError
                      ? Colors.red.withOpacity(0.05)
                      : AppTheme.accentColor(context).withOpacity(0.08),
                ),
                child: Text(
                  _statusMessage!,
                  style: TextStyle(
                    fontSize: 12,
                    color: _statusIsError
                        ? Colors.red
                        : AppTheme.accentColor(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FormField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _FormField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  State<_FormField> createState() => _FormFieldState();
}

class _FormFieldState extends State<_FormField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _focused = focused),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: Border.all(
            color: _focused
                ? AppTheme.accentColor(context)
                : AppTheme.borderColor(context),
            width: _focused ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextFormField(
          controller: widget.controller,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          style: TextStyle(fontSize: 13, color: AppTheme.textColor(context)),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontSize: 13,
              color: AppTheme.mutedColor(context),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: InputBorder.none,
            errorStyle: const TextStyle(fontSize: 11),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback? onTap;

  const _SubmitButton({required this.isLoading, required this.onTap});

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered
                ? AppTheme.accentColor(context)
                : AppTheme.textColor(context),
            borderRadius: BorderRadius.circular(4),
          ),
          child: widget.isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.bgColor(context),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SEND MESSAGE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: AppTheme.bgColor(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.send_rounded,
                      size: 14,
                      color: AppTheme.bgColor(context),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final bool isMobile;
  const _ContactInfo({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GET IN TOUCH',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: AppTheme.textColor(context),
          ),
        ),
        const SizedBox(height: 20),

        _InfoRow(
          icon: Icons.email_outlined,
          label: 'Email',
          value: 'ilechukwuthelma92@gmail.com',
          onTap: () => _launchEmail('ilechukwuthelma92@gmail.com'),
        ),
        const SizedBox(height: 16),

        _InfoRow(
          icon: Icons.phone_outlined,
          label: 'Phone',
          value: '+234 913 447 3521',
          onTap: () => _launchPhone('+2349134473521'),
        ),
        const SizedBox(height: 16),

        _InfoRow(
          icon: Icons.code,
          label: 'GitHub',
          value: 'github.com/Thelma-I',
          onTap: () => _launchUrl('https://github.com/Thelma-I'),
        ),

        const SizedBox(height: 32),
        Container(height: 1, color: AppTheme.borderColor(context)),
        const SizedBox(height: 24),

        Text(
          'SOCIALS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: AppTheme.textColor(context),
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            _SocialIcon(
              onTap: () => _launchUrl('https://github.com/Thelma-I'),
              hintMessage: 'Github',
              svgPath: 'assets/svg/github.svg',
            ),
            const SizedBox(width: 12),
            _SocialIcon(
              onTap: () => _launchUrl(
                'https://linkedin.com/in/thelma-ilechukwu-a924252b5?utm_source=share_via&utm_content=profile&utm_medium=member_android',
              ),
              hintMessage: 'LinkedIn',
              svgPath: 'assets/svg/logmein.svg',
            ),
            const SizedBox(width: 12),
            _SocialIcon(
              onTap: () => _launchUrl('https://x.com/_Phoenix_gamer_?s=08'),
              hintMessage: 'LinkedIn',
              svgPath: 'assets/svg/x.svg',
            ),
            const SizedBox(width: 12),
            _SocialIcon(
              onTap: () => _launchEmail('ilechukwuthelma92@gmail.com'),
              hintMessage: 'Gmail',
              svgPath: 'assets/svg/gmail.svg',
            ),
          ],
        ),
      ],
    );
  }

  static void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: '_blank');
    }
  }

  static void _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static void _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _InfoRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  State<_InfoRow> createState() => _InfoRowState();
}

class _InfoRowState extends State<_InfoRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.borderColor(context)),
                borderRadius: BorderRadius.circular(4),
                color: _hovered
                    ? AppTheme.accentColor(context).withOpacity(0.1)
                    : Colors.transparent,
              ),
              child: Icon(
                widget.icon,
                size: 16,
                color: _hovered
                    ? AppTheme.accentColor(context)
                    : AppTheme.mutedColor(context),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.mutedColor(context),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _hovered
                        ? AppTheme.accentColor(context)
                        : AppTheme.textColor(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final VoidCallback onTap;
  final String hintMessage;
  final String svgPath;
  const _SocialIcon({
    required this.onTap,
    required this.hintMessage,
    required this.svgPath,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Color containerColor = _hovered
        ? AppTheme.textColor(context)
        : Colors.transparent;

    final Color iconColor = _hovered
        ? AppTheme.bgColor(context)
        : AppTheme.textColor(context);
    return Tooltip(
      message: widget.hintMessage,
      waitDuration: const Duration(milliseconds: 500),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.borderColor(context)),
              borderRadius: BorderRadius.circular(4),
              color: containerColor,
            ),
            child: Center(
              child: SvgPicture.asset(
                widget.svgPath,
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _BottomRow extends StatelessWidget {
  final bool isMobile;
  final double pad;
  const _BottomRow({required this.isMobile, required this.pad});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(pad, 24, pad, 32),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.borderColor(context), width: 1),
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '© 2026 Ilechukwu Thelma',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.mutedColor(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Built with Flutter',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.mutedColor(context),
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '© 2026 Ilechukwu Thelma. All rights reserved.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.mutedColor(context),
                  ),
                ),
                Text(
                  'Built with Flutter',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.mutedColor(context),
                  ),
                ),
              ],
            ),
    );
  }
}
