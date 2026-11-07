import 'web_helper.dart' as web_helper;
import 'intro_overlay.dart';
import 'translations.dart';
import 'contact_form_dialog.dart';
import 'skill_hover_card.dart';
import 'experience_card.dart';
import 'project_dialog.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Walid Hassani - Portfolio & CV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Roboto',
        fontFamilyFallback: const ['Cairo', 'Arial', 'sans-serif'],
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

enum MediaState { loading, videoReady, imageFallback }

class _PortfolioHomeState extends State<PortfolioHome> {
  VideoPlayerController? _videoController;
  MediaState _mediaState = MediaState.loading;
  String _currentLanguage = 'fr'; // 'fr' par défaut, 'en', 'ar'
  bool _showIntro = true;

  // Dictionnaire complet de traductions pour le support multilingue (isolé dans translations.dart)
  final Map<String, Map<String, String>> _translations = appTranslations;

  // ===========================================================================
  // ====================== GESTION DU MÉDIA (VIDÉO/IMAGE) =====================
  // ===========================================================================

  @override
  void initState() {
    super.initState();
    _loadMedia(_currentLanguage);
  }

  void _loadMedia(String lang) {
    setState(() {
      _mediaState = MediaState.loading;
    });

    _videoController?.dispose();
    _videoController = VideoPlayerController.asset('assets/pitch_video_$lang.webm');

    _videoController!.initialize().then((_) {
      if (mounted) {
        setState(() {
          _mediaState = MediaState.videoReady;
        });
        _videoController!.setVolume(0.0); // Mode muet par défaut
        _videoController!.setLooping(true);
        _videoController!.addListener(() {
          if (mounted) setState(() {});
        });
        _videoController!.play().catchError((e) {
          debugPrint("Autoplay empêché par le navigateur: $e");
        });
      }
    }).catchError((error) {
      debugPrint("Vidéo non trouvée pour $lang, fallback vers image. Erreur: $error");
      if (mounted) {
        setState(() {
          _mediaState = MediaState.imageFallback;
        });
      }
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  // ===========================================================================
  // ============================== ACTIONS UTILISATEUR ========================
  // ===========================================================================

  // Télécharger le CV PDF correspondant à la langue sélectionnée
  void _downloadCv(BuildContext context) {
    final String lang = _currentLanguage; // 'fr', 'en', 'ar'
    final String pdfUrl = 'cv_$lang.pdf'; // URL directe depuis la racine du serveur web (Vercel)

    try {
      web_helper.downloadFile(pdfUrl, 'Walid_Hassani_CV_${lang.toUpperCase()}.pdf');
    } catch (e) {
      debugPrint("Erreur lors du téléchargement du CV: $e");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Téléchargement du CV (${lang.toUpperCase()})...'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.teal,
      ),
    );
  }

  // Ouvrir le formulaire de contact interactif et sécurisé (Anti-Bot)
  void _openContactDialog(BuildContext context) {
    final Map<String, String> t = _translations[_currentLanguage]!;
    final bool isRtl = _currentLanguage == 'ar';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: ContactFormDialog(translations: t, isRtl: isRtl),
        );
      },
    );
  }

  // ===========================================================================
  // ============================== WIDGETS D'INTERFACE ========================
  // ===========================================================================

  // Construire un bouton de sélection de langue
  Widget _buildLanguageBtn(String label, String langCode) {
    bool isSelected = _currentLanguage == langCode;
    return InkWell(
      onTap: () {
        if (_currentLanguage != langCode) {
          setState(() {
            _currentLanguage = langCode;
          });
          _loadMedia(langCode);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blueGrey.shade900 : Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> t = _translations[_currentLanguage]!;
    bool isRtl = _currentLanguage == 'ar';

    // Calcul dynamique de la largeur d'écran pour un design responsive
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    double horizontalPadding = isMobile ? 16.0 : 40.0;
    double videoSize = screenWidth < 380 ? (screenWidth - 40) : 300.0;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Stack(
          children: [
            SingleChildScrollView(
          child: Column(
            children: [
              // 1. Section Héro (Présentation principale)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 60, horizontal: horizontalPadding),
                color: Colors.blueGrey.shade900,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Sélecteur de langue en haut
                    Align(
                      alignment: isRtl ? Alignment.topLeft : Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildLanguageBtn('FR', 'fr'),
                            _buildLanguageBtn('EN', 'en'),
                            _buildLanguageBtn('AR', 'ar'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- Section Média de Profil Circulaire (Vidéo ou Image) ---
                    GestureDetector(
                      onTap: () async {
                        if (_mediaState != MediaState.videoReady || _videoController == null) return;
                        setState(() {
                          if (_videoController!.value.isPlaying) {
                            _videoController!.pause();
                          } else {
                            _videoController!.play();
                          }
                        });
                      },
                      child: Container(
                        width: videoSize,
                        height: videoSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueGrey.shade800,
                          border: Border.all(color: Colors.tealAccent, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withValues(alpha: 0.4),
                              blurRadius: 25,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: ClipOval(
                          child: _mediaState == MediaState.loading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : _mediaState == MediaState.imageFallback
                                  ? Image.asset(
                                      'assets/profile.jpg',
                                      fit: BoxFit.cover,
                                      width: videoSize,
                                      height: videoSize,
                                    )
                                  : Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          width: videoSize,
                                          height: videoSize,
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: SizedBox(
                                              width: _videoController!.value.size.width,
                                              height: _videoController!.value.size.height,
                                              child: VideoPlayer(_videoController!),
                                            ),
                                          ),
                                        ),

                                        // Superposition sombre avec icône Play au centre lorsque la vidéo est en pause
                                        if (!_videoController!.value.isPlaying)
                                          Container(
                                            color: Colors.black45,
                                            child: const Center(
                                              child: Icon(
                                                Icons.play_arrow,
                                                size: 70,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),

                                        // Barre de contrôle flottante au bas de la vidéo (Play/Pause & Son)
                                        Positioned(
                                          bottom: 20,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: const Color(0xA6000000),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: Colors.white38, width: 1),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Bouton de Lecture / Pause
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (_videoController!.value.isPlaying) {
                                                        _videoController!.pause();
                                                      } else {
                                                        _videoController!.play();
                                                      }
                                                    });
                                                  },
                                                  child: Icon(
                                                    _videoController!.value.isPlaying
                                                        ? Icons.pause
                                                        : Icons.play_arrow,
                                                    color: Colors.white,
                                                    size: 22,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Container(
                                                  height: 16,
                                                  width: 1,
                                                  color: Colors.white38,
                                                ),
                                                const SizedBox(width: 12),
                                                // Bouton d'activation ou coupure du son (Icône uniquement)
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (_videoController!.value.volume == 0.0) {
                                                      await _videoController!.setVolume(1.0);
                                                      await _videoController!.play();
                                                    } else {
                                                      await _videoController!.setVolume(0.0);
                                                    }
                                                    if (mounted) setState(() {});
                                                  },
                                                  child: Icon(
                                                    _videoController!.value.volume == 0.0
                                                        ? Icons.volume_off
                                                        : Icons.volume_up,
                                                    color: Colors.white,
                                                    size: 22,
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
                    ),
                    const SizedBox(height: 25),
                    Text(
                      t['name']!,
                      style: TextStyle(
                          fontSize: isMobile ? 30 : 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      t['jobTitle']!,
                      style: TextStyle(
                          fontSize: isMobile ? 16 : 20,
                          color: Colors.white70,
                          height: 1.3,
                          letterSpacing: 1.1),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, color: Colors.tealAccent, size: 18),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            t['locationMobility']!,
                            style: const TextStyle(color: Colors.white60, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () => _downloadCv(context),
                      icon: const Icon(Icons.download, color: Colors.white),
                      label: Text(t['downloadCv']!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white, // Couleur du texte et icône en blanc très lisible
                        padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 20 : 30, vertical: 15),
                        textStyle: TextStyle(
                            fontSize: isMobile ? 15 : 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Bannière de Statistiques & Métriques d'Impact
              Container(
                width: double.infinity,
                color: Colors.blueGrey.shade800,
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: horizontalPadding),
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _buildStatCard('15+', t['statsProjects']!, Icons.business),
                    _buildStatCard('100%', t['statsSatisfaction']!, Icons.verified),
                    _buildStatCard('10+', t['statsExperience']!, Icons.work_history),
                    _buildStatCard('60%', t['statsAutomation']!, Icons.auto_graph),
                  ],
                ),
              ),

              // 3. Section Profil Professionnel (Résumé du CV)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: horizontalPadding),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 900),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    border: Border.all(color: Colors.blueGrey.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_pin, color: Colors.blueGrey, size: 28),
                          const SizedBox(width: 10),
                          Text(
                            t['profileTitle']!,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        t['profileText']!,
                        style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Section Pôles d'Expertise & Compétences Élites (10 Pôles Animés)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: horizontalPadding),
                child: Column(
                  children: [
                    Text(
                      t['skillsTitle']!,
                      style: TextStyle(
                          fontSize: isMobile ? 22 : 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _currentLanguage == 'ar'
                          ? 'خبرات تقنية متقدمة تجمع بين الذكاء الاصطناعي المؤسساتي وهندسة النظم البرمجية المعقدة'
                          : _currentLanguage == 'en'
                              ? 'High-impact technical capabilities combining Enterprise AI with mission-critical systems engineering'
                              : 'Compétences de pointe alliant IA générative & locale et ingénierie de systèmes critiques',
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 15,
                        color: Colors.blueGrey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: [
                        SkillHoverCard(
                          title: t['skill1Title']!,
                          desc: t['skill1Desc']!,
                          tags: t['skill1Tags']!.split(', '),
                          icon: Icons.psychology,
                          badge: '96%',
                          gradientColors: const [Color(0xFF00BFA5), Color(0xFF00E5FF)],
                        ),
                        SkillHoverCard(
                          title: t['skill2Title']!,
                          desc: t['skill2Desc']!,
                          tags: t['skill2Tags']!.split(', '),
                          icon: Icons.document_scanner,
                          badge: '98%',
                          gradientColors: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        SkillHoverCard(
                          title: t['skill3Title']!,
                          desc: t['skill3Desc']!,
                          tags: t['skill3Tags']!.split(', '),
                          icon: Icons.memory,
                          badge: '94%',
                          gradientColors: const [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
                        ),
                        SkillHoverCard(
                          title: t['skill4Title']!,
                          desc: t['skill4Desc']!,
                          tags: t['skill4Tags']!.split(', '),
                          icon: Icons.devices,
                          badge: '97%',
                          gradientColors: const [Color(0xFF0284C7), Color(0xFF06B6D4)],
                        ),
                        SkillHoverCard(
                          title: t['skill5Title']!,
                          desc: t['skill5Desc']!,
                          tags: t['skill5Tags']!.split(', '),
                          icon: Icons.cloud_sync,
                          badge: '96%',
                          gradientColors: const [Color(0xFF10B981), Color(0xFF34D399)],
                        ),
                        SkillHoverCard(
                          title: t['skill6Title']!,
                          desc: t['skill6Desc']!,
                          tags: t['skill6Tags']!.split(', '),
                          icon: Icons.auto_awesome,
                          badge: '95%',
                          gradientColors: const [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                        ),
                        SkillHoverCard(
                          title: t['skill7Title']!,
                          desc: t['skill7Desc']!,
                          tags: t['skill7Tags']!.split(', '),
                          icon: Icons.business_center,
                          badge: '98%',
                          gradientColors: const [Color(0xFF2563EB), Color(0xFF3B82F6)],
                        ),
                        SkillHoverCard(
                          title: t['skill8Title']!,
                          desc: t['skill8Desc']!,
                          tags: t['skill8Tags']!.split(', '),
                          icon: Icons.cloud_queue,
                          badge: '93%',
                          gradientColors: const [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                        ),
                        SkillHoverCard(
                          title: t['skill9Title']!,
                          desc: t['skill9Desc']!,
                          tags: t['skill9Tags']!.split(', '),
                          icon: Icons.gavel,
                          badge: '95%',
                          gradientColors: const [Color(0xFFD97706), Color(0xFFF59E0B)],
                        ),
                        SkillHoverCard(
                          title: t['skill10Title']!,
                          desc: t['skill10Desc']!,
                          tags: t['skill10Tags']!.split(', '),
                          icon: Icons.security,
                          badge: '92%',
                          gradientColors: const [Color(0xFF059669), Color(0xFF10B981)],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 5. Section Expériences Professionnelles (Chronologie Interactive Animée)
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: horizontalPadding),
                child: Column(
                  children: [
                    Text(
                      t['experienceTitle']!,
                      style: TextStyle(fontSize: isMobile ? 22 : 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Column(
                        children: [
                          ExperienceCard(
                            role: t['exp1Role']!,
                            company: t['exp1Company']!,
                            bulletList: [
                              t['exp1Bullet1']!,
                              t['exp1Bullet2']!,
                              t['exp1Bullet3']!,
                              t['exp1Bullet4']!,
                              t['exp1Bullet5']!,
                            ],
                            tags: const ['Dolibarr ERP', 'WordPress & WooCommerce', 'Plugins Sur-Mesure', 'OCR Tesseract', 'Linux Debian', 'Flutter'],
                            icon: Icons.business_center,
                          ),
                          ExperienceCard(
                            role: t['exp2Role']!,
                            company: t['exp2Company']!,
                            bulletList: [
                              t['exp2Bullet1']!,
                              t['exp2Bullet2']!,
                              t['exp2Bullet3']!,
                            ],
                            tags: const ['CNC Laser', 'CAD/CAM', 'Fichiers Vectoriels', 'Qualité Industrielle'],
                            icon: Icons.precision_manufacturing,
                          ),
                          ExperienceCard(
                            role: t['exp3Role']!,
                            company: t['exp3Company']!,
                            bulletList: [
                              t['exp3Bullet1']!,
                              t['exp3Bullet2']!,
                            ],
                            tags: const ['Gestion Agence', 'Projets Multimédia', 'Cadrage Budgétaire'],
                            icon: Icons.work_history,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 6. Section Stack Technique (Badges)
              Container(
                width: double.infinity,
                color: Colors.blueGrey.shade50,
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: horizontalPadding),
                child: Column(
                  children: [
                    Text(
                      t['techStackTitle']!,
                      style: TextStyle(fontSize: isMobile ? 22 : 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildTechChip('Dolibarr ERP', Colors.blue),
                        _buildTechChip('WordPress & WooCommerce', Colors.blue.shade900),
                        _buildTechChip('Plugins WordPress Sur-Mesure', Colors.teal),
                        _buildTechChip('Flutter Desktop & Mobile', Colors.lightBlue),
                        _buildTechChip('OCR (Tesseract & PaddleOCR)', Colors.teal.shade700),
                        _buildTechChip('LLMs Locaux (llama-server)', Colors.deepPurple),
                        _buildTechChip('WinDev & WebDev', Colors.indigo),
                        _buildTechChip('PHP & MySQL', Colors.amber.shade800),
                        _buildTechChip('Linux Debian / Ubuntu', Colors.orange.shade800),
                        _buildTechChip('Sauvegardes (rclone)', Colors.green),
                      ],
                    ),
                  ],
                ),
              ),

              // 7. Section Projets Marquants
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: horizontalPadding),
                child: Column(
                  children: [
                    Text(
                      t['projectsTitle']!,
                      style: TextStyle(
                          fontSize: isMobile ? 22 : 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: List.generate(13, (index) {
                        int pNum = index + 1;
                        return _buildProjectCard(
                          context,
                          t['proj${pNum}Title']!,
                          t['proj${pNum}Desc']!,
                          t['proj${pNum}Tech']!,
                          t['viewDetails']!,
                          t['closeModal'] ?? 'Fermer',
                          screenWidth,
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // 8. Section Formation, Diplômes & Engagement
              Container(
                width: double.infinity,
                color: Colors.blueGrey.shade50,
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: horizontalPadding),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Wrap(
                    spacing: 30,
                    runSpacing: 30,
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      // Block Formation
                      Container(
                        width: isMobile ? screenWidth : 400,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.school, color: Colors.blueGrey),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(t['educationTitle']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text('• ${t['edu1']!}', style: const TextStyle(fontSize: 13, height: 1.4)),
                            const SizedBox(height: 8),
                            Text('• ${t['edu2']!}', style: const TextStyle(fontSize: 13, height: 1.4)),
                            const SizedBox(height: 8),
                            Text('• ${t['edu3']!}', style: const TextStyle(fontSize: 13, height: 1.4)),
                          ],
                        ),
                      ),

                      // Block Langues & Engagement
                      Container(
                        width: isMobile ? screenWidth : 400,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.language, color: Colors.blueGrey),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(t['langCommitmentTitle']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text('• ${t['lang1']!}', style: const TextStyle(fontSize: 13)),
                            const SizedBox(height: 6),
                            Text('• ${t['lang2']!}', style: const TextStyle(fontSize: 13)),
                            const SizedBox(height: 6),
                            Text('• ${t['lang3']!}', style: const TextStyle(fontSize: 13)),
                            const SizedBox(height: 12),
                            Text('• ${t['commitment']!}', style: const TextStyle(fontSize: 13, height: 1.4, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 9. Section Appel à l'Action & Contact
              Container(
                width: double.infinity,
                color: Colors.blueGrey.shade900,
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: horizontalPadding),
                child: Column(
                  children: [
                    Text(
                      t['contactTitle']!,
                      style: TextStyle(
                          fontSize: isMobile ? 22 : 28, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '${t['email']!}  |  ${t['phone']!}',
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _openContactDialog(context),
                          icon: const Icon(Icons.mail_outline, color: Colors.white, size: 20),
                          label: Text(t['contactMe']!),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            textStyle: TextStyle(
                              fontSize: isMobile ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            try {
                              web_helper.openUrl('https://www.linkedin.com/in/walidhassani');
                            } catch (e) {
                              debugPrint("Erreur lors de l'ouverture de LinkedIn: $e");
                            }
                          },
                          icon: const FaIcon(FontAwesomeIcons.linkedinIn, color: Colors.white, size: 20),
                          label: const Text('LinkedIn', style: TextStyle(color: Colors.white)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white54),
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            try {
                              web_helper.openUrl('https://github.com/onedevit');
                            } catch (e) {
                              debugPrint("Erreur lors de l'ouverture de GitHub: $e");
                            }
                          },
                          icon: const FaIcon(FontAwesomeIcons.github, color: Colors.white, size: 20),
                          label: const Text('GitHub', style: TextStyle(color: Colors.white)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white54),
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_showIntro)
          IntroOverlay(
            onFinished: () {
              if (mounted) {
                setState(() {
                  _showIntro = false;
                });
              }
            },
          ),
      ],
    ),
  ),
);
  }

  // Widget pour afficher les cartes de statistiques
  Widget _buildStatCard(String value, String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.tealAccent, size: 30),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  // Widget pour les badges de technologies
  Widget _buildTechChip(String label, Color color) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: color,
        radius: 6,
      ),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
      backgroundColor: Colors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  // Card de projet interactive responsive avec animation au survol
  Widget _buildProjectCard(
      BuildContext context, String title, String desc, String tech, String btnText, String closeBtnText, double screenWidth) {
    return ProjectCard(
      title: title,
      desc: desc,
      tech: tech,
      btnText: btnText,
      closeBtnText: closeBtnText,
      screenWidth: screenWidth,
    );
  }
}
