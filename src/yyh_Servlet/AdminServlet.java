package yyh_Servlet;

import yyh_db_class.BookManager;
import yyh_db_class.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");

        PrintWriter out = response.getWriter();

        String username = (String) request.getSession().getAttribute("username");
        if (username != null && !username.isEmpty()) {
            try (Connection conn = DatabaseConnection.connect()) {
                String queryUserIdSql = "SELECT is_admin FROM users WHERE username = ?";
                PreparedStatement pstmt = conn.prepareStatement(queryUserIdSql);
                pstmt.setString(1, username);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    boolean isAdmin = rs.getBoolean("is_admin");
                    out.print("{\"isAdmin\": " + isAdmin + "}");
                } else {
                    out.print("{\"isAdmin\": false}");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\": \"检查管理员状态时发生错误\"}");
            }
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"未登录\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        switch (action) {
            case "borrowBook":
                handleBorrowBook(request, response, out);
                break;

            case "returnBook":
                handleReturnBook(request, response, out);
                break;

            case "deleteBook":
                handleDeleteBook(request, response, out);
                break;

            case "addBook":
                handleAddBook(request, response, out);
                break;

            default:
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"无效的操作\"}");
                break;
        }
    }

    private void handleBorrowBook(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        int userId = (Integer) request.getSession().getAttribute("userId");
        int bookId = Integer.parseInt(request.getParameter("bookId"));

        boolean success = BookManager.borrowBook(userId, bookId);
        if (success) {
            out.print("{\"message\": \"借书成功\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"借书失败\"}");
        }
    }

    private void handleReturnBook(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        int userId = (Integer) request.getSession().getAttribute("userId");
        int bookId = Integer.parseInt(request.getParameter("bookId"));

        boolean success = BookManager.returnBook(userId, bookId);
        if (success) {
            out.print("{\"message\": \"还书成功\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"还书失败\"}");
        }
    }

    private void handleDeleteBook(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        System.out.println("bookId: " + bookId);
        boolean success = BookManager.deleteBook(bookId);
        if (success) {
            out.print("{\"message\": \"删除书籍成功\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"删除书籍失败\"}");
        }
    }

    private void handleAddBook(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String publishDate = request.getParameter("publishDate");

        boolean success = BookManager.addBook(title, author, publishDate);
        if (success) {
            out.print("{\"message\": \"添加书籍成功\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"添加书籍失败\"}");
        }
    }
}
