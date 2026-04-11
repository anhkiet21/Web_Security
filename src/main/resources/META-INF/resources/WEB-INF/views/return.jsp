<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="utf-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Chính Sách Đổi Trả - CellPhoneStore</title>

            <style>
                .return-section {
                    padding: 60px 0;
                    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                    min-height: calc(100vh - 200px);
                }

                .return-header {
                    text-align: center;
                    margin-bottom: 50px;
                }

                .return-header h1 {
                    font-size: 42px;
                    font-weight: 700;
                    color: #2B2D42;
                    margin-bottom: 15px;
                    font-family: 'Montserrat', sans-serif;
                }

                .return-header p {
                    font-size: 16px;
                    color: #6c757d;
                    max-width: 700px;
                    margin: 0 auto;
                }

                .return-container {
                    max-width: 1000px;
                    margin: 0 auto;
                }

                .return-card {
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                    padding: 40px;
                    margin-bottom: 30px;
                }

                .return-card h2 {
                    font-size: 28px;
                    font-weight: 700;
                    color: #D10024;
                    margin-bottom: 25px;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }

                .return-card h2 i {
                    font-size: 32px;
                }

                .return-card h3 {
                    font-size: 22px;
                    font-weight: 600;
                    color: #2B2D42;
                    margin: 25px 0 15px;
                }

                .return-card p {
                    font-size: 15px;
                    line-height: 1.8;
                    color: #495057;
                    margin-bottom: 15px;
                }

                .return-card ul {
                    margin: 15px 0;
                    padding-left: 25px;
                }

                .return-card ul li {
                    font-size: 15px;
                    line-height: 1.8;
                    color: #495057;
                    margin-bottom: 10px;
                }

                .return-card strong {
                    color: #D10024;
                    font-weight: 600;
                }

                .return-highlight {
                    background: linear-gradient(135deg, #FFF5F5 0%, #FFE8E8 100%);
                    border-left: 4px solid #D10024;
                    padding: 20px 25px;
                    border-radius: 8px;
                    margin: 20px 0;
                }

                .return-highlight p {
                    margin-bottom: 0;
                }

                .return-steps {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 20px;
                    margin: 25px 0;
                }

                .return-step {
                    background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
                    padding: 25px;
                    border-radius: 8px;
                    border: 2px solid #e9ecef;
                    text-align: center;
                    transition: all 0.3s ease;
                }

                .return-step:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 6px 20px rgba(209, 0, 36, 0.15);
                    border-color: #D10024;
                }

                .return-step-number {
                    width: 50px;
                    height: 50px;
                    background: linear-gradient(135deg, #D10024 0%, #A00018 100%);
                    color: white;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 24px;
                    font-weight: 700;
                    margin: 0 auto 15px;
                }

                .return-step h4 {
                    font-size: 18px;
                    font-weight: 600;
                    color: #2B2D42;
                    margin-bottom: 10px;
                }

                .return-step p {
                    font-size: 14px;
                    color: #6c757d;
                    margin-bottom: 0;
                }

                .return-table {
                    width: 100%;
                    border-collapse: collapse;
                    margin: 20px 0;
                }

                .return-table th,
                .return-table td {
                    padding: 15px;
                    text-align: left;
                    border-bottom: 1px solid #e9ecef;
                }

                .return-table th {
                    background: linear-gradient(135deg, #D10024 0%, #A00018 100%);
                    color: white;
                    font-weight: 600;
                    font-size: 16px;
                }

                .return-table tr:hover {
                    background: #f8f9fa;
                }

                .return-table td {
                    font-size: 15px;
                    color: #495057;
                }

                .return-table .check-icon {
                    color: #28a745;
                    font-size: 18px;
                }

                .return-table .times-icon {
                    color: #dc3545;
                    font-size: 18px;
                }

                .return-contact {
                    background: linear-gradient(135deg, #D10024 0%, #A00018 100%);
                    color: white;
                    padding: 40px;
                    border-radius: 12px;
                    text-align: center;
                }

                .return-contact h3 {
                    font-size: 28px;
                    font-weight: 700;
                    margin-bottom: 20px;
                    color: white;
                }

                .return-contact p {
                    font-size: 16px;
                    margin-bottom: 25px;
                    opacity: 0.95;
                    color: white;
                }

                .return-contact-info {
                    display: flex;
                    justify-content: center;
                    gap: 40px;
                    flex-wrap: wrap;
                    margin-bottom: 25px;
                }

                .return-contact-item {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    font-size: 16px;
                }

                .return-contact-item i {
                    font-size: 24px;
                }

                .return-contact .btn {
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
                    margin: 5px;
                }

                .return-contact .btn:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
                }

                @media (max-width: 768px) {
                    .return-section {
                        padding: 40px 0;
                    }

                    .return-header h1 {
                        font-size: 32px;
                    }

                    .return-card {
                        padding: 25px;
                    }

                    .return-card h2 {
                        font-size: 24px;
                    }

                    .return-steps {
                        grid-template-columns: 1fr;
                    }

                    .return-contact-info {
                        flex-direction: column;
                        gap: 20px;
                    }
                }
            </style>
        </head>

        <body>
            <!-- RETURN SECTION -->
            <div class="return-section">
                <div class="container">
                    <div class="return-header">
                        <h1>Chính Sách Đổi Trả Hàng</h1>
                        <p>CellPhoneStore cam kết mang đến trải nghiệm mua sắm tốt nhất với chính sách đổi trả linh hoạt
                            và
                            minh bạch</p>
                    </div>

                    <div class="return-container">
                        <!-- Thời gian đổi trả -->
                        <div class="return-card">
                            <h2>
                                <i class="fa fa-clock-o"></i>
                                Thời Gian Đổi Trả
                            </h2>
                            <p>Chúng tôi chấp nhận đổi trả sản phẩm trong các khung thời gian sau:</p>

                            <table class="return-table">
                                <thead>
                                    <tr>
                                        <th>Tình trạng sản phẩm</th>
                                        <th>Thời gian đổi trả</th>
                                        <th>Phí đổi trả</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><strong>Nguyên seal, chưa kích hoạt</strong></td>
                                        <td>7 ngày</td>
                                        <td>Miễn phí</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Lỗi kỹ thuật từ NSX</strong></td>
                                        <td>30 ngày</td>
                                        <td>Miễn phí</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Đổi ý (đã kích hoạt)</strong></td>
                                        <td>3 ngày</td>
                                        <td>Phí 10% giá trị SP</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Sai model/màu sắc</strong></td>
                                        <td>15 ngày</td>
                                        <td>Miễn phí</td>
                                    </tr>
                                </tbody>
                            </table>

                            <div class="return-highlight">
                                <p><i class="fa fa-info-circle"></i> <strong>Lưu ý:</strong> Thời gian đổi trả được tính
                                    từ
                                    ngày mua hàng ghi trên hóa đơn VAT.</p>
                            </div>
                        </div>

                        <!-- Điều kiện đổi trả -->
                        <div class="return-card">
                            <h2>
                                <i class="fa fa-check-square-o"></i>
                                Điều Kiện Đổi Trả
                            </h2>
                            <p>Sản phẩm được chấp nhận đổi trả khi đáp ứng các điều kiện sau:</p>

                            <h3>✓ Được chấp nhận đổi trả:</h3>
                            <ul>
                                <li>Sản phẩm còn trong thời gian đổi trả quy định</li>
                                <li>Có đầy đủ hóa đơn VAT, phiếu bảo hành chính hãng</li>
                                <li>Sản phẩm còn nguyên vẹn, không có dấu hiệu sử dụng (đối với đổi trả nguyên seal)
                                </li>
                                <li>Đầy đủ hộp, phụ kiện, tài liệu kèm theo</li>
                                <li>Không có dấu hiệu rơi vỡ, va đập, ngấm nước</li>
                                <li>IMEI trên máy khớp với hóa đơn và hộp</li>
                            </ul>

                            <h3>✗ Không được chấp nhận đổi trả:</h3>
                            <ul>
                                <li><strong>Hết thời gian:</strong> Quá thời gian đổi trả quy định</li>
                                <li><strong>Hư hỏng do người dùng:</strong> Rơi vỡ, ngấm nước, trầy xước nặng</li>
                                <li><strong>Thiếu phụ kiện:</strong> Không đủ hộp, sạc, cáp, tai nghe...</li>
                                <li><strong>Không có hóa đơn:</strong> Không cung cấp được hóa đơn mua hàng</li>
                                <li><strong>Sản phẩm đã sửa chữa:</strong> Đã tháo mở, sửa chữa tại nơi không chính hãng
                                </li>
                                <li><strong>Hàng khuyến mãi đặc biệt:</strong> Một số chương trình có điều kiện riêng
                                </li>
                            </ul>
                        </div>

                        <!-- Quy trình đổi trả -->
                        <div class="return-card">
                            <h2>
                                <i class="fa fa-refresh"></i>
                                Quy Trình Đổi Trả
                            </h2>
                            <p>Để đổi trả sản phẩm, bạn cần liên hệ với Admin để được hỗ trợ:</p>

                            <div class="return-steps">
                                <div class="return-step">
                                    <div class="return-step-number">1</div>
                                    <h4>Liên hệ Admin</h4>
                                    <p>Liên hệ qua chat, hotline hoặc email để thông báo yêu cầu đổi trả</p>
                                </div>
                                <div class="return-step">
                                    <div class="return-step-number">2</div>
                                    <h4>Cung cấp thông tin</h4>
                                    <p>Gửi thông tin đơn hàng, lý do đổi trả và hình ảnh sản phẩm</p>
                                </div>
                                <div class="return-step">
                                    <div class="return-step-number">3</div>
                                    <h4>Chờ xác nhận</h4>
                                    <p>Admin kiểm tra và xác nhận yêu cầu đổi trả của bạn</p>
                                </div>
                                <div class="return-step">
                                    <div class="return-step-number">4</div>
                                    <h4>Gửi sản phẩm</h4>
                                    <p>Đóng gói sản phẩm và gửi về theo hướng dẫn của Admin</p>
                                </div>
                                <div class="return-step">
                                    <div class="return-step-number">5</div>
                                    <h4>Kiểm tra & xử lý</h4>
                                    <p>Admin kiểm tra sản phẩm và tiến hành đổi mới hoặc hoàn tiền</p>
                                </div>
                            </div>

                            <div class="return-highlight">
                                <p><i class="fa fa-clock-o"></i> <strong>Thời gian xử lý:</strong> 3-5 ngày làm việc kể
                                    từ
                                    khi nhận được sản phẩm trả lại.</p>
                            </div>
                        </div>

                        <!-- Hình thức đổi trả -->
                        <div class="return-card">
                            <h2>
                                <i class="fa fa-exchange"></i>
                                Hình Thức Đổi Trả
                            </h2>

                            <h3>1. Đổi sang sản phẩm khác</h3>
                            <ul>
                                <li>Đổi sang model khác cùng giá trị hoặc cao hơn</li>
                                <li>Nếu sản phẩm mới có giá cao hơn, khách hàng bù thêm tiền chênh lệch</li>
                                <li>Nếu sản phẩm mới có giá thấp hơn, hoàn lại tiền chênh lệch</li>
                            </ul>

                            <h3>2. Hoàn tiền</h3>
                            <ul>
                                <li><strong>Hoàn tiền 100%:</strong> Đối với sản phẩm lỗi kỹ thuật, sai model/màu sắc
                                </li>
                                <li><strong>Hoàn tiền 90%:</strong> Đối với trường hợp đổi ý (đã kích hoạt sản phẩm)
                                </li>
                                <li>Thời gian hoàn tiền: 7-10 ngày làm việc</li>
                                <li>Hình thức: Chuyển khoản ngân hàng hoặc hoàn tiền mặt</li>
                            </ul>

                            <h3>3. Đổi sang voucher</h3>
                            <ul>
                                <li>Nhận voucher trị giá 105% giá trị sản phẩm (thêm 5% ưu đãi)</li>
                                <li>Voucher có thời hạn sử dụng 6 tháng</li>
                                <li>Áp dụng cho tất cả sản phẩm tại cửa hàng</li>
                            </ul>

                            <div class="return-highlight">
                                <p><i class="fa fa-gift"></i> <strong>Ưu đãi:</strong> Chọn đổi sang voucher để được
                                    thêm 5%
                                    giá trị và ưu tiên hỗ trợ trong các lần mua hàng tiếp theo!</p>
                            </div>
                        </div>

                        <!-- Chính sách vận chuyển -->
                        <div class="return-card">
                            <h2>
                                <i class="fa fa-truck"></i>
                                Vận Chuyển Khi Đổi Trả
                            </h2>

                            <h3>Phí vận chuyển:</h3>
                            <ul>
                                <li><strong>Miễn phí vận chuyển:</strong> Đối với sản phẩm lỗi kỹ thuật, sai model/màu
                                    sắc
                                </li>
                                <li><strong>Khách hàng chịu phí:</strong> Đối với trường hợp đổi ý (khoảng 30.000đ -
                                    50.000đ)</li>
                                <li><strong>Hỗ trợ 50% phí ship:</strong> Đối với khách hàng VIP (mua từ 3 đơn hàng trở
                                    lên)
                                </li>
                            </ul>

                            <h3>Cách thức gửi hàng:</h3>
                            <ul>
                                <li>Đóng gói cẩn thận sản phẩm cùng đầy đủ phụ kiện</li>
                                <li>Gửi qua đơn vị vận chuyển (GHN, J&T Express, Viettel Post...)</li>
                                <li>Ghi rõ "Hàng dễ vỡ - Xin nhẹ tay" trên bao bì</li>
                                <li>Chụp ảnh sản phẩm trước khi gửi để làm bằng chứng</li>
                            </ul>
                        </div>

                        <!-- Liên hệ Admin -->
                        <div class="return-contact">
                            <h3>Cần Đổi Trả Sản Phẩm?</h3>
                            <p>Vui lòng liên hệ với Admin để được hỗ trợ nhanh chóng và chuyên nghiệp</p>

                            <div class="return-contact-info">
                                <div class="return-contact-item">
                                    <i class="fa fa-phone"></i>
                                    <span>0889-251-007</span>
                                </div>
                                <div class="return-contact-item">
                                    <i class="fa fa-envelope"></i>
                                    <span>kietccc21@gmail.com</span>
                                </div>
                                <div class="return-contact-item">
                                    <i class="fa fa-comments"></i>
                                    <span>Chat trực tuyến 24/7</span>
                                </div>
                            </div>

                            <a href="${pageContext.request.contextPath}/user/chat" class="btn">
                                <i class="fa fa-comments"></i>
                                Liên hệ Admin ngay
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /RETURN SECTION -->
        </body>

        </html>