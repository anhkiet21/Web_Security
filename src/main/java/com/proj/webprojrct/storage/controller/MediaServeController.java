package com.proj.webprojrct.storage.controller;

import com.proj.webprojrct.storage.service.MediaStorageService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@RestController
@RequiredArgsConstructor
public class MediaServeController {

    private final MediaStorageService mediaStorageService;

    @GetMapping("/media/{filename}")
    public ResponseEntity<byte[]> serve(@PathVariable String filename) {
        try {
            byte[] data = mediaStorageService.read(filename);
            // Try to guess content type from filename extension
            String lc = filename.toLowerCase();
            MediaType mt = MediaType.APPLICATION_OCTET_STREAM;
            if (lc.endsWith(".png") || lc.endsWith(".jpg") || lc.endsWith(".jpeg") || lc.endsWith(".gif")) {
                mt = MediaType.IMAGE_JPEG;
                if (lc.endsWith(".png")) mt = MediaType.IMAGE_PNG;
            } else if (lc.endsWith(".mp4") || lc.endsWith(".webm") || lc.endsWith(".ogg")) {
                mt = MediaType.valueOf("video/mp4");
            }

            return ResponseEntity.status(HttpStatus.OK)
                    .header(HttpHeaders.CONTENT_TYPE, mt.toString())
                    .body(data);
        } catch (IOException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
