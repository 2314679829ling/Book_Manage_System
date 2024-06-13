package yyh_db_class;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class BookManager {

    // 获取可用书籍数量
    public static int getAvailableBooksCount() {
        int availableBooks = 0;
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.connect();
            stmt = conn.createStatement();
            String sql = "SELECT COUNT(*) AS available_count FROM books WHERE status='available'";
            rs = stmt.executeQuery(sql);

            if (rs.next()) {
                availableBooks = rs.getInt("available_count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return availableBooks;
    }
    public static List<BorrowRecord> getUserBorrowRecords(int userId) {
        List<BorrowRecord> borrowRecords = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.connect();
            String queryBorrowRecordsSql = "SELECT record_id, book_id, borrow_date, return_date FROM borrow_records WHERE user_id = ?";
            stmt = conn.prepareStatement(queryBorrowRecordsSql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                BorrowRecord record = new BorrowRecord();
                record.setRecordId(rs.getInt("record_id"));
                record.setBookId(rs.getInt("book_id"));
                record.setBorrowDate(rs.getDate("borrow_date"));
                record.setReturnDate(rs.getDate("return_date"));
                borrowRecords.add(record);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return borrowRecords;
    }

    // 借书
    public static boolean borrowBook(int userId, int bookId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        System.out.println("bookid in borrowBook"+bookId);
        try {
            conn = DatabaseConnection.connect();

            // 更新书籍状态
            String updateBookStatusSql = "UPDATE books SET status='borrowed' WHERE id = ? AND status='available'";
            stmt = conn.prepareStatement(updateBookStatusSql);
            stmt.setInt(1, bookId);
            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated == 0) {
                return false; // 书籍已被借出或不存在
            }

            // 更新用户的借书次数
            String updateUserBorrowCountSql = "UPDATE users SET borrow_count = borrow_count + 1 WHERE id = ?";
            stmt = conn.prepareStatement(updateUserBorrowCountSql);
            stmt.setInt(1, userId);
            stmt.executeUpdate();

            // 插入借书记录
            String insertBorrowRecordSql = "INSERT INTO borrow_records (user_id, book_id, borrow_date) VALUES (?, ?, CURDATE())";
            stmt = conn.prepareStatement(insertBorrowRecordSql);
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            stmt.executeUpdate();

            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    // 归还书
    public static boolean returnBook(int userId, int bookId) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.connect();

            // 更新书籍状态
            String updateBookStatusSql = "UPDATE books SET status='available',borrow_count=borrow_count+1 WHERE id = ? AND status='borrowed'";
            stmt = conn.prepareStatement(updateBookStatusSql);
            stmt.setInt(1, bookId);
            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated == 0) {
                return false; // 书籍未被借出或不存在
            }

            // 更新用户的借书次数
            String updateUserBorrowCountSql = "UPDATE users SET borrow_count = borrow_count - 1 WHERE id = ?";
            stmt = conn.prepareStatement(updateUserBorrowCountSql);
            stmt.setInt(1, userId);
            stmt.executeUpdate();

            // 更新借书记录的归还日期
            String updateBorrowRecordSql = "UPDATE borrow_records SET return_date = CURDATE() WHERE user_id = ? AND book_id = ? AND return_date IS NULL";
            stmt = conn.prepareStatement(updateBorrowRecordSql);
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            stmt.executeUpdate();

            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    // 添加书籍
    public static boolean addBook(String title, String author, String publishDate) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.connect();

            String insertBookSql = "INSERT INTO books (title, author, publish_date, status) VALUES (?, ?, ?, 'available')";
            stmt = conn.prepareStatement(insertBookSql);
            stmt.setString(1, title);
            stmt.setString(2, author);
            stmt.setString(3, publishDate);
            stmt.executeUpdate();

            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    // 删除书籍
    public static boolean deleteBook(int bookId) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.connect();

            String deleteBookSql = "DELETE FROM books WHERE id = ?";
            stmt = conn.prepareStatement(deleteBookSql);
            stmt.setInt(1, bookId);
            stmt.executeUpdate();

            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    // 关闭资源
    private static void closeResources(ResultSet rs, Statement stmt, Connection conn) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (conn != null) {
            DatabaseConnection.disconnect(conn);
        }
    }
}