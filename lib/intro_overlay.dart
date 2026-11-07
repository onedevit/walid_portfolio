import 'dart:math' as math;
import 'package:flutter/material.dart';

/// الشاشة الافتتاحية التفاعلية السينمائية (Futuristic Cyber-Intro)
/// تظهر تلقائياً لمدة 3.5 ثانية وتتلاشى بسلاسة تامة، مع إمكانية التخطي الفوري
class IntroOverlay extends StatefulWidget {
  final VoidCallback onFinished;

  const IntroOverlay({super.key, required this.onFinished});

  @override
  State<IntroOverlay> createState() => _IntroOverlayState();
}

class _IntroOverlayState extends State<IntroOverlay> with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _particleController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<double> _letterSpacing;
  late final Animation<double> _lineWidth;
  late final Animation<double> _badgeFade;
  late final Animation<double> _exitFade;
  late final Animation<double> _exitScale;

  bool _isExiting = false;

  @override
  void initState() {
    super.initState();

    // مشغل حركة الخلفية المستمرة (جزيئات النيون)
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // مشغل المشهد السينمائي الكامل (3.5 ثوانٍ)
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    // 1. ظهور اللوغو وتوسعه (0.0s إلى 1.0s)
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOutBack),
      ),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );

    // 2. ظهور الاسم وتباعد الأحرف (0.8s إلى 1.8s)
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.25, 0.55, curve: Curves.easeIn),
      ),
    );
    _letterSpacing = Tween<double>(begin: 1.0, end: 6.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.25, 0.70, curve: Curves.easeOutCubic),
      ),
    );

    // 3. تمدد الخط النيوني الليزري (1.2s إلى 2.0s)
    _lineWidth = Tween<double>(begin: 0.0, end: 240.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    // 4. ظهور الشارات والصفة المهنية (1.8s إلى 2.8s)
    _badgeFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.55, 0.85, curve: Curves.easeIn),
      ),
    );

    // 5. تلاشي المشهد بالكامل سينمائياً (3.0s إلى 3.5s)
    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.85, 1.0, curve: Curves.easeInOutCubic),
      ),
    );
    _exitScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.85, 1.0, curve: Curves.easeIn),
      ),
    );

    _mainController.forward();

    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _finish();
      }
    });
  }

  void _finish() {
    if (_isExiting) return;
    _isExiting = true;
    widget.onFinished();
  }

  void _skip() {
    if (_isExiting) return;
    _isExiting = true;
    widget.onFinished();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 600;

    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Opacity(
          opacity: _exitFade.value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: _exitScale.value,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, -0.1),
                  radius: 1.2,
                  colors: [
                    Color(0xFF0F1E2E), // كحلي نيوني دافئ في المركز
                    Color(0xFF080D14), // أسود لؤلؤي محيطي
                  ],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // خلفية الجزيئات الرقمية المتلألئة
                  AnimatedBuilder(
                    animation: _particleController,
                    builder: (context, _) {
                      return CustomPaint(
                        size: Size.infinite,
                        painter: _CyberParticlesPainter(progress: _particleController.value),
                      );
                    },
                  ),

                  // زر التخطي السريع بالأعلى
                  Positioned(
                    top: isMobile ? 30 : 40,
                    right: isMobile ? 20 : 40,
                    child: InkWell(
                      onTap: _skip,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.tealAccent.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Passer',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: Colors.tealAccent.withValues(alpha: 0.8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // المحتوى المركزي المبهر
                  Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 1. مونوغرام النيون المركزي (WH)
                            Transform.scale(
                              scale: _logoScale.value,
                              child: Opacity(
                                opacity: _logoFade.value.clamp(0.0, 1.0),
                                child: Container(
                                  width: isMobile ? 90 : 110,
                                  height: isMobile ? 90 : 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF00E5FF),
                                        Color(0xFF00BFA5),
                                        Color(0xFF1DE9B6),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.tealAccent.withValues(alpha: 0.45),
                                        blurRadius: 35,
                                        spreadRadius: 3,
                                      ),
                                      BoxShadow(
                                        color: Colors.cyanAccent.withValues(alpha: 0.25),
                                        blurRadius: 60,
                                        spreadRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF0B141E),
                                      ),
                                      child: Center(
                                        child: ShaderMask(
                                          shaderCallback: (bounds) => const LinearGradient(
                                            colors: [Colors.white, Color(0xFF64FFDA)],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ).createShader(bounds),
                                          child: Text(
                                            'WH',
                                            style: TextStyle(
                                              fontSize: isMobile ? 38 : 46,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 2.0,
                                              color: Colors.white,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // 2. الاسم بحركة تباعد الحروف السينمائية
                            Opacity(
                              opacity: _textFade.value.clamp(0.0, 1.0),
                              child: Text(
                                'WALID HASSANI',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isMobile ? 26 : 38,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: _letterSpacing.value,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.tealAccent.withValues(alpha: 0.5),
                                      blurRadius: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // 3. الخط الليزري الممتد من المركز
                            Container(
                              width: _lineWidth.value,
                              height: 2.0,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Color(0xFF64FFDA),
                                    Color(0xFF00E5FF),
                                    Colors.transparent,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.tealAccent.withValues(alpha: 0.8),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // 4. التخصص والصفة المهنية
                            Opacity(
                              opacity: _badgeFade.value.clamp(0.0, 1.0),
                              child: Column(
                                children: [
                                  Text(
                                    'CONSULTANT ERP & CHEF DE PROJET TECHNIQUE',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: isMobile ? 12 : 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withValues(alpha: 0.85),
                                      letterSpacing: isMobile ? 1.5 : 2.5,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 10,
                                    runSpacing: 8,
                                    children: [
                                      _buildIntroPill('Dolibarr ERP', Icons.business_center),
                                      _buildIntroPill('Applied AI & OCR', Icons.psychology),
                                      _buildIntroPill('Full-Stack Web', Icons.code_rounded),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIntroPill(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF004D40).withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.tealAccent.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.tealAccent),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

/// رسام الجزيئات والشبكة الرقمية عالية الأداء
class _CyberParticlesPainter extends CustomPainter {
  final double progress;

  _CyberParticlesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint particlePaint = Paint()
      ..color = const Color(0xFF64FFDA).withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.08)
      ..strokeWidth = 1.0;

    // رسم 28 نقطة رقمية تتحرك بمسارات خفيفة انسيابية
    const int count = 28;
    final List<Offset> points = [];

    for (int i = 0; i < count; i++) {
      final double seed = i * 137.5;
      final double x = (math.sin(seed + progress * 2 * math.pi) * 0.5 + 0.5) * size.width;
      final double y = (math.cos(seed * 0.8 + progress * 2 * math.pi) * 0.5 + 0.5) * size.height;
      final double radius = (math.sin(seed + progress * 4 * math.pi) * 1.5 + 2.0).abs();

      points.add(Offset(x, y));
      canvas.drawCircle(Offset(x, y), radius, particlePaint);
    }

    // ربط النقاط المتقاربة بخطوط نيونية خافتة
    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final double dist = (points[i] - points[j]).distance;
        if (dist < 110) {
          canvas.drawLine(points[i], points[j], linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CyberParticlesPainter oldDelegate) => true;
}
