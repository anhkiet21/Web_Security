<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="utf-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Chính Sách Bảo Hành - CellPhoneStore</title>

            <style>
                .warranty-section {
                    padding: 60px 0;
                    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                    min-height: calc(100vh - 200px);
                }

                .warranty-header {
                    text-align: center;
                    margin-bottom: 50px;
                }

                .warranty-header h1 {
                    font-size: 42px;
                    font-weight: 700;
                    color: #2B2D42;
                    margin-bottom: 15px;
                    font-family: 'Montserrat', sans-serif;
                }

                .warranty-header p {
                    font-size: 16px;
                    color: #6c757d;
                    max-width: 700px;
                    margin: 0 auto;
                }

                .warranty-container {
                    max-width: 1000px;
                    margin: 0 auto;
                }

                .warranty-card {
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                    padding: 40px;
                    margin-bottom: 30px;
                }

                .warranty-card h2 {
                    font-size: 28px;
                    font-weight: 700;
                    color: #D10024;
                    margin-bottom: 25px;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }

                .warranty-card h2 i {
                    font-size: 32px;
                }

                .warranty-card h3 {
                    font-size: 22px;
                    font-weight: 600;
                    color: #2B2D42;
                    margin: 25px 0 15px;
                }

                .warranty-card p {
                    font-size: 15px;
                    line-height: 1.8;
                    color: #495057;
                    margin-bottom: 15px;
                }

                .warranty-card ul {
                    margin: 15px 0;
                    padding-left: 25px;
                }

                .warranty-card ul li {
                    font-size: 15px;
                    line-height: 1.8;
                    color: #495057;
                    margin-bottom: 10px;
                }

                .warranty-card strong {
                    color: #D10024;
                    font-weight: 600;
                }

                .warranty-highlight {
                    background: linear-gradient(135deg, #FFF5F5 0%, #FFE8E8 100%);
                    border-left: 4px solid #D10024;
                    padding: 20px 25px;
                    border-radius: 8px;
                    margin: 20px 0;
                }

                .warranty-highlight p {
                    margin-bottom: 0;
                }

                .warranty-steps {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                    gap: 20px;
                    margin: 25px 0;
                }

                .warranty-step {
                    background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
                    padding: 25px;
                    border-radius: 8px;
                    border: 2px solid #e9ecef;
                    text-align: center;
                    transition: all 0.3s ease;
                }

                .warranty-step:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 6px 20px rgba(209, 0, 36, 0.15);
                    border-color: #D10024;
                }

                .warranty-step-number {
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

                .warranty-step h4 {
                    font-size: 18px;
                    font-weight: 600;
                    color: #2B2D42;
                    margin-bottom: 10px;
                }

                .warranty-step p {
                    font-size: 14px;
                    color: #6c757d;
                    margin-bottom: 0;
                }

                .warranty-table {
                    width: 100%;
                    border-collapse: collapse;
                    margin: 20px 0;
                }

                .warranty-table th,
                .warranty-table td {
                    padding: 15px;
                    text-align: left;
                    border-bottom: 1px solid #e9ecef;
                }

                .warranty-table th {
                    background: linear-gradient(135deg, #D10024 0%, #A00018 100%);
                    color: white;
                    font-weight: 600;
                    font-size: 16px;
                }

                .warranty-table tr:hover {
                    background: #f8f9fa;
                }

                .warranty-table td {
                    font-size: 15px;
                    color: #495057;
                }

                .warranty-table .check-icon {
                    color: #28a745;
                    font-size: 18px;
                }

                .warranty-table .times-icon {
                    color: #dc3545;
                    font-size: 18px;
                }

                .warranty-contact {
                    background: linear-gradient(135deg, #D10024 0%, #A00018 100%);
                    color: white;
                    padding: 40px;
                    border-radius: 12px;
                    text-align: center;
                }

                .warranty-contact h3 {
                    font-size: 28px;
                    font-weight: 700;
                    margin-bottom: 20px;
                    color: white;
                }

                .warranty-contact p {
                    font-size: 16px;
                    margin-bottom: 25px;
                    opacity: 0.95;
                    color: white;
                }

                .warranty-contact-info {
                    display: flex;
                    justify-content: center;
                    gap: 40px;
                    flex-wrap: wrap;
                }

                .warranty-contact-item {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    font-size: 16px;
                }

                .warranty-contact-item i {
                    font-size: 24px;
                }

                .warranty-contact .btn {
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
                    margin-top: 10px;
                }

                .warranty-contact .btn:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
                }

                @media (max-width: 768px) {
                    .warranty-section {
                        padding: 40px 0;
                    }

                    .warranty-header h1 {
                        font-size: 32px;
                    }

                    .warranty-card {
                        padding: 25px;
                    }

                    .warranty-card h2 {
                        font-size: 24px;
                    }

                    .warranty-steps {
                        grid-template-columns: 1fr;
                    }

                    .warranty-contact-info {
                        flex-direction: column;
                        gap: 20px;
                    }
                }
            </style>
        </head>

        <body>
            <!-- WARRANTY SECTION -->
            <div class="warranty-section">
                <div class="container">
                    <div class="warranty-header">
                        <h1>Chính Sách Bảo Hành</h1>
                        <p>CellPhoneStore cam kết mang đến dịch vụ bảo hành tốt nhất, đảm bảo quyền lợi khách hàng với
                            sản
                            phẩm chính hãng 100%</p>
                    </div>

                    <div class="warranty-container">
                        <!-- Thời gian bảo hành -->
                        <div class="warranty-card">
                            <h2>
                                <i class="fa fa-clock-o"></i>
                                Thời Gian Bảo Hành
                            </h2>
                            <p>Tất cả sản phẩm điện thoại tại CellPhoneStore đều được bảo hành chính hãng với các mức
                                thời
                                gian như sau:</p>

                            <table class="warranty-table">
                                <thead>
                                    <tr>
                                        <th>Loại sản phẩm</th>
                                        <th>Thời gian bảo hành</th>
                                        <th>Đổi mới</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><strong>Điện thoại</strong></td>
                                        <td>12 tháng</td>
                                        <td><i class="fa fa-check check-icon"></i> 30 ngày</td>
                                    </tr>

                                </tbody>
                            </table>

                            <div class="warranty-highlight">
                                <p><i class="fa fa-info-circle"></i> <strong>Lưu ý:</strong> Thời gian bảo hành được
                                    tính từ
                                    ngày mua hàng ghi trên hóa đơn VAT hoặc phiếu bảo hành chính hãng.</p>
                            </div>
                        </div>

                        <!-- Điều kiện bảo hành -->
                        <div class="warranty-card">
                            <h2>
                                <i class="fa fa-check-square-o"></i>
                                Điều Kiện Bảo Hành
                            </h2>
                            <p>Sản phẩm được bảo hành khi đáp ứng đầy đủ các điều kiện sau:</p>

                            <h3>✓ Được bảo hành khi:</h3>
                            <ul>
                                <li>Sản phẩm còn trong thời gian bảo hành</li>
                                <li>Có phiếu bảo hành chính hãng hoặc hóa đơn mua hàng</li>
                                <li>Tem niêm phong, serial number còn nguyên vẹn</li>
                                <li>Lỗi kỹ thuật do nhà sản xuất (lỗi phần cứng, phần mềm từ nhà sản xuất)</li>
                                <li>Máy không có dấu hiệu va đập, rơi vỡ, cong vênh</li>
                            </ul>

                            <h3>✗ Không được bảo hành khi:</h3>
                            <ul>
                                <li><strong>Rơi vỡ, va đập:</strong> Máy bị móp méo, vỡ màn hình, nứt vỡ</li>
                                <li><strong>Ngấm nước:</strong> Máy dính nước, ẩm ướt, các chỉ báo nước đổi màu</li>
                                <li><strong>Tự ý sửa chữa:</strong> Máy đã được tháo mở, sửa chữa tại nơi không phải
                                    trung
                                    tâm bảo hành chính hãng</li>
                                <li><strong>Tem bảo hành bị rách, mờ:</strong> Không thể xác định được thông tin bảo
                                    hành
                                </li>
                                <li><strong>Sản phẩm không chính hãng:</strong> Hàng nhái, hàng xách tay không rõ nguồn
                                    gốc
                                </li>
                                <li><strong>Hết thời gian bảo hành:</strong> Quá thời hạn ghi trên phiếu bảo hành</li>
                            </ul>
                        </div>

                        <!-- Quy trình bảo hành -->
                        <div class="warranty-card">
                            <h2>
                                <i class="fa fa-refresh"></i>
                                Quy Trình Bảo Hành
                            </h2>
                            <p>Quy trình bảo hành đơn giản và nhanh chóng tại CellPhoneStore:</p>

                            <div class="warranty-steps">
                                <div class="warranty-step">
                                    <div class="warranty-step-number">1</div>
                                    <h4>Mang sản phẩm đến</h4>
                                    <p>Mang sản phẩm lỗi, phiếu bảo hành và hóa đơn đến cửa hàng hoặc trung tâm bảo hành
                                    </p>
                                </div>
                                <div class="warranty-step">
                                    <div class="warranty-step-number">2</div>
                                    <h4>Kiểm tra sản phẩm</h4>
                                    <p>Nhân viên kiểm tra tình trạng sản phẩm và xác định lỗi</p>
                                </div>
                                <div class="warranty-step">
                                    <div class="warranty-step-number">3</div>
                                    <h4>Lập phiếu tiếp nhận</h4>
                                    <p>Lập phiếu tiếp nhận bảo hành và thông báo thời gian sửa chữa dự kiến</p>
                                </div>
                                <div class="warranty-step">
                                    <div class="warranty-step-number">4</div>
                                    <h4>Sửa chữa/Đổi mới</h4>
                                    <p>Sửa chữa hoặc đổi mới sản phẩm theo chính sách bảo hành</p>
                                </div>
                                <div class="warranty-step">
                                    <div class="warranty-step-number">5</div>
                                    <h4>Trả sản phẩm</h4>
                                    <p>Nhận lại sản phẩm đã được sửa chữa hoặc đổi mới</p>
                                </div>
                            </div>

                            <div class="warranty-highlight">
                                <p><i class="fa fa-clock-o"></i> <strong>Thời gian xử lý:</strong> 7-15 ngày làm việc
                                    tùy
                                    theo mức độ hư hỏng. Với lỗi nhẹ, sản phẩm có thể được trả trong ngày.</p>
                            </div>
                        </div>

                        <!-- Chính sách đổi mới -->
                        <div class="warranty-card">
                            <h2>
                                <i class="fa fa-exchange"></i>
                                Chính Sách Đổi Mới
                            </h2>
                            <p>CellPhoneStore hỗ trợ đổi mới sản phẩm trong các trường hợp sau:</p>

                            <h3>Đổi mới trong 30 ngày:</h3>
                            <ul>
                                <li>Sản phẩm bị lỗi kỹ thuật từ nhà sản xuất (không phải do người dùng)</li>
                                <li>Sản phẩm được bảo hành <strong>2 lần trở lên</strong> cho cùng một lỗi</li>
                                <li>Máy không thể sửa chữa được (theo xác nhận của trung tâm bảo hành)</li>
                            </ul>

                            <h3>Đổi ngay sản phẩm mới 100% khi:</h3>
                            <ul>
                                <li>Sản phẩm còn nguyên seal, chưa kích hoạt trong vòng <strong>7 ngày</strong></li>
                                <li>Phát hiện lỗi phần cứng nghiêm trọng trong vòng <strong>15 ngày</strong></li>
                                <li>Sản phẩm không đúng model, màu sắc đã đặt</li>
                            </ul>

                            <div class="warranty-highlight">
                                <p><i class="fa fa-info-circle"></i> <strong>Điều kiện đổi mới:</strong> Sản phẩm phải
                                    còn
                                    nguyên vẹn, đầy đủ phụ kiện, hộp, không có dấu hiệu sử dụng hoặc hư hỏng do người
                                    dùng.
                                </p>
                            </div>
                        </div>

                        <!-- Trung tâm bảo hành -->
                        <div class="warranty-card">
                            <h2>
                                <i class="fa fa-map-marker"></i>
                                Trung Tâm Bảo Hành
                            </h2>
                            <p>Bạn có thể gửi bảo hành tại các địa điểm sau:</p>

                            <h3>1. Cửa hàng CellPhoneStore</h3>
                            <p><i class="fa fa-map-marker"></i> Trường ĐH Sư Phạm Kỹ Thuật - 1 Võ Văn Ngân, Linh Chiểu,
                                Thủ
                                Đức, TP.HCM</p>
                            <p><i class="fa fa-phone"></i> Hotline: <strong>0889-251-007</strong></p>
                            <p><i class="fa fa-clock-o"></i> Giờ làm việc: 8:00 - 20:00 (Thứ 2 - Chủ nhật)</p>

                            <h3>2. Các trung tâm bảo hành chính hãng</h3>
                            <ul>
                                <li><strong>Apple:</strong> Các Apple Authorized Service Provider trên toàn quốc</li>
                                <li><strong>Samsung:</strong> Trung tâm bảo hành Samsung Electronics tại TP.HCM, Hà Nội
                                    và
                                    các tỉnh</li>
                                <li><strong>Xiaomi:</strong> Xiaomi Service Center toàn quốc</li>
                                <li><strong>OPPO, Vivo:</strong> Trung tâm bảo hành chính hãng tại các tỉnh thành</li>
                            </ul>

                            <div class="warranty-highlight">
                                <p><i class="fa fa-truck"></i> <strong>Dịch vụ hỗ trợ:</strong> Miễn phí vận chuyển đến
                                    trung tâm bảo hành cho khách hàng ở xa (áp dụng cho đơn hàng trên 5 triệu đồng).</p>
                            </div>
                        </div>

                        <!-- Liên hệ bảo hành -->
                        <div class="warranty-contact">
                            <h3>Cần Hỗ Trợ Bảo Hành?</h3>
                            <p>Liên hệ ngay với chúng tôi để được tư vấn và hỗ trợ nhanh chóng</p>

                            <div class="warranty-contact-info">
                                <div class="warranty-contact-item">
                                    <i class="fa fa-phone"></i>
                                    <span>0889-251-007</span>
                                </div>
                                <div class="warranty-contact-item">
                                    <i class="fa fa-envelope"></i>
                                    <span>kietccc21@gmail.com</span>
                                </div>
                                <div class="warranty-contact-item">
                                    <i class="fa fa-comments"></i>
                                    <span>Chat trực tuyến 24/7</span>
                                </div>
                            </div>

                            <a href="${pageContext.request.contextPath}/user/chat" class="btn">
                                <i class="fa fa-comments"></i>
                                Liên hệ ngay
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /WARRANTY SECTION -->
        </body>

        </html>