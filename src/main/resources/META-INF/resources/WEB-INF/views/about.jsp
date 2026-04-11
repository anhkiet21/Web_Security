<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Giới thiệu - CellPhoneStore</title>
    <style>
        .about-section {
            background: white;
            padding: 40px;
            margin: 30px 0;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .about-section h2 {
            color: #d70018;
            margin-bottom: 20px;
            font-size: 28px;
            font-weight: bold;
        }
        
        .about-section h3 {
            color: #333;
            margin-top: 30px;
            margin-bottom: 15px;
            font-size: 22px;
        }
        
        .about-section p {
            color: #555;
            line-height: 1.8;
            font-size: 16px;
            margin-bottom: 15px;
        }
        
        .tech-stack {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin: 20px 0;
        }
        
        .tech-stack ul {
            list-style: none;
            padding: 0;
        }
        
        .tech-stack li {
            padding: 8px 0;
            border-bottom: 1px solid #dee2e6;
        }
        
        .tech-stack li:last-child {
            border-bottom: none;
        }
        
        .tech-stack li i {
            color: #d70018;
            margin-right: 10px;
        }
        
        .team-section {
            margin-top: 30px;
        }
        
        .team-member {
            background: #f8f9fa;
            padding: 20px;
            margin: 15px 0;
            border-left: 4px solid #d70018;
            border-radius: 4px;
        }
        
        .team-member h4 {
            color: #d70018;
            margin: 0 0 10px 0;
            font-size: 18px;
        }
        
        .team-member p {
            margin: 5px 0;
            color: #666;
        }
        
        .team-member .mssv {
            font-weight: bold;
            color: #333;
        }
    </style>
</head>
<body>
    <div class="section">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <div class="about-section">
                        <h2><i class="fa fa-info-circle"></i> Giới thiệu về CellPhoneStore</h2>
                        
                        <p>
                            Trang Web Bán Điện Thoại <strong>CellPhoneStore</strong> là dự án được thiết kế và phát triển 
                            bởi Nhóm 4 với mục đích tạo ra một nền tảng thương mại điện tử hiện đại, 
                            chuyên nghiệp cho việc mua bán điện thoại và phụ kiện.
                        </p>
                        
                        <h3><i class="fa fa-code"></i> Công nghệ sử dụng</h3>
                        <div class="tech-stack">
                            <ul>
                                <li><i class="fa fa-check-circle"></i> <strong>Spring Boot</strong> - Framework backend mạnh mẽ</li>
                                <li><i class="fa fa-check-circle"></i> <strong>JSP/JSTL</strong> - Template engine cho giao diện động</li>
                                <li><i class="fa fa-check-circle"></i> <strong>Bootstrap</strong> - Framework CSS responsive</li>
                                <li><i class="fa fa-check-circle"></i> <strong>JPA (Hibernate)</strong> - ORM framework</li>
                                <li><i class="fa fa-check-circle"></i> <strong>MySQL/PostgreSQL</strong> - Hệ quản trị cơ sở dữ liệu</li>
                                <li><i class="fa fa-check-circle"></i> <strong>Sitemesh Decorator</strong> - Template layout framework</li>
                                <li><i class="fa fa-check-circle"></i> <strong>JWT (JSON Web Token)</strong> - Xác thực và phân quyền</li>
                                <li><i class="fa fa-check-circle"></i> <strong>WebSocket</strong> - Giao tiếp real-time</li>
                            </ul>
                        </div>
                        
                        <h3><i class="fa fa-users"></i> Sinh viên thực hiện</h3>
                        <div class="team-section">
                            <div class="team-member">
                                <h4><i class="fa fa-user"></i> Dương Khánh Duy</h4>
                                <p class="mssv">Mã số sinh viên: 23162010</p>
                            </div>
                            
                            <div class="team-member">
                                <h4><i class="fa fa-user"></i> Trần Anh Kiệt</h4>
                                <p class="mssv">Mã số sinh viên: 23162049</p>
                            </div>
                            
                            <div class="team-member">
                                <h4><i class="fa fa-user"></i> Lê Thành Nhân</h4>
                                <p class="mssv">Mã số sinh viên: 23162069</p>
                            </div>
                            
                            <div class="team-member">
                                <h4><i class="fa fa-user"></i> Phan Thành Nhân</h4>
                                <p class="mssv">Mã số sinh viên: 23162070</p>
                            </div>
                        </div>
                        
                        <div style="margin-top: 40px; padding-top: 20px; border-top: 2px solid #dee2e6;">
                            <p style="text-align: center; color: #666; font-style: italic;">
                                <i class="fa fa-graduation-cap"></i> 
                                Dự án môn Lập trình Web - Học kỳ 1 năm 2025
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
