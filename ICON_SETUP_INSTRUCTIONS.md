# How to Change App Icon to MedicalShala Logo

## Step 1: Save Your Logo
1. Save your MedicalShala logo image as: `assets/icon/medical_shala_logo.png`
2. Make sure the image is:
   - PNG format
   - Square aspect ratio (1024x1024 recommended)
   - High resolution for best quality

## Step 2: Install Dependencies
Run this command in your terminal:
```bash
flutter pub get
```

## Step 3: Generate App Icons
Run this command to automatically generate all required icon sizes:
```bash
flutter pub run flutter_launcher_icons:main
```

## Step 4: Clean and Rebuild
```bash
flutter clean
flutter pub get
flutter run
```

## What This Will Generate:
- ✅ Android icons (all densities: hdpi, mdpi, xhdpi, xxhdpi, xxxhdpi)
- ✅ iOS icons (all required sizes for iPhone and iPad)
- ✅ Web favicon
- ✅ Windows app icon
- ✅ macOS app icon

## File Locations:
- Android: `android/app/src/main/res/mipmap-*/launcher_icon.png`
- iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Web: `web/icons/`

## Notes:
- The package automatically handles all the different sizes required
- Your original logo should be at least 1024x1024 pixels for best quality
- The tool will automatically crop/resize as needed for each platform
