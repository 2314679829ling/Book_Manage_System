package yyh_Servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import yyh_db_class.BookManager;


public class ReturnBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        String userName = (String) request.getSession().getAttribute("username");

        if (userName != null && !userName.isEmpty()) {
            // 假设你已经从session中获取了userId
            int userId = (int) request.getSession().getAttribute("userId");
            if (BookManager.returnBook(userId, bookId)) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("书籍归还成功");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("未找到未归还的书籍记录或书籍已归还");
            }
        } else {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("请先登录");
        }
    }
}