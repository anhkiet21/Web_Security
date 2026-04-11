package com.proj.webprojrct.user.dto.response;

import com.proj.webprojrct.user.entity.UserRole;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class UserAdminResponse {

    private long id;
    private String phone;
    private String fullname;
    private String email;
    private String address;
    private String avatarUrl;
    private UserRole role;
    private boolean isActive;
    
    // Thêm getter thủ công vì JSP EL cần getIsActive() không phải isActive()
    public boolean getIsActive() {
        return isActive;
    }
    
    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
}
