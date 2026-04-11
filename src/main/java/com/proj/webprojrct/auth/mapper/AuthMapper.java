package com.proj.webprojrct.auth.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;
import com.proj.webprojrct.auth.dto.request.RegisterRequest;
import com.proj.webprojrct.auth.dto.request.LoginRequest;
import com.proj.webprojrct.auth.dto.response.LoginResponse;

import com.proj.webprojrct.user.entity.User;

@Mapper(componentModel = "spring")
public interface AuthMapper {

    User toEntity(LoginRequest loginRequest);

    User toEntity(RegisterRequest registerRequest);

    LoginResponse toDto(User user);
}
