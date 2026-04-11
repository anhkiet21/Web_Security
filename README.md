# 📱 Website Bán Điện Thoại - WebProject 2.0

> **Đồ án môn học Lập trình Web**  
> **Trường Đại Học Sư Phạm Kỹ Thuật TP.HCM**  
> **Khoa Công Nghệ Thông Tin - Học kỳ I (2025-2026)**

[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.5-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![MySQL](https://img.shields.io/badge/MySQL-8.0.33-blue.svg)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-Academic-yellow.svg)](https://github.com/webProject-l-p-trinh-web-hk1-2025/webProject.git)

---

## 📋 Mục lục
- [Giới thiệu](#-giới-thiệu)
- [Công nghệ sử dụng](#-công-nghệ-sử-dụng)
- [Kiến trúc hệ thống](#-kiến-trúc-hệ-thống)
- [Chức năng chính](#-chức-năng-chính)
- [Yêu cầu hệ thống](#-yêu-cầu-hệ-thống)
- [Cài đặt và chạy](#-cài-đặt-và-chạy)
- [Cấu hình](#-cấu-hình)
- [API Documentation](#-api-documentation)
- [Cơ sở dữ liệu](#-cơ-sở-dữ-liệu)
- [Bảo mật](#-bảo-mật)
- [Cấu trúc thư mục](#-cấu-trúc-thư-mục)
- [Troubleshooting](#-troubleshooting)

---

## 🎯 Giới thiệu

**WebProject 2.0** là một website bán điện thoại trực tuyến được xây dựng bằng **Spring Boot 3.5.5** và **Java 17**. 

Hệ thống sử dụng **kiến trúc kết hợp (Hybrid Architecture)**:
- 🌐 **JSP Views** - Giao diện web server-side rendering cho khách hàng mua sắm
- 🔌 **REST API** - API endpoints trả JSON cho mobile app/external integrations

Hệ thống hỗ trợ đầy đủ các tính năng của một website bán điện thoại hiện đại, bao gồm:

- � Quản lý sản phẩm điện thoại (thông số kỹ thuật, hình ảnh, giá cả)
- 🛒 Giỏ hàng và đặt hàng trực tuyến
- 👥 Hệ thống người dùng đa vai trò (Admin, Seller, User)
- 🔐 Xác thực và phân quyền với JWT & OAuth2 (Google Login)
- 💳 Tích hợp thanh toán VNPay và COD
- 📧 Gửi email xác thực và thông báo đơn hàng
- 📱 Gửi SMS OTP qua SpeedSMS
- 💬 Chat realtime với WebSocket (hỗ trợ khách hàng)
- ⭐ Đánh giá và review sản phẩm
- 📊 Thống kê và báo cáo doanh thu cho Admin/Seller
- 📄 Quản lý tài liệu sản phẩm

---

## 🚀 Công nghệ sử dụng

### Backend Framework (Framework Backend)
- **Spring Boot 3.5.5** - Framework chính cho ứng dụng Java
- **Spring MVC** - Xử lý HTTP requests, hỗ trợ cả REST API và JSP views
- **Spring Data JPA** - Quản lý cơ sở dữ liệu, ORM mapping với Hibernate
- **Spring Security** - Xác thực và phân quyền người dùng
- **Spring OAuth2** - Đăng nhập qua Google OAuth2
- **Spring WebSocket** - Giao tiếp real-time (chat, notifications)
- **Spring Mail** - Gửi email tự động (verification, notifications)
- **Spring Validation** - Validate dữ liệu đầu vào

### Database (Cơ sở dữ liệu)
- **MySQL 8.0.33** - Database chính (chạy trên port 3307)
- **Hibernate** - ORM framework, tự động mapping object-relational

### Security & Authentication (Bảo mật & Xác thực)
- **JWT (JSON Web Tokens)** - Xác thực không trạng thái (stateless authentication)
- **jjwt 0.11.5** - Thư viện tạo và xác thực JWT tokens
- **BCrypt** - Mã hóa mật khẩu với salt
- **OAuth2 Resource Server** - Bảo vệ API endpoints
- **Spring Security Filter Chain** - Chuỗi filter bảo mật tùy chỉnh

### Frontend (Giao diện người dùng)
- **JSP (JavaServer Pages)** - Template engine render HTML từ server
- **JSTL 3.0** - Thư viện tag chuẩn cho JSP (vòng lặp, điều kiện, format)
- **SiteMesh 3.2.1** - Trang trí và layout thống nhất cho các trang JSP
- **Tomcat Jasper** - JSP compiler và runtime engine
- **JavaScript** - Xử lý tương tác phía client
- **CSS/Bootstrap** - Styling và responsive design

### API Documentation (Tài liệu API)
- **SpringDoc OpenAPI 2.8.5** - Tự động tạo tài liệu API
- **Swagger UI** - Giao diện test API trực quan
- **OpenAPI 3.0 Specification** - Chuẩn mô tả RESTful API

### Mapping & Utilities (Công cụ hỗ trợ)
- **MapStruct 1.5.5** - Map giữa Entity, DTO, Request/Response objects
- **Lombok 1.18.30** - Giảm boilerplate code (getter/setter, constructor, builder)
- **Gson 2.10.1** - Chuyển đổi JSON <-> Java objects

### External Services (Dịch vụ bên ngoài)
- **Twilio SDK 9.3.0** - Gửi SMS OTP và thông báo
- **SpeedSMS** - Dịch vụ SMS thay thế cho Việt Nam
- **Gmail SMTP** - Gửi email qua Gmail
- **VNPay Payment Gateway** - Cổng thanh toán trực tuyến

### Development Tools (Công cụ phát triển)
- **Spring DevTools** - Hot reload tự động khi code thay đổi
- **Spring Docker Compose** - Tích hợp Docker trong Spring Boot
- **Maven 3.9+** - Quản lý dependencies và build project
- **Git** - Version control system

### Containerization (Đóng gói ứng dụng)
- **Docker** - Containerize ứng dụng và database

---

## 🏗️ Kiến trúc hệ thống

### Kiến trúc tổng quan

**Kiến trúc Kết hợp (Hybrid Architecture):**

```
┌────────────────────────────────────────────────────────────────┐
│                    Clients                                     │
│  ┌──────────────────┐         ┌─────────────────────┐          │
│  │   Web Browser    │         │  Mobile/External    │          │
│  │   (JSP Views)    │         │    (JSON Client)    │          │
│  └────────┬─────────┘         └──────────┬──────────┘          │
└───────────┼────────────────────────────────┼───────────────────┘
            │                                │
            ▼                                ▼
┌───────────────────────────────────────────────────────────────┐
│              Spring MVC Controllers                           │
│  ┌────────────────────┐      ┌──────────────────────┐         │
│  │  @Controller       │      │  @RestController     │         │
│  │  (trả JSP Views)   │      │  (trả JSON/API)      │         │
│  │  - Admin Pages     │      │  - /api/products     │         │
│  │  - Seller Pages    │      │  - /api/orders       │         │
│  │  - User Pages      │      │  - /api/auth         │         │
│  └────────────────────┘      └──────────────────────┘         │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│                      Security Layer                           │
│             ┌─────────────┐  ┌──────────────┐                 │
│             │ JWT Filter  │  │ OAuth2 Login │                 │
│             └─────────────┘  └──────────────┘                 │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│                       Service Layer                           │
│           Business Logic & Transaction Management             │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│                      Repository Layer                         │
│                     (Spring Data JPA)                         │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│                       MySQL Database                          │
│                         (Port 3307)                           │
└───────────────────────────────────────────────────────────────┘
```

### Kiến trúc Module

Project được tổ chức theo module-based architecture:

```
webprojrct/
├── admin/          # Quản trị hệ thống
├── auth/           # Xác thực & OAuth2
├── cart/           # Giỏ hàng
├── category/       # Danh mục sản phẩm
├── common/         # Config & utilities chung
├── document/       # Quản lý tài liệu
├── email/          # Email service
├── favorite/       # Yêu thích sản phẩm
├── order/          # Đơn hàng
├── payment/        # Thanh toán
├── product/        # Sản phẩm & biến thể
├── ReviewandRating/# Đánh giá
├── seller/         # Người bán
├── sms/            # SMS service
├── storage/        # Upload & lưu file
├── user/           # Người dùng
└── websocket/      # Chat realtime
```

---

## ✨ Chức năng chính

### 👤 Hệ thống người dùng
- ✅ Đăng ký, đăng nhập (JWT & Google OAuth2)
- ✅ Xác thực email/phone qua OTP
- ✅ Quản lý profile, avatar
- ✅ Đổi mật khẩu, reset password
- ✅ Phân quyền: ADMIN, SELLER, USER

### 🛒 Giỏ hàng & Đơn hàng
- ✅ Thêm/xóa/cập nhật sản phẩm trong giỏ
- ✅ Tính toán tổng tiền tự động
- ✅ Đặt hàng với nhiều sản phẩm
- ✅ Theo dõi trạng thái đơn hàng
- ✅ Hủy đơn hàng & yêu cầu hoàn tiền

### 🏪 Người bán (Seller)
- ✅ Quản lý sản phẩm riêng
- ✅ Quản lý đơn hàng (chấp nhận, vận chuyển, giao hàng)
- ✅ Hủy đơn hàng với lý do

### 📦 Sản phẩm
- ✅ Danh mục điện thoại phân cấp (theo hãng, dòng máy)
- ✅ Biến thể sản phẩm (màu sắc, dung lượng)
- ✅ Upload nhiều ảnh sản phẩm
- ✅ Quản lý tồn kho điện thoại
- ✅ Thông số kỹ thuật chi tiết (màn hình, camera, chip, pin, v.v.)
- ✅ Active/Inactive sản phẩm
- ✅ Tìm kiếm, lọc theo giá/hãng/tính năng, sắp xếp

### ⭐ Đánh giá & Review
- ✅ Đánh giá sao (1-5 stars)
- ✅ Bình luận review
- ✅ Admin duyệt/xóa review

### 💳 Thanh toán
- ✅ Tích hợp VNPay
- ✅ Thanh toán COD

### 📧 Thông báo
- ✅ Gửi email xác thực
- ✅ Email thông báo đơn hàng
- ✅ SMS OTP qua Twilio/SpeedSMS
- ✅ WebSocket chat realtime

### 👨‍💼 Admin
- ✅ Dashboard thống kê
- ✅ Quản lý users, products, categories
- ✅ Quản lý đơn hàng toàn hệ thống
- ✅ Quản lý reviews
- ✅ Support 

### 📄 Tài liệu
- ✅ Public document viewing

### 💬 Chat realtime
- ✅ WebSocket messaging
- ✅ Chat giữa user & admin

---

## 💻 Yêu cầu hệ thống

### Phần mềm cần thiết
- **Java JDK 17** trở lên
- **Maven 3.6+**
- **MySQL 8.0+** (hoặc PostgreSQL 13+)
- **Docker & Docker Compose** (optional, khuyến khích)
- **Git**

### Khuyến nghị
- RAM: 4GB trở lên
- Disk: 2GB free space
- OS: Windows 10/11, macOS, Linux

---

## 🔧 Cài đặt và chạy

### Cách 1: Chạy với Docker Compose (Khuyến khích)

#### Bước 1: Clone project từ GitHub
```bash
git clone https://github.com/webProject-l-p-trinh-web-hk1-2025/webProject.git
cd webProject
```

#### Bước 2: Chọn cách chạy Docker

**Option A: Chỉ chạy MySQL (Khuyến khích cho Development):**

**Linux:**
```bash
sudo docker compose -f mySQL.yaml up -d --build
```

**Windows:**
```bash
docker compose -f mySQL.yaml up -d --build
```

Docker sẽ tự động:
- ✅ Tạo MySQL container (port 3306)
- ✅ Khởi tạo database từ `db/init.sql`

Sau đó chạy Spring Boot app bằng Maven:
```bash
mvn spring-boot:run
```

---

**Option B: Chạy Full Stack (MySQL + Spring Boot):**

```bash
docker-compose up -d
```

Docker sẽ tự động:
- ✅ Tạo MySQL container (port 3306)
- ✅ Khởi tạo database từ `db/init.sql`
- ✅ Build và chạy Spring Boot application

---

**Các lệnh Docker hữu ích:**

**Reset database:**
```bash
docker volume rm webproject10_mysql_data
docker compose -f mySQL.yaml up -d --build
```

**Thao tác với database:**
```bash
docker exec -it mysql bash
mysql -u cps -p cps_db
# Password: cps
```

#### Bước 3: Truy cập ứng dụng
- **Web Application**: http://localhost:8080
- **Swagger UI**: http://localhost:8080/swagger-ui.html

---

### Cách 2: Chạy thủ công (Development)

#### Bước 1: Clone project từ GitHub
```bash
git clone https://github.com/webProject-l-p-trinh-web-hk1-2025/webProject.git
cd webProject
```

#### Bước 2: Cài đặt MySQL

Tạo database:
```sql
CREATE DATABASE cps_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'cps'@'localhost' IDENTIFIED BY 'cps';
GRANT ALL PRIVILEGES ON cps_db.* TO 'cps'@'localhost';
FLUSH PRIVILEGES;
```

Import init script:
```bash
mysql -u cps -p cps_db < db/init.sql
```

#### Bước 3: Cấu hình application.properties

Cập nhật file `src/main/resources/application.properties`:

```properties
# Database
spring.datasource.url=jdbc:mysql://localhost:3307/cps_db
spring.datasource.username=cps
spring.datasource.password=cps

# Email (Gmail)
spring.mail.username=your-email@gmail.com
spring.mail.password=your-app-password

# Twilio SMS
twilio.account_sid=your-account-sid
twilio.auth_token=your-auth-token
twilio.phone_number=your-twilio-phone

# OAuth2 Google
spring.security.oauth2.client.registration.google.client-id=your-client-id
spring.security.oauth2.client.registration.google.client-secret=your-client-secret
```

#### Bước 4: Build và chạy

**Build toàn bộ project:**
```bash
mvn clean install -DskipTests
```

**Chạy dự án:**
```bash
mvn spring-boot:run
```

#### Bước 5: Truy cập
- **Application**: http://localhost:8080
- **Swagger UI**: http://localhost:8080/swagger-ui/index.html

---

## ⚙️ Cấu hình

### Database Configuration

#### MySQL (mặc định)
```properties
spring.datasource.url=jdbc:mysql://localhost:3307/cps_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
spring.datasource.username=cps
spring.datasource.password=cps
spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
```

#### PostgreSQL (alternative)
Bỏ comment trong `application.properties`:
```properties
spring.datasource.url=jdbc:postgresql://localhost:5433/cps_db
spring.datasource.username=cps
spring.datasource.password=cps
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
```

Sử dụng `postgreSQL.yaml` thay vì `mySQL.yaml`:
```bash
docker-compose -f postgreSQL.yaml up -d
```

### File Upload Configuration

```properties
# Upload paths
file.storage.avatars=uploads/avatars
file.storage.products=uploads/products
file.storage.documents=uploads/documents
file.storage.media=uploads/media

# Max file size
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB
```

### Email Configuration

#### Gmail SMTP
```properties
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=your-email@gmail.com
spring.mail.password=your-16-char-app-password
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
```

**Lưu ý**: Cần tạo App Password tại: https://myaccount.google.com/apppasswords

### SMS Configuration

#### Twilio
```properties
twilio.account_sid=ACxxxxxxxxxxxxxxxxxxxxxxxxxx
twilio.auth_token=your-auth-token
twilio.phone_number=+1234567890
```

#### SpeedSMS
```properties
speedSMS_APIKEY=your-api-key
```

### OAuth2 Google Login

1. Tạo OAuth2 credentials tại: https://console.cloud.google.com/apis/credentials
2. Cấu hình Redirect URI: `http://localhost:8080/login/oauth2/code/google`
3. Cập nhật trong `application.properties`:

```properties
spring.security.oauth2.client.registration.google.client-id=your-client-id
spring.security.oauth2.client.registration.google.client-secret=your-client-secret
spring.security.oauth2.client.registration.google.scope=email,profile
```

### Security Configuration

```properties
# Allow bean overriding for custom security
spring.main.allow-bean-definition-overriding=true

# Debug security (development only)
logging.level.org.springframework.security=DEBUG
```

### JSP Configuration

```properties
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp
```

---

## 📚 API Documentation

### Swagger UI
Sau khi chạy application, truy cập:
- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **Swagger UI (alternative)**: http://localhost:8080/swagger-ui/index.html
- **OpenAPI JSON**: http://localhost:8080/v3/api-docs

---

## 🗄️ Cơ sở dữ liệu

### Schema Overview

```sql
-- Core tables
users                 # Người dùng
categories            # Danh mục sản phẩm (hierarchical)
products              # Sản phẩm
product_specs      # Biến thể sản phẩm
product_images        # Ảnh sản phẩm

-- Shopping
carts                 # Giỏ hàng
cart_items            # Sản phẩm trong giỏ
orders                # Đơn hàng
order_items           # Sản phẩm trong đơn
Payments              # Thanh Toán
Payment_url_vnpay     # Lưu URL đã tạo khi thanh toán chưa hoàn tất
-- Reviews
reviews               # Đánh giá

-- Documents
documents             # Tài liệu

-- Authentication
otp_codes             # OTP codes

-- Others
favorites             # Yêu thích
payments              # Thanh toán
chat_messages         # Chat
chat_rooms            # room chat
```

### Quan hệ chính

```
# Quan hệ từ User (Người dùng)
users (1) ----< (n) orders            # Một người dùng đặt nhiều đơn hàng
users (1) ----< (1) carts             # Một người dùng có một giỏ hàng duy nhất
users (1) ----< (n) reviews           # Một người dùng viết nhiều đánh giá
users (1) ----< (n) favorites         # Một người dùng yêu thích nhiều sản phẩm
users (1) ----< (n) otp_codes         # Một người dùng có nhiều mã OTP (qua thời gian)
users (1) ----< (n) chat_messages     # Một người dùng gửi/nhận nhiều tin nhắn
users (1) ----< (n) chat_rooms        # Một người có nhiều phòng chat

# Quan hệ từ Product (Sản phẩm)
products (1) ----< (n) product_images # Một sản phẩm có nhiều ảnh
products (1) ----< (n) product_specs  # Một sản phẩm có nhiều thông số kỹ thuật
products (1) ----< (n) reviews        # Một sản phẩm có nhiều đánh giá
products (1) ----< (n) cart_items     # Một sản phẩm xuất hiện trong nhiều giỏ hàng
products (1) ----< (n) order_items    # Một sản phẩm xuất hiện trong nhiều đơn hàng
products (1) ----< (n) favorites      # Một sản phẩm được nhiều người yêu thích
products (n) ----< (1) categories     # Nhiều sản phẩm thuộc một danh mục
products (1) ----< (1) documents      # Một sản phẩm có một văn bản

# Quan hệ từ Category (Danh mục)
categories (1) ----< (n) products     # Một danh mục chứa nhiều sản phẩm
categories (1) ----< (n) categories   # Một danh mục cha có nhiều danh mục con (phân cấp)

# Quan hệ từ Cart (Giỏ hàng)
carts (1) ----< (n) cart_items        # Một giỏ hàng chứa nhiều sản phẩm (items)

# Quan hệ từ Order (Đơn hàng)
orders (1) ----< (n) order_items      # Một đơn hàng chứa nhiều sản phẩm (items)
orders (1) ---- (1) payments          # Một đơn hàng có một thanh toán

# Quan hệ từ Review (Đánh giá)
reviews (1) ----< (n) reviews         # Một đánh giá cha có nhiều đánh giá con (trả lời)

# Quan hệ từ ChatRoom (Phòng chat)
chat_rooms (1) ----< (n) chat_messages   # Một phòng chat có nhiều tin nhắn
```

### Khởi tạo dữ liệu

File `db/init.sql` chứa:
- ✅ Schema đầy đủ
- ✅ 3 admin accounts (password: `123`)
- ✅ Sample users


**Test accounts:**
```
ADMIN:
  Phone: 0889251007 / Password: 123
  
SeLLER
  Phone: 1234567890 / Password: 123

USER:
  Có thể đăng kí 
```

---

## 🔒 Bảo mật

### Luồng Xác thực (Authentication Flow)

**Với REST API (JSON):**
```
1. Client gửi credentials → Server cấp JWT token (JSON response)
2. Token được lưu trữ ở client (localStorage/sessionStorage)
3. Mỗi API call gửi kèm token trong header (Authorization: Bearer <token>)
4. JwtAuthenticationFilter xác thực token
5. SecurityContext được khởi tạo với thông tin user
6. Controller kiểm tra quyền và trả JSON response
```

**Với JSP Views (Web Pages):**
```
1. User login qua form → Server cấp JWT token và lưu vào cookie/session
2. Token được gửi tự động qua cookie trong mỗi request
3. JwtAuthenticationFilter xác thực token từ cookie
4. SecurityContext được khởi tạo với thông tin user
5. Controller kiểm tra quyền và trả JSP view (HTML)
```

### Authorization

**Role-based Access Control (RBAC):**

| Role  | Quyền                                                     |
|-------|-----------------------------------------------------------|
| ADMIN | Toàn quyền hệ thống, quản lý users, products, orders      |
| SELLER| Quản lý sản phẩm & đơn hàng                               |
| USER  | Mua hàng, review, quản lý profile                         |

### Security Features

- ✅ **Password Hashing**: BCrypt với salt
- ✅ **JWT Authentication**: Stateless token-based auth
- ✅ **OAuth2 Integration**: Google Login
- ✅ **CSRF Protection**: Enabled
- ✅ **XSS Protection**: Input validation & sanitization
- ✅ **SQL Injection Prevention**: JPA parameterized queries
- ✅ **OTP Verification**: Email & SMS OTP

---

## 📁 Cấu trúc thư mục

```
webProject2.0/
├── .mvn/                          # Maven wrapper
├── db/
│   └── init.sql                   # Database initialization
├── src/
│   ├── main/
│   │   ├── java/com/proj/webprojrct/
│   │   │   ├── WebprojrctApplication.java
│   │   │   ├── admin/             # Admin module
│   │   │   ├── auth/              # Authentication & OAuth2
│   │   │   ├── cart/              # Shopping cart
│   │   │   ├── category/          # Product categories
│   │   │   ├── common/            # Shared components, Security, JSP
│   │   │   ├── document/          # Document management
│   │   │   ├── email/             # Email service
│   │   │   ├── favorite/          # Wishlist
│   │   │   ├── order/             # Order management
│   │   │   ├── payment/           # Payment integration
│   │   │   ├── product/           # Product module
│   │   │   ├── ReviewandRating/   # Reviews & ratings
│   │   │   ├── seller/            # Seller functions
│   │   │   ├── sms/               # SMS service
│   │   │   ├── storage/           # File upload & storage
│   │   │   ├── user/              # User management
│   │   │   └── websocket/         # WebSocket chat
│   │   └── resources/
│   │       ├── application.properties
│   │       ├── data.sql
│   │       ├── META-INF/          # View và layout JSP
│   │       └── static/            # CSS, JS, images
│   └── test/                      # Unit tests
├── target/                        # Build output
├── uploads/                       # User uploaded files
│   ├── avatars/
│   ├── products/
│   ├── documents/
│   └── media/
├── docker-compose.yml             # MySQL + Spring Boot
├── mySQL.yaml                     # MySQL only compose
├── pom.xml                        # Maven dependencies
├── mvnw, mvnw.cmd                 # Maven wrapper scripts
└── README.md                      # This file
```

---

## 🐛 Troubleshooting

### Lỗi thường gặp

#### 1. Port 8080 already in use
```bash
# Windows
netstat -ano | findstr :8080
taskkill /PID <PID> /F

# Linux/Mac
lsof -i :8080
kill -9 <PID>
```

#### 2. MySQL connection refused
- Kiểm tra MySQL đang chạy: `docker ps`
- Kiểm tra port: mặc định 3307 trong config
- Kiểm tra credentials trong `application.properties`

#### 3. Bean definition conflicts
Đã fix với:
```properties
spring.main.allow-bean-definition-overriding=true
```

#### 4. JWT token invalid
- Kiểm tra token expiration time
- Đảm bảo secret key nhất quán
- Clear localStorage/cookies và login lại

#### 5. File upload failed
- Kiểm tra thư mục `uploads/` tồn tại
- Kiểm tra permission (read/write)
- Kiểm tra max file size trong config

#### 6. OAuth2 Google login failed
- Kiểm tra client-id và client-secret
- Kiểm tra redirect URI khớp với Google Console
- Đảm bảo https trong production

---

## 📄 License & Thông tin dự án

**Đồ án môn học Web Development**

Dự án này được thực hiện bởi nhóm 4 thành viên cho môn học lập trình Web.

### Thành viên nhóm:
1. Trần Anh Kiệt - Trưởng nhóm/Module authen, author, payment, seller
2. Dương Khánh Duy - Thành viên/Module cart, order, wishlist
3. Lê Thành Nhân - Thành viên/Module product, category, document
4. Phan Thành Nhân Thành viên/Module admin, chat support, review and rating

**Mục đích**: Học tập và nghiên cứu

**Giảng viên hướng dẫn**: Nguyễn Hữu Trung

**Trường/Khoa**: Trường Đại Học Sư Phạm Kỹ Thuật Tp.HCM - Khoa Công Nghệ Thông Tin

**Học kỳ/Năm học**: Đợt 1/Kì I - 2025-2026

---

## 📞 Liên hệ & Hỗ trợ

### Thông tin liên hệ nhóm:
- **Email nhóm**: kietccc21@gmail.com
- **GitHub Repository**: https://github.com/webProject-l-p-trinh-web-hk1-2025/webProject.git
- **Demo Video**: [Link video demo]

### Báo lỗi & Góp ý:
- Tạo issue trên GitHub repository
- Liên hệ trực tiếp qua email
- Pull request được hoan nghênh

---

## 🙏 Lời cảm ơn

Nhóm chúng em xin chân thành cảm ơn:

- **Thầy Nguyễn Hữu Trung** - Giảng viên hướng dẫn, đã tận tình chỉ bảo và định hướng trong suốt quá trình thực hiện đồ án
- **Khoa Công Nghệ Thông Tin** - Trường Đại Học Sư Phạm Kỹ Thuật TP.HCM
- **Các bạn trong lớp** - Đã góp ý và hỗ trợ trong quá trình phát triển
- **Cộng đồng Spring Boot & Stack Overflow** - Nguồn tài liệu và giải pháp quý báu

Dự án này là thành quả của sự nỗ lực, học hỏi và hợp tác của cả nhóm. Mọi ý kiến đóng góp để cải thiện đồ án đều được chúng em trân trọng tiếp nhận!

---

**🎓 Đồ án môn Web Development - Học kỳ I (2025-2026)**

**Made with ❤️ by Team WebProject 2.0 | Spring Boot 3.5.5 & Java 17**
