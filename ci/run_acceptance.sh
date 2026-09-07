#!/usr/bin/env bash
set -euo pipefail
APK="app/build/outputs/apk/debug/app-debug.apk"
PACKAGE="com.beanstersips.v11"
ACTIVITY="com.sipsqueak.v7.MainActivity"

adb wait-for-device
adb install -r "$APK"
adb logcat -c
adb shell am force-stop "$PACKAGE" || true
adb shell am start -W -n "$PACKAGE/$ACTIVITY" --ez beanster_acceptance true

mkdir -p ci-artifacts
for i in $(seq 1 90); do
  adb logcat -d > ci-artifacts/logcat.txt || true
  if grep -Fq 'BeansterAcceptance: PASS:桂花米酿拿铁' ci-artifacts/logcat.txt; then
    echo 'BEANSTER_APP_ACCEPTANCE=PASS'
    adb shell screencap -p /sdcard/beanster-pass.png || true
    adb pull /sdcard/beanster-pass.png ci-artifacts/beanster-pass.png || true
    adb shell uiautomator dump /sdcard/window.xml || true
    adb pull /sdcard/window.xml ci-artifacts/window.xml || true
    exit 0
  fi
  if grep -Fq 'BeansterAcceptance: FAIL:' ci-artifacts/logcat.txt || grep -Fq 'BeansterAcceptance: PASS:' ci-artifacts/logcat.txt; then
    echo 'BEANSTER_APP_ACCEPTANCE=FAIL'
    grep 'BeansterAcceptance' ci-artifacts/logcat.txt | tail -20 || true
    adb shell screencap -p /sdcard/beanster-fail.png || true
    adb pull /sdcard/beanster-fail.png ci-artifacts/beanster-fail.png || true
    exit 1
  fi
  sleep 2
done

echo 'BEANSTER_APP_ACCEPTANCE=TIMEOUT'
grep -E 'BeansterAcceptance|BeansterNative|AndroidRuntime|FATAL EXCEPTION' ci-artifacts/logcat.txt | tail -160 || true
adb shell screencap -p /sdcard/beanster-timeout.png || true
adb pull /sdcard/beanster-timeout.png ci-artifacts/beanster-timeout.png || true
exit 1
