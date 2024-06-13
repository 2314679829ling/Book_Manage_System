package yyh_Servlet;

import yyh_db_class.BookManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/borrowBook")
public class BorrowBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            int userId = (int) request.getSession().getAttribute("userId"); // 从session获取userId

            if (BookManager.borrowBook(userId, bookId)) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("成功借阅");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("借阅失败");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("无效id");
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("请求时发生错误");
            e.printStackTrace();
        }
    }
}