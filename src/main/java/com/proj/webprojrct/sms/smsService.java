package com.proj.webprojrct.sms;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class smsService {

    @Value("${twilio.account_sid}")
    private String accountSid;

    @Value("${twilio.auth_token}")
    private String authToken;

    @Value("${twilio.phone_number}")
    private String fromPhone;

    public void sendSms(String to, String body) {

        Twilio.init(accountSid, authToken);
        Message message = Message.creator(
                new com.twilio.type.PhoneNumber(to),
                new com.twilio.type.PhoneNumber(fromPhone),
                body
        ).create();
        System.out.println("SMS sent: " + message.getSid());
    }

    public void sendOtp(String to, String otp) {
        String body = "Your OTP code is: " + otp;
        sendSms(to, body);
    }
}
