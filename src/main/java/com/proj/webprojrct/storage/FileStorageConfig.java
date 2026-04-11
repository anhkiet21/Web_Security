package com.proj.webprojrct.storage;

import com.proj.webprojrct.storage.entity.FileStorageServiceI;
import com.proj.webprojrct.storage.service.AvatarStorageService;
import com.proj.webprojrct.storage.service.ProductStorageService;

import com.proj.webprojrct.storage.service.DocumentStorageService;
import com.proj.webprojrct.storage.service.MediaStorageService;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;
import java.nio.file.Paths;

import com.proj.webprojrct.storage.service.DocumentStorageService;

import com.proj.webprojrct.storage.service.DocumentStorageService;

@Configuration
public class FileStorageConfig {

    @Bean
    public AvatarStorageService avatarStorage(FileStorageProperties props) throws IOException {
        return new AvatarStorageService(Paths.get(props.getAvatars()));
    }

    @Bean
    public ProductStorageService productStorage(FileStorageProperties props) throws IOException {
        return new ProductStorageService(Paths.get(props.getProducts()));
    }

    @Bean
    public DocumentStorageService documentStorage(FileStorageProperties props) throws IOException {
        return new DocumentStorageService(Paths.get(props.getDocuments()));
    }

    @Bean
    public MediaStorageService mediaStorage(FileStorageProperties props) throws IOException {
        return new MediaStorageService(Paths.get(props.getMedia()));
    }

}
