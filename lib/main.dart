import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Walid Hassani - Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Roboto',
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({Key? key}) : super(key: key);

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  late VideoPlayerController _videoController;
  String _currentLanguage = 'fr'; // 'fr' par défaut, 'en', 'ar'

  // Dictionnaire complet de traductions pour le support multilingue
  final Map<String, Map<String, String>> _translations = {
    'fr': {
      'name': 'WALID HASSANI',
      'jobTitle': 'Consultant ERP & Chef de Projet Technique',
      'downloadCv': 'Télécharger mon CV',
      'expertiseTitle': 'Mon Expertise Hybride',
      'erpTitle': 'Gestion & ERP',
      'erpDesc': 'Intégration et paramétrage Dolibarr, gestion commerciale, modules sur-mesure.',
      'devTitle': 'Développement & IA',
      'devDesc': 'Flutter, OCR local (Tesseract), intégration d\'API IA pour l\'automatisation.',
      'projectsTitle': 'Démos & Réalisations Interactives',
      'project1Title': 'Facturation Intelligente',
      'project1Desc': 'Application Desktop avec lecture OCR pour l\'extraction automatique de factures.',
      'project2Title': 'ERP Dolibarr Sur-mesure',
      'project2Desc': 'Automatisation des flux métiers et extrafields complexes.',
      'techStackTitle': 'Stack Technique & Technologies Masterisées',
      'timelineTitle': 'Mon Parcours Professionnel',
      'contactTitle': 'Travaillons Ensemble',
      'statsProjects': 'Projets Déployés',
      'statsSatisfaction': 'Satisfaction Client',
      'statsExperience': 'Ans d\'Expérience',
      'statsAutomation': 'Gain de Temps IA',
      'viewDetails': 'Cliquer pour voir la démo',
      'emailCopied': 'Adresse e-mail copiée dans le presse-papiers !',
      'contactMe': 'Me Contacter par E-mail',
    },
    'en': {
      'name': 'WALID HASSANI',
      'jobTitle': 'ERP Consultant & Technical Project Manager',
      'downloadCv': 'Download my CV',
      'expertiseTitle': 'My Hybrid Expertise',
      'erpTitle': 'Management & ERP',
      'erpDesc': 'Dolibarr integration & setup, commercial management, custom modules.',
      'devTitle': 'Development & AI',
      'devDesc': 'Flutter, local OCR (Tesseract), AI API integration for automation.',
      'projectsTitle': 'Interactive Demos & Projects',
      'project1Title': 'Smart Invoicing',
      'project1Desc': 'Desktop Application with OCR processing for automatic invoice data extraction.',
      'project2Title': 'Custom Dolibarr ERP',
      'project2Desc': 'Business workflow automation and complex custom fields.',
      'techStackTitle': 'Tech Stack & Mastered Technologies',
      'timelineTitle': 'Professional Career Journey',
      'contactTitle': 'Let\'s Work Together',
      'statsProjects': 'Deployed Projects',
      'statsSatisfaction': 'Client Satisfaction',
      'statsExperience': 'Years Experience',
      'statsAutomation': 'AI Time Saved',
      'viewDetails': 'Click to view demo',
      'emailCopied': 'Email address copied to clipboard!',
      'contactMe': 'Contact Me by Email',
    },
    'ar': {
      'name': 'وليد حساني',
      'jobTitle': 'مستشار ERP ومدير مشاريع تقني',
      'downloadCv': 'تحميل السيرة الذاتية',
      'expertiseTitle': 'خبرتي المزدوجة',
      'erpTitle': 'الإدارة وأنظمة ERP',
      'erpDesc': 'تكامل وإعداد Dolibarr، الإدارة التجارية، وتطوير وحدات حسب الطلب.',
      'devTitle': 'التطوير والذكاء الاصطناعي',
      'devDesc': 'Flutter، قراءة النصوص OCR محلياً (Tesseract)، وربط واجهات الذكاء الاصطناعي للأتمتة.',
      'projectsTitle': 'العروض والمشاريع التفاعلية',
      'project1Title': 'الفوترة الذكية',
      'project1Desc': 'تطبيق مكتبي مع تقنية OCR لاستخراج بيانات الفواتير تلقائياً.',
      'project2Title': 'نظام ERP Dolibarr مخصص',
      'project2Desc': 'أتمتة مسارات العمل والحقول المخصصة المعقدة.',
      'techStackTitle': 'التقنيات والأدوات المعتمدة',
      'timelineTitle': 'المسار المهني',
      'contactTitle': 'لنعمل معاً',
      'statsProjects': 'مشروع مكتمل',
      'statsSatisfaction': 'رضا العملاء',
      'statsExperience': 'سنوات خبرة',
      'statsAutomation': 'توفير الوقت بالذكاء الاصطناعي',
      'viewDetails': 'أنقر لمشاهدة العرض',
      'emailCopied': 'تم نسخ البريد الإلكتروني بنجاح!',
      'contactMe': 'التواصل عبر البريد',
    },
  };

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/pitch_video_fr.webm')
      ..addListener(() {
        if (mounted) setState(() {});
      })
      ..setVolume(0.0) // Initialisation en mode muet pour permettre le chargement sur navigateur Web (Chrome)
      ..setLooping(true)
      ..initialize().then((_) {
        if (mounted) {
          _videoController.play().catchError((e) {
            debugPrint("Autoplay empêché par le navigateur: $e");
          });
        }
      }).catchError((error) {
        debugPrint("Erreur lors de l'initialisation de la vidéo: $error");
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  // Widget pour le bouton de sélection de langue
  Widget _buildLanguageBtn(String label, String langCode) {
    bool isSelected = _currentLanguage == langCode;
    return InkWell(
      onTap: () {
        setState(() {
          _currentLanguage = langCode;
        });
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

  // Boîte de dialogue pour afficher la démo interactive du projet
  void _showProjectModal(BuildContext context, String title, String desc, String techStack) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                desc,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 15),
              const Text(
                'Technologies:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  techStack,
                  style: TextStyle(color: Colors.blueGrey.shade800, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> t = _translations[_currentLanguage]!;
    bool isRtl = _currentLanguage == 'ar';

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 1. Section Héro (Présentation)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
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
                    const SizedBox(height: 30),

                    // --- Section Vidéo de Profil Circulaire ---
                    GestureDetector(
                      onTap: () async {
                        if (!_videoController.value.isInitialized) return;
                        setState(() {
                          if (_videoController.value.isPlaying) {
                            _videoController.pause();
                          } else {
                            _videoController.play();
                          }
                        });
                      },
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueGrey.shade800,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 15)
                          ],
                        ),
                        child: ClipOval(
                          child: _videoController.value.isInitialized
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 300,
                                      height: 300,
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                          width: _videoController.value.size.width,
                                          height: _videoController.value.size.height,
                                          child: VideoPlayer(_videoController),
                                        ),
                                      ),
                                    ),

                                    // Superposition sombre avec icône Play au centre lorsque la vidéo est en pause
                                    if (!_videoController.value.isPlaying)
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
                                                  if (_videoController.value.isPlaying) {
                                                    _videoController.pause();
                                                  } else {
                                                    _videoController.play();
                                                  }
                                                });
                                              },
                                              child: Icon(
                                                _videoController.value.isPlaying
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
                                                if (_videoController.value.volume == 0.0) {
                                                  await _videoController.setVolume(1.0);
                                                  await _videoController.play();
                                                } else {
                                                  await _videoController.setVolume(0.0);
                                                }
                                                if (mounted) setState(() {});
                                              },
                                              child: Icon(
                                                _videoController.value.volume == 0.0
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
                                )
                              : const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      t['name']!,
                      style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      t['jobTitle']!,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                          letterSpacing: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Action pour télécharger le CV ou ouvrir un رابط
                      },
                      icon: const Icon(Icons.download),
                      label: Text(t['downloadCv']!),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Bannière de Statistiques & Métriques d'Impact (Section Clé)
              Container(
                width: double.infinity,
                color: Colors.blueGrey.shade800,
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _buildStatCard('15+', t['statsProjects']!, Icons.check_circle_outline),
                    _buildStatCard('100%', t['statsSatisfaction']!, Icons.sentiment_very_satisfied),
                    _buildStatCard('5+', t['statsExperience']!, Icons.work_outline),
                    _buildStatCard('80%', t['statsAutomation']!, Icons.bolt),
                  ],
                ),
              ),

              // 3. Section Expertise (Compétences)
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Text(
                      t['expertiseTitle']!,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 40,
                      runSpacing: 40,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildExpertiseCard(
                          t['erpTitle']!,
                          t['erpDesc']!,
                          Icons.business_center,
                        ),
                        _buildExpertiseCard(
                          t['devTitle']!,
                          t['devDesc']!,
                          Icons.code,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 4. Section Stack Technique (Badges de Technologies)
              Container(
                width: double.infinity,
                color: Colors.blueGrey.shade50,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      t['techStackTitle']!,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 25),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildTechChip('Dolibarr ERP', Colors.blue),
                        _buildTechChip('Flutter & Dart', Colors.lightBlue),
                        _buildTechChip('OCR Local (Tesseract)', Colors.teal),
                        _buildTechChip('Intégration API IA', Colors.deepPurple),
                        _buildTechChip('Python & Scripts', Colors.amber.shade800),
                        _buildTechChip('PostgreSQL & SQL', Colors.indigo),
                        _buildTechChip('REST APIs & Webhooks', Colors.green),
                        _buildTechChip('Docker & Cloud', Colors.blueGrey),
                      ],
                    ),
                  ],
                ),
              ),

              // 5. Section Projets (Démos & Réalisations)
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Text(
                      t['projectsTitle']!,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildProjectCard(
                          context,
                          t['project1Title']!,
                          t['project1Desc']!,
                          'Flutter Desktop, Tesseract OCR, Python Backend',
                          t['viewDetails']!,
                        ),
                        _buildProjectCard(
                          context,
                          t['project2Title']!,
                          t['project2Desc']!,
                          'Dolibarr PHP/SQL, Extrafields, REST API',
                          t['viewDetails']!,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 6. Section Appel à l'Action & Contact
              Container(
                width: double.infinity,
                color: Colors.blueGrey.shade900,
                padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      t['contactTitle']!,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'walid.hassani@example.com',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(text: 'walid.hassani@example.com'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(t['emailCopied']!),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.teal,
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy),
                      label: Text(t['contactMe']!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour afficher les cartes de statistiques
  Widget _buildStatCard(String value, String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.tealAccent, size: 32),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
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
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      backgroundColor: Colors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    );
  }

  // Card d'expertise
  Widget _buildExpertiseCard(String title, String desc, IconData icon) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Icon(icon, size: 50, color: Colors.blueGrey),
          const SizedBox(height: 15),
          Text(title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(desc,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // Card de projet interactive
  Widget _buildProjectCard(
      BuildContext context, String title, String desc, String tech, String btnText) {
    return InkWell(
      onTap: () => _showProjectModal(context, title, desc, tech),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 350,
        height: 220,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blueGrey.shade100),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const Icon(Icons.open_in_new, size: 20, color: Colors.blueGrey),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                desc,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.touch_app, size: 16, color: Colors.teal),
                const SizedBox(width: 5),
                Text(
                  btnText,
                  style: const TextStyle(
                      color: Colors.teal,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
