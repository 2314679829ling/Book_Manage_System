<%@ page import="yyh_db_class.UserManager" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录</title>
    <link rel="stylesheet" href="./static/css/login.css">
</head>
<body>
<div class="yyh">
    <form action="login.jsp" method="post" onsubmit="return check()">
        <input type="text" name="username" placeholder="用户名"><br>
        <input type="password" name="password" placeholder="密码"><br>
        <input type="submit" value="登录">
    </form>
</div>
<script>
    //用户名和密码不能为空
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
<%
    //检查输入和数据库是否匹配
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username != null && password != null) {
            UserManager userManager = new UserManager();
            boolean login = userManager.authenticateUser(username, password);
            if (login) {
                //如果登录成功,重定向到用户界面
                response.sendRedirect("user_page.jsp");
            } else {
                out.println("<p>用户名或密码错误</p>");
                out.println("<a href='register.jsp'>立即注册</a>");
            }
        } else {
            out.println("<p>用户名或密码不能为空</p>");
        }
    }
%>



</body>
</html>