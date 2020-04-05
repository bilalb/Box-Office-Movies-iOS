# Script that first configures the simulator's current locale, language, keyboard, status bar and appearance and then run `fastlane snapshot`

# Usage
# $ snapshot --language en --appearance light
# $ snapshot --language en --appearance dark
# $ snapshot --language fr --appearance light
# $ snapshot --language fr --appearance dark

# $ snapshot --language en --appearance light --device iPhone 11 Pro

# Get the parameters
# parameterName=${parameterName:-defaultValue}
language=${language:-en}
appearance=${appearance:-light}

while [ $# -gt 0 ]; do
   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
        # echo $1 $2 // Optional to see the parameter:value result
   fi
  shift
done

echo $language $appearance


# TODO: find a way to get it programmatically
# `xcrun simctl list`
UUID="CC8EA215-D771-4C9A-9A4D-525CF925C798"
PLIST=~/Library/Developer/CoreSimulator/Devices/$UUID/data/Library/Preferences/.GlobalPreferences.plist

# language="en"
# locale="en_US"
# keyboard="en_US@sw=QWERTY;hw=Automatic"

# TODO: Set language, locale & keyboard based on the language parameter
language="fr"
locale="fr_FR"
keyboard="fr_FR@sw=AZERTY-French;hw=Automatic"

plutil -replace AppleLocale -string $locale $PLIST
plutil -replace AppleLanguages -json "[ \"$language\" ]" $PLIST
plutil -replace AppleKeyboards -json "[ \"$keyboard\" ]" $PLIST

xcrun simctl boot $UUID
xcrun simctl status_bar $UUID override --time 2007-01-09T09:41:01+0100 --wifiMode active --wifiBars 3 --cellularMode active --cellularBars 4 --batteryState charged --batteryLevel 100

# # `xcrun simctl ui` is available from Xcode 11.4
# # appearance=dark
# appearance=light
# xcrun simctl ui $UUID appearance $appearance

# Static parameters
# fastlane snapshot --workspace "../Box-Office-Movies.xcworkspace" --devices ["iPhone 11 Pro"] --languages ["fr-FR"] --clear_previous_screenshots true --reinstall_app true --app_identifier ksjhdflhsg --erase_simulator true --localize_simulator true --dark_mode true

# Dynamic parameters
fastlane snapshot --workspace "../Box-Office-Movies.xcworkspace" --devices ["iPhone 11 Pro"] --languages [$language] --clear_previous_screenshots true --reinstall_app true --app_identifier ksjhdflhsg --erase_simulator true --localize_simulator true --dark_mode true
