import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/responsive.dart';
import '../widgets/nav_bar.dart';
import '../widgets/hero_section.dart';
import '../widgets/marquee_ticker.dart';
import '../widgets/portfolio_section.dart';
import '../widgets/stages_section.dart';
import '../widgets/help_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/scroll_reveal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  // Section keys for nav scroll-to
  final Map<String, GlobalKey> _sectionKeys = {
    'hero':      GlobalKey(),
    'portfolio': GlobalKey(),
    'stages':    GlobalKey(),
    'help':      GlobalKey(),
    'contact':   GlobalKey(),
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
   // final maxW = Responsive.maxWidth(context);

    return Scaffold(
      backgroundColor: AppTheme.bgColor(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.maxWidth(context)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    //  Hero Section
                    ScrollReveal(
                      key: _sectionKeys['hero'],
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: pad),
                        child: const HeroSection(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ScrollReveal(
                      slideFrom: const Offset(0, 20),
                      delay: const Duration(milliseconds: 100),
                      child: const MarqueeTicker(),
                    ),
                    ScrollReveal(
                      key: _sectionKeys['portfolio'],
                      delay: const Duration(milliseconds: 150),
                      child: const PortfolioSection(),
                    ),
                    ScrollReveal(
                      key: _sectionKeys['stages'],
                      delay: const Duration(milliseconds: 100),
                      child: const StagesSection(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: pad),
                      child: Divider(
                        color: AppTheme.borderColor(context),
                        height: 1,
                      ),
                    ),
                    ScrollReveal(
                      key: _sectionKeys['help'],
                      delay: const Duration(milliseconds: 100),
                      child: const HelpSection(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: pad),
                      child: Divider(
                        color: AppTheme.borderColor(context),
                        height: 1,
                      ),
                    ),
                    ScrollReveal(
                      key: _sectionKeys['contact'],
                      delay: const Duration(milliseconds: 100),
                      child: const ContactSection(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: NavBar(
              scrollController: _scrollController,
              sectionKeys: _sectionKeys,
            ),
          ),
        ],
      ),
    );
  }
}