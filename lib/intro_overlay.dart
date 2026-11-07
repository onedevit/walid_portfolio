import 'dart:math' as math;
import 'package:flutter/material.dart';

/// الشاشة الافتتاحية التفاعلية السينمائية (Futuristic Cyber-Intro)
/// تعرض صورة البروفايل داخل حلقة نيون متوهجة وحركة جزيئات رقمية مستمرة
/// وتبقى ظاهرة حتى ينقر الزائر على زر الدخول أو التخطي (Passer)
class IntroOverlay extends StatefulWidget {
  final VoidCallback onFinished;

  const IntroOverlay({super.key, required this.onFinished});

  @override
  State<IntroOverlay> createState() => _IntroOverlayState();
}

class _IntroOverlayState extends State<IntroOverlay> with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;
  late final AnimationController _particleController;
  late final AnimationController _exitController;

  late final Animation<double> _photoScale;
  late final Animation<double> _photoFade;
  late final Animation<double> _textFade;
  late final Animation<double> _letterSpacing;
  late final Animation<double> _lineWidth;
  late final Animation<double> _badgeFade;
  late final Animation<double> _buttonFade;
  late final Animation<double> _exitFade;
  late final Animation<double> _exitScale;

  bool _isExiting = false;

  @override
  void initState() {
    super.initState();

    // 1. مشغل حركة جزيئات النيون في الخلفية
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // 2. مشغل النبض والتوهج المستمر (Ambient Breathing Loop)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    // 3. مشغل الدخول التدريجي للعناصر (Entrance: 1.8s)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // 4. مشغل الخروج السلس عند النقر (Exit: 500ms)
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // حركة ظهور وتكبير الصورة
    _photoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );
    _photoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.40, curve: Curves.easeIn),
      ),
    );

    // ظهور الاسم وتباعد الأحرف السينمائي
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.30, 0.70, curve: Curves.easeIn),
      ),
    );
    _letterSpacing = Tween<double>(begin: 1.0, end: 5.5).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.30, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    // تمدد الخط النيوني الليزري
    _lineWidth = Tween<double>(begin: 0.0, end: 260.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.45, 0.80, curve: Curves.easeOutCubic),
      ),
    );

    // ظهور الشارات والصفة المهنية
    _badgeFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.65, 0.95, curve: Curves.easeIn),
      ),
    );

    // ظهور زر الدخول التفاعلي
    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    // حركة الخروج والتلاشي عند النقر
    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInOutCubic),
    );
    _exitScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );

    _entranceController.forward();
  }

  void _triggerExit() {
    if (_isExiting) return;
    _isExiting = true;
    _exitController.forward().then((_) {
      if (mounted) {
        widget.onFinished();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 600;

    return AnimatedBuilder(
      animation: Listenable.merge([_entranceController, _exitController, _pulseController]),
      builder: (context, child) {
        final double pulseValue = _pulseController.value;

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
                  radius: 1.25,
                  colors: [
                    Color(0xFF0F1E2E), // كحلي نيوني دافئ في المركز
                    Color(0xFF080D14), // أسود لؤلؤي محيطي
                  ],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. خلفية الجزيئات الرقمية المتلألئة
                  AnimatedBuilder(
                    animation: _particleController,
                    builder: (context, _) {
                      return CustomPaint(
                        size: Size.infinite,
                        painter: _CyberParticlesPainter(progress: _particleController.value),
                      );
                    },
                  ),

                  // 2. زر التخطي العلوي السريع
                  Positioned(
                    top: isMobile ? 30 : 40,
                    right: isMobile ? 20 : 40,
                    child: InkWell(
                      onTap: _triggerExit,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.tealAccent.withValues(alpha: 0.35)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Passer',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: Colors.tealAccent.withValues(alpha: 0.85),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3. المحتوى المركزي الفخم
                  Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // أ. صورة البروفايل الشخصية داخل الحلقة النيونية المضيئة
                            Transform.scale(
                              scale: _photoScale.value,
                              child: Opacity(
                                opacity: _photoFade.value.clamp(0.0, 1.0),
                                child: Container(
                                  width: isMobile ? 120 : 145,
                                  height: isMobile ? 120 : 145,
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
                                        color: Colors.tealAccent.withValues(alpha: 0.45 + (pulseValue * 0.20)),
                                        blurRadius: 35 + (pulseValue * 15),
                                        spreadRadius: 3 + (pulseValue * 2),
                                      ),
                                      BoxShadow(
                                        color: Colors.cyanAccent.withValues(alpha: 0.25),
                                        blurRadius: 65,
                                        spreadRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/profile.jpg',
                                        fit: BoxFit.cover,
                                        width: isMobile ? 112 : 137,
                                        height: isMobile ? 112 : 137,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 26),

                            // ب. الاسم بحركة تباعد الحروف السينمائية
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
                                      color: Colors.tealAccent.withValues(alpha: 0.55),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // ج. الخط الليزري الممتد من المركز
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

                            // د. التخصص والصفة المهنية والشارات
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
                                      color: Colors.white.withValues(alpha: 0.88),
                                      letterSpacing: isMobile ? 1.5 : 2.5,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 10,
                                    runSpacing: 8,
                                    children: [
                                      _buildIntroPill('Enterprise AI & LLMs', Icons.psychology),
                                      _buildIntroPill('Cross-Platform Flutter', Icons.devices),
                                      _buildIntroPill('Dolibarr ERP & Cloud', Icons.business_center),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // هـ. زر الدخول التفاعلي البارز للموقع
                            Opacity(
                              opacity: _buttonFade.value.clamp(0.0, 1.0),
                              child: InkWell(
                                onTap: _triggerExit,
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 24 : 34,
                                    vertical: isMobile ? 12 : 15,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF00BFA5), Color(0xFF00E5FF)],
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.tealAccent.withValues(alpha: 0.4 + (pulseValue * 0.25)),
                                        blurRadius: 22 + (pulseValue * 8),
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Entrer sur le site',
                                        style: TextStyle(
                                          color: Colors.blueGrey.shade900,
                                          fontSize: isMobile ? 13 : 15,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 18,
                                        color: Colors.blueGrey.shade900,
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
