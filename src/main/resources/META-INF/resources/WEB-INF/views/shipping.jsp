<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="utf-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Chính Sách Vận Chuyển - CellPhoneStore</title>

            <style>
                .shipping-section {
                    padding: 60px 0;
                    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                    min-height: calc(100vh - 200px);
                }

                .shipping-header {
                    text-align: center;
                    margin-bottom: 50px;
                }

                .shipping-header h1 {
                    font-size: 42px;
                    font-weight: 700;
                    color: #2B2D42;
                    margin-bottom: 15px;
                    font-family: 'Montserrat', sans-serif;
                }

                .shipping-header p {
                    font-size: 16px;
                    color: #6c757d;
                    max-width: 700px;
                    margin: 0 auto;
                }

                .shipping-container {
                    max-width: 1000px;
                    margin: 0 auto;
                }

                .shipping-card {
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                    padding: 40px;
                    margin-bottom: 30px;
                }

                .shipping-card h2 {
                    font-size: 28px;
                    font-weight: 700;
                    color: #D10024;
                    margin-bottom: 25px;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }

                .shipping-card h2 i {
                    font-size: 32px;
                }

                .shipping-card h3 {
                    font-size: 22px;
                    font-weight: 600;
                    color: #2B2D42;
                    margin: 25px 0 15px;
                }

                .shipping-card p {
                    font-size: 15px;
                    line-height: 1.8;
                    color: #495057;
                    margin-bottom: 15px;
                }

                .shipping-card ul {
                    margin: 15px 0;
                    padding-left: 25px;
                }

                .shipping-card ul li {
                    font-size: 15px;
                    line-height: 1.8;
                    color: #495057;
                    margin-bottom: 10px;
                }

                .shipping-card strong {
                    color: #D10024;
                    font-weight: 600;
                }

                .shipping-highlight {
                    background: linear-gradient(135deg, #FFF5F5 0%, #FFE8E8 100%);
                    border-left: 4px solid #D10024;
                    padding: 20px 25px;
                    border-radius: 8px;
                    margin: 20px 0;
                }

                .shipping-highlight p {
                    margin-bottom: 0;
                }

                .shipping-table {
                    width: 100%;
                    border-collapse: collapse;
                    margin: 20px 0;
                }

                .shipping-table th,
                .shipping-table td {
                    padding: 15px;
                    text-align: left;
                    border-bottom: 1px solid #e9ecef;
                }

                .shipping-table th {
                    background: linear-gradient(135deg, #D10024 0%, #A00018 100%);
                    color: white;
                    font-weight: 600;
                    font-size: 16px;
                }

                .shipping-table tr:hover {
                    background: #f8f9fa;
                }

                .shipping-table td {
                    font-size: 15px;
                    color: #495057;
                }

                .shipping-zones {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                    gap: 20px;
                    margin: 25px 0;
                }

                .shipping-zone {
                    background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
                    padding: 30px;
                    border-radius: 12px;
                    border: 2px solid #e9ecef;
                    text-align: center;
                    transition: all 0.3s ease;
                }

                .shipping-zone:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 6px 20px rgba(209, 0, 36, 0.15);
                    border-color: #D10024;
                }

                .shipping-zone-icon {
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

                .shipping-zone h4 {
                    font-size: 20px;
                    font-weight: 600;
                    color: #2B2D42;
                    margin-bottom: 12px;
                }

                .shipping-zone .time {
                    font-size: 18px;
                    font-weight: 700;
                    color: #D10024;
                    margin-bottom: 8px;
                }

                .shipping-zone .fee {
                    font-size: 16px;
                    color: #6c757d;
                }

                .shipping-steps {
                    counter-reset: step-counter;
                    margin: 25px 0;
                }

                .shipping-step {
                    background: #fff;
                    padding: 25px;
                    margin-bottom: 20px;
                    border-radius: 8px;
                    border: 2px solid #e9ecef;
                    position: relative;
                    padding-left: 80px;
                    transition: all 0.3s ease;
                }

                .shipping-step:hover {
                    border-color: #D10024;
                    box-shadow: 0 4px 12px rgba(209, 0, 36, 0.1);
                }

                .shipping-step::before {
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

                .shipping-step h4 {
                    font-size: 18px;
                    font-weight: 600;
                    color: #2B2D42;
                    margin-bottom: 10px;
                }

                .shipping-step p {
                    font-size: 15px;
                    color: #6c757d;
                    margin-bottom: 0;
                }

                .shipping-warning {
                    background: #fff3cd;
                    border-left: 4px solid #ffc107;
                    padding: 20px 25px;
                    border-radius: 8px;
                    margin: 20px 0;
                }

                .shipping-warning p {
                    color: #856404;
                    margin-bottom: 0;
                }

                .shipping-warning i {
                    color: #ffc107;
                    margin-right: 8px;
                }

                .shipping-contact {
                    background: linear-gradient(135deg, #D10024 0%, #A00018 100%);
                    color: white;
                    padding: 40px;
                    border-radius: 12px;
                    text-align: center;
                }

                .shipping-contact h3 {
                    font-size: 28px;
                    font-weight: 700;
                    margin-bottom: 20px;
                    color: white;
                }

                .shipping-contact p {
                    font-size: 16px;
                    margin-bottom: 25px;
                    opacity: 0.95;
                    color: white;
                }

                .shipping-contact .btn {
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

                .shipping-contact .btn:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
                }

                @media (max-width: 768px) {
                    .shipping-section {
                        padding: 40px 0;
                    }

                    .shipping-header h1 {
                        font-size: 32px;
                    }

                    .shipping-card {
                        padding: 25px;
                    }

                    .shipping-card h2 {
                        font-size: 24px;
                    }

                    .shipping-zones {
                        grid-template-columns: 1fr;
                    }

                    .shipping-step {
                        padding-left: 25px;
                        padding-top: 60px;
                    }

                    .shipping-step::before {
                        left: 50%;
                        top: 20px;
                        transform: translateX(-50%);
                    }
                }
            </style>
        </head>

        <body>
            <!-- SHIPPING SECTION -->
            <div class="shipping-section">
                <div class="container">
                    <div class="shipping-header">
                        <h1>Chính Sách Vận Chuyển</h1>
                        <p>Thông tin chi tiết về dịch vụ vận chuyển, thời gian giao hàng và phí vận chuyển tại
                            CellPhoneStore</p>
                    </div>

                    <div class="shipping-container">
                        <!-- Thời gian và khu vực giao hàng -->
                        <div class="shipping-card">
                            <h2>
                                <i class="fa fa-clock-o"></i>
                                Thời Gian Giao Hàng
                            </h2>
                            <p>Thời gian giao hàng phụ thuộc vào khu vực của bạn:</p>

                            <div class="shipping-zones">
                                <div class="shipping-zone">
                                    <div class="shipping-zone-icon">
                                        <i class="fa fa-building"></i>
                                    </div>
                                    <h4>Nội thành TP.HCM</h4>
                                    <div class="time">1-2 ngày</div>
                                    <div class="fee">Phí: 30.000đ</div>
                                </div>

                                <div class="shipping-zone">
                                    <div class="shipping-zone-icon">
                                        <i class="fa fa-map-marker"></i>
                                    </div>
                                    <h4>Các tỉnh thành khác</h4>
                                    <div class="time">3-5 ngày</div>
                                    <div class="fee">Phí: 50.000đ - 100.000đ</div>
                                </div>

                                <div class="shipping-zone">
                                    <div class="shipping-zone-icon">
                                        <i class="fa fa-globe"></i>
                                    </div>
                                    <h4>Vùng sâu, vùng xa</h4>
                                    <div class="time">5-7 ngày</div>
                                    <div class="fee">Phí: 100.000đ - 150.000đ</div>
                                </div>
                            </div>

                            <div class="shipping-highlight">
                                <p><i class="fa fa-gift"></i> <strong>Miễn phí vận chuyển</strong> cho đơn hàng từ
                                    500.000đ
                                    trở lên!</p>
                            </div>
                        </div>

                        <!-- Bảng phí vận chuyển -->
                        <div class="shipping-card">
                            <h2>
                                <i class="fa fa-money"></i>
                                Phí Vận Chuyển
                            </h2>
                            <p>Phí vận chuyển được tính theo giá trị đơn hàng và khu vực giao hàng:</p>

                            <table class="shipping-table">
                                <thead>
                                    <tr>
                                        <th>Giá trị đơn hàng</th>
                                        <th>Nội thành TP.HCM</th>
                                        <th>Các tỉnh thành</th>
                                        <th>Vùng xa</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><strong>Dưới 500.000đ</strong></td>
                                        <td>30.000đ</td>
                                        <td>50.000đ</td>
                                        <td>100.000đ</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Từ 500.000đ - 2.000.000đ</strong></td>
                                        <td><strong style="color: #28a745;">Miễn phí</strong></td>
                                        <td>30.000đ</td>
                                        <td>50.000đ</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Trên 2.000.000đ</strong></td>
                                        <td><strong style="color: #28a745;">Miễn phí</strong></td>
                                        <td><strong style="color: #28a745;">Miễn phí</strong></td>
                                        <td>30.000đ</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Trên 5.000.000đ</strong></td>
                                        <td><strong style="color: #28a745;">Miễn phí</strong></td>
                                        <td><strong style="color: #28a745;">Miễn phí</strong></td>
                                        <td><strong style="color: #28a745;">Miễn phí</strong></td>
                                    </tr>
                                </tbody>
                            </table>

                            <div class="shipping-warning">
                                <p><i class="fa fa-info-circle"></i> <strong>Lưu ý:</strong> Phí vận chuyển có thể thay
                                    đổi
                                    tùy theo chương trình khuyến mãi và điều kiện địa lý cụ thể.</p>
                            </div>
                        </div>

                        <!-- Giao hàng nhanh -->
                        <div class="shipping-card">
                            <h2>
                                <i class="fa fa-rocket"></i>
                                Dịch Vụ Giao Hàng Nhanh
                            </h2>
                            <p>Dành cho khách hàng cần nhận hàng gấp tại nội thành TP.HCM:</p>

                            <h3>Giao hàng trong 3-4 giờ</h3>
                            <ul>
                                <li><strong>Thời gian:</strong> Giao hàng trong vòng 3-4 giờ kể từ khi đặt hàng thành
                                    công
                                </li>
                                <li><strong>Khu vực:</strong> Chỉ áp dụng tại nội thành TP.HCM (quận 1-12, Thủ Đức, Bình
                                    Thạnh...)</li>
                                <li><strong>Phí dịch vụ:</strong> +50.000đ (miễn phí cho đơn hàng trên 3 triệu)</li>
                                <li><strong>Giờ phục vụ:</strong> 8:00 - 20:00 hàng ngày</li>
                            </ul>

                            <h3>Giao hàng trong ngày</h3>
                            <ul>
                                <li><strong>Thời gian:</strong> Giao hàng trước 22:00 cùng ngày (đặt trước 16:00)</li>
                                <li><strong>Phí dịch vụ:</strong> +30.000đ</li>
                            </ul>

                            <div class="shipping-highlight">
                                <p><i class="fa fa-clock-o"></i> <strong>Đặt trước 12:00</strong> để nhận hàng trong
                                    buổi
                                    chiều cùng ngày!</p>
                            </div>
                        </div>

                        <!-- Quy trình giao hàng -->
                        <div class="shipping-card">
                            <h2>
                                <i class="fa fa-truck"></i>
                                Quy Trình Giao Hàng
                            </h2>
                            <p>Quy trình giao hàng chuẩn tại CellPhoneStore:</p>

                            <div class="shipping-steps">
                                <div class="shipping-step">
                                    <h4>Xác nhận đơn hàng</h4>
                                    <p>Sau khi đặt hàng thành công, bạn sẽ nhận email/SMS xác nhận đơn hàng với thông
                                        tin
                                        chi tiết.</p>
                                </div>
                                <div class="shipping-step">
                                    <h4>Đóng gói sản phẩm</h4>
                                    <p>Sản phẩm được kiểm tra kỹ lưỡng và đóng gói cẩn thận, kèm phiếu bảo hành và hóa
                                        đơn
                                        VAT.</p>
                                </div>
                                <div class="shipping-step">
                                    <h4>Bàn giao đơn vị vận chuyển</h4>
                                    <p>Đơn hàng được chuyển cho đối tác vận chuyển uy tín (GHN, J&T Express, Viettel
                                        Post...).</p>
                                </div>

                                <div class="shipping-step">
                                    <h4>Liên hệ trước giao hàng</h4>
                                    <p>Shipper sẽ gọi điện trước 30 phút để thông báo thời gian giao hàng.</p>
                                </div>
                                <div class="shipping-step">
                                    <h4>Giao hàng và thanh toán</h4>
                                    <p>Kiểm tra sản phẩm kỹ lưỡng trước khi nhận hàng. Thanh toán (nếu chọn COD) và ký
                                        nhận.
                                    </p>
                                </div>
                            </div>
                        </div>

                        <!-- Chính sách khi giao hàng -->
                        <div class="shipping-card">
                            <h2>
                                <i class="fa fa-shield"></i>
                                Chính Sách Khi Giao Hàng
                            </h2>

                            <h3>Quyền lợi khách hàng:</h3>
                            <ul>
                                <li><strong>Kiểm tra hàng:</strong> Được kiểm tra sản phẩm trước khi thanh toán (đối với
                                    COD)</li>
                                <li><strong>Từ chối nhận:</strong> Có quyền từ chối nhận hàng nếu sản phẩm không đúng,
                                    hư
                                    hỏng hoặc không đúng mô tả</li>
                                <li><strong>Đổi hàng ngay:</strong> Đổi sản phẩm khác ngay tại thời điểm giao hàng nếu
                                    phát
                                    hiện lỗi</li>
                                <li><strong>Hỗ trợ 24/7:</strong> Liên hệ hotline để được hỗ trợ khi có vấn đề trong quá
                                    trình giao nhận</li>
                            </ul>

                            <h3>Lưu ý quan trọng:</h3>
                            <ul>
                                <li>Vui lòng cung cấp <strong>số điện thoại chính xác</strong> để shipper có thể liên hệ
                                </li>
                                <li>Kiểm tra kỹ <strong>nguyên seal, tem bảo hành</strong> trước khi ký nhận</li>
                                <li>Đếm đủ <strong>phụ kiện, tài liệu</strong> kèm theo theo danh sách</li>
                                <li>Giữ lại <strong>hóa đơn VAT và phiếu bảo hành</strong> để sử dụng dịch vụ bảo hành
                                </li>
                                <li>Nếu không nhận được hàng sau thời gian dự kiến, vui lòng liên hệ ngay với chúng tôi
                                </li>
                            </ul>

                            <div class="shipping-warning">
                                <p><i class="fa fa-exclamation-triangle"></i> <strong>Quan trọng:</strong> Sau khi ký
                                    nhận
                                    và thanh toán, bạn không thể từ chối hoặc đổi trả sản phẩm vì lý do đổi ý. Vui lòng
                                    kiểm
                                    tra kỹ trước khi nhận hàng!</p>
                            </div>
                        </div>


                        <!-- Các câu hỏi thường gặp -->
                        <div class="shipping-card">
                            <h2>
                                <i class="fa fa-question-circle"></i>
                                Câu Hỏi Thường Gặp
                            </h2>

                            <h3>Tôi có thể thay đổi địa chỉ giao hàng không?</h3>
                            <p>Có, bạn có thể thay đổi địa chỉ giao hàng trong vòng <strong>2 giờ</strong> sau khi đặt
                                hàng.
                                Vui lòng liên hệ ngay với hotline hoặc chat để được hỗ trợ.</p>

                            <h3>Shipper giao hàng mà tôi không có nhà thì sao?</h3>
                            <p>Shipper sẽ gọi lại để hẹn lịch giao hàng lần 2 (miễn phí). Nếu sau 3 lần giao không thành
                                công, đơn hàng sẽ được hoàn về kho và bạn cần liên hệ để sắp xếp lại.</p>

                            <h3>Tôi có thể chọn thời gian giao hàng không?</h3>
                            <p>Bạn có thể ghi chú thời gian mong muốn khi đặt hàng (ví dụ: giao buổi sáng, buổi
                                chiều...).
                                Chúng tôi sẽ cố gắng sắp xếp phù hợp, tuy nhiên không đảm bảo 100%.</p>

                            <h3>Sản phẩm bị hư hỏng trong quá trình vận chuyển thì sao?</h3>
                            <p>Nếu phát hiện sản phẩm hư hỏng khi nhận hàng, vui lòng <strong>chụp ảnh và từ chối nhận
                                    hàng</strong> ngay. Liên hệ với chúng tôi để được đổi sản phẩm mới hoàn toàn miễn
                                phí.
                            </p>

                            <h3>Tôi có thể hẹn giao hàng vào cuối tuần không?</h3>
                            <p>Có, chúng tôi giao hàng tất cả các ngày trong tuần, bao gồm cả thứ 7, Chủ nhật và ngày
                                lễ.
                            </p>
                        </div>

                        <!-- Liên hệ hỗ trợ -->
                        <div class="shipping-contact">
                            <h3>Cần Hỗ Trợ Vận Chuyển?</h3>
                            <p>Liên hệ ngay với chúng tôi để được tư vấn và hỗ trợ về vận chuyển 24/7</p>

                            <a href="${pageContext.request.contextPath}/user/chat" class="btn">
                                <i class="fa fa-comments"></i>
                                Liên hệ ngay
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /SHIPPING SECTION -->
        </body>

        </html>