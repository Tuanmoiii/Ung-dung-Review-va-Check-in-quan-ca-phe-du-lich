# Ứng dụng Review và Check-in Quán Cà Phê

## 📋 Bối Cảnh và Vấn Đề

Trong thời đại số hóa, việc tìm kiếm và trải nghiệm quán cà phê chất lượng đang trở nên quan trọng hơn bao giờ hết. Tuy nhiên, người dùng thường gặp khó khăn trong việc:

- **Tìm quán cà phê phù hợp**: Thiếu thông tin chi tiết về không gian, chất lượng dịch vụ
- **Đánh giá thực tế**: Không có hệ thống review đáng tin cậy từ cộng đồng
- **Theo dõi trải nghiệm**: Không có cách ghi nhận và chia sẻ trải nghiệm check-in
- **Khám phá địa điểm mới**: Thiếu công cụ tìm kiếm và lọc thông minh

**Giải pháp**: Hệ thống "Go & Chill" - một ứng dụng di động kết hợp với backend API cho phép người dùng:
- Khám phá và tìm kiếm quán cà phê theo vị trí, sở thích
- Đọc và viết review từ cộng đồng
- Check-in với mã QR để ghi nhận trải nghiệm
- Tích điểm và nhận ưu đãi từ hệ thống membership

## 🎯 Nghiệp Vụ Chính

### 1. **Quản lý Người dùng**
- Đăng ký/đăng nhập tài khoản
- Hệ thống membership (Bronze/Silver/Gold) dựa trên điểm tích lũy
- Quản lý profile cá nhân với avatar và thống kê

### 2. **Quản lý Quán Cà Phê**
- Thêm/sửa/xóa thông tin quán cà phê
- Hiển thị vị trí trên bản đồ
- Phân loại theo tags (Aesthetic, Quiet, WiFi, Parking, Nature)
- Hệ thống rating và review

### 3. **Hệ thống Review & Đánh giá**
- Viết review với rating sao
- Upload ảnh review
- Hiển thị review theo thời gian và độ hữu ích
- Thống kê rating tổng thể

### 4. **Check-in System**
- Tạo mã QR daily cho mỗi quán
- Scan QR để check-in
- Ghi nhận thời gian check-in
- Tích điểm cho user

### 5. **Tính năng Cộng đồng**
- Đăng bài viết chia sẻ trải nghiệm
- Like và comment bài viết
- Theo dõi bạn bè
- Xem hoạt động check-in của bạn bè

### 6. **Tính năng Cá nhân**
- Danh sách quán yêu thích
- Lịch sử check-in
- Thống kê cá nhân (điểm, số lần check-in, số review)
- Cài đặt tài khoản

## 🏗️ Kiến Trúc Hệ thống

### Backend (.NET 8.0)
- **Framework**: ASP.NET Core Web API
- **Database**: SQLite với Entity Framework Core
- **Authentication**: JWT Bearer Token
- **Password Hashing**: BCrypt
- **API Documentation**: Swagger/OpenAPI
- **CORS**: Cho phép cross-origin requests

### Mobile (Flutter)
- **Framework**: Flutter 3.11+
- **State Management**: Provider
- **HTTP Client**: Dio
- **Local Storage**: Shared Preferences
- **Maps**: Flutter Map + LatLong2
- **Authentication**: Google Sign-in + JWT

## 📁 Cấu trúc Thư mục

```
btl_backend/                    # Backend .NET API
├── Controllers/                 # API Controllers
│   ├── CoffeeShopsController.cs
│   ├── UsersController.cs
│   ├── ReviewsController.cs
│   ├── CheckInsController.cs
│   ├── PostsController.cs
│   └── ...
├── Models/                     # Entity Models
│   ├── User.cs
│   ├── CoffeeShop.cs
│   ├── Review.cs
│   ├── CheckIn.cs
│   └── ...
├── DTOs/                       # Data Transfer Objects
├── Data/                       # Database Context & Seed
├── Migrations/                 # EF Core Migrations
├── appsettings.json            # Configuration
├── Program.cs                  # Application Entry Point
└── Dockerfile                  # Docker Configuration

btl_mobile/                     # Flutter Mobile App
├── lib/
│   ├── main.dart              # App Entry Point
│   ├── models/                # Data Models
│   ├── providers/             # State Management
│   ├── screens/               # UI Screens
│   │   ├── auth/             # Authentication
│   │   ├── explore/          # Coffee Shop Discovery
│   │   ├── checkin/          # QR Check-in
│   │   ├── community/        # Social Features
│   │   └── profile/          # User Profile
│   ├── services/             # API Services
│   └── widgets/              # Reusable Widgets
├── android/                   # Android Configuration
├── ios/                      # iOS Configuration
├── web/                      # Web Configuration
└── pubspec.yaml              # Dependencies
```

## 🚀 Hướng Dẫn Cài Đặt và Chạy

### Yêu cầu hệ thống
- **Backend**: .NET 8.0 SDK, SQLite
- **Mobile**: Flutter 3.11+, Android Studio/VS Code
- **Database**: SQLite (tự động tạo)

### 1. Chạy Backend API

```bash
# 1. Di chuyển vào thư mục backend
cd btl_backend

# 2. Khôi phục packages
dotnet restore

# 3. Chạy migration (tạo database)
dotnet ef database update

# 4. Chạy server
dotnet run
```

**API sẽ chạy tại**: `http://localhost:5233`
- **Swagger UI**: `http://localhost:5233/swagger`
- **API Base URL**: `http://localhost:5233/api/`

### 2. Chạy Mobile App

```bash
# 1. Di chuyển vào thư mục mobile
cd btl_mobile

# 2. Cài đặt dependencies
flutter pub get

# 3. Chạy trên Android emulator
flutter run

# Hoặc build APK
flutter build apk --release
```

### 3. Cấu hình API URL

Trong `btl_mobile/lib/services/api_service.dart`, cập nhật `baseUrl`:

```dart
// Cho Android emulator
static const String baseUrl = 'http://10.0.2.2:5233';

// Cho iOS simulator
static const String baseUrl = 'http://127.0.0.1:5233';

// Cho thiết bị thật (thay IP máy tính)
static const String baseUrl = 'http://192.168.1.100:5233';
```

## 📊 Cơ sở dữ liệu

### Tables chính:
- **Users**: Thông tin người dùng, điểm, membership
- **CoffeeShops**: Thông tin quán cà phê, vị trí, tags
- **Reviews**: Đánh giá và review của user
- **CheckIns**: Lịch sử check-in với mã QR
- **Posts**: Bài viết cộng đồng
- **Comments**: Bình luận
- **Favorites**: Danh sách yêu thích
- **DailyCodes**: Mã QR daily cho check-in

### Seed Data:
- 10+ users mẫu với các role khác nhau
- 20+ quán cà phê tại Copenhagen
- Reviews và check-ins mẫu
- Posts và comments cộng đồng

## 🔧 API Endpoints

### Authentication
- `POST /api/users/login` - Đăng nhập
- `POST /api/users/register` - Đăng ký
- `GET /api/users/{id}` - Lấy thông tin user

### Coffee Shops
- `GET /api/coffeeshops` - Lấy danh sách quán (có filter)
- `GET /api/coffeeshops/{id}` - Chi tiết quán
- `POST /api/coffeeshops` - Thêm quán mới (admin)
- `PUT /api/coffeeshops/{id}` - Cập nhật quán (admin)

### Reviews
- `GET /api/reviews?coffeeShopId={id}` - Lấy reviews của quán
- `POST /api/reviews` - Thêm review mới
- `PUT /api/reviews/{id}` - Cập nhật review
- `DELETE /api/reviews/{id}` - Xóa review

### Check-ins
- `GET /api/checkins?userId={id}` - Lịch sử check-in
- `POST /api/checkins` - Check-in mới
- `GET /api/dailycodes/{shopId}` - Lấy mã QR daily

### Community
- `GET /api/posts` - Danh sách bài viết
- `POST /api/posts` - Đăng bài mới
- `GET /api/comments?postId={id}` - Bình luận của bài
- `POST /api/comments` - Thêm bình luận

## 🎨 Giao diện Mobile App

### Màn hình chính:
1. **Login/Register**: Xác thực người dùng
2. **Home**: Dashboard với thống kê cá nhân
3. **Explore**: Khám phá quán cà phê với bản đồ và bộ lọc
4. **Check-in**: Scan QR code để check-in
5. **Community**: Xem bài viết và tương tác cộng đồng
6. **Profile**: Quản lý tài khoản và lịch sử

### Tính năng nổi bật:
- **Interactive Map**: Hiển thị quán cà phê trên bản đồ
- **Smart Search**: Tìm kiếm theo tên, tag, vị trí
- **QR Scanner**: Check-in nhanh chóng
- **Social Feed**: Chia sẻ trải nghiệm
- **Gamification**: Hệ thống điểm và badge

## 🔒 Bảo mật

- **JWT Authentication**: Bảo vệ API endpoints
- **Password Hashing**: BCrypt cho mật khẩu
- **CORS Policy**: Kiểm soát cross-origin requests
- **Input Validation**: Validate dữ liệu đầu vào
- **Role-based Access**: Phân quyền user/admin

## 📈 Tính năng Mở rộng

### Sắp tới:
- **Real-time Notifications**: Push notifications
- **Offline Mode**: Lưu cache cho chế độ offline
- **Advanced Analytics**: Thống kê chi tiết cho admin
- **Loyalty Program**: Hệ thống voucher và ưu đãi
- **Social Integration**: Chia sẻ lên mạng xã hội

### Công nghệ bổ sung:
- **Redis**: Cache và session management
- **SignalR**: Real-time features
- **Firebase**: Push notifications
- **AWS S3**: File storage cho ảnh

## 👥 Đội ngũ Phát triển

- **Backend Developer**: .NET Core API, Database Design
- **Mobile Developer**: Flutter UI/UX, API Integration
- **UI/UX Designer**: Design System, User Experience
- **QA Tester**: Testing, Bug Fixing

## 📝 License

This project is for educational purposes as part of a university assignment (BTL - Bài Tập Lớn).

---

**Lưu ý**: Đây là dự án học thuật, không dành cho production environment. Để deploy production, cần cấu hình database PostgreSQL/MySQL, thêm HTTPS, và implement security best practices.</content>
<parameter name="filePath">d:\HocTap\BTL_Test\README.md
