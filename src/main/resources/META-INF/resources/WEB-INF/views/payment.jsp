<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="utf-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Phương Thức Thanh Toán - CellPhoneStore</title>

            <style>
                .payment-section {
                    padding: 60px 0;
                    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                    min-height: calc(100vh - 200px);
                }

                .payment-header {
                    text-align: center;
                    margin-bottom: 50px;
                }

                .payment-header h1 {
                    font-size: 42px;
                    font-weight: 700;
                    color: #2B2D42;
                    margin-bottom: 15px;
                    font-family: 'Montserrat', sans-serif;
                }

                .payment-header p {
                    font-size: 16px;
                    color: #6c757d;
                    max-width: 700px;
                    margin: 0 auto;
                }

                .payment-container {
                    max-width: 1000px;
                    margin: 0 auto;
                }

                .payment-card {
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                    padding: 40px;
                    margin-bottom: 30px;
                }

                .payment-card h2 {
                    font-size: 28px;
                    font-weight: 700;
                    color: #D10024;
                    margin-bottom: 25px;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }

                .payment-card h2 i {
                    font-size: 32px;
                }

                .payment-card h3 {
                    font-size: 22px;
                    font-weight: 600;
                    color: #2B2D42;
                    margin: 25px 0 15px;
                }

                .payment-card p {
                    font-size: 15px;
                    line-height: 1.8;
                    color: #495057;
                    margin-bottom: 15px;
                }

                .payment-card ul {
                    margin: 15px 0;
                    padding-left: 25px;
                }

                .payment-card ul li {
                    font-size: 15px;
                    line-height: 1.8;
                    color: #495057;
                    margin-bottom: 10px;
                }

                .payment-card strong {
                    color: #D10024;
                    font-weight: 600;
                }

                .payment-highlight {
                    background: linear-gradient(135deg, #FFF5F5 0%, #FFE8E8 100%);
                    border-left: 4px solid #D10024;
                    padding: 20px 25px;
                    border-radius: 8px;
                    margin: 20px 0;
                }

                .payment-highlight p {
                    margin-bottom: 0;
                }

                .payment-methods {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                    gap: 20px;
                    margin: 25px 0;
                }

                .payment-method {
                    background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
                    padding: 30px;
                    border-radius: 12px;
                    border: 2px solid #e9ecef;
                    text-align: center;
                    transition: all 0.3s ease;
                }

                .payment-method:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 6px 20px rgba(209, 0, 36, 0.15);
                    border-color: #D10024;
                }

                .payment-method-icon {
                    width: 70px;
                    height: 70px;
                    background: linear-gradient(135deg, #D10024 0%, #A00018 100%);
                    color: white;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 32px;
                    margin: 0 auto 20px;
                }

                .payment-method h4 {
                    font-size: 20px;
                    font-weight: 600;
                    color: #2B2D42;
                    margin-bottom: 12px;
                }

                .payment-method p {
                    font-size: 14px;
                    color: #6c757d;
                    margin-bottom: 0;
                }

                .payment-steps {
                    counter-reset: step-counter;
                    margin: 25px 0;
                }

                .payment-step {
                    background: #fff;
                    padding: 25px;
                    margin-bottom: 20px;
                    border-radius: 8px;
                    border: 2px solid #e9ecef;
                    position: relative;
                    padding-left: 80px;
                    transition: all 0.3s ease;
                }

                .payment-step:hover {
                    border-color: #D10024;
                    box-shadow: 0 4px 12px rgba(209, 0, 36, 0.1);
                }

                .payment-step::before {
                    counter-increment: step-counter;
                    content: counter(step-counter);
                    position: absolute;
                    left: 25px;
                    top: 50%;
                    transform: translateY(-50%);
                    width: 40px;
                    height: 40px;
                    background: linear-gradient(135deg, #D10024 0%, #A00018 100%);
                    color: white;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 20px;
                    font-weight: 700;
                }

                .payment-step h4 {
                    font-size: 18px;
                    font-weight: 600;
                    color: #2B2D42;
                    margin-bottom: 10px;
                }

                .payment-step p {
                    font-size: 15px;
                    color: #6c757d;
                    margin-bottom: 0;
                }

                .payment-info-box {
                    background: linear-gradient(135deg, #2B2D42 0%, #1a1b2e 100%);
                    color: white;
                    padding: 25px;
                    border-radius: 8px;
                    margin: 20px 0;
                }

                .payment-info-box h4 {
                    font-size: 18px;
                    font-weight: 600;
                    margin-bottom: 15px;
                    color: #D10024;
                }

                .payment-info-row {
                    display: flex;
                    justify-content: space-between;
                    padding: 10px 0;
                    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                }

                .payment-info-row:last-child {
                    border-bottom: none;
                }

                .payment-info-label {
                    font-weight: 600;
                }

                .payment-info-value {
                    text-align: right;
                    font-family: monospace;
                }

                .payment-warning {
                    background: #fff3cd;
                    border-left: 4px solid #ffc107;
                    padding: 20px 25px;
                    border-radius: 8px;
                    margin: 20px 0;
                }

                .payment-warning p {
                    color: #856404;
                    margin-bottom: 0;
                }

                .payment-warning i {
                    color: #ffc107;
                    margin-right: 8px;
                }

                .payment-contact {
                    background: linear-gradient(135deg, #D10024 0%, #A00018 100%);
                    color: white;
                    padding: 40px;
                    border-radius: 12px;
                    text-align: center;
                }

                .payment-contact h3 {
                    font-size: 28px;
                    font-weight: 700;
                    margin-bottom: 20px;
                    color: white;
                }

                .payment-contact p {
                    font-size: 16px;
                    margin-bottom: 25px;
                    opacity: 0.95;
                    color: white;
                }

                .payment-contact .btn {
                    background: white;
                    color: #D10024;
                    padding: 12px 30px;
                    border-radius: 6px;
                    font-weight: 600;
                    text-decoration: none;
                    display: inline-flex;
                    align-items: center;
                    gap: 10px;
                    transition: all 0.3s ease;
                }

                .payment-contact .btn:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
                }

                @media (max-width: 768px) {
                    .payment-section {
                        padding: 40px 0;
                    }

                    .payment-header h1 {
                        font-size: 32px;
                    }

                    .payment-card {
                        padding: 25px;
                    }

                    .payment-card h2 {
                        font-size: 24px;
                    }

                    .payment-methods {
                        grid-template-columns: 1fr;
                    }

                    .payment-step {
                        padding-left: 25px;
                        padding-top: 60px;
                    }

                    .payment-step::before {
                        left: 50%;
                        top: 20px;
                        transform: translateX(-50%);
                    }
                }
            </style>
        </head>

        <body>
            <!-- PAYMENT GUIDE SECTION -->
            <div class="payment-section">
                <div class="container">
                    <div class="payment-header">
                        <h1>Hướng Dẫn Thanh Toán</h1>
                        <p>Hướng dẫn chi tiết các phương thức thanh toán và quy trình đặt hàng tại CellPhoneStore</p>
                    </div>

                    <div class="payment-container">
                        <!-- Các phương thức thanh toán -->
                        <div class="payment-card">
                            <h2>
                                <i class="fa fa-credit-card"></i>
                                Các Phương Thức Thanh Toán
                            </h2>
                            <p>Chúng tôi hỗ trợ 2 phương thức thanh toán tiện lợi:</p>

                            <div class="payment-methods">
                                <div class="payment-method">
                                    <div class="payment-method-icon">
                                        <i class="fa fa-money"></i>
                                    </div>
                                    <h4>Thanh toán COD</h4>
                                    <p>Thanh toán khi nhận hàng. Tiện lợi, an toàn, kiểm tra hàng trước khi trả tiền.
                                    </p>
                                </div>

                                <div class="payment-method">
                                    <div class="payment-method-icon">
                                        <i class="fa fa-credit-card"></i>
                                    </div>
                                    <h4>VNPay</h4>
                                    <p>Thanh toán trực tuyến qua cổng VNPay. Hỗ trợ thẻ ATM, Visa, MasterCard và ví điện
                                        tử.
                                    </p>
                                </div>
                            </div>

                            <div class="payment-highlight">
                                <p><i class="fa fa-check-circle"></i> <strong>Tất cả giao dịch đều được mã hóa
                                        SSL</strong>
                                    đảm bảo an toàn thông tin tài khoản và thẻ của bạn.</p>
                            </div>
                        </div>

                        <!-- Hướng dẫn thanh toán COD -->
                        <div class="payment-card">
                            <h2>
                                <i class="fa fa-money"></i>
                                Thanh Toán Khi Nhận Hàng (COD)
                            </h2>
                            <p>Phương thức phổ biến nhất, phù hợp cho mọi khách hàng:</p>

                            <div class="payment-steps">
                                <div class="payment-step">
                                    <h4>Đặt hàng trên website</h4>
                                    <p>Chọn sản phẩm, thêm vào giỏ hàng và tiến hành thanh toán. Chọn phương thức "Thanh
                                        toán khi nhận hàng".</p>
                                </div>
                                <div class="payment-step">
                                    <h4>Xác nhận đơn hàng</h4>
                                    <p>Nhận email/SMS xác nhận đơn hàng với thông tin chi tiết về sản phẩm và thời gian
                                        giao
                                        hàng dự kiến.</p>
                                </div>
                                <div class="payment-step">
                                    <h4>Nhận hàng và kiểm tra</h4>
                                    <p>Nhân viên giao hàng sẽ liên hệ trước 30 phút. Kiểm tra kỹ sản phẩm trước khi
                                        thanh
                                        toán.</p>
                                </div>
                                <div class="payment-step">
                                    <h4>Thanh toán bằng tiền mặt</h4>
                                    <p>Trả tiền cho nhân viên giao hàng và nhận hóa đơn VAT đầy đủ.</p>
                                </div>
                            </div>

                            <div class="payment-highlight">
                                <p><i class="fa fa-gift"></i> <strong>Ưu đãi:</strong> Đơn hàng COD trên 5 triệu đồng
                                    được
                                    miễn phí vận chuyển toàn quốc!</p>
                            </div>
                        </div>

                        <!-- Hướng dẫn thanh toán VNPay -->
                        <div class="payment-card">
                            <h2>
                                <i class="fa fa-credit-card"></i>
                                Thanh Toán Qua VNPay
                            </h2>
                            <p>Thanh toán trực tuyến an toàn, nhanh chóng qua cổng thanh toán VNPay:</p>

                            <div class="payment-steps">
                                <div class="payment-step">
                                    <h4>Chọn phương thức thanh toán VNPay</h4>
                                    <p>Tại trang thanh toán, chọn "Thanh toán qua VNPay".</p>
                                </div>
                                <div class="payment-step">
                                    <h4>Chọn hình thức thanh toán</h4>
                                    <p>Chọn thanh toán bằng: Thẻ ATM nội địa, Thẻ tín dụng/ghi nợ quốc tế (Visa,
                                        MasterCard), hoặc Ví điện tử (MoMo, ZaloPay).</p>
                                </div>
                                <div class="payment-step">
                                    <h4>Nhập thông tin thanh toán</h4>
                                    <p>Điền thông tin thẻ hoặc đăng nhập ví điện tử theo hướng dẫn trên trang VNPay.</p>
                                </div>
                                <div class="payment-step">
                                    <h4>Xác thực OTP</h4>
                                    <p>Nhập mã OTP được gửi về số điện thoại để xác nhận giao dịch.</p>
                                </div>
                                <div class="payment-step">
                                    <h4>Hoàn tất thanh toán</h4>
                                    <p>Sau khi xác thực thành công, đơn hàng sẽ được xử lý và giao ngay.</p>
                                </div>
                            </div>

                            <div class="payment-highlight">
                                <p><i class="fa fa-shield"></i> <strong>Bảo mật:</strong> VNPay sử dụng chuẩn bảo mật
                                    PCI-DSS quốc tế. Thông tin thẻ được mã hóa SSL và không lưu trữ trên hệ thống.</p>
                            </div>

                            <h3>Phương thức thanh toán qua VNPay:</h3>
                            <ul>
                                <li><strong>Thẻ ATM nội địa:</strong> Tất cả các ngân hàng Việt Nam hỗ trợ Internet
                                    Banking
                                </li>
                                <li><strong>Thẻ tín dụng/ghi nợ:</strong> Visa, MasterCard, JCB quốc tế</li>
                                <li><strong>Ví điện tử:</strong> MoMo, ZaloPay, Viettel Money</li>
                                <li><strong>VNPay QR:</strong> Quét mã QR bằng app ngân hàng</li>
                            </ul>


                        </div>

                        <!-- Câu hỏi thường gặp -->

                        <!-- Câu hỏi thường gặp -->
                        <div class="payment-card">
                            <h2>
                                <i class="fa fa-question-circle"></i>
                                Câu Hỏi Thường Gặp
                            </h2>

                            <h3>Tôi có thể hủy đơn hàng sau khi thanh toán không?</h3>
                            <p>Có, bạn có thể hủy đơn hàng trong vòng <strong>2 giờ</strong> sau khi đặt hàng. Số tiền
                                sẽ
                                được hoàn lại trong 7-10 ngày làm việc.</p>

                            <h3>Thanh toán online có an toàn không?</h3>
                            <p>Hoàn toàn an toàn. Chúng tôi sử dụng cổng thanh toán VNPay với chuẩn bảo mật PCI-DSS quốc
                                tế.
                                Thông tin thẻ được mã hóa SSL và không lưu trữ trên hệ thống.</p>

                            <h3>Tôi có được xuất hóa đơn VAT không?</h3>
                            <p>Có, tất cả đơn hàng đều được xuất hóa đơn VAT đầy đủ. Bạn có thể yêu cầu xuất hóa đơn
                                công ty
                                khi đặt hàng.</p>

                            <h3>Phí giao dịch thanh toán online là bao nhiêu?</h3>
                            <p>Miễn phí hoàn toàn! CellPhoneStore chịu toàn bộ phí giao dịch thanh toán online.</p>

                            <h3>Tôi đã chuyển khoản nhưng chưa thấy xác nhận?</h3>
                            <p>Thông thường đơn hàng sẽ được xác nhận trong vòng 30 phút. Nếu quá thời gian này, vui
                                lòng
                                liên hệ với chúng tôi qua chat hoặc hotline.</p>
                        </div>

                        <!-- Liên hệ hỗ trợ -->
                        <div class="payment-contact">
                            <h3>Cần Hỗ Trợ Thanh Toán?</h3>
                            <p>Liên hệ ngay với chúng tôi để được tư vấn và hỗ trợ thanh toán 24/7</p>

                            <a href="${pageContext.request.contextPath}/user/chat" class="btn">
                                <i class="fa fa-comments"></i>
                                Liên hệ ngay
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /PAYMENT GUIDE SECTION -->
        </body>

        </html>