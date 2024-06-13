<%@ page import="java.sql.*,java.util.List, yyh_db_class.DatabaseConnection, yyh_db_class.BookManager, yyh_db_class.BorrowRecord" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>用户借阅记录</title>
    <link href="static/css/user_page.css" rel="stylesheet">
    <link href="static/css/user_page.css" rel="stylesheet">
</head>
<body>

<div class="container">
    <div class="borrow">
        <a href="borrow.jsp" id="borrow">借书</a>
    </div>
    <%
        //通过session获得username 防止用户直接访问
        String userName = (String)session.getAttribute("username");
        if (userName != null && !userName.isEmpty()) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                conn = DatabaseConnection.connect();

                // 首先根据用户名查询用户ID
                String queryUserIdSql = "SELECT id, username, is_admin, borrow_count FROM users WHERE username = ?";
                pstmt = conn.prepareStatement(queryUserIdSql);
                pstmt.setString(1, userName);
                rs = pstmt.executeQuery();

                // 检查是否找到了用户ID
                if (rs.next()) {
                    int userId = rs.getInt("id");

                    //将用户id也写入session
                    request.getSession().setAttribute("userId", userId);
                    String username = rs.getString("username");
                    boolean isAdmin = rs.getBoolean("is_admin");
                    int borrowCount = rs.getInt("borrow_count");

                    // 使用找到的用户ID来查询借阅记录
                    List<BorrowRecord> borrowRecords = BookManager.getUserBorrowRecords(userId);

                    out.println("<h2><u>" + username + "的借阅记录</u></h2>");
                    out.println("<p>您已借阅" + borrowCount + "本书</p>");


                    out.println("<summary><h3>未归还的书籍：</h3></summary>");
                    out.println("<div class='record-list'>");

                    for (BorrowRecord record : borrowRecords) {
                        if (record.getReturnDate() == null) {
                            out.println("<div class='record' id='record-" + record.getRecordId() + "'>");
                            out.println("<p>记录ID: " + record.getRecordId() + "</p>");
                            out.println("<p>书籍ID: " + record.getBookId() + "</p>");
                            out.println("<p>借阅日期: " + record.getBorrowDate() + "</p>");

                            int days = (int) ((System.currentTimeMillis() - record.getBorrowDate().getTime()) / (1000 * 60 * 60 * 24));
                            out.println("<p>归还日期: <span id='return-date-" + record.getRecordId() + "'>" + "已借阅" + days + "天" + "未归还" + "</span></p>");
                            out.println("<button class='return-btn' onclick='returnBook(" + record.getRecordId() + ", " + record.getBookId() + ");'>归还书籍</button>");
                            out.println("</div>");
                        }
                    }

                    out.println("</div>");


                    out.println("<details>");
                    out.println("<summary><h3>已归还的书籍：</h3></summary>");
                    out.println("<div class='record-list'>");

                    for (BorrowRecord record : borrowRecords) {
                        if (record.getReturnDate() != null) {
                            out.println("<div class='record' id='record-" + record.getRecordId() + "'>");
                            out.println("<p>记录ID: " + record.getRecordId() + "</p>");
                            out.println("<p>书籍ID: " + record.getBookId() + "</p>");
                            out.println("<p>借阅日期: " + record.getBorrowDate() + "</p>");
                            out.println("<p>归还日期: <span id='return-date-" + record.getRecordId() + "'>" + record.getReturnDate() + "</span></p>");
                            out.println("</div>");
                        }
                    }

                    out.println("</div>");
                    out.println("</details>");
                } else {
                    out.println("<p>找不到该用户名的用户。</p>");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>获取借阅记录时发生错误。</p>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) DatabaseConnection.disconnect(conn);
            }
        } else {
            //只能通过重定向访问
            out.println("<p>请先登录。3s 后返回登录界面</p>");
            out.println("<script>setTimeout(function() { window.location.href = 'login.jsp'; }, 3000);</script>");
        }
    %>
</div>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    //归还书籍
    function returnBook(recordId, bookId) {
        if (confirm("确定要归还这本书吗？")) {
            $.ajax({
                type: 'POST',
                url: 'returnBook',
                data: { bookId: bookId },
                success: function(response) {
                    alert(response);
                    // 动态更新归还日期
                    $('#return-date-' + recordId).text(new Date().toLocaleDateString());
                },
                error: function(xhr, status, error) {
                    alert('书籍归还失败: ' + xhr.responseText);
                }
            });
        }
    }
</script>
</body>
</html>
