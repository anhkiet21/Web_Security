package com.proj.webprojrct.storage.entity;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public interface FileStorageServiceI {

    /**
     * Lưu file vào hệ thống lưu trữ và trả về tên file đã lưu (có thể được sửa
     * đổi cho unique).
     */
    String save(String filename, InputStream data) throws IOException;

    /**
     * Đọc file theo tên, trả về nội dung file dưới dạng mảng byte.
     */
    byte[] read(String filename) throws IOException;

    /**
     * Xóa file theo tên, trả về true nếu xóa thành công.
     */
    boolean delete(String filename) throws IOException;

    /**
     * Trả về danh sách các file hiện có (dưới dạng tên file).
     */
    List<String> list() throws IOException;
}
