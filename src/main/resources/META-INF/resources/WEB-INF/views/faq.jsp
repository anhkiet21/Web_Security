<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="utf-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Câu Hỏi Thường Gặp - CellPhoneStore</title>

            <style>
                .faq-section {
                    padding: 60px 0;
                    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                    min-height: calc(100vh - 200px);
                }

                .faq-header {
                    text-align: center;
                    margin-bottom: 50px;
                }

                .faq-header h1 {
                    font-size: 42px;
                    font-weight: 700;
                    color: #2B2D42;
                    margin-bottom: 15px;
                    font-family: 'Montserrat', sans-serif;
                }

                .faq-header p {
                    font-size: 16px;
                    color: #6c757d;
                    max-width: 600px;
                    margin: 0 auto;
                }

                .faq-container {
                    max-width: 900px;
                    margin: 0 auto;
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                    padding: 40px;
                }

                .faq-category {
                    margin-bottom: 40px;
                }

                .faq-category:last-child {
                    margin-bottom: 0;
                }

                .faq-category-title {
                    font-size: 24px;
                    font-weight: 700;
                    color: #D10024;
                    margin-bottom: 25px;
                    padding-bottom: 12px;
                    border-bottom: 3px solid #D10024;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }

                .faq-category-title i {
                    font-size: 28px;
                }

                .faq-item {
                    margin-bottom: 20px;
                    border: 1px solid #e9ecef;
                    border-radius: 8px;
                    overflow: hidden;
                    transition: all 0.3s ease;
                }

                .faq-item:hover {
                    box-shadow: 0 4px 12px rgba(209, 0, 36, 0.1);
                    border-color: #D10024;
                }

                .faq-question {
                    background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
                    padding: 20px 25px;
                    cursor: pointer;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    font-weight: 600;
                    color: #2B2D42;
                    transition: all 0.3s ease;
                    user-select: none;
                }

                .faq-question:hover {
                    background: linear-gradient(135deg, #FFF5F5 0%, #FFE8E8 100%);
                    color: #D10024;
                }

                .faq-question.active {
                    background: linear-gradient(135deg, #D10024 0%, #A00018 100%);
                    color: white;
                }

                .faq-question-text {
                    flex: 1;
                    font-size: 16px;
                    line-height: 1.5;
                }

                .faq-question-icon {
                    font-size: 20px;
                    transition: transform 0.3s ease;
                    margin-left: 15px;
                }

                .faq-question.active .faq-question-icon {
                    transform: rotate(180deg);
                }

                .faq-answer {
                    max-height: 0;
                    overflow: hidden;
                    transition: max-height 0.3s ease;
                    background: #fff;
                }

                .faq-answer-content {
                    padding: 25px;
                    color: #495057;
                    font-size: 15px;
                    line-height: 1.8;
                    border-top: 1px solid #e9ecef;
                }

                .faq-answer-content p {
                    margin-bottom: 12px;
                }

                .faq-answer-content p:last-child {
                    margin-bottom: 0;
                }

                .faq-answer-content ul {
                    margin: 12px 0;
                    padding-left: 25px;
                }

                .faq-answer-content ul li {
                    margin-bottom: 8px;
                }

                .faq-answer-content strong {
                    color: #D10024;
                    font-weight: 600;
                }

                .faq-contact-box {
                    background: linear-gradient(135deg, #D10024 0%, #A00018 100%);
                    color: white;
                    padding: 30px;
                    border-radius: 12px;
                    text-align: center;
                    margin-top: 40px;
                }

                .faq-contact-box h3 {
                    font-size: 24px;
                    font-weight: 700;
                    margin-bottom: 15px;
                }

                .faq-contact-box p {
                    font-size: 15px;
                    margin-bottom: 20px;
                    opacity: 0.95;
                }

                .faq-contact-box .btn {
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

                .faq-contact-box .btn:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
                }

                @media (max-width: 768px) {
                    .faq-section {
                        padding: 40px 0;
                    }

                    .faq-header h1 {
                        font-size: 32px;
                    }

                    .faq-container {
                        padding: 25px;
                    }

                    .faq-category-title {
                        font-size: 20px;
                    }

                    .faq-question-text {
                        font-size: 15px;
                    }

                    .faq-answer-content {
                        padding: 20px;
                        font-size: 14px;
                    }
                }
            </style>
        </head>

        <body>
            <!-- FAQ SECTION -->
            <div class="faq-section">
                <div class="container">
                    <div class="faq-header">
                        <h1>Câu hỏi thường gặp</h1>
                        <p>Tìm câu trả lời nhanh chóng cho các câu hỏi phổ biến về sản phẩm và dịch vụ của chúng tôi</p>
                    </div>

                    <div class="faq-container">
                        <!-- Category 1: Đặt hàng & Thanh toán -->
                        <div class="faq-category">
                            <div class="faq-category-title">
                                <i class="fa fa-shopping-cart"></i>
                                <span>Đặt hàng & Thanh toán</span>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question" onclick="toggleAnswer(this)">
                                    <span class="faq-question-text">Làm thế nào để đặt hàng trên website?</span>
                                    <i class="fa fa-chevron-down faq-question-icon"></i>
                                </div>
                                <div class="faq-answer">
                                    <div class="faq-answer-content">
                                        <p>Để đặt hàng trên website của chúng tôi, bạn thực hiện các bước sau:</p>
                                        <ul>
                                            <li>Tìm kiếm và chọn sản phẩm bạn muốn mua</li>
                                            <li>Nhấn vào nút "Thêm vào giỏ hàng"</li>
                                            <li>Kiểm tra giỏ hàng và nhấn "Thanh toán"</li>
                                            <li>Điền thông tin giao hàng và chọn phương thức thanh toán</li>
                                            <li>Xác nhận đơn hàng và hoàn tất thanh toán</li>
                                        </ul>
                                        <p>Bạn sẽ nhận được email xác nhận đơn hàng ngay sau khi đặt hàng thành công.
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question" onclick="toggleAnswer(this)">
                                    <span class="faq-question-text">Các hình thức thanh toán nào được chấp nhận?</span>
                                    <i class="fa fa-chevron-down faq-question-icon"></i>
                                </div>
                                <div class="faq-answer">
                                    <div class="faq-answer-content">
                                        <p>Chúng tôi hỗ trợ nhiều hình thức thanh toán tiện lợi:</p>
                                        <ul>
                                            <li><strong>Thanh toán khi nhận hàng (COD):</strong> Thanh toán bằng tiền
                                                mặt khi nhận hàng</li>
                                            <li><strong>Chuyển khoản ngân hàng:</strong> Chuyển khoản qua tài khoản ngân
                                                hàng</li>
                                            <li><strong>Thẻ tín dụng/ghi nợ:</strong> Visa, MasterCard, JCB</li>
                                            <li><strong>Ví điện tử:</strong> MoMo, ZaloPay, VNPay</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question" onclick="toggleAnswer(this)">
                                    <span class="faq-question-text">Tôi có thể hủy hoặc thay đổi đơn hàng không?</span>
                                    <i class="fa fa-chevron-down faq-question-icon"></i>
                                </div>
                                <div class="faq-answer">
                                    <div class="faq-answer-content">
                                        <p>Bạn có thể hủy khi đơn hàng chưa được xác nhận <strong>hoặc </strong>chưa
                                            thanh
                                            toán đơn hàng</p>
                                        <p>Để thực hiện, vui lòng:</p>
                                        <ul>
                                            <li>Liên hệ hotline: <strong>0889-251-007</strong></li>
                                            <li>Hoặc gửi email đến: <strong>kietccc21@gmail.com</strong></li>
                                            <li>Cung cấp mã đơn hàng và thông tin cần thay đổi</li>
                                        </ul>
                                        <p>Sau khi đơn hàng đã được xử lý, việc hủy hoặc thay đổi sẽ không được chấp
                                            nhận.</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Category 2: Vận chuyển & Giao hàng -->
                        <div class="faq-category">
                            <div class="faq-category-title">
                                <i class="fa fa-truck"></i>
                                <span>Vận chuyển & Giao hàng</span>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question" onclick="toggleAnswer(this)">
                                    <span class="faq-question-text">Thời gian giao hàng là bao lâu?</span>
                                    <i class="fa fa-chevron-down faq-question-icon"></i>
                                </div>
                                <div class="faq-answer">
                                    <div class="faq-answer-content">
                                        <p>Thời gian giao hàng phụ thuộc vào khu vực của bạn:</p>
                                        <ul>
                                            <li><strong>Nội thành TP.HCM:</strong> 1-2 ngày làm việc</li>
                                            <li><strong>Các tỉnh thành khác:</strong> 3-5 ngày làm việc</li>
                                            <li><strong>Vùng sâu, vùng xa:</strong> 5-7 ngày làm việc</li>
                                        </ul>
                                        <p>Đối với đơn hàng khẩn cấp, chúng tôi có dịch vụ giao hàng nhanh trong
                                            <strong>3-4 giờ</strong> tại nội thành TP.HCM (phụ thu phí giao hàng nhanh).
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question" onclick="toggleAnswer(this)">
                                    <span class="faq-question-text">Phí vận chuyển được tính như thế nào?</span>
                                    <i class="fa fa-chevron-down faq-question-icon"></i>
                                </div>
                                <div class="faq-answer">
                                    <div class="faq-answer-content">
                                        <p>Phí vận chuyển được tính theo khoảng cách và trọng lượng đơn hàng:</p>
                                        <ul>
                                            <li><strong>Miễn phí vận chuyển</strong> cho đơn hàng từ 500.000đ trở lên
                                            </li>
                                            <li><strong>30.000đ</strong> - Nội thành TP.HCM (đơn hàng dưới 500.000đ)
                                            </li>
                                            <li><strong>50.000đ - 100.000đ</strong> - Các tỉnh thành khác</li>
                                            <li>Phí giao hàng nhanh: <strong>+50.000đ</strong></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question" onclick="toggleAnswer(this)">
                                    <span class="faq-question-text">Làm thế nào để kiểm tra tình trạng đơn hàng?</span>
                                    <i class="fa fa-chevron-down faq-question-icon"></i>
                                </div>
                                <div class="faq-answer">
                                    <div class="faq-answer-content">
                                        <p>Bạn có thể kiểm tra tình trạng đơn hàng bằng cách:</p>
                                        <ul>
                                            <li>Đăng nhập vào tài khoản và vào mục <strong>"Đơn hàng của tôi"</strong>
                                            </li>
                                            <li>Nhấn vào đơn hàng cụ thể để xem chi tiết và trạng thái</li>
                                            <li>Hoặc kiểm tra email xác nhận đơn hàng có chứa link theo dõi</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Category 3: Sản phẩm & Bảo hành -->
                        <div class="faq-category">
                            <div class="faq-category-title">
                                <i class="fa fa-mobile"></i>
                                <span>Sản phẩm & Bảo hành</span>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question" onclick="toggleAnswer(this)">
                                    <span class="faq-question-text">Sản phẩm có chính hãng không?</span>
                                    <i class="fa fa-chevron-down faq-question-icon"></i>
                                </div>
                                <div class="faq-answer">
                                    <div class="faq-answer-content">
                                        <p><strong>100% sản phẩm của chúng tôi đều là hàng chính hãng</strong>, được
                                            nhập khẩu từ các nhà phân phối ủy quyền.</p>
                                        <p>Mỗi sản phẩm đều đi kèm:</p>
                                        <ul>
                                            <li>Hộp nguyên seal</li>
                                            <li>Phiếu bảo hành chính hãng</li>
                                            <li>Hóa đơn VAT đầy đủ</li>
                                            <li>Tem chống hàng giả</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question" onclick="toggleAnswer(this)">
                                    <span class="faq-question-text">Chính sách bảo hành như thế nào?</span>
                                    <i class="fa fa-chevron-down faq-question-icon"></i>
                                </div>
                                <div class="faq-answer">
                                    <div class="faq-answer-content">
                                        <p>Chúng tôi cung cấp chính sách bảo hành toàn diện:</p>
                                        <ul>
                                            <li><strong>Bảo hành 12 tháng</strong> cho tất cả sản phẩm điện thoại</li>
                                            <li><strong>Đổi mới trong 30 ngày</strong> nếu sản phẩm có lỗi từ nhà sản
                                                xuất</li>
                                            <li><strong>Hỗ trợ kỹ thuật miễn phí</strong> suốt thời gian sử dụng</li>
                                            <li>Bảo hành tại <strong>các trung tâm bảo hành chính hãng</strong> trên
                                                toàn quốc</li>
                                        </ul>
                                        <p>Lưu ý: Bảo hành không áp dụng cho các trường hợp rơi vỡ, ngấm nước, tự ý sửa
                                            chữa.</p>
                                    </div>
                                </div>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question" onclick="toggleAnswer(this)">
                                    <span class="faq-question-text">Tôi có thể đổi trả sản phẩm không?</span>
                                    <i class="fa fa-chevron-down faq-question-icon"></i>
                                </div>
                                <div class="faq-answer">
                                    <div class="faq-answer-content">
                                        <p>Chúng tôi chấp nhận đổi trả sản phẩm trong các trường hợp sau:</p>
                                        <ul>
                                            <li><strong>Đổi trả trong 7 ngày</strong> nếu sản phẩm còn nguyên seal, chưa
                                                kích hoạt</li>
                                            <li><strong>Đổi mới ngay</strong> nếu phát hiện lỗi kỹ thuật từ nhà sản xuất
                                            </li>
                                            <li><strong>Hoàn tiền 100%</strong> nếu không đổi được sản phẩm tương đương
                                            </li>
                                        </ul>
                                        <p>Điều kiện đổi trả:</p>
                                        <ul>
                                            <li>Sản phẩm còn nguyên vẹn, đầy đủ phụ kiện</li>
                                            <li>Có hóa đơn mua hàng</li>
                                            <li>Không có dấu hiệu sử dụng, va đập</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Category 4: Tài khoản & Bảo mật -->
                        <div class="faq-category">
                            <div class="faq-category-title">
                                <i class="fa fa-user"></i>
                                <span>Tài khoản & Bảo mật</span>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question" onclick="toggleAnswer(this)">
                                    <span class="faq-question-text">Làm thế nào để đăng ký tài khoản?</span>
                                    <i class="fa fa-chevron-down faq-question-icon"></i>
                                </div>
                                <div class="faq-answer">
                                    <div class="faq-answer-content">
                                        <p>Bạn có thể đăng ký tài khoản rất đơn giản:</p>
                                        <ul>
                                            <li>Nhấn vào nút "Đăng ký" ở góc trên cùng</li>
                                            <li>Điền thông tin: họ tên, email, số điện thoại, mật khẩu</li>
                                            <li>Xác nhận email và số điện thoại</li>
                                            <li>Hoàn tất đăng ký và đăng nhập</li>
                                        </ul>
                                        <p>Hoặc bạn có thể đăng ký nhanh bằng tài khoản Google.</p>
                                    </div>
                                </div>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question" onclick="toggleAnswer(this)">
                                    <span class="faq-question-text">Tôi quên mật khẩu, phải làm sao?</span>
                                    <i class="fa fa-chevron-down faq-question-icon"></i>
                                </div>
                                <div class="faq-answer">
                                    <div class="faq-answer-content">
                                        <p>Để khôi phục mật khẩu:</p>
                                        <ul>
                                            <li>Nhấn vào "Quên mật khẩu" ở trang đăng nhập</li>
                                            <li>Nhập email đã đăng ký</li>
                                            <li>Kiểm tra email và nhấn vào link đặt lại mật khẩu</li>
                                            <li>Tạo mật khẩu mới và xác nhận</li>
                                        </ul>
                                        <p>Nếu không nhận được email, vui lòng kiểm tra hộp thư spam hoặc liên hệ với
                                            chúng tôi để được hỗ trợ.</p>
                                    </div>
                                </div>
                            </div>

                            <div class="faq-item">
                                <div class="faq-question" onclick="toggleAnswer(this)">
                                    <span class="faq-question-text">Thông tin cá nhân của tôi có được bảo mật
                                        không?</span>
                                    <i class="fa fa-chevron-down faq-question-icon"></i>
                                </div>
                                <div class="faq-answer">
                                    <div class="faq-answer-content">
                                        <p><strong>Chúng tôi cam kết bảo mật tuyệt đối</strong> thông tin cá nhân của
                                            khách hàng:</p>
                                        <ul>
                                            <li>Sử dụng mã hóa SSL/TLS cho tất cả giao dịch</li>
                                            <li>Không chia sẻ thông tin với bên thứ ba</li>
                                            <li>Hệ thống bảo mật đạt tiêu chuẩn quốc tế</li>
                                            <li>Tuân thủ luật bảo vệ dữ liệu cá nhân</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Contact Box -->
                        <div class="faq-contact-box">
                            <h3>Không tìm thấy câu trả lời bạn cần?</h3>
                            <p>Đội ngũ hỗ trợ của chúng tôi luôn sẵn sàng giúp đỡ bạn 24/7</p>
                            <a href="${pageContext.request.contextPath}/user/chat" class="btn">
                                <i class="fa fa-comments"></i>
                                Liên hệ ngay
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /FAQ SECTION -->

            <script>
                function toggleAnswer(element) {
                    const faqItem = element.closest('.faq-item');
                    const answer = faqItem.querySelector('.faq-answer');
                    const question = faqItem.querySelector('.faq-question');
                    const isActive = question.classList.contains('active');

                    // Close all other items in the same category
                    const category = faqItem.closest('.faq-category');
                    const allItems = category.querySelectorAll('.faq-item');
                    allItems.forEach(item => {
                        const itemAnswer = item.querySelector('.faq-answer');
                        const itemQuestion = item.querySelector('.faq-question');
                        itemQuestion.classList.remove('active');
                        itemAnswer.style.maxHeight = null;
                    });

                    // Toggle current item
                    if (!isActive) {
                        question.classList.add('active');
                        answer.style.maxHeight = answer.scrollHeight + 'px';
                    }
                }

                // Open first item in each category by default
                document.addEventListener('DOMContentLoaded', function () {
                    document.querySelectorAll('.faq-category').forEach(category => {
                        const firstItem = category.querySelector('.faq-item');
                        if (firstItem) {
                            const firstQuestion = firstItem.querySelector('.faq-question');
                            toggleAnswer(firstQuestion);
                        }
                    });
                });
            </script>
        </body>

        </html>