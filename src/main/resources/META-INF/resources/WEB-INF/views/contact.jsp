<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="utf-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Liên Hệ - CellPhoneStore</title>

            <style>
                .contact-section {
                    padding: 60px 0;
                    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                    min-height: calc(100vh - 200px);
                }

                .contact-header {
                    text-align: center;
                    margin-bottom: 50px;
                }

                .contact-header h1 {
                    font-size: 42px;
                    font-weight: 700;
                    color: #2B2D42;
                    margin-bottom: 15px;
                    font-family: 'Montserrat', sans-serif;
                }

                .contact-header p {
                    font-size: 16px;
                    color: #6c757d;
                    max-width: 700px;
                    margin: 0 auto;
                }

                .contact-container {
                    max-width: 1200px;
                    margin: 0 auto;
                }

                .contact-row {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 30px;
                    margin-bottom: 30px;
                }

                .contact-card {
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                    padding: 40px;
                }

                .contact-card h2 {
                    font-size: 28px;
                    font-weight: 700;
                    color: #D10024;
                    margin-bottom: 25px;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }

                .contact-card h2 i {
                    font-size: 32px;
                }

                .contact-info-item {
                    display: flex;
                    align-items: flex-start;
                    gap: 15px;
                    margin-bottom: 25px;
                    padding: 20px;
                    background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
                    border-radius: 8px;
                    border: 2px solid #e9ecef;
                    transition: all 0.3s ease;
                }

                .contact-info-item:hover {
                    border-color: #D10024;
                    box-shadow: 0 4px 12px rgba(209, 0, 36, 0.1);
                }

                .contact-info-item:last-child {
                    margin-bottom: 0;
                }

                .contact-info-icon {
                    width: 50px;
                    height: 50px;
                    background: linear-gradient(135deg, #D10024 0%, #A00018 100%);
                    color: white;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 24px;
                    flex-shrink: 0;
                }

                .contact-info-content h3 {
                    font-size: 18px;
                    font-weight: 600;
                    color: #2B2D42;
                    margin-bottom: 8px;
                }

                .contact-info-content p {
                    font-size: 15px;
                    color: #6c757d;
                    margin-bottom: 0;
                    line-height: 1.6;
                }

                .contact-info-content a {
                    color: #D10024;
                    text-decoration: none;
                    font-weight: 600;
                }

                .contact-info-content a:hover {
                    text-decoration: underline;
                }

                .contact-map {
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                    padding: 40px;
                    margin-bottom: 30px;
                }

                .contact-map h2 {
                    font-size: 28px;
                    font-weight: 700;
                    color: #D10024;
                    margin-bottom: 25px;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }

                .contact-map h2 i {
                    font-size: 32px;
                }

                .map-container {
                    width: 100%;
                    height: 400px;
                    border-radius: 8px;
                    overflow: hidden;
                    border: 2px solid #e9ecef;
                }

                .map-container iframe {
                    width: 100%;
                    height: 100%;
                    border: none;
                }

                .contact-social {
                    background: linear-gradient(135deg, #D10024 0%, #A00018 100%);
                    color: white;
                    padding: 40px;
                    border-radius: 12px;
                    text-align: center;
                }

                .contact-social h3 {
                    font-size: 28px;
                    font-weight: 700;
                    margin-bottom: 20px;
                    color: white;
                }

                .contact-social p {
                    font-size: 16px;
                    margin-bottom: 25px;
                    opacity: 0.95;
                    color: white;
                }

                .social-links {
                    display: flex;
                    justify-content: center;
                    gap: 20px;
                    flex-wrap: wrap;
                }

                .social-link {
                    width: 60px;
                    height: 60px;
                    background: white;
                    color: #D10024;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 28px;
                    text-decoration: none;
                    transition: all 0.3s ease;
                }

                .social-link:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
                }

                .contact-hours {
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                    padding: 40px;
                }

                .contact-hours h2 {
                    font-size: 28px;
                    font-weight: 700;
                    color: #D10024;
                    margin-bottom: 25px;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }

                .contact-hours h2 i {
                    font-size: 32px;
                }

                .hours-item {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 15px 20px;
                    margin-bottom: 10px;
                    background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
                    border-radius: 8px;
                    border: 2px solid #e9ecef;
                }

                .hours-item:last-child {
                    margin-bottom: 0;
                }

                .hours-day {
                    font-size: 16px;
                    font-weight: 600;
                    color: #2B2D42;
                }

                .hours-time {
                    font-size: 16px;
                    color: #D10024;
                    font-weight: 600;
                }

                @media (max-width: 768px) {
                    .contact-section {
                        padding: 40px 0;
                    }

                    .contact-header h1 {
                        font-size: 32px;
                    }

                    .contact-row {
                        grid-template-columns: 1fr;
                    }

                    .contact-card,
                    .contact-map,
                    .contact-hours {
                        padding: 25px;
                    }

                    .map-container {
                        height: 300px;
                    }
                }
            </style>
        </head>

        <body>
            <!-- CONTACT SECTION -->
            <div class="contact-section">
                <div class="container">
                    <div class="contact-header">
                        <h1>Liên Hệ Với Chúng Tôi</h1>
                        <p>Hãy để lại thông tin hoặc liên hệ trực tiếp với chúng tôi. Đội ngũ CellPhoneStore luôn sẵn
                            sàng
                            hỗ trợ bạn!</p>
                    </div>

                    <div class="contact-container">
                        <!-- Thông tin liên hệ -->
                        <div class="contact-card" style="max-width: 800px; margin: 0 auto 30px;">
                            <h2>
                                <i class="fa fa-info-circle"></i>
                                Thông Tin Liên Hệ
                            </h2>

                            <div class="contact-info-item">
                                <div class="contact-info-icon">
                                    <i class="fa fa-map-marker"></i>
                                </div>
                                <div class="contact-info-content">
                                    <h3>Địa chỉ</h3>
                                    <p>Trường ĐH Sư Phạm Kỹ Thuật<br>
                                        1 Võ Văn Ngân, Linh Chiểu, Thủ Đức, TP.HCM</p>
                                </div>
                            </div>

                            <div class="contact-info-item">
                                <div class="contact-info-icon">
                                    <i class="fa fa-phone"></i>
                                </div>
                                <div class="contact-info-content">
                                    <h3>Hotline</h3>
                                    <p><a href="tel:0889251007">0889-251-007</a><br>
                                        Hỗ trợ 24/7 - Miễn phí cuộc gọi</p>
                                </div>
                            </div>

                            <div class="contact-info-item">
                                <div class="contact-info-icon">
                                    <i class="fa fa-envelope"></i>
                                </div>
                                <div class="contact-info-content">
                                    <h3>Email</h3>
                                    <p><a href="mailto:kietccc21@gmail.com">kietccc21@gmail.com</a><br>
                                        Phản hồi trong 24 giờ</p>
                                </div>
                            </div>

                            <div class="contact-info-item">
                                <div class="contact-info-icon">
                                    <i class="fa fa-comments"></i>
                                </div>
                                <div class="contact-info-content">
                                    <h3>Chat trực tuyến</h3>
                                    <p><a href="${pageContext.request.contextPath}/user/chat">Nhắn tin ngay</a><br>
                                        Hỗ trợ trực tuyến 24/7</p>
                                </div>
                            </div>
                        </div>

                        <!-- Giờ làm việc và Mạng xã hội -->
                        <div class="contact-row">
                            <!-- Giờ làm việc -->
                            <div class="contact-hours">
                                <h2>
                                    <i class="fa fa-clock-o"></i>
                                    Giờ Làm Việc
                                </h2>

                                <div class="hours-item">
                                    <span class="hours-day">Thứ 2 - Thứ 6</span>
                                    <span class="hours-time">8:00 - 20:00</span>
                                </div>
                                <div class="hours-item">
                                    <span class="hours-day">Thứ 7</span>
                                    <span class="hours-time">8:00 - 18:00</span>
                                </div>
                                <div class="hours-item">
                                    <span class="hours-day">Chủ nhật</span>
                                    <span class="hours-time">9:00 - 17:00</span>
                                </div>
                                <div class="hours-item">
                                    <span class="hours-day">Ngày lễ, Tết</span>
                                    <span class="hours-time">9:00 - 15:00</span>
                                </div>
                            </div>

                            <!-- Mạng xã hội -->
                            <div class="contact-social">
                                <h3>Kết Nối Với Chúng Tôi</h3>
                                <p>Theo dõi chúng tôi trên các nền tảng mạng xã hội để cập nhật thông tin mới nhất</p>

                                <div class="social-links">
                                    <a href="https://facebook.com" target="_blank" class="social-link" title="Facebook">
                                        <i class="fa fa-facebook"></i>
                                    </a>
                                    <a href="https://zalo.me/0889251007" target="_blank" class="social-link"
                                        title="Zalo">
                                        <i class="fa fa-comment"></i>
                                    </a>
                                    <a href="https://instagram.com" target="_blank" class="social-link"
                                        title="Instagram">
                                        <i class="fa fa-instagram"></i>
                                    </a>
                                    <a href="https://youtube.com" target="_blank" class="social-link" title="YouTube">
                                        <i class="fa fa-youtube-play"></i>
                                    </a>
                                    <a href="mailto:kietccc21@gmail.com" class="social-link" title="Email">
                                        <i class="fa fa-envelope"></i>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Bản đồ -->
                        <div class="contact-map">
                            <h2>
                                <i class="fa fa-map"></i>
                                Vị Trí Của Chúng Tôi
                            </h2>
                            <div class="map-container">
                                <iframe
                                    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3918.4544374621546!2d106.76933337480602!3d10.850632889302971!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31752763f23816ab%3A0x282f711441b6916f!2zVHLGsOG7nW5nIMSQ4bqhaSBo4buNYyBTxrAgcGjhuqFtIEvhu7kgdGh14bqtdCBUaMOgbmggcGjhu5EgSOG7kyBDaMOtIE1pbmg!5e0!3m2!1svi!2s!4v1698318234567!5m2!1svi!2s"
                                    allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade">
                                </iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /CONTACT SECTION -->
        </body>

        </html>