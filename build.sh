#!/bin/sh
 
CLIENT="$1"

rm -rf android/app/src
rm -rf ios/Runner,
rm -rf "ios/Share Extension",
cp -rv "clients/$1/android/src" "android/app"
cp -rv "clients/$1/clientConfig.dart.txt" "lib/clientConfig.dart"
cp -rv "clients/$1/android/build.gradle" "android/app/build.gradle"
cp -rv "clients/$1/android/build.s7.gradle" "android/app/build.s7.gradle"
cp -rv "clients/$1/android/project_build.gradle" "android/build.gradle"
cp -rv "clients/$1/android/settings.gradle" "android/settings.gradle"
cp -rv "clients/$1/android/key.properties" "android/key.properties"
cp -rv "clients/$1/android/key.s7.properties" "android/key.s7.properties"
cp -rv "clients/$1/android/vumodule" "android"
cp -rv "clients/$1/pubspec.yaml" "pubspec.yaml"
cp -rv "clients/$1/android/google-services.json" "android/app/google-services.json"
cp -rv "clients/$1/ios/Share Extension" "ios"
cp -rv "clients/$1/ios/Runner" "ios"
cp -rv "clients/$1/ios/Runner.xcodeproj/project.pbxproj" "ios/Runner.xcodeproj/project.pbxproj"