package com.proj.webprojrct.storage.service;

import org.apache.tika.Tika;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;

public class FileSignatureValidator {

    private static final Tika tika = new Tika();
    // Buffer đủ lớn để Tika không đọc vượt quá phạm vi mark()
    private static final int MARK_LIMIT = 65536; // 64KB

    /**
     * Đảm bảo InputStream hỗ trợ mark/reset với buffer 64KB.
     * Luôn wrap lại bằng BufferedInputStream(is, 64KB) để đảm bảo
     * nhất quán kể cả khi is.markSupported() trả về true (vd: kích thước buffer cũ nhỏ).
     */
    public static InputStream ensureMarkSupported(InputStream is) {
        return new BufferedInputStream(is, MARK_LIMIT);
    }

    /**
     * Kiểm tra file có phải là ảnh hợp lệ (JPEG, PNG, GIF, WEBP, ...).
     * Luồng được mark/reset => không bị tiêu thụ sau khi gọi hàm này.
     */
    public static boolean isValidImage(InputStream is) throws IOException {
        is.mark(MARK_LIMIT);
        String mimeType = tika.detect(is);
        is.reset();
        if (mimeType == null) return false;
        return mimeType.startsWith("image/");
    }

    /**
     * Trả về MIME type thực tế đã phát hiện (để hiển thị thông báo lỗi chi tiết).
     */
    public static String detectMimeType(InputStream is) throws IOException {
        is.mark(MARK_LIMIT);
        String mimeType = tika.detect(is);
        is.reset();
        return mimeType != null ? mimeType : "unknown";
    }

    public static boolean isValidDocument(InputStream is) throws IOException {
        is.mark(MARK_LIMIT);
        String mimeType = tika.detect(is);
        is.reset();
        if (mimeType == null) return false;
        
        return mimeType.startsWith("text/") || 
               mimeType.equals("application/pdf") ||
               mimeType.startsWith("application/vnd.ms-excel") ||
               mimeType.startsWith("application/vnd.openxmlformats-officedocument.spreadsheetml") ||
               mimeType.startsWith("application/msword") ||
               mimeType.startsWith("application/vnd.openxmlformats-officedocument.wordprocessingml") ||
               mimeType.startsWith("application/vnd.ms-powerpoint") ||
               mimeType.startsWith("application/vnd.openxmlformats-officedocument.presentationml") ||
               mimeType.equals("application/rtf");
    }

    public static boolean isValidMedia(InputStream is) throws IOException {
        is.mark(MARK_LIMIT);
        String mimeType = tika.detect(is);
        is.reset();
        if (mimeType == null) return false;
        
        return mimeType.startsWith("image/") || 
               mimeType.startsWith("video/") || 
               mimeType.startsWith("audio/") ||
               mimeType.equals("application/ogg");
    }
}
