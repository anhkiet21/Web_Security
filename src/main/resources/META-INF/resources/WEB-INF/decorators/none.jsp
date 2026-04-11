<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Minimal decorator that outputs body only (no header/footer) --%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title><sitemesh:write property="title"/></title>
</head>
<body>
    <sitemesh:write property="body" />
    <sitemesh:write property="head" />
</body>
</html>
