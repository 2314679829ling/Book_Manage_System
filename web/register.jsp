<%@ page import="yyh_db_class.Register_user" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>注册</title>
    <link href="./static/css/login.css" rel="stylesheet">
</head>
<body>
<div class="yyh">
<form action="register.jsp" method="post" onsubmit="return check()">
    <input type="text" name="username" placeholder="用户名"><br>
    <input type="password" name="password" placeholder="密码"><br>
    <input type="password" name="password2" placeholder="确认密码"><br>
    <input type="submit" value="注册">
</form>
</div>>
    <script>
        //检查正确性
        function check() {
            let username = document.getElementsByName("username")[0].value;
            let password = document.getElementsByName("password")[0].value;
            let password2 = document.getElementsByName("password2")[0].value;
            if (username === "" || password === "" || password2 === "") {
                alert("请输入用户名或密码");
                return false;
            }
            if(password !== password2){
                alert("两次密码不一致");
                return false;
            }
        }
    </script>


<%
    //注册的JSP 代码
    if(request.getMethod().equalsIgnoreCase("POST")) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        Register_user register_user = new Register_user();
        if (register_user.register(username, password)) {
            out.println("<p>注册成功</p>");
            out.println("<a href='login.jsp'>立即登录</a>");
        } else {
            out.println("<p>注册失败</p>");
        }
    }

%>
</body>
</html>
