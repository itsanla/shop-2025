# Setup Auth - Login & Registrasi

## Alur Kerja:
1. User login via Firebase (Email/Phone/Google/Facebook)
2. Firebase Auth berhasil → dapat User object
3. Flutter kirim data user ke Backend Express.js
4. Backend simpan/update user ke database PostgreSQL

## Backend (Express.js)

### File yang dibuat:
- `src/auth.ts` - Endpoint `/api/auth/verify` untuk terima data user dari Firebase

### Cara kerja:
```
POST /api/auth/verify
Body: { uid, email, name, phone }
Response: { success: true, userId: "..." }
```

### Database:
Tambah tabel `users` dengan kolom:
- firebaseUid (unique) - ID dari Firebase
- email, name, phone - data user

## Frontend (Flutter)

### File yang dibuat:
- `lib/auth_service.dart` - Service untuk kirim data ke backend

### Cara kerja:
Setelah login berhasil, otomatis panggil `AuthService.syncUserToBackend(user)`

## Cara Test:

### 1. Setup Database
```bash
cd apps/api
pnpm prisma migrate dev --name add_users
pnpm prisma generate
```

### 2. Jalankan Backend
```bash
cd apps/api
pnpm dev
```

### 3. Jalankan Flutter
```bash
cd apps/mobile
flutter run
```

### 4. Test Login
- Buka app → Login dengan email/Google/Facebook
- Cek database: `SELECT * FROM users;`
- User otomatis tersimpan di database
