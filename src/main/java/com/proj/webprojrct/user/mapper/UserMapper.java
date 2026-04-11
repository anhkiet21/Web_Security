package com.proj.webprojrct.user.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

import com.proj.webprojrct.user.dto.request.UserCreateRequest;
import com.proj.webprojrct.user.dto.request.UserUpdateRequest;
import com.proj.webprojrct.user.dto.response.UserAdminResponse;
import com.proj.webprojrct.user.dto.response.UserResponse;
import com.proj.webprojrct.user.entity.User;

@Mapper(componentModel = "spring")
public interface UserMapper {

    @Mapping(target = "fullName", source = "fullname")
    public User toEntity(UserCreateRequest user);

    @Mapping(target = "fullName", source = "fullname")
    public User toEntity(UserUpdateRequest user);

    @Mapping(target = "fullname", source = "fullName")
    public UserResponse toDto(User user);

    @Mapping(target = "fullname", source = "fullName")
    public UserAdminResponse toAdminResponse(User user);

    @Mapping(target = "fullname", source = "fullName")
    public List<UserAdminResponse> toDto(List<User> user);
}
