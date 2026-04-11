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
import com.proj.webprojrct.storage.entity.FileStorageServiceI;

import lombok.*;

public class ProductStorageService implements FileStorageServiceI {

    private final Path root;

    // Constructor nhận trực tiếp Path
    public ProductStorageService(Path path) throws IOException {
        this.root = path.toAbsolutePath().normalize();
        Files.createDirectories(root);
    }

    public String save(String filename, InputStream data) throws IOException {

        //Get unique file name
        String uniqueFileName = UUID.randomUUID() + "_" + filename;

        Path filePath = root.resolve(uniqueFileName);
        Files.copy(data, filePath, StandardCopyOption.REPLACE_EXISTING);
        return uniqueFileName;
    }

    public byte[] read(String filename) throws IOException {
        Path path = root.resolve(filename);
        if (!Files.exists(path)) {
            throw new FileNotFoundException("Không tìm thấy file: " + path.toString());
        }
        return Files.readAllBytes(path);
    }

    public boolean delete(String filename) throws IOException {
        return Files.deleteIfExists(root.resolve(filename));
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
