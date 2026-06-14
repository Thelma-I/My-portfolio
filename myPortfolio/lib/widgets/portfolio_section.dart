import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme.dart';
import '../core/responsive.dart';
import '../core/models.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioSection extends StatelessWidget {
  const PortfolioSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    final cols = Responsive.gridCols(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),
          _WorksGrid(cols: cols),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

class _WorksGrid extends StatelessWidget {
  final int cols;
  const _WorksGrid({required this.cols});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor(context), width: 1),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          childAspectRatio: cols == 1 ? 0.95 : 0.9,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),
        itemCount: portfolioWorks.length,
        itemBuilder: (context, index) {
          return _WorkCard(
            item: portfolioWorks[index],
            index: index,
            totalCols: cols,
          );
        },
      ),
    );
  }
}

class _WorkCard extends StatefulWidget {
  final WorkItem item;
  final int index;
  final int totalCols;

  const _WorkCard({
    required this.item,
    required this.index,
    required this.totalCols,
  });

  @override
  State<_WorkCard> createState() => _WorkCardState();
}

class _WorkCardState extends State<_WorkCard> {
  bool _hovered = false;

  Border _getBorder(BuildContext context) {
    final color = AppTheme.borderColor(context);
    final isLeftCol = widget.index % widget.totalCols == 0;
    final isLastRow = widget.index >= portfolioWorks.length - widget.totalCols;

    return Border(
      right: isLeftCol && widget.totalCols > 1
          ? BorderSide(color: color, width: 1)
          : BorderSide.none,
      bottom: !isLastRow ? BorderSide(color: color, width: 1) : BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child:
          GestureDetector(
                onTap: () {
                  if (widget.item.projectUrl != null) {
                    // URL launching handled below
                    _launchUrl(widget.item.projectUrl!);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _hovered
                        ? AppTheme.surfaceColor(context)
                        : AppTheme.bgColor(context),
                    border: _getBorder(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.item.title,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.textColor(context),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.item.subtitle,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.mutedColor(context),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: widget.item.tags.map((tag) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppTheme.borderColor(context),
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    tag,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                      color: AppTheme.mutedColor(context),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _hovered
                                  ? AppTheme.textColor(context).withOpacity(0.2)
                                  : AppTheme.borderColor(context),
                            ),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Network image
                              Image.network(
                                widget.item.imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (ctx, child, progress) {
                                  if (progress == null) return child;
                                  return Container(
                                    color: AppTheme.surfaceColor(context),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        color: AppTheme.mutedColor(context),
                                        value:
                                            progress.expectedTotalBytes != null
                                            ? progress.cumulativeBytesLoaded /
                                                  progress.expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (ctx, err, stack) => Container(
                                  color: AppTheme.surfaceColor(context),
                                  child: Center(
                                    child: Icon(
                                      Icons.image_outlined,
                                      color: AppTheme.borderColor(context),
                                      size: 32,
                                    ),
                                  ),
                                ),
                              ),

                              // Hover overlay
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 250),
                                opacity: _hovered ? 1.0 : 0.0,
                                child: Container(
                                  color: Colors.black.withOpacity(0.45),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.north_east,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'View Project',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(
                duration: 600.ms,
                delay: Duration(milliseconds: 150 * widget.index),
              )
              .slideY(begin: 0.08, end: 0),
    );
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse('https://github.com/Thelma-I');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: '_blank');
    }
  }
}
