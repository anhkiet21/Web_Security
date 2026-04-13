package com.proj.webprojrct.sms;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import org.springframework.beans.factory.annotation.Value;
import com.proj.webprojrct.sms.SpeedSMSAPI;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @param args
 * @throws UnsupportedEncodingException
 */
@Service
public class speedSMsService {

    private static final Logger log = LoggerFactory.getLogger(speedSMsService.class);

    @Value("${speedSMS_APIKEY}")
    private String APIKEY;

    public boolean sendSMS(String phone, String content) throws IOException {
        SpeedSMSAPI api = new SpeedSMSAPI(APIKEY);

        try {
            // String userInfo = api.getUserInfo();
            String result = api.sendSMS(phone, content, 5, "460371d0b8416b7f");
            return true;
        } catch (IOException e) {
            log.error("Lỗi gửi SMS qua SpeedSMS", e);
        }
        return false;
    }

    public void sendOtp(String to, String otp) {
        String body = "Your OTP code is: " + otp;
        try {
            sendSMS(to, body);
        } catch (IOException e) {
            log.error("Lỗi gửi OTP qua SpeedSMS", e);
        }
    }
}
