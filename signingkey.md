# E3tmed Android Release Signing Key Documentation

## ⚠️ IMPORTANT SECURITY NOTICE
**This file contains sensitive security credentials. Keep this information secure and do not share publicly.**

---

## Keystore Details

### File Information
- **Keystore File**: `android/e3tmed-release-key.jks`
- **Keystore Type**: JKS (Java KeyStore)
- **Key Algorithm**: RSA
- **Key Size**: 2048 bits
- **Validity**: 100 years (36,500 days)
- **Created**: March 2, 2026

### Certificate Information
- **Common Name (CN)**: E3tmed
- **Organizational Unit (OU)**: Development
- **Organization (O)**: E3tmed
- **Location (L)**: Cairo
- **State (ST)**: Cairo
- **Country (C)**: EG

### Credentials
- **Store Password**: `E3tmed@2026#Secure!`
- **Key Password**: `E3tmed@2026#Secure!`
- **Key Alias**: `e3tmed-key-alias`

---

## Configuration Files

### key.properties Location
The `key.properties` file is located at: `android/key.properties`

**Content:**
```properties
storePassword=E3tmed@2026#Secure!
keyPassword=E3tmed@2026#Secure!
keyAlias=e3tmed-key-alias
storeFile=/Users/abdallatawfik/Documents/GitHub/E3tamd-FE/android/e3tmed-release-key.jks
```

**Note:** The `storeFile` path should be an absolute path to ensure Gradle can find it correctly.

---

## How to Use

### Building Release APK
```bash
flutter build apk --release
```

### Building Release App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### Verifying the Keystore
```bash
keytool -list -v -keystore android/e3tmed-release-key.jks -alias e3tmed-key-alias
# Password: E3tmed@2026#Secure!
```

---

## Backup Instructions

### Critical Files to Backup
1. `android/e3tmed-release-key.jks` - The keystore file
2. `android/key.properties` - The configuration file
3. This documentation file

### Recommended Backup Locations
- [ ] Secure cloud storage (encrypted)
- [ ] External encrypted drive
- [ ] Password manager (store credentials)
- [ ] Company vault/secure repository

---

## Recovery Instructions

If you need to restore the signing configuration on a new machine:

1. Clone the repository
2. Copy `e3tmed-release-key.jks` to `android/` folder
3. Copy `key.properties` to `android/` folder
4. Verify the configuration:
   ```bash
   cd android
   keytool -list -v -keystore e3tmed-release-key.jks
   ```

---

## Troubleshooting

### Build fails with signing errors
1. Verify `key.properties` exists in `android/` folder
2. Verify `e3tmed-release-key.jks` exists in `android/` folder
3. Check that passwords match in `key.properties`
4. Ensure file paths are correct

### Lost keystore password
If you lose the keystore password, you **cannot recover it**. You will need to:
1. Generate a new keystore
2. Release the app as a new application (new package name)
3. This is why this documentation exists!

---

## Play Store Upload Requirements

When uploading to Google Play Store:
- Use the **App Bundle** format (`.aab`)
- Build command: `flutter build appbundle --release`
- The app bundle will be signed with this keystore
- Google Play will generate optimized APKs for users

---

## SHA-1 and SHA-256 Fingerprints

**Current Release Key Fingerprints** (needed for Firebase, Google Sign-In, etc.):

- **SHA-1**: `C1:35:04:C4:76:28:80:6B:7A:CD:C7:A0:99:79:00:02:BF:D6:3A:1B`
- **SHA-256**: `3C:28:18:E4:F2:D6:E1:D5:A9:63:05:B2:03:C6:9C:91:EB:57:45:F5:8F:B3:39:4C:40:8D:4F:CC:85:8B:27:7B`

To verify or get updated fingerprints:

```bash
keytool -list -v -keystore android/e3tmed-release-key.jks -alias e3tmed-key-alias
```

Password: `E3tmed@2026#Secure!`

You can also get them using:
```bash
cd android && ./gradlew signingReport
```

---

## Notes

- **Never commit key.properties to a public repository** (it's in .gitignore)
- This documentation file is committed intentionally for reference
- The keystore file should be backed up securely
- If you regenerate the keystore, you cannot update existing apps in Play Store
- Keep multiple backups of the keystore file

---

**Last Updated**: March 2, 2026
**Maintained by**: Development Team
