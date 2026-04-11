package com.proj.webprojrct.storage;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "file.storage")
@Data
public class FileStorageProperties {

    private String avatars;
    private String products;
    private String documents;

    // media cho phần chat support
    private String media;
}
