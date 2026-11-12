#!/bin/bash
# Linux / macOS 通用构建脚本（ThalynnX）
set -e
PROJECT_DIR="$(cd "$(dirname "$0")/NatTypeTester-Android" && pwd)"
: "${JAVA_HOME:?请设置 JAVA_HOME 指向 JDK 17}"
: "${ANDROID_HOME:?请设置 ANDROID_HOME 指向 Android SDK}"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/platform-tools:$PATH"
cd "$PROJECT_DIR"
./gradlew assembleRelease -Dorg.gradle.jvmargs="-Xmx2048m" --no-daemon --console=plain
echo "产物: $PROJECT_DIR/app/build/outputs/apk/release/"
