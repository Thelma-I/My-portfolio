import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/responsive.dart';
import 'dart:ui' show ImageFilter;
import 'package:url_launcher/url_launcher.dart';

class NavBar extends StatefulWidget {
  final ScrollController scrollController;
  final Map<String, GlobalKey> sectionKeys;

  const NavBar({
    super.key,
    required this.scrollController,
    required this.sectionKeys,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      final isScrolled = widget.scrollController.offset > 40;
      if (isScrolled != _scrolled) {
        setState(() => _scrolled = isScrolled);
      }
    });
  }

  void _scrollTo(String section) {
    final key = widget.sectionKeys[section];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final isMobile = Responsive.isMobile(context);
    final pad = Responsive.pagePadding(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
        horizontal: pad,
        vertical: _scrolled ? 10 : 18,
      ),
      decoration: BoxDecoration(
        color: _scrolled
            ? AppTheme.bgColor(context).withOpacity(0.95)
            : Colors.transparent,
        border: _scrolled
            ? Border(
                bottom: BorderSide(
                  color: AppTheme.borderColor(context),
                  width: 1,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => widget.scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
            ),
            child: Text(
              'ILECHUKWU THELMA',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: AppTheme.textColor(context),
              ),
            ),
          ),

          const Spacer(),

          if (!isMobile) ...[
            _NavLink(label: 'Works', onTap: () => _scrollTo('portfolio')),
            const SizedBox(width: 32),
            _NavLink(label: 'About', onTap: () => _scrollTo('help')),
            const SizedBox(width: 32),
            _NavLink(label: 'Contact', onTap: () => _scrollTo('contact')),
            const SizedBox(width: 32),
            _DownloadBtn(),
            const SizedBox(width: 24),
          ],

          _ThemeToggle(notifier: themeNotifier),

          if (isMobile) ...[
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => _showMobileMenu(context),
              child: Icon(
                Icons.menu,
                color: AppTheme.textColor(context),
                size: 22,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    final theme = Theme.of(context);
    showGeneralDialog(
      context: context,
      pageBuilder: (context, Animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
      barrierDismissible: true,
      barrierLabel: 'Close Menu',
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return Stack(
          children: [
            FadeTransition(
              opacity: curvedAnimation,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: const SizedBox.expand(),
              ),
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: Align(
                alignment: Alignment.centerRight,
                child: Theme(
                  data: theme,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.bgColor(context),
                        border: Border(
                          left: BorderSide(
                            color: AppTheme.borderColor(context),
                            width: 1,
                          ),
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 32,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: Icon(
                                    Icons.close,
                                    color: AppTheme.textColor(context),
                                    size: 22,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              _MobileNavItem(
                                label: 'Work',
                                onTap: () {
                                  Navigator.pop(context);
                                  _scrollTo('portfolio');
                                },
                              ),
                              const SizedBox(height: 16),
                              _MobileNavItem(
                                label: 'About',
                                onTap: () {
                                  Navigator.pop(context);
                                  _scrollTo('help');
                                },
                              ),
                              const SizedBox(height: 16),
                              _MobileNavItem(
                                label: 'Contact',
                                onTap: () {
                                  Navigator.pop(context);
                                  _scrollTo('contact');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MobileNavItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _MobileNavItem({required this.label, required this.onTap});

  @override
  State<_MobileNavItem> createState() => _MobileNavItemState();
}

class _MobileNavItemState extends State<_MobileNavItem> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: _hovered
                    ? AppTheme.textColor(context)
                    : AppTheme.mutedColor(context),
              ),
            ),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 1,
              width: _hovered ? 30 : 0,
              color: AppTheme.textColor(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: _hovered
                    ? AppTheme.textColor(context)
                    : AppTheme.mutedColor(context),
              ),
            ),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 1,
              width: _hovered ? 30 : 0,
              color: AppTheme.textColor(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadBtn extends StatefulWidget {
  @override
  State<_DownloadBtn> createState() => _DownloadBtnState();
}

class _DownloadBtnState extends State<_DownloadBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? AppTheme.textColor(context) : Colors.transparent,
            border: Border.all(color: AppTheme.borderColor(context)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Download CV',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  color: _hovered
                      ? AppTheme.bgColor(context)
                      : AppTheme.textColor(context),
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.north_east,
                size: 12,
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

class _ThemeToggle extends StatelessWidget {
  final ThemeNotifier notifier;
  const _ThemeToggle({required this.notifier});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: notifier.toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor(context)),
          color: AppTheme.surfaceColor(context),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: notifier.isDark
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: AppTheme.textColor(context),
              shape: BoxShape.circle,
            ),
            child: Icon(
              notifier.isDark ? Icons.dark_mode : Icons.light_mode,
              size: 10,
              color: AppTheme.bgColor(context),
            ),
          ),
        ),
      ),
    );
  }
}
