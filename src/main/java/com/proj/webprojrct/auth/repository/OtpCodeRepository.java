package com.proj.webprojrct.auth.repository;

import com.proj.webprojrct.auth.entity.OtpCode;
import com.proj.webprojrct.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface OtpCodeRepository extends JpaRepository<OtpCode, Long> {

    Optional<OtpCode> findByUserAndOtpCodeAndUsedFalse(User user, String otpCode);

}
