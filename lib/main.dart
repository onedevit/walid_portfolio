import 'web_helper.dart' as web_helper;
import 'intro_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Dictionnaire complet de traductions pour le support multilingue
  final Map<String, Map<String, String>> _translations = {
    'fr': {
      'name': 'WALID HASSANI',
      'jobTitle': 'Consultant ERP & Intégrateur de Solutions de Gestion\nChef de Projet Technique',
      'locationMobility': 'Ksar Hellal, Tunisie | Mobilité Internationale : France / Belgique',
      'downloadCv': 'Télécharger mon CV (PDF)',
      
      'profileTitle': 'PROFIL PROFESSIONNEL',
      'profileText': 'Entrepreneur et Chef de projet technique avec plus de 10 ans d’expérience dans la conception, le déploiement et l’intégration de solutions logicielles d’entreprise. Double compétence rare alliant la maîtrise des processus de gestion/comptabilité à l’ingénierie logicielle appliquée. Expert dans l’automatisation des flux métier, la personnalisation d’ERP (Dolibarr), le développement e-commerce WordPress & WooCommerce (plugins sur-mesure), et l’intégration de technologies avancées (OCR, IA locale, APIs) pour optimiser la productivité des PME.',
      
      'skillsTitle': 'COMPÉTENCES CLÉS',
      'skill1Title': 'Gestion & ERP',
      'skill1Desc': 'Intégration et paramétrage ERP/CRM (Dolibarr), conformité facturation/fiscalité, gestion commerciale, modules sur-mesure.',
      'skill2Title': 'Automatisation & IA Appliquée',
      'skill2Desc': 'Ingénierie de prompts, intégration d’IA en production (APIs, LLMs locaux via llama-server), reconnaissance optique de documents (OCR Tesseract, PaddleOCR).',
      'skill3Title': 'WordPress & WooCommerce',
      'skill3Desc': 'Développement e-commerce, création et personnalisation de plugins WordPress/WooCommerce sur-mesure, passerelles de paiement et synchronisation de données.',
      'skill4Title': 'Conception & Développement',
      'skill4Desc': 'Logique algorithmique avancée (WinDev, WebDev), développement applicatif assisté par IA (Flutter Desktop/Mobile, Dart, PHP, JavaScript).',
      'skill5Title': 'Infrastructure & Systèmes',
      'skill5Desc': 'Administration serveurs Linux (Debian, Ubuntu), Windows Server, stratégies de sauvegarde automatisée (rclone, Google Drive), NAS et réseaux locaux.',
      'skill6Title': 'Gestion de Projet',
      'skill6Desc': 'Cycle complet (analyse des besoins, cahier des charges, prototypage rapide, déploiement, formation utilisateurs).',

      'experienceTitle': 'EXPÉRIENCES PROFESSIONNELLES',
      'exp1Role': 'Fondateur & Chef de Projet Technique / Intégrateur ERP & Web',
      'exp1Company': 'ONEDEV – Ksar Hellal, Tunisie | Janvier 2016 – Présent',
      'exp1Bullet1': 'Pilotage de bout en bout de projets logiciels de gestion et plateformes e-commerce pour un portefeuille de plus de 15 clients PME.',
      'exp1Bullet2': 'Conception et personnalisation avancée de l’ERP Dolibarr et développement de plugins WordPress/WooCommerce sur-mesure.',
      'exp1Bullet3': 'Développement de solutions de bureau et mobiles de gestion (facturation intelligente, déclaration fiscale automatisée avec lecture OCR de factures).',
      'exp1Bullet4': 'Mise en place et administration d’infrastructures serveurs sécurisées (Linux Debian, automatisation de sauvegardes cloud via scripts shell et rclone).',
      'exp1Bullet5': 'Supervision technique d’équipes de développement et formation de plus de 20 stagiaires et collaborateurs.',

      'exp2Role': 'Co-fondateur & Responsable Technique FAO / Systèmes',
      'exp2Company': 'PetouHome – Ksar Hellal, Tunisie | Janvier 2022 – Présent',
      'exp2Bullet1': 'Supervision de la chaîne de production numérique et optimisation des processus de découpe industrielle CNC Laser.',
      'exp2Bullet2': 'Analyse et conversion de plus de 5 000 fichiers vectoriels et plans techniques (CAD/CAM).',
      'exp2Bullet3': 'Paramétrage précis des flux machines et mise en place de protocoles de contrôle qualité stricts.',

      'exp3Role': 'Gérant & Coordinateur de Projets Multimédia',
      'exp3Company': 'S.T.P.T – Ksar Hellal, Tunisie | Juillet 2011 – Novembre 2015',
      'exp3Bullet1': 'Direction opérationnelle de l’agence et coordination de projets d’applications et de communication numérique.',
      'exp3Bullet2': 'Gestion des relations clients, cadrage budgétaire et planification des livrables.',

      'projectsTitle': 'PROJETS MARQUANTS INTERACTIFS',
      'proj1Title': 'Plateforme E-Commerce Lumina',
      'proj1Desc': 'Boutique en ligne moderne et responsive, optimisée pour la gestion de catalogue et le traitement fluide des flux de commandes.',
      'proj1Tech': 'WordPress, WooCommerce, PHP, MySQL, REST API',

      'proj2Title': 'Dolibarr Mobile Enterprise',
      'proj2Desc': 'Application mobile connectée aux serveurs Dolibarr ERP via API sécurisée pour le pilotage et la consultation en temps réel des flux d’entreprise.',
      'proj2Tech': 'Flutter (Android & iOS), Dolibarr REST API, Provider, Material 3',

      'proj3Title': 'Notifio CRM - Marketing Automation SaaS',
      'proj3Desc': 'Plateforme SaaS d’automatisation marketing multi-canaux (WhatsApp, Email, SMS) avec gestion de files d’attente et suivi des performances.',
      'proj3Tech': 'Flutter, Architecture SaaS, Queue Processing, REST APIs, Webhooks',

      'proj4Title': 'OneDev Track - Portail de Suivi Projets',
      'proj4Desc': 'Portail web collaboratif en production dédié au suivi d’avancement des projets clients, validation des étapes et archivage sécurisé.',
      'proj4Tech': 'Flutter Web, Backend PHP, MySQL, REST API, Déploiement Cloud',

      'proj5Title': 'Suite Fiscale & OCR Intelligent (Desktop)',
      'proj5Desc': 'Application de gestion comptable avec extraction optique de documents (OCR local) et édition automatisée des déclarations fiscales.',
      'proj5Tech': 'Flutter Desktop, Moteur OCR, SQLite, Générateur PDF',

      'proj6Title': 'ONEDEV Facture Lite',
      'proj6Desc': 'Solution logicielle autonome et portable de gestion commerciale, devis et facturation avec base de données locale embarquée.',
      'proj6Tech': 'Flutter Desktop/Mobile, SQLite, Moteur PDF, Clean Architecture',

      'proj7Title': 'ERP Métier Sur-Mesure (Dolibarr)',
      'proj7Desc': 'Déploiement et personnalisation de modules ERP/CRM pour optimiser la gestion administrative, commerciale et le suivi financier.',
      'proj7Tech': 'Dolibarr ERP, PHP, SQL, Extrafields, REST API',

      'proj8Title': 'ONEDEV Baraem - Gestion Scolaire & Préscolaire',
      'proj8Desc': 'Système de gestion multiplateforme (Desktop & Mobile) pour structures éducatives, opérant en mode autonome hors-ligne (Offline-First).',
      'proj8Tech': 'Flutter Desktop & Mobile, Base SQLite (Offline-First), UI Responsive',

      'proj9Title': 'ONEDEV Indemnité Accident - Legal-Tech',
      'proj9Desc': 'Solution Legal-Tech spécialisée dans le calcul d’indemnités réglementaires et l’édition de rapports d’évaluation pour dossiers juridiques.',
      'proj9Tech': 'Flutter, Moteur de Calcul Normatif, SQLite, Édition PDF',

      'proj10Title': 'Kartiq - Solution de Fidélité Digitale',
      'proj10Desc': 'Système de fidélisation client dématérialisé innovant offrant une expérience fluide sans application (Zero-App via QR Code web).',
      'proj10Tech': 'Flutter Web, Expérience QR Code, Backend Cloud, UI Responsive',

      'proj11Title': 'Écosystème Home Rules (Mobile & Desktop)',
      'proj11Desc': 'Solution synchronisant une application mobile de supervision avec un agent Windows Desktop sécurisé pour la régulation du temps d’écran.',
      'proj11Tech': 'Flutter Mobile, Flutter Desktop, Windows Win32 API, Supabase Cloud',

      'proj12Title': 'Plateforme Éducative Interactive (Azzouz)',
      'proj12Desc': 'Suite applicative interactive combinant un lecteur multimédia didactique et un gestionnaire de modules pédagogiques.',
      'proj12Tech': 'Flutter Windows Desktop, Gestion Modulaire de Contenu, UI Enfant',

      'proj13Title': 'Azzouz Game - Jeu de Plateforme 2D',
      'proj13Desc': 'Jeu vidéo 2D rétro avec moteur physique, animations de sprites par images-clés, niveaux progressifs et conception sonore dynamique.',
      'proj13Tech': 'Flutter, Flame Game Engine 2D, Audio FX, Persistance d’État',
      'closeModal': 'Fermer',

      'educationTitle': 'FORMATION & DIPLÔMES',
      'edu1': 'Licence en Sciences de Gestion (Spécialité Comptabilité) – Université Virtuelle de Tunis (En cours)',
      'edu2': 'Formation CEFE (Création d\'Entreprises et Formation d\'Entrepreneurs) – ANETI, Tunisie (2010)',
      'edu3': 'Baccalauréat en Économie et Gestion – Lycée 2 Mars 1934, Ksar Hellal, Tunisie (2005)',

      'langCommitmentTitle': 'LANGUES & ENGAGEMENT',
      'lang1': 'Français : Courant / Professionnel',
      'lang2': 'Arabe : Langue maternelle',
      'lang3': 'Anglais : Technique / Professionnel',
      'commitment': 'Engagement : Ancien membre actif CONECT (Confédération des Entreprises Citoyennes de Tunisie).',

      'techStackTitle': 'STACK TECHNIQUE & OUTILS',
      'contactTitle': 'ME CONTACTER',
      'phone': '(+216) 52 985 659',
      'email': 'hasseniwalid@gmail.com',
      'statsProjects': 'Clients PME Actifs',
      'statsSatisfaction': 'Satisfaction Client',
      'statsExperience': 'Ans d\'Expérience',
      'statsAutomation': 'Gain de Temps IA',
      'viewDetails': 'Cliquer pour détails & démo',
      'emailCopied': 'Adresse e-mail copiée dans le presse-papiers !',
      'contactMe': 'Me Contacter par E-mail',
    },
    'en': {
      'name': 'WALID HASSANI',
      'jobTitle': 'ERP Consultant & Business Solutions Integrator\nTechnical Project Manager',
      'locationMobility': 'Ksar Hellal, Tunisia | International Mobility: France / Belgium',
      'downloadCv': 'Download my CV (PDF)',
      
      'profileTitle': 'PROFESSIONAL PROFILE',
      'profileText': 'Entrepreneur and Technical Project Manager with over 10 years of experience in designing, deploying, and integrating enterprise software solutions. Possesses a rare dual competence combining management and accounting expertise with applied software engineering. Expert in business workflow automation, ERP customization (Dolibarr), e-commerce development (custom WordPress & WooCommerce plugins), and advanced technology integration (OCR, local AI, APIs) to optimize SME productivity.',
      
      'skillsTitle': 'CORE COMPETENCIES',
      'skill1Title': 'Management & ERP',
      'skill1Desc': 'Dolibarr ERP/CRM integration and setup, invoicing and tax compliance, commercial management, custom modules.',
      'skill2Title': 'Automation & Applied AI',
      'skill2Desc': 'Prompt engineering, production AI integration (APIs, local LLMs via llama-server), optical document recognition (Tesseract OCR, PaddleOCR).',
      'skill3Title': 'WordPress & WooCommerce',
      'skill3Desc': 'E-commerce development, creation and customization of bespoke WordPress/WooCommerce plugins, payment gateways, and data synchronization.',
      'skill4Title': 'Design & Development',
      'skill4Desc': 'Advanced algorithmic logic (WinDev, WebDev), AI-assisted application development (Flutter Desktop/Mobile, Dart, PHP, JavaScript).',
      'skill5Title': 'Infrastructure & Systems',
      'skill5Desc': 'Linux server administration (Debian, Ubuntu), Windows Server, automated backup strategies (rclone, Google Drive), NAS, and local networks.',
      'skill6Title': 'Project Management',
      'skill6Desc': 'Full lifecycle management (needs analysis, technical specifications, rapid prototyping, deployment, user training).',

      'experienceTitle': 'PROFESSIONAL EXPERIENCE',
      'exp1Role': 'Founder, Technical Project Manager & ERP/Web Integrator',
      'exp1Company': 'ONEDEV – Ksar Hellal, Tunisia | January 2016 – Present',
      'exp1Bullet1': 'End-to-end management of business software projects and e-commerce platforms for a portfolio of over 15 SME clients.',
      'exp1Bullet2': 'Advanced design and customization of Dolibarr ERP and development of bespoke WordPress/WooCommerce plugins.',
      'exp1Bullet3': 'Development of desktop and mobile management solutions (smart invoicing, automated tax declarations with OCR invoice reading).',
      'exp1Bullet4': 'Setup and administration of secure server infrastructures (Linux Debian, automated cloud backups via shell scripts and rclone).',
      'exp1Bullet5': 'Technical supervision of development teams and training of over 20 trainees and collaborators.',

      'exp2Role': 'Co-founder & Technical Lead CAM / Systems',
      'exp2Company': 'PetouHome – Ksar Hellal, Tunisia | January 2022 – Present',
      'exp2Bullet1': 'Supervision of the digital production line and optimization of CNC Laser industrial cutting processes.',
      'exp2Bullet2': 'Analysis and conversion of over 5,000 vector files and technical drawings (CAD/CAM).',
      'exp2Bullet3': 'Precise machine workflow configuration and implementation of strict quality control protocols.',

      'exp3Role': 'Manager & Multimedia Project Coordinator',
      'exp3Company': 'S.T.P.T – Ksar Hellal, Tunisia | July 2011 – November 2015',
      'exp3Bullet1': 'Operational agency management and coordination of application and digital communication projects.',
      'exp3Bullet2': 'Client relationship management, budget scoping, and deliverable planning.',

      'projectsTitle': 'FEATURED INTERACTIVE PROJECTS',
      'proj1Title': 'Lumina E-Commerce Platform',
      'proj1Desc': 'Modern and responsive online store optimized for catalog management and smooth order processing workflows.',
      'proj1Tech': 'WordPress, WooCommerce, PHP, MySQL, REST API',

      'proj2Title': 'Dolibarr Mobile Enterprise',
      'proj2Desc': 'Cross-platform mobile application securely connected to Dolibarr ERP servers via API for real-time business monitoring.',
      'proj2Tech': 'Flutter (Android & iOS), Dolibarr REST API, Provider, Material 3',

      'proj3Title': 'Notifio CRM - Marketing Automation SaaS',
      'proj3Desc': 'Multi-channel marketing automation SaaS platform (WhatsApp, Email, SMS) with queue processing and delivery performance tracking.',
      'proj3Tech': 'Flutter, SaaS Architecture, Queue Processing, REST APIs, Webhooks',

      'proj4Title': 'OneDev Track - Project Tracking Portal',
      'proj4Desc': 'Live collaborative web portal for real-time monitoring of client project milestones, deliverables, and secure archives.',
      'proj4Tech': 'Flutter Web, PHP Backend, MySQL, REST API, Cloud Deployment',

      'proj5Title': 'Smart Tax & OCR Suite (Desktop)',
      'proj5Desc': 'Accounting management software featuring local optical document extraction (OCR) and automated tax report generation.',
      'proj5Tech': 'Flutter Desktop, OCR Engine, SQLite, PDF Generator',

      'proj6Title': 'ONEDEV Facture Lite',
      'proj6Desc': 'Standalone portable invoicing and commercial management solution with an embedded local database.',
      'proj6Tech': 'Flutter Desktop/Mobile, SQLite, PDF Engine, Clean Architecture',

      'proj7Title': 'Custom Business ERP (Dolibarr)',
      'proj7Desc': 'Deployment and customization of ERP/CRM modules to streamline administrative, commercial, and financial operations.',
      'proj7Tech': 'Dolibarr ERP, PHP, SQL, Extrafields, REST API',

      'proj8Title': 'ONEDEV Baraem - Educational Management',
      'proj8Desc': 'Cross-platform management system (Desktop & Mobile) for educational facilities, operating reliably offline (Offline-First).',
      'proj8Tech': 'Flutter Desktop & Mobile, SQLite Database (Offline-First), Responsive UI',

      'proj9Title': 'ONEDEV Accident Compensation - Legal-Tech',
      'proj9Desc': 'Specialized Legal-Tech solution designed for statutory compensation calculations and formal legal evaluation reports.',
      'proj9Tech': 'Flutter, Legal Calculation Engine, SQLite, PDF Reports',

      'proj10Title': 'Kartiq - Digital Loyalty System',
      'proj10Desc': 'Modern contactless customer loyalty system offering an instant zero-app web experience via interactive QR codes.',
      'proj10Tech': 'Flutter Web, QR Experience, Cloud Backend, Responsive UI',

      'proj11Title': 'Home Rules Ecosystem (Mobile & Desktop)',
      'proj11Desc': 'Connected system synchronizing a parent mobile app with a secure Windows Desktop agent for smart screen-time regulation.',
      'proj11Tech': 'Flutter Mobile, Flutter Desktop, Windows Win32 API, Supabase Cloud',

      'proj12Title': 'Azzouz Interactive Learning Platform',
      'proj12Desc': 'Interactive educational suite combining a multimedia learning player and a modular pedagogical content manager.',
      'proj12Tech': 'Flutter Windows Desktop, Modular Content Management, Child-Friendly UI',

      'proj13Title': 'Azzouz Game - 2D Platformer Video Game',
      'proj13Desc': 'Retro-style 2D platformer video game built with a 2D physics engine, smooth sprite animations, progressive levels, and dynamic audio.',
      'proj13Tech': 'Flutter, Flame Game Engine 2D, Audio FX, State Persistence',
      'closeModal': 'Close',

      'educationTitle': 'EDUCATION & CERTIFICATIONS',
      'edu1': 'Bachelor\'s Degree in Management Sciences (Accounting Specialization) – Virtual University of Tunis (In progress)',
      'edu2': 'CEFE Training (Business Creation and Entrepreneurship) – ANETI, Tunisia (2010)',
      'edu3': 'High School Diploma in Economics and Management – Lycée 2 Mars 1934, Ksar Hellal, Tunisia (2005)',

      'langCommitmentTitle': 'LANGUAGES & VOLUNTEERING',
      'lang1': 'French: Fluent / Professional',
      'lang2': 'Arabic: Native Language',
      'lang3': 'English: Technical / Professional',
      'commitment': 'Volunteering: Former active member of CONECT (Confederation of Tunisian Citizen Enterprises).',

      'techStackTitle': 'TECH STACK & TOOLS',
      'contactTitle': 'CONTACT ME',
      'phone': '(+216) 52 985 659',
      'email': 'hasseniwalid@gmail.com',
      'statsProjects': 'Active SME Clients',
      'statsSatisfaction': 'Client Satisfaction',
      'statsExperience': 'Years Experience',
      'statsAutomation': 'AI Time Saved',
      'viewDetails': 'Click for details & demo',
      'emailCopied': 'Email address copied to clipboard!',
      'contactMe': 'Contact Me by Email',
    },
    'ar': {
      'name': 'وليد الحساني',
      'jobTitle': 'مستشار ERP ومُدمج لحلول الإدارة\nمدير مشاريع تقني',
      'locationMobility': 'قصر هلال، تونس | القابلية للتنقل الدولي: فرنسا / بلجيكا',
      'downloadCv': 'تحميل السيرة الذاتية (PDF)',
      
      'profileTitle': 'الملف الشخصي والمهني',
      'profileText': 'رائد أعمال ومدير مشاريع تقني بخبرة تتجاوز 10 سنوات في تصميم، نشر، ودمج الحلول البرمجية للمؤسسات. أمتلك كفاءة مزدوجة ونادرة تجمع بين إتقان عمليات الإدارة والمحاسبة، وهندسة البرمجيات التطبيقية. خبير في أتمتة مسارات العمل، تخصيص أنظمة ERP (Dolibarr)، تطوير المتاجر الإلكترونية وبرمجة إضافات ووردبريس وووكمرس المخصصة، بالإضافة إلى دمج التقنيات المتقدمة (التعرف الضوئي على الحروف OCR، الذكاء الاصطناعي المحلي، وواجهات برمجة التطبيقات APIs) لتحسين إنتاجية الشركات الصغرى والمتوسطة.',
      
      'skillsTitle': 'الكفاءات الأساسية',
      'skill1Title': 'الإدارة وأنظمة ERP',
      'skill1Desc': 'إعداد ودمج نظام ERP/CRM (Dolibarr)، مطابقة الفوترة والجباية، الإدارة التجارية، وتطوير وحدات مخصصة.',
      'skill2Title': 'الأتمتة والذكاء الاصطناعي التطبيقي',
      'skill2Desc': 'هندسة الأوامر (Prompt Engineering)، دمج الذكاء الاصطناعي في بيئة الإنتاج (APIs، ونماذج لغوية محلية LLMs عبر llama-server)، والتعرف الضوئي على المستندات (OCR Tesseract, PaddleOCR).',
      'skill3Title': 'ووردبريس وووكمرس',
      'skill3Desc': 'تطوير المتاجر الإلكترونية، إنشاء وتخصيص إضافات ووردبريس وووكمرس (Plugins)، دمج بوابات الدفع الإلكتروني، ومزامنة البيانات.',
      'skill4Title': 'التصميم والتطوير',
      'skill4Desc': 'المنطق الخوارزمي المتقدم (WinDev, WebDev)، وتطوير التطبيقات بمساعدة الذكاء الاصطناعي (Flutter Desktop/Mobile, Dart, PHP, JavaScript).',
      'skill5Title': 'البنية التحتية والأنظمة',
      'skill5Desc': 'إدارة خوادم Linux (Debian, Ubuntu)، Windows Server، استراتيجيات النسخ الاحتياطي التلقائي (rclone, Google Drive)، الخوادم التخزينية NAS، والشبكات المحلية.',
      'skill6Title': 'إدارة المشاريع',
      'skill6Desc': 'الدورة الكاملة للمشروع (تحليل الاحتياجات، كراس الشروط، النمذجة السريعة، النشر، وتدريب المستخدمين).',

      'experienceTitle': 'الخبرات المهنية',
      'exp1Role': 'مؤسس ومدير مشاريع تقني / مُدمج أنظمة ERP والويب',
      'exp1Company': 'ONEDEV – قصر هلال، تونس | جانفي 2016 – الحالي',
      'exp1Bullet1': 'الإدارة الشاملة لمشاريع البرمجيات الإدارية ومنصات التجارة الإلكترونية لأكثر من 15 شركة صغيرة ومتوسطة (PME).',
      'exp1Bullet2': 'التصميم والتخصيص المتقدم لنظام Dolibarr ERP وتطوير إضافات ووردبريس وووكمرس مخصصة.',
      'exp1Bullet3': 'تطوير حلول إدارة مكتبية للهواتف والحواسيب (الفوترة الذكية، والتصريح الجبائي الآلي عبر قراءة الفواتير بتقنية OCR).',
      'exp1Bullet4': 'إعداد وإدارة بنية خوادم آمنة (Linux Debian، وأتمتة النسخ الاحتياطي السحابي عبر نصوص برمجة Shell و rclone).',
      'exp1Bullet5': 'الإشراف التقني على فرق التطوير وتدريب أكثر من 20 متدرباً ومعاوناً.',

      'exp2Role': 'شريك مؤسس ومسؤول تقني للأنظمة والتصنيع بمساعدة الحاسوب (CAM)',
      'exp2Company': 'PetouHome – قصر هلال، تونس | جانفي 2022 – الحالي',
      'exp2Bullet1': 'الإشراف على خط الإنتاج الرقمي وأتمتة عمليات القطع الصناعي بالليزر CNC Laser.',
      'exp2Bullet2': 'تحليل وتحويل أكثر من 5000 ملف متجه ومخطط تقني (CAD/CAM).',
      'exp2Bullet3': 'الضبط الدقيق لمسارات الآلات وتطبيق بروتوكولات صارمة لمراقبة الجودة.',

      'exp3Role': 'مدير ومنسق مشاريع الوسائط المتعددة',
      'exp3Company': 'S.T.P.T – قصر هلال، تونس | جويلية 2011 – نوفمبر 2015',
      'exp3Bullet1': 'الإدارة التشغيلية للوكالة وتنسيق مشاريع التطبيقات والتواصل الرقمي.',
      'exp3Bullet2': 'إدارة العلاقات مع العملاء والضبط المالي والتخطيط للمخرجات.',

      'projectsTitle': 'المشاريع البارزة التفاعلية',
      'proj1Title': 'منصة التجارة الإلكترونية Lumina',
      'proj1Desc': 'متجر إلكتروني حديث ومتجاوب، مصمم ومحسّن لإدارة كتالوج المنتجات وتدفق الطلبيات بسلاسة وسرعة.',
      'proj1Tech': 'WordPress, WooCommerce, PHP, MySQL, REST API',

      'proj2Title': 'تطبيق الجوال لمؤسسات Dolibarr Mobile Enterprise',
      'proj2Desc': 'تطبيق هاتف متعدد المنصات يرتبط مباشرة مع أنظمة Dolibarr ERP عبر واجهة برمجية آمنة لمتابعة الأداء التجاري والبيانات في الوقت الفعلي.',
      'proj2Tech': 'Flutter (Android & iOS), Dolibarr REST API, Provider, Material 3',

      'proj3Title': 'منصة أتمتة الحملات والتواصل Notifio CRM',
      'proj3Desc': 'منصة سحابية متقدمة (SaaS) لإدارة وأتمتة حملات التواصل متعددة القنوات (WhatsApp, Email, SMS) مع متابعة دقيقة لمعدلات الوصول والتسليم.',
      'proj3Tech': 'Flutter, SaaS Architecture, Queue Processing, REST APIs, Webhooks',

      'proj4Title': 'بوابة متابعة المشاريع OneDev Track',
      'proj4Desc': 'منصة ويب تفاعلية منشورة مباشرة تتيح للعملاء متابعة مراحل إنجاز المشاريع والمهام والتسليمات المعتمدة بشفافية وأمان.',
      'proj4Tech': 'Flutter Web, PHP Backend, MySQL, REST API, Cloud Deployment',

      'proj5Title': 'منظومة المحاسبة والتصريح الجبائي الذكية (Desktop)',
      'proj5Desc': 'برنامج مكتبي لإدارة المعاملات المحاسبية مع خاصية القراءة الضوئية الذكية للفواتير (OCR) وإصدار التقارير الجبائية آلياً.',
      'proj5Tech': 'Flutter Desktop, OCR Engine, SQLite, PDF Generator',

      'proj6Title': 'برنامج الفوترة المحمول ONEDEV Facture Lite',
      'proj6Desc': 'حل برمجي مستقل ومحمول لإدارة المبيعات والفوترة السريعة مع قاعدة بيانات محلية مدمجة.',
      'proj6Tech': 'Flutter Desktop/Mobile, SQLite, PDF Engine, Clean Architecture',

      'proj7Title': 'نظام ERP مخصص للمؤسسات (Dolibarr)',
      'proj7Desc': 'إعداد وتخصيص وحدات متقدمة لنظام إدارة المؤسسات ERP/CRM لتبسيط ومتابعة مسارات العمل والوثائق الإدارية والمالية.',
      'proj7Tech': 'Dolibarr ERP, PHP, SQL, Extrafields, REST API',

      'proj8Title': 'منظومة إدارة المؤسسات التربوية ONEDEV Baraem',
      'proj8Desc': 'نظام تطبيقي متكامل يعمل على الحواسيب والهواتف لإدارة العمليات الإدارية والمالية للمؤسسات التعليمية بنمط العمل دون اتصال (Offline-First).',
      'proj8Tech': 'Flutter Desktop & Mobile, Base SQLite (Offline-First), UI Responsive',

      'proj9Title': 'تطبيق الحسابات القانونية والتعويضات ONEDEV Legal-Tech',
      'proj9Desc': 'حل برمجي قانوني تخصصي لحساب مستحقات التعويضات بدقة وفق المقاييس المعتمدة وإصدار تقارير مفصلة للملفات القانونية.',
      'proj9Tech': 'Flutter, Legal Computing Engine, SQLite, PDF Reports',

      'proj10Title': 'نظام الولاء الرقمي الذكي Kartiq',
      'proj10Desc': 'منظومة ولاء رقمية حديثة للمحلات والمطاعم تعتمد تجربة المستخدم الفورية عبر الـ QR Code دون إلزام العميل بتحميل أي تطبيق.',
      'proj10Tech': 'Flutter Web, QR Experience, Cloud Backend, Responsive UI',

      'proj11Title': 'منظومة Home Rules المتكاملة (Mobile & Desktop)',
      'proj11Desc': 'حل تقني يربط بين تطبيق هاتف للإشراف وتطبيق حاسوب بنظام Windows مزود بحماية أمان لتنظيم وإدارة أوقات استخدام الأجهزة الذكية.',
      'proj11Tech': 'Flutter Mobile, Flutter Desktop, Windows Win32 API, Supabase Cloud',

      'proj12Title': 'المنصة التعليمية التفاعلية "تعلم مع عزوز"',
      'proj12Desc': 'بيئة برمجية تفاعلية تجمع بين مشغل وسائط تعليمي وتطبيقي موجه للأطفال مع أداة مرنة لإدارة وتنظيم المحتوى التدريبي.',
      'proj12Tech': 'Flutter Windows Desktop, Modular Content Management, Child-Friendly UI',

      'proj13Title': 'لعبة المغامرات ثنائية الأبعاد Azzouz Game',
      'proj13Desc': 'لعبة فيديو 2D كلاسيكية مشوقة تعتمد محرك ألعاب مخصص وفيزياء الحركة والتصادم مع مراحل متدرجة ومؤثرات صوتية تفاعلية.',
      'proj13Tech': 'Flutter, Flame Game Engine 2D, Audio FX, State Persistence',
      'closeModal': 'إغلاق',

      'educationTitle': 'التعليم والشهادات',
      'edu1': 'إجازة في علوم التصرف (اختصاص محاسبة) – الجامعة الافتراضية بتونس (قيد الدراسة)',
      'edu2': 'تدريب CEFE (تكوين بعث المؤسسات وتدريب الباعثين) – الوكالة الوطنية للتشغيل والعمل المستقل ANETI، تونس (2010)',
      'edu3': 'شهادة البكالوريا في الاقتصاد والتصرف – معهد 2 مارس 1934 بقصر هلال (2005)',

      'langCommitmentTitle': 'اللغات والعمل الجمعياتي',
      'lang1': 'الفرنسية : طليق / مهني',
      'lang2': 'العربية : اللغة الأم',
      'lang3': 'الإنجليزية : تقني / مهني',
      'commitment': 'العمل الجمعياتي : عضو نشط سابق في منظمة CONECT (كنفدرالية المؤسسات المواطنة التونسية).',

      'techStackTitle': 'التقنيات والأدوات المعتمدة',
      'contactTitle': 'التواصل المباشر',
      'phone': '(+216) 52 985 659',
      'email': 'hasseniwalid@gmail.com',
      'statsProjects': 'شركة PME نشطة',
      'statsSatisfaction': 'رضا العملاء',
      'statsExperience': 'سنوات خبرة',
      'statsAutomation': 'توفير الوقت بالذكاء الاصطناعي',
      'viewDetails': 'أنقر لمشاهدة التفاصيل',
      'emailCopied': 'تم نسخ البريد الإلكتروني بنجاح!',
      'contactMe': 'التواصل عبر البريد',
    },
  };

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

  // Afficher la boîte de dialogue des détails du projet (Modal)
  void _showProjectModal(BuildContext context, String title, String desc, String techStack, String closeBtnText) {
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 15),
              const Text(
                'Technologies & Stack:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
                  style: TextStyle(color: Colors.blueGrey.shade800, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(closeBtnText),
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

              // 4. Section Compétences Clés (6 Pôles d'Expertise Animés)
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
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 25,
                      runSpacing: 25,
                      alignment: WrapAlignment.center,
                      children: [
                        _HoverCard(
                          title: t['skill1Title']!,
                          desc: t['skill1Desc']!,
                          icon: Icons.business_center,
                          badge: '95%',
                        ),
                        _HoverCard(
                          title: t['skill2Title']!,
                          desc: t['skill2Desc']!,
                          icon: Icons.psychology,
                          badge: '92%',
                        ),
                        _HoverCard(
                          title: t['skill3Title']!,
                          desc: t['skill3Desc']!,
                          icon: Icons.shopping_cart_checkout,
                          badge: '95%',
                        ),
                        _HoverCard(
                          title: t['skill4Title']!,
                          desc: t['skill4Desc']!,
                          icon: Icons.code,
                          badge: '90%',
                        ),
                        _HoverCard(
                          title: t['skill5Title']!,
                          desc: t['skill5Desc']!,
                          icon: Icons.dns,
                          badge: '88%',
                        ),
                        _HoverCard(
                          title: t['skill6Title']!,
                          desc: t['skill6Desc']!,
                          icon: Icons.account_tree,
                          badge: '95%',
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
                          _ExperienceCard(
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
                          _ExperienceCard(
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
                          _ExperienceCard(
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
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: t['email']!));
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
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            textStyle: TextStyle(fontSize: isMobile ? 14 : 16),
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
    double cardWidth = screenWidth < 400 ? (screenWidth - 32) : 350.0;
    return InkWell(
      onTap: () => _showProjectModal(context, title, desc, tech, closeBtnText),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: cardWidth,
        height: 230,
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
                          fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                const Icon(Icons.open_in_new, size: 18, color: Colors.blueGrey),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                desc,
                style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.touch_app, size: 16, color: Colors.teal),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    btnText,
                    style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
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

// Widget d'expérience professionnelle interactif avec effet de survol (Hover Animation)
class _ExperienceCard extends StatefulWidget {
  final String role;
  final String company;
  final List<String> bulletList;
  final List<String> tags;
  final IconData icon;

  const _ExperienceCard({
    required this.role,
    required this.company,
    required this.bulletList,
    required this.tags,
    required this.icon,
  });

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(24),
        transform: _isHovered
            ? Matrix4.translationValues(0, -6, 0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? Colors.teal : Colors.blueGrey.shade100,
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? Colors.teal.withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: _isHovered ? 20 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isHovered ? Colors.teal : Colors.blueGrey.shade800,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.role,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.company,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ...widget.bulletList.map(
              (bullet) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_right_rounded,
                        color: Colors.teal, size: 22),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        bullet,
                        style: const TextStyle(
                            fontSize: 14, height: 1.45, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.tags.isNotEmpty) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.teal.shade200),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.teal.shade800,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Widget de carte de compétence avec effet de survol (Hover Animation & Badge)
class _HoverCard extends StatefulWidget {
  final String title;
  final String desc;
  final IconData icon;
  final String badge;

  const _HoverCard({
    required this.title,
    required this.desc,
    required this.icon,
    required this.badge,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth < 380 ? (screenWidth - 32) : 280.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: cardWidth,
        padding: const EdgeInsets.all(22),
        transform: _isHovered
            ? Matrix4.translationValues(0, -6, 0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? Colors.teal : Colors.blueGrey.shade100,
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? Colors.teal.withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: _isHovered ? 20 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  widget.icon,
                  size: 42,
                  color: _isHovered ? Colors.teal : Colors.blueGrey,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isHovered ? Colors.teal : Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.badge,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _isHovered ? Colors.white : Colors.blueGrey.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.desc,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}
