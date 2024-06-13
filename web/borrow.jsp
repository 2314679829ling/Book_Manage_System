
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, yyh_db_class.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>借书</title>
</head>
<body>
<div class="container">
    <button><a href="user_page.jsp">返回用户界面</a></button>
    <h1>借书</h1>

    <!-- 查询书籍信息表单 -->
    <form method="post" action="borrow.jsp">
        <label for="bookId">请输入书籍ID查询：</label>
        <input type="text" id="bookId" name="bookId">
        <input type="submit" value="查询">
    </form>

    <%
        String bookId = request.getParameter("bookId");
        if (bookId != null && !bookId.isEmpty()) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                conn = DatabaseConnection.connect();

                // 查询书籍信息
                String queryBookSql = "SELECT * FROM books WHERE id = ?";
                pstmt = conn.prepareStatement(queryBookSql);
                pstmt.setString(1, bookId);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    out.println("<h2>书籍信息：</h2>");
                    out.println("<p>书籍ID: " + rs.getInt("id") + "</p>");
                    out.println("<p>书名: " + rs.getString("title") + "</p>");
                    out.println("<p>作者: " + rs.getString("author") + "</p>");
                    out.println("<p>状态: " + rs.getString("status") + "</p>");
                    out.println("<p>出版日期: " + rs.getDate("publish_date") + "</p>");
                    out.println("<p>出版日期: " + rs.getInt("borrow_count") + "</p>");

                } else {
                    out.println("<p>未找到该书籍。</p>");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>查询书籍信息时发生错误。</p>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) DatabaseConnection.disconnect(conn);
            }
        }
    %>

    <h2>所有可借阅的书籍：</h2>
    <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConnection.connect();

            // 查询所有可借阅的书籍
            String queryAvailableBooksSql = "SELECT * FROM books WHERE status='available' ";
            pstmt = conn.prepareStatement(queryAvailableBooksSql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                out.println("<div class='book' id='book" + rs.getInt("id") + "'>");
                out.println("<p>书籍ID: " + rs.getInt("id") + "</p>");
                out.println("<p>书名: " + rs.getString("title") + "</p>");
                out.println("<p>作者: " + rs.getString("author") + "</p>");
                out.println("<p>状态: " + rs.getString("status") + "</p>");
                out.println("<p>出版日期: " + rs.getDate("publish_date") + "</p>");
                out.println("<p>出版日期: " + rs.getInt("borrow_count") + "</p>");
                out.println("<button class='borrow-btn' onclick='borrowBook(" + rs.getInt("id") + ");'>借阅</button>");
                out.println("<button class='return-btn' onclick='returnBook(" + rs.getInt("id") + ");'>归还</button>");
                out.println("</div>");
                out.println("<hr>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>获取可借阅书籍时发生错误。</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) DatabaseConnection.disconnect(conn);
        }
    %>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function borrowBook(bookId) {
        console.log("Borrowing book with ID:", bookId);
        $.ajax({
            type: 'POST',
            url: 'borrowBook',
            data: { bookId: bookId },
            success: function(response) {
                alert(response);
                location.reload();
            },
            error: function(xhr, status, error) {
                alert('借书失败: ' + xhr.responseText);
            }
        });
    }

    function returnBook(bookId) {
        console.log("Returning book with ID:", bookId);
        $.ajax({
            type: 'POST',
            url: 'returnBook',
            data: { bookId: bookId },
            success: function(response) {
                alert(response);
                location.reload();
            },
            error: function(xhr, status, error) {
                alert('还书失败: ' + xhr.responseText);
            }
        });
    }
</script>
</body>
</html>