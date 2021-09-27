exec > ${PROJECT_DIR}/prebuild.log 2>&1

echo "Write Log File"

buildNumber=$(/usr/libexec/Plistbuddy -c "Print CFBundleVersion" "${PROJECT_DIR}/rovercontrol/Info.plist")

echo "BuildNumber: $buildNumber"

versionNumber="$MARKETING_VERSION"
echo "VersionNumber: $versionNumber"

buildNumber=$(($buildNumber + 1))

echo "Updating to new build number: $buildNumber"

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "${PROJECT_DIR}/rovercontrol/Info.plist"
