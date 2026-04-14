package com.proj.webprojrct.user.service;

import java.io.IOException;
import java.io.InputStream;
import java.security.SecureRandom;
import java.util.List;
import java.util.stream.Collectors;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import com.proj.webprojrct.common.config.security.CustomUserDetails;

import com.proj.webprojrct.user.dto.request.UserUpdateRequest;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.dto.response.UserResponse;
import com.proj.webprojrct.user.mapper.UserMapper;
import com.proj.webprojrct.user.repository.UserRepository;
import com.proj.webprojrct.storage.service.AvatarStorageService;
import com.proj.webprojrct.user.dto.request.UserAdminUpdateRequest;
import com.proj.webprojrct.user.dto.request.UserCreateRequest;
import com.proj.webprojrct.user.dto.response.UserAdminResponse;
import com.proj.webprojrct.user.entity.UserRole;
import com.proj.webprojrct.common.config.logging.SecurityEventLogger;
import com.proj.webprojrct.common.HtmlSanitizer;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Service
public class UserService {
    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    /**
     * Helper: Lấy User từ principal — hỗ trợ cả 2 loại login:
     * - Đăng nhập thường (CustomUserDetails)
     * - Đăng nhập OAuth2/Google (CustomOauth2User)
     */
    private User extractUser(Authentication authentication) {
        Object principal = authentication.getPrincipal();
        if (principal instanceof CustomUserDetails cud) {
            return cud.getUser();
        }
        throw new RuntimeException("Không xác định được thông tin người dùng.");
    }

    @Autowired
    private AvatarStorageService avatarStorageService;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private PasswordEncoder passwordEncoder;

    public List<UserAdminResponse> getAllUsers(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new RuntimeException("Bạn chưa đăng nhập.");
        }
        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
        if (!isAdmin) {
            throw new RuntimeException("Bạn không đủ quyền truy cập.");
        }
        List<User> users = userRepository.findAll();
        return userMapper.toDto(users);
    }

    /////////////////////////////////////// thêm vào service cho phân
    /////////////////////////////////////// trang/////////////////////////////////////////////////////
    public Page<UserAdminResponse> getPagedUsers(
            Authentication authentication,
            Pageable pageable,
            String phone,
            String fullname,
            String email,
            String role,
            Boolean active) {

        // Kiểm tra quyền truy cập
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new RuntimeException("Bạn chưa đăng nhập.");
        }
        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
        if (!isAdmin) {
            throw new RuntimeException("Bạn không đủ quyền truy cập.");
        }

        logger.debug("Filtering users with criteria - phone: {}, fullname: {}, email: {}, role: {}, active: {}",
                phone, fullname, email, role, active);

        // Lấy tất cả users (trong thực tế nên tích hợp JPA Specification để query hiệu
        // quả hơn)
        List<User> allUsers = userRepository.findAll();

        logger.debug("Total users before filtering: {}", allUsers.size());

        // Lọc theo các tiêu chí
        List<User> filteredUsers = allUsers.stream()
                .filter(user -> {
                    boolean matches = true;

                    if (StringUtils.hasText(phone)) {
                        matches &= user.getPhone() != null
                                && user.getPhone().toLowerCase().contains(phone.toLowerCase());
                    }

                    if (StringUtils.hasText(fullname)) {
                        matches &= user.getFullName() != null
                                && user.getFullName().toLowerCase().contains(fullname.toLowerCase());
                    }

                    if (StringUtils.hasText(email)) {
                        matches &= user.getEmail() != null
                                && user.getEmail().toLowerCase().contains(email.toLowerCase());
                    }

                    if (StringUtils.hasText(role)) {
                        matches &= user.getRole() != null && user.getRole().name().equalsIgnoreCase(role);
                    }

                    if (active != null) {
                        matches &= user.getIsActive().equals(active);
                    }

                    return matches;
                })
                .collect(Collectors.toList());

        // Phân trang kết quả
        int start = (int) pageable.getOffset();
        int end = Math.min((start + pageable.getPageSize()), filteredUsers.size());

        if (start > filteredUsers.size()) {
            return new PageImpl<>(new ArrayList<>(), pageable, filteredUsers.size());
        }

        List<User> pageContent = filteredUsers.subList(start, end);

        // Chuyển đổi sang DTO
        List<UserAdminResponse> dtoList = userMapper.toDto(pageContent);

        // Log thông tin phân trang
        logger.debug("Pagination info - total: {}, page size: {}, current page: {}, content size: {}",
                filteredUsers.size(), pageable.getPageSize(), pageable.getPageNumber(), dtoList.size());

        // Trả về Page
        return new PageImpl<>(dtoList, pageable, filteredUsers.size());
    }

    /////////////////////////////////////// thêm vào service cho phân
    /////////////////////////////////////// trang/////////////////////////////////////////////////////

    public UserAdminResponse handleCreateUser(Authentication authentication, UserCreateRequest userCreateRequest) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new RuntimeException("Bạn chưa đăng nhập.");
        }
        String phone = authentication.getName();
        User currUser = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản hiện tại"));

        if (currUser.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Bạn không đủ quyền thực hiện thao tác này.");
        }
        if (userRepository.existsByPhone(userCreateRequest.getPhone())) {
            throw new RuntimeException("Số điện thoại đã tồn tại trong hệ thống.");
        }

        if (userRepository.existsByEmail(userCreateRequest.getEmail())) {
            throw new RuntimeException("Email đã tồn tại trong hệ thống.");
        }
        User newUser = userMapper.toEntity(userCreateRequest);
        // FIX V-13: Sinh mật khẩu ngẫu nhiên an toàn thay vì hardcode "123"
        String tempPassword = generateTempPassword();
        newUser.setPasswordHash(passwordEncoder.encode(tempPassword));
        userRepository.save(newUser);
        UserAdminResponse response = userMapper.toAdminResponse(newUser);
        response.setTempPassword(tempPassword); // trả lại 1 lần duy nhất cho admin
        return response;
    }

    public UserAdminResponse handleUpdateUser(Authentication authentication, UserAdminUpdateRequest updateRequest,
            long id) {

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new RuntimeException("Bạn chưa đăng nhập.");
        }

        String phone = authentication.getName();
        User currUser = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản hiện tại"));

        if (currUser.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Bạn không đủ quyền thực hiện thao tác này.");
        }

        User userToUpdate = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user cần cập nhật"));

        // [LOGGING] Lưu role cũ trước khi cập nhật - OWASP A09
        UserRole oldRole = userToUpdate.getRole();

        userToUpdate.setFullName(HtmlSanitizer.sanitize(updateRequest.getFullname()));
        userToUpdate.setEmail(updateRequest.getEmail());
        userToUpdate.setAddress(updateRequest.getAddress());
        userToUpdate.setRole(updateRequest.getRole());

        // Cập nhật trạng thái active nếu có
        if (updateRequest.getIsActive() != null) {
            userToUpdate.setIsActive(updateRequest.getIsActive());
        }

        userRepository.save(userToUpdate);

        // [LOGGING] Ghi log thay đổi role nếu có - OWASP A09
        if (updateRequest.getRole() != null && oldRole != updateRequest.getRole()) {
            SecurityEventLogger.roleChanged(
                    currUser.getPhone(),
                    userToUpdate.getPhone(),
                    oldRole.name(),
                    updateRequest.getRole().name(),
                    getClientIp());
        }

        return userMapper.toAdminResponse(userToUpdate);
    }

    public void handleDeleteUser(Authentication authentication, long userId) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new RuntimeException("Bạn chưa đăng nhập.");
        }

        String phone = authentication.getName();
        User currUser = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản hiện tại"));

        if (currUser.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Bạn không đủ quyền thực hiện thao tác này.");
        }

        User userToDelete = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user cần xóa"));
        userToDelete.setIsActive(false);
        userRepository.save(userToDelete);

        // [LOGGING] Ghi log xóa user - OWASP A09
        SecurityEventLogger.userDeleted(currUser.getPhone(), String.valueOf(userId), getClientIp());
    }

    /////////////////////////////////////////////////////////////////////////////////

    public UserResponse handleGetUserProfile(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new RuntimeException("Bạn chưa đăng nhập.");
        }

        User user = extractUser(authentication);

        return userMapper.toDto(user);
    }

    public UserResponse updateCurrentUserProfile(Authentication authentication, UserUpdateRequest userReq,
            MultipartFile avt) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new RuntimeException("Bạn chưa đăng nhập.");
        }

        User existingUser = extractUser(authentication);

        if (avt != null && !avt.isEmpty()) {
            try (InputStream inputStream = avt.getInputStream()) {
                String savedFileName = avatarStorageService.save(avt.getOriginalFilename(), inputStream);

                String oldAvatar = existingUser.getAvatarUrl();
                if (oldAvatar != null && oldAvatar.startsWith("/uploads/avatars/")) {
                    String oldFileName = oldAvatar.substring("/uploads/avatars/".length());
                    avatarStorageService.delete(oldFileName);
                }
                existingUser.setAvatarUrl("/uploads/avatars/" + savedFileName);
            } catch (IllegalArgumentException e) {
                throw new RuntimeException("File avatar không hợp lệ: Chỉ chấp nhận file ảnh (.jpg, .jpeg, .png, .gif, .webp)");
            } catch (IOException e) {
                throw new RuntimeException("Lỗi khi lưu avatar. Vui lòng thử lại.");
            }
        }

        existingUser.setFullName(HtmlSanitizer.sanitize(userReq.getFullname()));
        existingUser.setEmail(userReq.getEmail());
        existingUser.setAddress(HtmlSanitizer.sanitize(userReq.getAddress()));

        userRepository.save(existingUser);

        return userMapper.toDto(existingUser);
    }

    public UserResponse handleGetUserById(Authentication authentication, Long userId) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new RuntimeException("Bạn chưa đăng nhập.");
        }
        User currUser = extractUser(authentication);
        if (currUser.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Bạn không đủ quyền thực hiện thao tác này.");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));

        return userMapper.toDto(user);
    }

    //////////////// Service cho phần chat
    //////////////// support////////////////////////////////////////////////////////////

    public List<String> findAdmins() {
        return userRepository.findAll().stream()
                .filter(u -> u.getRole() != null && u.getRole().name().equals("ADMIN"))
                .map(User::getPhone)
                .collect(Collectors.toList());
    }

    public UserResponse handleGetUserByPhone(Authentication authentication, String phone) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof org.springframework.security.authentication.AnonymousAuthenticationToken) {
            throw new RuntimeException("Bạn chưa đăng nhập.");
        }

        User currUser = extractUser(authentication);
        if (currUser.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Bạn không đủ quyền truy cập.");
        }

        User user = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));

        return userMapper.toDto(user);
    }

    // [LOGGING] Lấy IP thực của client - OWASP A09
    private String getClientIp() {
        try {
            ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attrs == null)
                return "unknown";
            HttpServletRequest req = attrs.getRequest();
            String ip = req.getHeader("X-Forwarded-For");
            if (ip != null && !ip.isEmpty() && !"unknown".equalsIgnoreCase(ip)) {
                return ip.split(",")[0].trim();
            }
            return req.getRemoteAddr();
        } catch (Exception e) {
            return "unknown";
        }
    }

    /**
     * FIX V-13: Sinh mật khẩu tạm ngẫu nhiên — ít nhất 12 ký tự,
     * bao gồm chữ hoa, chữ thường, số, ký tự đặc biệt.
     */
    private String generateTempPassword() {
        SecureRandom random = new SecureRandom();
        String upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String lower = "abcdefghijklmnopqrstuvwxyz";
        String digits = "0123456789";
        String special = "!@#$%";
        String all = upper + lower + digits + special;

        StringBuilder sb = new StringBuilder();
        sb.append(upper.charAt(random.nextInt(upper.length())));
        sb.append(lower.charAt(random.nextInt(lower.length())));
        sb.append(digits.charAt(random.nextInt(digits.length())));
        sb.append(special.charAt(random.nextInt(special.length())));
        for (int i = 4; i < 12; i++) {
            sb.append(all.charAt(random.nextInt(all.length())));
        }
        // Xào trộn để tránh các ký tự bắt buộc luôn ở đầu
        char[] chars = sb.toString().toCharArray();
        for (int i = chars.length - 1; i > 0; i--) {
            int j = random.nextInt(i + 1);
            char tmp = chars[i];
            chars[i] = chars[j];
            chars[j] = tmp;
        }
        return new String(chars);
    }

}
