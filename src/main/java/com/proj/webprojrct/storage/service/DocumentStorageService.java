package com.proj.webprojrct.storage.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.Arrays;
import com.proj.webprojrct.storage.entity.FileStorageServiceI;

import lombok.*;

public class DocumentStorageService implements FileStorageServiceI {

    private final Path root;

    // Constructor nhận trực tiếp Path
    public DocumentStorageService(Path path) throws IOException {
        this.root = path.toAbsolutePath().normalize();
        Files.createDirectories(root);
    }

    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".webp");

    public String save(String filename, InputStream data) throws IOException {
        if (filename == null || filename.isEmpty()) {
            throw new IllegalArgumentException("Filename cannot be empty");
        }
        
        String lowerCaseName = filename.toLowerCase();
        if (ALLOWED_EXTENSIONS.stream().noneMatch(lowerCaseName::endsWith)) {
            throw new IllegalArgumentException("Invalid file type for document image. Allowed: " + ALLOWED_EXTENSIONS);
        }

        // Deep content filter (Document here actually stores DocumentImage)
        data = FileSignatureValidator.ensureMarkSupported(data);
        if (!FileSignatureValidator.isValidImage(data)) {
            throw new IllegalArgumentException("Invalid file content signature for document image.");
        }

        // Strip any directory components before building the stored name
        String safeName = Path.of(filename).getFileName().toString();
        //Get unique file name
        String uniqueFileName = UUID.randomUUID() + "_" + safeName;

        Path filePath = safeResolve(uniqueFileName);
        Files.copy(data, filePath, StandardCopyOption.REPLACE_EXISTING);
        return uniqueFileName;
    }

    public byte[] read(String filename) throws IOException {
        Path path = safeResolve(filename);
        if (!Files.exists(path)) {
            throw new FileNotFoundException("Không tìm thấy file: " + path.toString());
        }
        return Files.readAllBytes(path);
    }

    public boolean delete(String filename) throws IOException {
        return Files.deleteIfExists(safeResolve(filename));
    }

    /**
     * Resolve a filename safely inside {@code root}.
     * Strips directory separators and verifies the result stays within root
     * to prevent path-traversal attacks (OWASP A01 / CWE-22).
     */
    private Path safeResolve(String filename) {
        if (filename == null || filename.isBlank()) {
            throw new IllegalArgumentException("Filename must not be empty");
        }
        String safeName = Path.of(filename).getFileName().toString();
        Path resolved = root.resolve(safeName).normalize();
        if (!resolved.startsWith(root)) {
            throw new SecurityException("Path traversal attempt detected");
        }
        return resolved;
    }

    public List<String> list() throws IOException {
        try (Stream<Path> paths = Files.list(root)) {
            return paths
                    .filter(Files::isRegularFile)
                    .map(p -> p.getFileName().toString())
                    .collect(Collectors.toList());
        }
    }

}
