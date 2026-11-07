import 'package:flutter/material.dart';

/// Carte de compétence interactive avec animations néon au survol,
/// jauge de télémétrie animée et badges technologiques.
class SkillHoverCard extends StatefulWidget {
  final String title;
  final String desc;
  final List<String> tags;
  final IconData icon;
  final String badge;
  final List<Color> gradientColors;

  const SkillHoverCard({
    super.key,
    required this.title,
    required this.desc,
    required this.tags,
    required this.icon,
    required this.badge,
    required this.gradientColors,
  });

  @override
  State<SkillHoverCard> createState() => _SkillHoverCardState();
}

class _SkillHoverCardState extends State<SkillHoverCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.028).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth < 380
        ? (screenWidth - 32)
        : screenWidth < 740
            ? (screenWidth - 48)
            : 340.0;

    double percent =
        (double.tryParse(widget.badge.replaceAll('%', '').trim()) ?? 90.0) /
            100.0;
    Color primaryColor = widget.gradientColors.first;
    Color secondaryColor = widget.gradientColors.last;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animController.reverse();
      },
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -7 * _glowAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          );
        },
        child: Container(
          width: cardWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.lerp(
                  Colors.blueGrey.shade100, primaryColor, _glowAnimation.value)!,
              width: _isHovered ? 1.8 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              if (_isHovered)
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.22),
                  blurRadius: 24,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bandeau lumineux supérieur néon (Top Accent Gradient)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isHovered
                          ? widget.gradientColors
                          : [
                              primaryColor.withValues(alpha: 0.3),
                              secondaryColor.withValues(alpha: 0.3)
                            ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ligne d'en-tête : Icône animée + Badge néon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: _isHovered
                                  ? LinearGradient(colors: widget.gradientColors)
                                  : null,
                              color: _isHovered
                                  ? null
                                  : primaryColor.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: _isHovered
                                  ? [
                                      BoxShadow(
                                        color: primaryColor.withValues(alpha: 0.40),
                                        blurRadius: 12,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              widget.icon,
                              size: 26,
                              color: _isHovered ? Colors.white : primaryColor,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: widget.gradientColors),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              widget.badge,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Titre du Pôle de Compétence
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Barre de télémétrie / jauge de maîtrise animée (RTL-ready)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            height: 5,
                            width: constraints.maxWidth,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 350),
                                width: constraints.maxWidth *
                                    (_isHovered ? percent : (percent * 0.88)),
                                decoration: BoxDecoration(
                                  gradient:
                                      LinearGradient(colors: widget.gradientColors),
                                  borderRadius: BorderRadius.circular(3),
                                  boxShadow: _isHovered
                                      ? [
                                          BoxShadow(
                                            color: secondaryColor
                                                .withValues(alpha: 0.4),
                                            blurRadius: 6,
                                          )
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Description détaillée
                      Text(
                        widget.desc,
                        style: TextStyle(
                          color: Colors.blueGrey.shade800,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),

                      // Badges / Tags technologiques associés
                      if (widget.tags.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: widget.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: primaryColor.withValues(alpha: 0.20),
                                ),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
