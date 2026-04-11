package com.proj.webprojrct.storage.service;

import com.proj.webprojrct.storage.entity.StorageMedia;
import com.proj.webprojrct.storage.repository.StorageMediaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Date;

@Service
@RequiredArgsConstructor
public class StorageMediaRecordService {

    private final StorageMediaRepository repository;
    private final MediaStorageService mediaStorageService;

  
    public StorageMedia store(MultipartFile file, String ownerId) throws IOException {
        var original = file.getOriginalFilename() == null ? "file" : file.getOriginalFilename();
        String storedName = mediaStorageService.save(original, file.getInputStream());

        StorageMedia m = StorageMedia.builder()
                .path(storedName)
                .contentType(file.getContentType())
                .size(file.getSize())
                .uploadedAt(new Date())
                .ownerId(ownerId)
                .build();
        return repository.save(m);
    }
}
