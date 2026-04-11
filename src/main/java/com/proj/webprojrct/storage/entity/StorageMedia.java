package com.proj.webprojrct.storage.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
@Table(name = "storage_media")
public class StorageMedia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // relative path or filename stored by MediaStorageService
    private String path;

    // content type e.g. image/png, video/mp4
    private String contentType;

    private Long size;

    private Date uploadedAt;

    // optional: uploader id
    private String ownerId;
}
