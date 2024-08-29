# BlogApp

## Übersicht

BlogApp ist eine Flutter-Anwendung, die es Nutzern ermöglicht, Blogs zu durchsuchen, zu liken, zu kommentieren und zu bearbeiten. Die App bietet eine einfache Benutzeroberfläche zum Anzeigen von Blogposts und eine Detailansicht für umfassendere Interaktionen.

## Funktionen

- **Blog-Liste**: Zeigt eine Liste von Blogs mit Titeln, Vorschau des Inhalts und Anzahl der Likes.
- **Blog-Details**: Detailansicht eines einzelnen Blogs, einschließlich des gesamten Inhalts und der Kommentare.
- **Kommentare hinzufügen**: Möglichkeit, Kommentare zu einem Blog hinzuzufügen.
- **Blog bearbeiten und löschen**: Bearbeite oder lösche Blogs direkt aus der Detailansicht.
- **Likes verwalten**: Blogs liken oder unliken.

## Technologien

- **Flutter**: Für die Entwicklung der mobilen App.
- **Provider**: Für das Zustand-Management.
- **API-Service**: Für die Kommunikation mit dem Backend.

## Projektstruktur

- **lib/**
  - **models/**: Enthält Datenmodelle wie `Blog` und `Comment`.
  - **services/**: Beinhaltet den `ApiService` für die Kommunikation mit dem Backend und den `UserProvider` für die Benutzerdaten.
  - **screens/**: Beinhaltet die verschiedenen Bildschirme der App wie `HomeScreen` und `BlogDetailScreen`.
  - **widgets/**: Beinhaltet benutzerdefinierte Widgets wie `BlogCard`.
  - **main.dart**: Einstiegspunkt der Anwendung.

## Installation

1. Klone das Repository:

   ```bash
   git clone https://github.com/davidoetterli/Blog-App.git
   ```

2. Wechsle in das Projektverzeichnis:

    ```bash
   cd blogapp
   ```
3. Installiere die Abhängigkeiten:

    ```bash
   flutter pub get
   ```
4. Starte die App:

    ```bash
   flutter run
   ```

## Backend
Das Backend wurde im Kurs Verteilte-Systeme entwickelt und kann unter folgendem Repository heruntergeladen werden.

   ```bash
   git clone https://github.com/davidoetterli/Verteilte-Systeme.git
   ```


## Konfiguration

Stelle sicher, dass du eine gültige Konfiguration für den API-Service hast. Ändere die Endpunkte und API-Keys in der Datei lib/services/api_service.dart, falls erforderlich.

### Nutzung

- **HomeScreen:** 
Zeigt eine Liste aller verfügbaren Blogs. Tippe auf einen Blog, um die Detailansicht zu öffnen.
 
- **BlogDetailScreen:**
Zeigt die Details eines Blogs an, einschließlich der Möglichkeit, den Blog zu bearbeiten, zu löschen und Kommentare hinzuzufügen.
 
- **CreateBlogScreen:**
Erstellung eines neuen Blogs.
 
- **EditBlogScreen:**
Editieren von Blogs.

- **SettingScreen:**
Hier kann man seine Einstellungen vornehmen. Im Moment ist nur der Darkmode implementiert.
 
- **LoginScreen:**
Hier kann man den username ändern. Zu einem späteren Zeitpunkt wird die authentifizierung über Keycloak noch implementiert.