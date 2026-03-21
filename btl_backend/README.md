# BTL Backend

Backend cho ứng dụng `Review & Check-in Quán Cà phê / Du lịch`.

## Stack
- Node.js + Express
- MySQL/MariaDB
- dotenv

## Cấu trúc
- `db/schema.sql` - DDL cho 10 bảng bạn đã mô tả
- `src/db.js` - Pool kết nối MySQL
- `src/index.js` - API cơ bản

## Cài đặt
1. `cd btl_backend`
2. `npm install`
3. Sao chép `.env.example` thành `.env` và cấu hình
4. Tạo database:
   - `CREATE DATABASE btl_app CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
   - `USE btl_app;`
   - `SOURCE db/schema.sql;`
5. Chạy server:
   - `npm run dev` (nodemon)
   - `npm start`

## API mẫu
- `GET /` - kiểm tra health
- `GET /users`
- `POST /users` (body: username,email,password_hash,full_name,avatar_url,bio)
- `GET /venues`
- `POST /venues`
- `POST /checkins`
- `POST /reviews`

## Tiếp theo cho ứng dụng Flutter
- Đồng bộ model (User, Venue, CheckIn, Review...) với API
- Viết service/Provider gọi `http`/`dio` đến endpoint backend
- Tạo UI màn hình: home, venue list, venue detail, checkin, review, profile, reward
- Tích hợp xác thực + lưu token / session nếu cần
