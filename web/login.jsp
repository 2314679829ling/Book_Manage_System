<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录</title>
    <link rel="stylesheet" href="./static/css/login.css">
</head>
<body>
<div class="yyh">
    <form id="loginForm" method="post" action="login" onsubmit="return check()">
        <input type="text" name="username" placeholder="用户名"><br>
        <input type="password" name="password" placeholder="密码"><br>
        <input type="submit" value="登录">
    </form>
    <div id="message"><%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %></div>
</div>
<script>
    function check() {
        let username = document.getElementsByName("username")[0].value;
        let password = document.getElementsByName("password")[0].value;
        if (username === "" || password === "") {
            alert("请输入用户名或密码");
            return false;
        }
        return true;
    }
</script>
</body>
</html>