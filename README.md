# Anla Online Shop

E-commerce mobile application built with Flutter and Node.js backend.

## Tech Stack

**Frontend (Mobile)**
- Flutter
- Firebase Authentication (Email, Google, Facebook)
- Provider (State Management)

**Backend (API)**
- Node.js + Express
- PostgreSQL + Prisma ORM
- Redis + BullMQ
- Docker

## Project Structure

```
shop-2025/
├── apps/
│   ├── mobile/          # Flutter mobile app
│   └── api/             # Node.js backend API
└── assets/              # Shared assets (CSV data, images)
```

## Setup

### Backend
```bash
cd apps/api
pnpm install
pnpm prisma:migrate
pnpm prisma:seed
pnpm dev
```

### Mobile
```bash
cd apps/mobile
flutter pub get
flutter run
```

### Docker
```bash
docker-compose up -d
```

## Features

- User authentication (Email, Google, Facebook)
- Product browsing by category
- Search functionality
- Shopping cart
- Payment integration (Midtrans)
- Transaction history

## Environment Variables

**Backend (.env.development)**
- `DATABASE_URL`
- `MIDTRANS_SERVER_KEY`

**Mobile (.env)**
- `BASE_URL`
- `GOOGLE_CLIENT_ID`
- `FACEBOOK_APP_ID`
- `S3_BUCKET_URL`
