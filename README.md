# Portfolio Professionnel & CV Interactif - Walid Hassani

[![Flutter Web](https://img.shields.io/badge/Flutter-Web-blue?logo=flutter)](https://flutter.dev)
![Licence](https://img.shields.io/badge/Licence-Priv%C3%A9e-red)
[![Statut du Déploiement](https://img.shields.io/badge/D%C3%A9ploiement-Vercel-success?logo=vercel)](https://walid-portfolio-blue.vercel.app)

Application Web moderne et réactive développée avec **Flutter Web**, présentant le parcours professionnel, les compétences clés et les projets marquants de **Walid Hassani** (Consultant ERP Dolibarr & Chef de Projet Technique).

---

## 🌟 Fonctionnalités Principales

- **✨ Intro Cinématique & Futuriste Interactive (Cyber-Intro)** :
  - Animation d'ouverture immersive de 3,5 secondes avec logo néon `WH`, typographie dynamique, grille de particules et transition de sortie en fondu fluide.
  - Bouton discret de saut rapide (*Passer / Skip*) pour un accès direct instantané.

- **🌐 Support Multilingue Complet (FR / EN / AR)** :
  - Sélection instantanée entre le Français (par défaut), l'Anglais et l'Arabe.
  - Gestion automatique de la direction du texte (**RTL - Right To Left**) pour l'Arabe sans rechargement de page.
  - Préchargement des polices (`Cairo` et `Roboto`) pour éviter tout saut de texte ou caractères illisibles.

- **🎥 Média de Présentation Dynamique & Intelligente** :
  - Intégration d'un lecteur vidéo circulaire interactif (`pitch_video_{lang}.webm`).
  - Détection automatique de la vidéo selon la langue choisie.
  - **Fallback automatique** vers l'image de profil (`profile.jpg`) si la vidéo d'une langue n'est pas disponible.
  - Barre de contrôle flottante pour la lecture/pause et le basculement du son (*Mute/Unmute*).

- **📄 Téléchargement de CV Adaptatif** :
  - Téléchargement du CV au format PDF (`cv_fr.pdf`, `cv_en.pdf`, `cv_ar.pdf`) selon la langue active en un clic.

- **💼 Showcase de 13 Projets Phares Interactifs** :
  - Exposition de 13 solutions réparties sur divers domaines stratégiques : ERP Dolibarr Mobile, Plateformes SaaS (Notifio CRM), Portails Collaboratifs (OneDev Track), Solutions Fiscales et OCR, Systèmes Éducatifs (ONEDEV Baraem, Plateforme Azzouz), Legal-Tech (Calcul d'indemnités), Fidélité Digitale (Kartiq), Contrôle Parental (Home Rules), et GameDev 2D (Azzouz Game).
  - Présentation synthétique protégeant la propriété intellectuelle tout en valorisant la stack technique et l'architecture logicielle.

- **⚡ 10 Pôles d'Expertise & Compétences Élites (AI & Enterprise Architecture)** :
  - Mise en avant de 10 compétences à très forte valeur ajoutée taillées pour les recruteurs et donneurs d'ordres :
    1. *IA d'Entreprise & LLMs Locaux* (llama.cpp, Ollama, vLLM, RAG sur-mesure, zéro fuite de données).
    2. *Document AI & OCR Intelligent* (PaddleOCR, Tesseract, LayoutLM, extraction JSON automatique).
    3. *Edge ML & Intelligence Embarquée* (TensorFlow Lite, ONNX Runtime, inférence locale sans cloud).
    4. *Architecture Multiplateforme Haute Performance* (Flutter & Dart, WebAssembly, Clean Architecture, 60 FPS).
    5. *Systèmes Autonomes Offline-First* (Bases locales SQLite & Drift, synchronisation bidirectionnelle résiliente).
    6. *Automatisation IA & Workflows Agents* (Agentic AI, Function Calling, Webhooks, APIs complexes).
    7. *ERP d'Entreprise & Modules API (Dolibarr)* (Core Dolibarr, REST API, modules PHP/SQL, conformité fiscale).
    8. *Architecture SaaS & Traitement Asynchrone* (Multi-tenancy, Queues, distribution omnicanale WhatsApp/SMS/Email).
    9. *Solutions FinTech & Legal-Tech* (Moteurs de calcul réglementaires, génération PDF certifiée, pistes d'audit).
    10. *Sécurité Applicative & Architecture Zero-Trust* (OWASP, CSP/HSTS, RBAC/ABAC, chiffrement de bout en bout).

- **🎨 Effets Visuels & Animations Futuristes Éblouissantes** :
  - **Cartes de compétences à lévitation 3D et halo néon dynamique** (*Neon Hover & 3D Lift*).
  - **Barres de télémétrie animées** (*Telemetry Progress Bar*) adaptées nativement à la direction LTR et RTL.
  - **Boîtes d'icônes à gradient actif** avec reflets lumineux et tags technologiques interactifs.
  - Badges de maîtrise chiffrés (92% à 98%).
  - Modales détaillées pour explorer les projets et les stacks techniques.

- **📱 Design 100% Réactif (Responsive)** :
  - Adaptation parfaite sur Mobile, Tablette et Écran Desktop.

- **⚡ Standards Web Modernes & Compatibilité WebAssembly (Wasm)** :
  - Migration vers `package:web` pour une exécution ultra-rapide et sécurisée sur les navigateurs modernes.

- **🔗 Liens Réseaux Sociaux Officiels** :
  - Intégration des icônes officielles FontAwesome pour **LinkedIn** et **GitHub**.

---

## 🛠️ Stack Technique

- **Framework Front-End** : [Flutter Web](https://flutter.dev) (Dart)
- **Standards Web** : `package:web` (Wasm Ready)
- **Lecteur Vidéo** : `video_player`
- **Icônes** : `font_awesome_flutter` & `cupertino_icons`
- **Police & Typographie** : Google Fonts (`Roboto`, `Cairo`)
- **Hébergement & Déploiement** : [Vercel](https://vercel.com)

---

## 🚀 Installation & Lancement en Local

### Prérequis

Assurez-vous d'avoir installé :
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version >= 3.13.1)
- [Google Chrome](https://www.google.com/chrome/) ou tout navigateur Web moderne

### Étapes

1. **Cloner le projet** :
   ```bash
   git clone https://github.com/onedevit/walid_portfolio.git
   cd walid_portfolio
   ```

2. **Récupérer les dépendances** :
   ```bash
   flutter pub get
   ```

3. **Lancer l'application en mode développement Web** :
   ```bash
   flutter run -d chrome
   ```

4. **Compiler pour la production (Web)** :
   ```bash
   flutter build web --release
   ```

---

## 📂 Structure du Projet

```text
walid_portfolio/
├── assets/                  # Ressources multimédias (images, vidéos, PDF)
├── lib/
│   └── main.dart            # Code source principal (UI, animations, traductions)
├── web/                     # Fichiers spécifiques au Web
│   ├── index.html           # Structure HTML, métadonnées SEO, liens Google Fonts
│   ├── manifest.json        # Configuration PWA & Thème
│   └── cv_*.pdf             # Fichiers PDF des CV accessibles à la racine
├── analysis_options.yaml    # Règles de linter et d'analyse statique
├── pubspec.yaml             # Gestion des dépendances et assets
└── README.md                # Documentation du projet
```

---

## 👤 Auteur

**Walid Hassani**  
- **Rôle** : Consultant ERP Dolibarr & Chef de Projet Technique  
- **E-mail** : [hasseniwalid@gmail.com](mailto:hasseniwalid@gmail.com)  
- **LinkedIn** : [linkedin.com/in/walidhassani](https://www.linkedin.com/in/walidhassani)  
- **GitHub** : [github.com/onedevit](https://github.com/onedevit)  
