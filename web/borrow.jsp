<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, yyh_db_class.DatabaseConnection" %>
<%@ page isELIgnored="false" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>借书</title>
    <link href="static/css/borrow.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <button><a href="user_page.jsp">返回用户界面</a></button>
    <h1>借书</h1>

    <!-- 激活管理员功能按钮 -->
    <button id="admin-button" onclick="checkAdmin()">激活管理员功能</button>

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
                    out.println("<b>书籍信息：</b>");
                    out.println("<div class='book' id='book" + rs.getInt("id") + "'>");
                    out.println("<p>书籍ID: " + rs.getInt("id") + "</p>");
                    out.println("<p>书名: " + rs.getString("title") + "</p>");
                    out.println("<p>作者: " + rs.getString("author") + "</p>");
                    out.println("<p>状态: " + rs.getString("status") + "</p>");
                    out.println("<p>出版日期: " + rs.getDate("publish_date") + "</p>");
                    out.println("<p>借阅次数: " + rs.getInt("borrow_count") + "</p>");
                    out.println("</div>");
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
    <details>
        <summary><b>所有可借阅的书籍：</b></summary>
        <div class="book-list">
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
                        out.println("<p>借阅次数: " + rs.getInt("borrow_count") + "</p>");
                        out.println("<button class='borrow-btn' onclick='borrowBook(" + rs.getInt("id") + ");'>借阅</button>");
                        out.println("<button class='return-btn' onclick='returnBook(" + rs.getInt("id") + ");'>归还</button>");
                        out.println("</div>");
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
    </details>
    <details>
        <summary><b>已借阅的书籍：</b></summary>
        <div class="book-list">
            <%
                try {
                    conn = DatabaseConnection.connect();

                    // 查询所有已借阅的书籍
                    String queryBorrowedBooksSql = "SELECT * FROM books WHERE status='borrowed' ";
                    pstmt = conn.prepareStatement(queryBorrowedBooksSql);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        out.println("<div class='book' id='book" + rs.getInt("id") + "'>");
                        out.println("<p>书籍ID: " + rs.getInt("id") + "</p>");
                        out.println("<p>书名: " + rs.getString("title") + "</p>");
                        out.println("<p>作者: " + rs.getString("author") + "</p>");
                        out.println("<p>状态: " + rs.getString("status") + "</p>");
                        out.println("<p>出版日期: " + rs.getDate("publish_date") + "</p>");
                        out.println("<p>借阅次数: " + rs.getInt("borrow_count") + "</p>");
                        out.println("<button class='return-btn' onclick='returnBook(" + rs.getInt("id") + ");'>归还</button>");
                        out.println("</div>");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<p>获取已借阅书籍时发生错误。</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (conn != null) DatabaseConnection.disconnect(conn);
                }
            %>
        </div>
    </details>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function borrowBook(bookId) {

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

    function checkAdmin() {
        $.ajax({
            type: 'GET',
            url: 'AdminServlet',
            dataType: 'json', // Ensure we expect JSON response
            success: function(response) {
                if (response.isAdmin) {
                    insertAdminPanel();
                    addDeleteButtons();
                } else {
                    alert('您不是管理员');
                }
            },
            error: function(xhr, status, error) {
                alert('检查管理员状态时发生错误: ' + xhr.responseText);
            }
        });
    }

    // 动态插入管理员功能区域
    function insertAdminPanel() {
        let adminPanelHtml = `
            <div id="admin-panel">
                <h2>管理员功能</h2>
                <div id="add-book-form">
                    <form onsubmit="addBook(); return false;">
                        书名: <input type='text' name='title' required><br>
                        作者: <input type='text' name='author' required><br>
                        出版日期: <input type='date' name='publishDate' required><br>
                        <input type='submit' value='增加书籍'>
                    </form>
                </div>
            </div>
        `;
        $('#admin-button').after(adminPanelHtml);
    }

    function addBook() {
        let title = $("input[name='title']").val();
        let author = $("input[name='author']").val();
        let publishDate = $("input[name='publishDate']").val();

        $.ajax({
            type: 'POST',
            url: 'AdminServlet',
            data: {
                action: 'addBook',
                title: title,
                author: author,
                publishDate: publishDate
            },
            success: function(response) {
                alert(response.message);
                // 重新加载页面或者更新书籍列表
                location.reload();
            },
            error: function(xhr, status, error) {
                alert('添加书籍失败: ' + xhr.responseText);
            }
        });
    }

    // 动态添加删除按钮
    function addDeleteButtons() {
        // 遍历每一个book元素 提取id 然后
        $('.book').each(function() {
            let bookId = $(this).attr('id').replace('book', '');
            console.log("Found book element with id: " + bookId); // 添加调试信息
            let deB="<button class='delete-btn' onclick='deleteBook("+bookId+")'>删除</button>";
            $(this).append(deB);
        });
    }

    function deleteBook(bookId) {

        $.ajax({
            type: 'POST',
            url: 'AdminServlet',
            data: {
                action: 'deleteBook',
                bookId: bookId
            },
            success: function(response) {
                alert(response.message);
                $('#book' + bookId).remove();
            },
            error: function(xhr, status, error) {
                alert(color="red">'删除书籍失败: ' + xhr.responseText);
            }
        });
    }

    // 显示添加书籍表单
    function showAddBookForm() {
        let form = document.getElementById("add-book-form");
        if (form.style.display === "none") {
            form.style.display = "block";
        } else {
            form.style.display = "none";
        }
    }
</script>
</body>
</html>
