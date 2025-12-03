# 🎮 Boutique de Jeux — Application Flutter

Bienvenue !
Ce dépôt contient le code source d’une application Flutter de boutique de jeux, destinée à l’apprentissage et à la démonstration de bonnes pratiques.

---

## 📌 À propos du projet

L’application présente un catalogue de jeux avec recherche, favoris, panier, détails et bibliothèque. Elle est structurée pour être lisible, évolutive et adaptée aux ateliers pédagogiques.

- Objectifs : montrer une architecture Flutter claire, l’intégration API, la gestion d’état, la persistance locale et des tests de base.
- Plateformes visées : iOS, Android, Web, macOS, Windows, Linux (selon la configuration Flutter).

---

## 🧩 Fonctionnalités principales

- Accueil avec liste de jeux et cartes personnalisées.
- Détails du jeu avec informations et actions.
- Favoris et bibliothèque (ajout/suppression).
- Panier avec comptage et gestion simple.
- Authentification basique (service stub pour démo).
- Navigation par onglets et barre inférieure.

---

## 🗂 Structure du projet

Les dossiers clés :

- `lib/` code applicatif Flutter
	- `Screens/` vues (accueil, détails, panier, bibliothèque, login…)
	- `Services/` logique (auth, favoris, panier, jeux)
	- `Models/` modèles (ex. `game.dart` + `game.g.dart`)
	- `CustomWidgets/` composants UI réutilisables
	- `main.dart` point d’entrée
- `assets/` ressources (images, icônes…)
- `test/` tests widget

---

## 🚀 Démarrage rapide

1. Cloner le dépôt :
```bash
git clone https://github.com/Majd04bougatef/Flutter2526.git
```
2. Se placer dans le dossier :
```bash
cd Flutter2526
```
3. Installer les dépendances :
```bash
flutter pub get
```
4. Lancer l’application :
```bash
flutter run
```

Conseils macOS/iOS : assurez-vous d’avoir Xcode, CocoaPods et un simulateur configuré. Pour le Web, vérifiez `flutter config --enable-web`.

---

## 🧪 Tests

Exécuter les tests widget :
```bash
flutter test
```

---

## 🛠 Technologies

- Flutter 3+ / Dart
- Widgets personnalisés, navigation, services
- JSON et générateurs (`build_runner` si utilisé pour `game.g.dart`)

---

## 📖 Ateliers et progression

Chaque série de commits illustre un thème :
- POO et modèles
- Widgets et composition
- Navigation
- HTTP/API et parsing
- Persistance locale (SharedPreferences/Hive selon besoin)
- Gestion d’état (Provider/Riverpod/Bloc selon atelier)
- Tests unitaires et widget

Pour explorer :
```bash
git log
git checkout <commit-id>
```

---

## 📬 Contact

Pour questions ou améliorations, ouvrez une issue ou un pull request sur ce dépôt.
