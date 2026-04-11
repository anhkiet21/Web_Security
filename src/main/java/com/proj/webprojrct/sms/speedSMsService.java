package com.proj.webprojrct.sms;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import org.springframework.beans.factory.annotation.Value;
import com.proj.webprojrct.sms.SpeedSMSAPI;
import org.springframework.stereotype.Service;

/**
 * @param args
 * @throws UnsupportedEncodingException
 */
@Service
public class speedSMsService {

    @Value("${speedSMS_APIKEY}")
    private String APIKEY;

    public boolean sendSMS(String phone, String content) throws IOException {
        SpeedSMSAPI api = new SpeedSMSAPI(APIKEY);

        try {
            // String userInfo = api.getUserInfo();
            // System.out.println(userInfo);
            String result = api.sendSMS(phone, content, 5, "460371d0b8416b7f");
            System.out.println(result);
            return true;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void sendOtp(String to, String otp) {
        String body = "Your OTP code is: " + otp;
        try {
            sendSMS(to, body);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
