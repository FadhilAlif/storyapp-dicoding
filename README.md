# Story App Dicoding

Aplikasi berbagi cerita (Story App) yang dikembangkan dengan Flutter sebagai submission untuk Dicoding.

## Fitur

- **Autentikasi** - Login dan Register dengan validasi
- **Daftar Cerita** - Menampilkan daftar cerita dengan infinite scroll pagination
- **Detail Cerita** - Menampilkan detail cerita dengan peta lokasi (jika tersedia)
- **Tambah Cerita** - Upload cerita baru dengan gambar dan lokasi opsional
- **Peta & Lokasi** - Integrasi Google Maps untuk menampilkan dan memilih lokasi
- **Multi Bahasa** - Mendukung bahasa Indonesia dan Inggris
- **Build Variants** - Konfigurasi flavor untuk dev dan production

## Tech Stack

- **Framework**: Flutter 3.9+
- **State Management**: Provider
- **Navigation**: GoRouter
- **HTTP Client**: http package
- **Localization**: easy_localization
- **Maps**: google_maps_flutter, geocoding, geolocator
- **Code Generation**: json_serializable, build_runner

## Struktur Proyek

```
lib/
├── api/                    # API Service
├── config/                 # App Configuration (Flavors)
├── data/
│   ├── model/             # Data Models (dengan code generation)
│   └── preferences/       # Shared Preferences
├── pages/                  # UI Pages
├── providers/              # State Management
├── router/                 # Navigation Router
├── widgets/                # Reusable Widgets
├── main.dart              # Entry point (default/prod)
├── main_dev.dart          # Entry point (dev flavor)
└── main_prod.dart         # Entry point (prod flavor)
```

## Instalasi & Setup

### 1. Clone Repository

```bash
git clone <repository-url>
cd storyapp-dicoding
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Setup Google Maps API Key Anda

#### Android

Buat/edit file `android/local.properties` dan tambahkan:

```properties
MAPS_API_KEY=YOUR_GOOGLE_MAPS_API_KEY
```

> Lihat `android/local.properties.example` untuk referensi

#### iOS

Buat file `ios/Runner/Secrets.plist` dengan isi:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>MAPS_API_KEY</key>
    <string>YOUR_GOOGLE_MAPS_API_KEY</string>
</dict>
</plist>
```

> Lihat `ios/Runner/Secrets.plist.example` untuk referensi

### 4. Generate Code (Model Classes)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Mendapatkan Google Maps API Key

1. Buka [Google Cloud Console](https://console.cloud.google.com/)
2. Buat project baru atau pilih project yang ada
3. Aktifkan **Billing** (diperlukan, tapi ada free tier $200/bulan)
4. Enable API berikut:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Geocoding API
5. Buat API Key di **APIs & Services > Credentials**
6. (Opsional) Tambahkan restrictions untuk keamanan

## Menjalankan Aplikasi

### Default (Production)

```bash
flutter run
```

### Dengan Flavor

```bash
# Development
flutter run --flavor dev -t lib/main_dev.dart

# Production
flutter run --flavor prod -t lib/main_prod.dart
```

### Build APK

```bash
# Dev
flutter build apk --flavor dev -t lib/main_dev.dart

# Prod
flutter build apk --flavor prod -t lib/main_prod.dart
```

## Konfigurasi Flavor

| Flavor | App Name       | App ID Suffix |
|--------|----------------|---------------|
| dev    | Story App Dev  | .dev          |
| prod   | Story App      | -             |

## API

Aplikasi ini menggunakan [Dicoding Story API](https://story-api.dicoding.dev/v1):

- Base URL: `https://story-api.dicoding.dev/v1`

## File yang Tidak Di-commit (Secrets)

File berikut ada di `.gitignore` untuk keamanan:

- `android/local.properties` - berisi API key Android
- `ios/Runner/Secrets.plist` - berisi API key iOS

**Pastikan untuk membuat file ini secara lokal sebelum menjalankan aplikasi agar fitur Maps bekerja.**

## License

This project is for educational purposes (Dicoding Submission).
