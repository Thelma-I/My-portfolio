import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme.dart';
import '../core/responsive.dart';
import '../core/models.dart';

class StagesSection extends StatefulWidget {
  const StagesSection({super.key});

  @override
  State<StagesSection> createState() => _StagesSectionState();
}

class _StagesSectionState extends State<StagesSection> {
  late List<Stage> _stages;

  @override
  void initState() {
    super.initState();
    _stages = buildStages();
  }

  void _toggle(int index) {
    setState(() {
      for (int i = 0; i < _stages.length; i++) {
        _stages[i].isOpen = i == index ? !_stages[i].isOpen : false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    final isMobile = Responsive.isMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Column(
            children: [
              Text(
                'STAGES OF WEBSITE',
                style: TextStyle(
                  fontSize: isMobile ? 28 : 44,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  color: AppTheme.textColor(context),
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.2, end: 0),

              Text(
                'DEVELOPMENT',
                style: TextStyle(
                  fontSize: isMobile ? 26 : 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  height: 0.9,
                  color: AppTheme.textColor(context).withOpacity(0.08),
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 100.ms)
                  .slideY(begin: 0.2, end: 0),
            ],
          ),
          const SizedBox(height: 48),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.borderColor(context),
                width: 1,
              ),
            ),
            child: Column(
              children: _stages.asMap().entries.map((entry) {
                final index = entry.key;
                final stage = entry.value;
                return _StageRow(
                  stage: stage,
                  index: index,
                  onTap: () => _toggle(index),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _StageRow extends StatefulWidget {
  final Stage stage;
  final int index;
  final VoidCallback onTap;

  const _StageRow({
    required this.stage,
    required this.index,
    required this.onTap,
  });

  @override
  State<_StageRow> createState() => _StageRowState();
}

class _StageRowState extends State<_StageRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.stage.isOpen ? 1.0 : 0.0,
    );
    _expandAnim = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant _StageRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stage.isOpen) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = widget.stage.isOpen;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderColor(context),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      widget.stage.number,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        color: AppTheme.mutedColor(context),
                      ),
                    ),
                  ),

                  // Stage title
                  Expanded(
                    child: Text(
                      widget.stage.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: AppTheme.textColor(context),
                      ),
                    ),
                  ),

                  // Toggle icon
                  AnimatedRotation(
                    turns: isOpen ? 0.125 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.borderColor(context),
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Icon(
                        isOpen ? Icons.close : Icons.add,
                        size: 16,
                        color: AppTheme.textColor(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnim,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(104, 0, 24, 24),
              child: Text(
                widget.stage.detail,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.75,
                  color: AppTheme.mutedColor(context),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: 500.ms,
          delay: Duration(milliseconds: 100 * widget.index),
        );
  }
}