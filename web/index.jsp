<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="yyh_db_class.BookManager" %>

<html lang=yyh_db_class.BookManager"zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>图书管理系统</title>
    <link rel="stylesheet" href="./static/css/index.css">
</head>
<body>
<div class="container">
    <div class="header">
        <h1>图书管理系统</h1>
    </div>
    <div class="content">
        <div>现存书有 <%= BookManager.getAvailableBooksCount() %> 本</div>
        <a href="./login.jsp">登录</a>
        <a href="./register.jsp">注册</a>
    </div>
</div>
</body>
</html>