# Portfolio Professionnel & CV Interactif - Walid Hassani

[![Flutter Web](https://img.shields.io/badge/Flutter-Web-blue?logo=flutter)](https://flutter.dev)
[![Licence](https://img.shields.io/badge/Licence-Priv%C3%A9e-red)](#)
[![Statut du Déploiement](https://img.shields.io/badge/D%C3%A9ploiement-Vercel-success?logo=vercel)](https://walid-portfolio-blue.vercel.app)

Application Web moderne et réactive développée avec **Flutter Web**, présentant le parcours professionnel, les compétences clés et les projets marquants de **Walid Hassani** (Consultant ERP Dolibarr & Chef de Projet Technique).

---

## 🌟 Fonctionnalités Principales

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

- **🎨 Effets Visuels & Animations Interactives** :
  - Cartes de compétences et d'expériences animées au survol de la souris (*Hover Animations*).
  - Badges d'expérience avec niveaux de maîtrise.
  - Boîtes de dialogue interactives (*Modals*) pour explorer les détails des projets.

- **📱 Design 100% Réactif (Responsive)** :
  - Adaptation parfaite sur Mobile, Tablette et Écran Desktop.

- **🔗 Liens Réseaux Sociaux Officiels** :
  - Intégration des icônes officielles FontAwesome pour **LinkedIn** et **GitHub**.

---

## 🛠️ Stack Technique

- **Framework Front-End** : [Flutter Web](https://flutter.dev) (Dart)
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
