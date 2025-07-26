#!/bin/bash

echo "🎨 MedicalShala App Icon Setup"
echo "==============================="

# Check if the logo file exists
if [ ! -f "assets/icon/medical_shala_logo.png" ]; then
    echo "⚠️  Logo file not found!"
    echo "Please save your MedicalShala logo as: assets/icon/medical_shala_logo.png"
    echo "Make sure it's:"
    echo "  - PNG format"
    echo "  - Square aspect ratio (1024x1024 recommended)"
    echo "  - High resolution"
    echo ""
    echo "After saving the logo, run this script again."
    exit 1
fi

echo "✅ Logo file found!"
echo "📱 Generating app icons for all platforms..."

# Generate icons
flutter pub run flutter_launcher_icons:main

if [ $? -eq 0 ]; then
    echo "✅ App icons generated successfully!"
    echo ""
    echo "🧹 Cleaning and rebuilding project..."
    flutter clean
    flutter pub get
    
    echo ""
    echo "🎉 Icon setup complete!"
    echo "Your MedicalShala logo is now your app icon on:"
    echo "  📱 Android (all screen densities)"
    echo "  🍎 iOS (iPhone & iPad)"
    echo "  🌐 Web (favicon)"
    echo "  🪟 Windows"
    echo "  🍎 macOS"
    echo ""
    echo "Run 'flutter run' to see your new app icon!"
else
    echo "❌ Error generating icons. Please check the logo file format and try again."
fi
