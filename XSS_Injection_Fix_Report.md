# BÁO CÁO KHẮC PHỤC LỖ HỔNG INJECTION / XSS — final_web_v4

> **Ngày thực hiện:** 14/04/2026  
> **Dự án:** Web Security — Cửa hàng điện thoại (Spring Boot 3.5.5 + JSP)  
> **Loại lỗ hổng:** Stored XSS (OWASP A03:2021), JSON Injection  
> **Phương pháp khắc phục:** Defense-in-Depth — 2 lớp bảo vệ

---

## MỤC LỤC

1. [Tổng quan lỗ hổng phát hiện](#1-tổng-quan-lỗ-hổng-phát-hiện)
2. [Chiến lược khắc phục](#2-chiến-lược-khắc-phục)
3. [File mới tạo](#3-file-mới-tạo)
4. [Chi tiết sửa Backend (Server-side)](#4-chi-tiết-sửa-backend-server-side)
5. [Chi tiết sửa Frontend (Client-side)](#5-chi-tiết-sửa-frontend-client-side)
6. [Khắc phục JSON Injection](#6-khắc-phục-json-injection)
7. [Tổng kết](#7-tổng-kết)

---

## 1. Tổng quan lỗ hổng phát hiện

| #     | Loại           | Mức độ | File                        | Mô tả                                                       |
| ----- | -------------- | ------ | --------------------------- | ----------------------------------------------------------- |
| 1     | JSON Injection | HIGH   | `SpeedSMSAPI.java`          | Nối chuỗi trực tiếp để tạo JSON body                        |
| 2     | Stored XSS     | HIGH   | `product_detail.jsp`        | `docData.description` render thẳng vào innerHTML            |
| 3-14  | Stored/DOM XSS | MEDIUM | 7 file JSP                  | Dữ liệu user-controlled render qua `innerHTML` không escape |
| 15-21 | Reflected XSS  | MEDIUM | 7 file JSP                  | `message` từ API response render thẳng vào innerHTML        |
| 22    | Reflected XSS  | MEDIUM | `register-phone-verify.jsp` | Không có decorator → không có `escapeHtml()` global         |

**Trước khi sửa:** Chỉ có duy nhất `ReviewService.java` (dòng 41) sử dụng `Jsoup.clean()` riêng lẻ để sanitize `review.comment`. Tất cả các trường khác (product name, brand, specs, username, address, category name, alert messages...) đều lưu thô vào DB và render trực tiếp qua `innerHTML`.

---

## 2. Chiến lược khắc phục

### Lớp 1: Server-side Sanitization (Jsoup — dùng chung HtmlSanitizer)

- Tạo **utility class dùng chung** `HtmlSanitizer` dùng `Jsoup.clean(input, Safelist.none())`
- **Tất cả service** đều import và gọi `HtmlSanitizer.sanitize()` — không ai dùng `Jsoup.clean()` riêng lẻ nữa
- Gọi sanitize **trước khi lưu vào DB** tại tầng Service
- Loại bỏ toàn bộ HTML tags khỏi input → dữ liệu trong DB luôn sạch

### Lớp 2: Client-side Escaping (escapeHtml — dùng chung security-utils.js)

- Tạo **file JS dùng chung** `security-utils.js` chứa function `escapeHtml()` toàn cục
- Include qua cả 2 SiteMesh decorator (`web.jsp` dòng 74, `admin.jsp` dòng 73)
- Trang nào không dùng decorator (auth pages) → thêm `escapeHtml()` inline
- Gọi escape **trước khi gán vào `innerHTML`** tại tất cả file JSP
- **Xóa hết function `escapeHtml()` local** trùng lặp (product_detail.jsp đã xóa)

### JSON Injection fix

- Thay thế nối chuỗi JSON bằng thư viện Jackson `ObjectMapper`

---

## 3. File mới tạo

### 3.1. HtmlSanitizer.java (Server-side utility)

**Đường dẫn:** `src/main/java/com/proj/webprojrct/common/util/HtmlSanitizer.java`

```java
package com.proj.webprojrct.common.util;

import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;

public final class HtmlSanitizer {

    private HtmlSanitizer() {
    }

    public static String sanitize(String input) {
        if (input == null) {
            return null;
        }
        return Jsoup.clean(input, Safelist.none());
    }
}
```

### 3.2. security-utils.js (Client-side utility)

**Đường dẫn:** `src/main/resources/static/js/security-utils.js`

```javascript
function escapeHtml(text) {
  if (text == null) return "";
  var div = document.createElement("div");
  div.appendChild(document.createTextNode(text));
  return div.innerHTML;
}
```

---

## 4. Chi tiết sửa Backend (Server-side)

### 4.1. ProductServiceImpl.java

**Đường dẫn:** `src/main/java/com/proj/webprojrct/product/service/ProductServiceImpl.java`

**Thêm import (dòng 5):**

```java
import com.proj.webprojrct.common.util.HtmlSanitizer;
```

**Thêm lời gọi sanitize trong method `create()` (dòng 51):**

```java
sanitizeCreateRequest(req);
```

**Thêm lời gọi sanitize trong method `update()` (dòng 81):**

```java
sanitizeUpdateRequest(req);
```

**Sanitize spec.key và spec.value trong vòng lặp specs — create (dòng 65-66):**

```java
// TRƯỚC:
.key(s.getKey())
.value(s.getValue())

// SAU:
.key(HtmlSanitizer.sanitize(s.getKey()))
.value(HtmlSanitizer.sanitize(s.getValue()))
```

**Sanitize spec.key và spec.value trong vòng lặp specs — update (dòng 95-96):**

```java
// TRƯỚC:
.key(s.getKey())
.value(s.getValue())

// SAU:
.key(HtmlSanitizer.sanitize(s.getKey()))
.value(HtmlSanitizer.sanitize(s.getValue()))
```

**Thêm method `sanitizeCreateRequest()` (dòng 283-299):**

```java
private void sanitizeCreateRequest(ProductCreateRequest req) {
    req.setName(HtmlSanitizer.sanitize(req.getName()));
    req.setBrand(HtmlSanitizer.sanitize(req.getBrand()));
    req.setScreenSize(HtmlSanitizer.sanitize(req.getScreenSize()));
    req.setDisplayTech(HtmlSanitizer.sanitize(req.getDisplayTech()));
    req.setResolution(HtmlSanitizer.sanitize(req.getResolution()));
    req.setDisplayFeatures(HtmlSanitizer.sanitize(req.getDisplayFeatures()));
    req.setRearCamera(HtmlSanitizer.sanitize(req.getRearCamera()));
    req.setFrontCamera(HtmlSanitizer.sanitize(req.getFrontCamera()));
    req.setChipset(HtmlSanitizer.sanitize(req.getChipset()));
    req.setCpuSpecs(HtmlSanitizer.sanitize(req.getCpuSpecs()));
    req.setRam(HtmlSanitizer.sanitize(req.getRam()));
    req.setStorage(HtmlSanitizer.sanitize(req.getStorage()));
    req.setBattery(HtmlSanitizer.sanitize(req.getBattery()));
    req.setSimType(HtmlSanitizer.sanitize(req.getSimType()));
    req.setOs(HtmlSanitizer.sanitize(req.getOs()));
    req.setNfcSupport(HtmlSanitizer.sanitize(req.getNfcSupport()));
}
```

**Thêm method `sanitizeUpdateRequest()` (dòng 303-319):**

```java
private void sanitizeUpdateRequest(ProductUpdateRequest req) {
    req.setName(HtmlSanitizer.sanitize(req.getName()));
    req.setBrand(HtmlSanitizer.sanitize(req.getBrand()));
    req.setScreenSize(HtmlSanitizer.sanitize(req.getScreenSize()));
    req.setDisplayTech(HtmlSanitizer.sanitize(req.getDisplayTech()));
    req.setResolution(HtmlSanitizer.sanitize(req.getResolution()));
    req.setDisplayFeatures(HtmlSanitizer.sanitize(req.getDisplayFeatures()));
    req.setRearCamera(HtmlSanitizer.sanitize(req.getRearCamera()));
    req.setFrontCamera(HtmlSanitizer.sanitize(req.getFrontCamera()));
    req.setChipset(HtmlSanitizer.sanitize(req.getChipset()));
    req.setCpuSpecs(HtmlSanitizer.sanitize(req.getCpuSpecs()));
    req.setRam(HtmlSanitizer.sanitize(req.getRam()));
    req.setStorage(HtmlSanitizer.sanitize(req.getStorage()));
    req.setBattery(HtmlSanitizer.sanitize(req.getBattery()));
    req.setSimType(HtmlSanitizer.sanitize(req.getSimType()));
    req.setOs(HtmlSanitizer.sanitize(req.getOs()));
    req.setNfcSupport(HtmlSanitizer.sanitize(req.getNfcSupport()));
}
```

**Tổng: 16 trường × 2 method + 2 spec fields × 2 = 36 vị trí sanitize**

---

### 4.2. UserService.java

**Đường dẫn:** `src/main/java/com/proj/webprojrct/user/service/UserService.java`

**Thêm import (dòng 22):**

```java
import com.proj.webprojrct.common.util.HtmlSanitizer;
```

**Sửa trong method admin update user (dòng 225, 227):**

```java
// TRƯỚC:
userToUpdate.setFullName(updateRequest.getFullname());
userToUpdate.setAddress(updateRequest.getAddress());

// SAU:
userToUpdate.setFullName(HtmlSanitizer.sanitize(updateRequest.getFullname()));
userToUpdate.setAddress(HtmlSanitizer.sanitize(updateRequest.getAddress()));
```

**Sửa trong method profile update (dòng 313, 315):**

```java
// TRƯỚC:
existingUser.setFullName(userReq.getFullname());
existingUser.setAddress(userReq.getAddress());

// SAU:
existingUser.setFullName(HtmlSanitizer.sanitize(userReq.getFullname()));
existingUser.setAddress(HtmlSanitizer.sanitize(userReq.getAddress()));
```

**Tổng: 4 vị trí sanitize (fullName + address × 2 methods)**

---

### 4.3. CategoryServiceImpl.java

**Đường dẫn:** `src/main/java/com/proj/webprojrct/category/service/CategoryServiceImpl.java`

**Thêm import (dòng 6):**

```java
import com.proj.webprojrct.common.util.HtmlSanitizer;
```

**Sửa trong method `create()` (dòng 35-36):**

```java
// TRƯỚC:
.name(dto.getName())
.description(dto.getDescription())

// SAU:
.name(HtmlSanitizer.sanitize(dto.getName()))
.description(HtmlSanitizer.sanitize(dto.getDescription()))
```

**Sửa trong method `update()` (dòng 46-47):**

```java
// TRƯỚC:
c.setName(dto.getName());
c.setDescription(dto.getDescription());

// SAU:
c.setName(HtmlSanitizer.sanitize(dto.getName()));
c.setDescription(HtmlSanitizer.sanitize(dto.getDescription()));
```

**Tổng: 4 vị trí sanitize (name + description × 2 methods)**

---

### 4.4. AuthService.java

**Đường dẫn:** `src/main/java/com/proj/webprojrct/auth/service/AuthService.java`

**Thêm import (dòng 50):**

```java
import com.proj.webprojrct.common.util.HtmlSanitizer;
```

**Sửa trong method `createUserFromRegistration()` (dòng 167-168):**

```java
// TRƯỚC:
// (fullName và address truyền thẳng vào mapper)

// SAU:
request.setFullName(HtmlSanitizer.sanitize(request.getFullName()));
request.setAddress(HtmlSanitizer.sanitize(request.getAddress()));
```

**Sửa trong method `registerUser()` (dòng 200-201):**

```java
// TRƯỚC:
// (fullName và address truyền thẳng vào mapper)

// SAU:
request.setFullName(HtmlSanitizer.sanitize(request.getFullName()));
request.setAddress(HtmlSanitizer.sanitize(request.getAddress()));
```

**Tổng: 4 vị trí sanitize (fullName + address × 2 methods)**

---

### 4.5. Oauth2RegistrationService.java

**Đường dẫn:** `src/main/java/com/proj/webprojrct/auth/service/Oauth2RegistrationService.java`

**Thêm import (dòng 10):**

```java
import com.proj.webprojrct.common.util.HtmlSanitizer;
```

**Sửa trong method `registerNewUser()` (dòng 43, 46):**

```java
// TRƯỚC:
user.setFullName(registerRequest.getFullName());
user.setAddress(registerRequest.getAddress());

// SAU:
user.setFullName(HtmlSanitizer.sanitize(registerRequest.getFullName()));
user.setAddress(HtmlSanitizer.sanitize(registerRequest.getAddress()));
```

**Tổng: 2 vị trí sanitize (fullName + address)**

---

### 4.6. DocumentService.java

**Đường dẫn:** `src/main/java/com/proj/webprojrct/document/service/DocumentService.java`

**Thêm import (dòng 7):**

```java
import com.proj.webprojrct.common.util.HtmlSanitizer;
```

**Sửa trong method `createDocument()` (dòng 43-44):**

```java
// TRƯỚC:
.title(dto.getTitle())
.description(dto.getDescription())

// SAU:
.title(HtmlSanitizer.sanitize(dto.getTitle()))
.description(HtmlSanitizer.sanitize(dto.getDescription()))
```

**Sửa trong method `updateDocument()` (dòng 76-77):**

```java
// TRƯỚC:
existing.setTitle(dto.getTitle());
existing.setDescription(dto.getDescription());

// SAU:
existing.setTitle(HtmlSanitizer.sanitize(dto.getTitle()));
existing.setDescription(HtmlSanitizer.sanitize(dto.getDescription()));
```

**Tổng: 4 vị trí sanitize (title + description × 2 methods)**

---

### 4.7. ReviewService.java (Thống nhất dùng HtmlSanitizer)

**Đường dẫn:** `src/main/java/com/proj/webprojrct/ReviewandRating/service/ReviewService.java`

**Trước khi fix:** File này là nơi duy nhất đã có sẵn sanitization, nhưng dùng `Jsoup.clean()` riêng lẻ thay vì dùng chung `HtmlSanitizer`.

**Sửa import (dòng 17):**

```java
// TRƯỚC:
import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;

// SAU:
import com.proj.webprojrct.common.util.HtmlSanitizer;
```

**Sửa trong method createReview (dòng 38):**

```java
// TRƯỚC:
if (dto.getComment() != null) {
    dto.setComment(Jsoup.clean(dto.getComment(), Safelist.none()));
}

// SAU:
dto.setComment(HtmlSanitizer.sanitize(dto.getComment()));
```

> **Lý do:** Thống nhất toàn bộ codebase dùng chung `HtmlSanitizer`. Không cần `null` check riêng vì `HtmlSanitizer.sanitize()` đã xử lý `null` bên trong.

**Tổng: 1 vị trí sanitize (comment)**

---

## 5. Chi tiết sửa Frontend (Client-side)

### 5.1. web.jsp (SiteMesh Decorator)

**Đường dẫn:** `src/main/resources/META-INF/resources/WEB-INF/decorators/web.jsp`

**Thêm script include (dòng 74):**

```html
<script
  src="${pageContext.request.contextPath}/js/security-utils.js"
  nonce="${cspNonce}"
></script>
```

> Đặt sau `main.js` — đảm bảo `escapeHtml()` có sẵn trên **mọi trang public**.

---

### 5.2. admin.jsp (SiteMesh Decorator)

**Đường dẫn:** `src/main/resources/META-INF/resources/WEB-INF/decorators/admin.jsp`

**Thêm script include (dòng 73):**

```html
<script
  src="${pageContext.request.contextPath}/js/security-utils.js"
  nonce="${cspNonce}"
></script>
```

> Đặt sau `main.js` — đảm bảo `escapeHtml()` có sẵn trên **mọi trang admin**.

---

### 5.3. headerWeb.jsp

**Đường dẫn:** `src/main/resources/META-INF/resources/common/headerWeb.jsp`

**Dòng 484 — Search suggestions image alt:**

```javascript
// TRƯỚC:
'<img src="' + imgSrc + '" alt="' + product.name + '"...';

// SAU:
'<img src="' + imgSrc + '" alt="' + escapeHtml(product.name) + '"...';
```

**Dòng 486 — Search suggestions display text:**

```javascript
// TRƯỚC:
"..." + product.name + "</div>";

// SAU:
"..." + escapeHtml(product.name) + "</div>";
```

---

### 5.4. headerAdmin.jsp

**Đường dẫn:** `src/main/resources/META-INF/resources/common/headerAdmin.jsp`

**Dòng 439 — Admin search suggestions image alt:**

```javascript
// TRƯỚC:
'<img src="' + imgSrc + '" alt="' + product.name + '"...';

// SAU:
'<img src="' + imgSrc + '" alt="' + escapeHtml(product.name) + '"...';
```

**Dòng 441 — Admin search suggestions display text:**

```javascript
// TRƯỚC:
"..." + product.name + "</div>";

// SAU:
"..." + escapeHtml(product.name) + "</div>";
```

---

### 5.5. cart.jsp

**Đường dẫn:** `src/main/resources/META-INF/resources/WEB-INF/views/user/cart.jsp`

**Dòng 355 — Cart item name (image alt):**

```javascript
// TRƯỚC:
'<img ... alt="' + item.name + '">';

// SAU:
'<img ... alt="' + escapeHtml(item.name) + '">';
```

**Dòng 363 — Cart item name (link text):**

```javascript
// TRƯỚC:
"..." + item.name + "</a>";

// SAU:
"..." + escapeHtml(item.name) + "</a>";
```

**Dòng 789 — Alert message (Wave 2):**

```javascript
// TRƯỚC:
alertDiv.innerHTML = '<i class="..."></i> <span>' + message + "</span>...";

// SAU:
alertDiv.innerHTML =
  '<i class="..."></i> <span>' + escapeHtml(message) + "</span>...";
```

---

### 5.6. product_detail.jsp

**Đường dẫn:** `src/main/resources/META-INF/resources/WEB-INF/views/product_detail.jsp`

#### Alert message (Wave 2)

**Dòng 530 — API response message:**

```javascript
// TRƯỚC:
msgEl.innerHTML = '<i class="..."></i> ' + data.message;

// SAU:
msgEl.innerHTML = '<i class="..."></i> ' + escapeHtml(data.message);
```

#### Specs section (Thông số kỹ thuật)

**Dòng 880 — Specification key:**

```javascript
// TRƯỚC:
html += '<td style="width: 40%; font-weight: 500;">' + spec.key + "</td>";

// SAU:
html +=
  '<td style="width: 40%; font-weight: 500;">' + escapeHtml(spec.key) + "</td>";
```

**Dòng 881 — Specification value:**

```javascript
// TRƯỚC:
html += "<td>" + (spec.value || "") + "</td>";

// SAU:
html += "<td>" + escapeHtml(spec.value || "") + "</td>";
```

#### Related products section (Sản phẩm liên quan)

**Dòng 1040 — Related product image alt:**

```javascript
// TRƯỚC:
'<img src="' + imgSrc + '" alt="' + product.name + '">';

// SAU:
'<img src="' + imgSrc + '" alt="' + escapeHtml(product.name) + '">';
```

**Dòng 1044 — Category name:**

```javascript
// TRƯỚC:
'<p class="product-category">' + categoryName + "</p>";

// SAU:
'<p class="product-category">' + escapeHtml(categoryName) + "</p>";
```

**Dòng 1045 — Related product name (link text):**

```javascript
// TRƯỚC:
">" + product.name + "</a></h3>";

// SAU:
">" + escapeHtml(product.name) + "</a></h3>";
```

#### Same-brand products section (Sản phẩm cùng thương hiệu)

**Dòng 1115 — Same-brand product image alt:**

```javascript
// TRƯỚC:
'<img src="' + imgSrc + '" alt="' + product.name + '"...';

// SAU:
'<img src="' + imgSrc + '" alt="' + escapeHtml(product.name) + '"...';
```

**Dòng 1118 — Same-brand product name (link text):**

```javascript
// TRƯỚC:
">" + product.name + "</a></h3>";

// SAU:
">" + escapeHtml(product.name) + "</a></h3>";
```

#### Version products section (Phiên bản khác)

**Dòng 1177 — Version product image alt:**

```javascript
// TRƯỚC:
'<img src="' + imgSrc + '" alt="' + product.name + '">';

// SAU:
'<img src="' + imgSrc + '" alt="' + escapeHtml(product.name) + '">';
```

**Dòng 1181 — Brand name:**

```javascript
// TRƯỚC:
'<p class="product-category">' + brandName + "</p>";

// SAU:
'<p class="product-category">' + escapeHtml(brandName) + "</p>";
```

**Dòng 1182 — Version product name (link text):**

```javascript
// TRƯỚC:
">" + product.name + "</a></h3>";

// SAU:
">" + escapeHtml(product.name) + "</a></h3>";
```

#### Document description (Wave 2)

**Dòng 1574 — Document description render:**

```javascript
// TRƯỚC:
descEl.innerHTML = docData.description;

// SAU:
descEl.innerHTML = escapeHtml(docData.description);
```

#### Reviews section (Đánh giá)

**Dòng 1891 — Review user name:**

```javascript
// TRƯỚC:
html += '<h5 class="name">' + (review.userName || "Ẩn danh") + "</h5>";

// SAU:
html +=
  '<h5 class="name">' + escapeHtml(review.userName || "Ẩn danh") + "</h5>";
```

**Dòng 1904 — Review comment:**

```javascript
// TRƯỚC:
html += '<p class="comment-text">' + review.comment + "</p>";

// SAU:
html += '<p class="comment-text">' + escapeHtml(review.comment) + "</p>";
```

**Dòng 1936 — Child reply comment:**

```javascript
// TRƯỚC:
replyHtml += '<p class="reply-text">' + child.comment + "</p>";

// SAU:
replyHtml += '<p class="reply-text">' + escapeHtml(child.comment) + "</p>";
```

#### Xóa function escapeHtml() local

```javascript
// ĐÃ XÓA (trước đây khai báo riêng trong product_detail.jsp):
function escapeHtml(text) {
  if (text == null) return "";
  var div = document.createElement("div");
  div.appendChild(document.createTextNode(text));
  return div.innerHTML;
}
```

> **Lý do xóa:** Trang này dùng SiteMesh decorator `web.jsp` → đã có sẵn `escapeHtml()` từ `security-utils.js` global. Giữ lại sẽ bị trùng lặp.

---

### 5.7. wishlist.jsp

**Đường dẫn:** `src/main/resources/META-INF/resources/WEB-INF/views/wishlist.jsp`

**Dòng 299 — Wishlist product image alt:**

```javascript
// TRƯỚC:
'<img src="' + imgSrc + '" alt="' + item.productName + '"...';

// SAU:
'<img src="' + imgSrc + '" alt="' + escapeHtml(item.productName) + '"...';
```

**Dòng 305 — Product brand:**

```javascript
// TRƯỚC:
'<p class="product-category">' +
  (item.productBrand || "Chưa phân loại") +
  "</p>";

// SAU:
'<p class="product-category">' +
  escapeHtml(item.productBrand || "Chưa phân loại") +
  "</p>";
```

**Dòng 313 — Product name (link text):**

```javascript
// TRƯỚC:
">" + item.productName + "</a>";

// SAU:
">" + escapeHtml(item.productName) + "</a>";
```

---

### 5.8. user/wishlist.jsp

**Đường dẫn:** `src/main/resources/META-INF/resources/WEB-INF/views/user/wishlist.jsp`

**Dòng 228 — Alert message (Wave 2):**

```javascript
// TRƯỚC:
alertDiv.innerHTML = "...<span>" + message + "</span>...";

// SAU:
alertDiv.innerHTML = "...<span>" + escapeHtml(message) + "</span>...";
```

**Dòng 384 — User wishlist product image alt:**

```javascript
// TRƯỚC:
'<img src="' + imgSrc + '" alt="' + item.productName + '"...';

// SAU:
'<img src="' + imgSrc + '" alt="' + escapeHtml(item.productName) + '"...';
```

**Dòng 390 — Product brand:**

```javascript
// TRƯỚC:
'<p class="product-category">' +
  (item.productBrand || "Chưa phân loại") +
  "</p>";

// SAU:
'<p class="product-category">' +
  escapeHtml(item.productBrand || "Chưa phân loại") +
  "</p>";
```

**Dòng 398 — Product name (link text):**

```javascript
// TRƯỚC:
">" + item.productName + "</a>";

// SAU:
">" + escapeHtml(item.productName) + "</a>";
```

---

### 5.9. deals.jsp

**Đường dẫn:** `src/main/resources/META-INF/resources/WEB-INF/views/deals.jsp`

**Dòng 729 — Deals section title:**

```javascript
// TRƯỚC:
title.innerHTML = "🎯 " + categoryName + " Hot Deals";

// SAU:
title.innerHTML = "🎯 " + escapeHtml(categoryName) + " Hot Deals";
```

---

### 5.10. order_detail.jsp (Wave 2)

**Đường dẫn:** `src/main/resources/META-INF/resources/WEB-INF/views/user/order_detail.jsp`

**Dòng 630 — Alert message từ API response:**

```javascript
// TRƯỚC:
alertDiv.innerHTML = '<i class="..."></i> <span>' + message + "</span>...";

// SAU:
alertDiv.innerHTML =
  '<i class="..."></i> <span>' + escapeHtml(message) + "</span>...";
```

---

### 5.11. profile.jsp (Wave 2)

**Đường dẫn:** `src/main/resources/META-INF/resources/WEB-INF/views/user/profile.jsp`

**Dòng 1515 — Alert message từ API response:**

```javascript
// TRƯỚC:
alertDiv.innerHTML = '<i class="..."></i> <span>' + message + "</span>...";

// SAU:
alertDiv.innerHTML =
  '<i class="..."></i> <span>' + escapeHtml(message) + "</span>...";
```

---

### 5.12. document_form.jsp (Wave 2)

**Đường dẫn:** `src/main/resources/META-INF/resources/WEB-INF/views/admin/document_form.jsp`

**Dòng 537 — Toast message từ API response:**

```javascript
// TRƯỚC:
toastBody.innerHTML = '<i class="..."></i> ' + message;

// SAU:
toastBody.innerHTML = '<i class="..."></i> ' + escapeHtml(message);
```

---

### 5.13. category_form.jsp (Wave 2)

**Đường dẫn:** `src/main/resources/META-INF/resources/WEB-INF/views/admin/category_form.jsp`

**Dòng 320 — Status message từ API response:**

```javascript
// TRƯỚC:
statusDiv.innerHTML = '<i class="..."></i> ' + message;

// SAU:
statusDiv.innerHTML = '<i class="..."></i> ' + escapeHtml(message);
```

---

### 5.14. register-phone-verify.jsp (Wave 2 — Special case)

**Đường dẫn:** `src/main/resources/META-INF/resources/WEB-INF/views/auth/register-phone-verify.jsp`

> ⚠️ **Đặc biệt:** Trang này thuộc nhóm auth, **không dùng SiteMesh decorator** (`web.jsp` / `admin.jsp`), nên **không có sẵn** `escapeHtml()` từ `security-utils.js` global. Phải thêm inline.

**Thêm function escapeHtml() inline (dòng 302-306):**

```javascript
function escapeHtml(text) {
  if (text == null) return "";
  var div = document.createElement("div");
  div.appendChild(document.createTextNode(text));
  return div.innerHTML;
}
```

**Dòng 326 — Alert message từ API response:**

```javascript
// TRƯỚC:
msgDiv.innerHTML = '<i class="..."></i> ' + data.message;

// SAU:
msgDiv.innerHTML = '<i class="..."></i> ' + escapeHtml(data.message);
```

---

## 6. Khắc phục JSON Injection

### SpeedSMSAPI.java

**Đường dẫn:** `src/main/java/com/proj/webprojrct/sms/SpeedSMSAPI.java`

**Thêm import (dòng 10-12):**

```java
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
```

**Sửa method `sendSMS()` (dòng 57-65):**

```java
// TRƯỚC (JSON Injection — nối chuỗi trực tiếp):
String json = "{\"to\": [\"" + to + "\"], \"content\": \""
    + EncodeNonAsciiCharacters(content) + "\", \"type\":"
    + type + ", \"brandname\":\"" + sender + "\"}";

// SAU (An toàn — dùng Jackson ObjectMapper):
ObjectMapper mapper = new ObjectMapper();
ObjectNode jsonObj = mapper.createObjectNode();
ArrayNode toArray = mapper.createArrayNode();
toArray.add(to);
jsonObj.set("to", toArray);
jsonObj.put("content", EncodeNonAsciiCharacters(content));
jsonObj.put("type", type);
jsonObj.put("brandname", sender);
String json = mapper.writeValueAsString(jsonObj);
```

**Lý do:** Khi nối chuỗi trực tiếp, attacker có thể inject JSON qua tham số `to` hoặc `sender` (ví dụ: `"\", \"admin\": true, \"to\": [\"`). Jackson tự động escape các ký tự đặc biệt khi serialize.

---

## 7. Tổng kết

### Thống kê file đã sửa

| Loại                      | Số file     | Chi tiết                                                                                                                     |
| ------------------------- | ----------- | ---------------------------------------------------------------------------------------------------------------------------- |
| File mới tạo              | 2           | `HtmlSanitizer.java`, `security-utils.js`                                                                                    |
| Java Service (backend)    | 7           | ProductServiceImpl, UserService, CategoryServiceImpl, AuthService, Oauth2RegistrationService, DocumentService, ReviewService |
| Java API (JSON injection) | 1           | SpeedSMSAPI                                                                                                                  |
| JSP Decorator             | 2           | web.jsp, admin.jsp                                                                                                           |
| JSP View (Wave 1)         | 7           | headerWeb, headerAdmin, cart, product_detail, wishlist, user/wishlist, deals                                                 |
| JSP View (Wave 2)         | 5           | order_detail, profile, document_form, category_form, register-phone-verify                                                   |
| **Tổng cộng**             | **24 file** |                                                                                                                              |

### Thống kê vị trí sửa

| Lớp bảo vệ                                        | Số vị trí     |
| ------------------------------------------------- | ------------- |
| Server-side sanitize (`HtmlSanitizer.sanitize()`) | 55 lời gọi    |
| Client-side escape (`escapeHtml()`)               | 36 lời gọi    |
| JSON injection fix (Jackson ObjectMapper)         | 1 vị trí      |
| **Tổng cộng**                                     | **92 vị trí** |

### Thống kê theo đợt (Wave)

| Đợt    | Loại sửa                                     | Số file | Chi tiết                                                                                                                                                                                                                         |
| ------ | -------------------------------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Wave 1 | Stored XSS (data fields)                     | 17      | 6 services + SpeedSMSAPI + 2 decorators + 7 JSP views + HtmlSanitizer.java + security-utils.js                                                                                                                                   |
| Wave 2 | Reflected XSS (alert messages) + Unification | 7       | cart(L789), product_detail(L530,L1574), order_detail(L630), profile(L1515), document_form(L537), category_form(L320), register-phone-verify(L302-306,L326) + ReviewService unification + product_detail local escapeHtml removal |

### Các trường dữ liệu được bảo vệ

| Entity       | Trường                                                                                                                                                        | Server-side |   Client-side    |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------: | :--------------: |
| Product      | name, brand, screenSize, displayTech, resolution, displayFeatures, rearCamera, frontCamera, chipset, cpuSpecs, ram, storage, battery, simType, os, nfcSupport |     ✅      | ✅ (name, brand) |
| Product Spec | key, value                                                                                                                                                    |     ✅      |        ✅        |
| User         | fullName, address                                                                                                                                             |     ✅      |        —         |
| Category     | name, description                                                                                                                                             |     ✅      |    ✅ (name)     |
| Document     | title, description                                                                                                                                            |     ✅      | ✅ (description) |
| Review       | comment                                                                                                                                                       |     ✅      |        ✅        |
| Review       | userName                                                                                                                                                      |      —      |        ✅        |
| Wishlist     | productName, productBrand                                                                                                                                     |      —      |        ✅        |
| SMS          | to, content, sender                                                                                                                                           |      —      |   ✅ (Jackson)   |
| Alert/Toast  | message (7 file JSP)                                                                                                                                          |      —      |        ✅        |

### Lưu ý còn tồn tại

| Rủi ro                                 | Mức độ | Mô tả                                                                               |
| -------------------------------------- | ------ | ----------------------------------------------------------------------------------- |
| CSP `script-src-attr 'unsafe-inline'`  | LOW    | Cho phép `onclick="..."` inline → có thể bị khai thác qua attribute injection       |
| `${variable}` trong onclick attributes | LOW    | Một số nút dùng EL expression trong `onclick` — nếu data chứa `"` có thể break out  |
| `document.write()` trong footer        | LOW    | `document.write(new Date().getFullYear())` — không dùng user data, an toàn hiện tại |
