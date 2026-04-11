package com.proj.webprojrct.storage.controller;

import com.proj.webprojrct.storage.entity.StorageMedia;
import com.proj.webprojrct.storage.service.StorageMediaRecordService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping("/api/media")
@RequiredArgsConstructor
public class StorageMediaController {

    private final StorageMediaRecordService recordService;

    /**
     * Upload an image or video. Returns JSON with saved entity (id and path).
     * The path can be used later to serve files via a static URL endpoint.
     */
    @PostMapping("/upload")
    public ResponseEntity<?> upload(@RequestParam("file") MultipartFile file,
                                    @RequestParam(value = "ownerId", required = false) String ownerId) throws IOException {
        StorageMedia saved = recordService.store(file, ownerId);
        return ResponseEntity.ok(saved);
    }
}
