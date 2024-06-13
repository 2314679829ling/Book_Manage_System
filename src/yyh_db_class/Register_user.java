package yyh_db_class;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
public class Register_user {

    // 注册用户方法
    public boolean register(String username, String password) {
        if (!isValidUsername(username) || !isValidPassword(password)) {
            return false;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseConnection.connect();
            if (conn == null || conn.isClosed()) {
                throw new SQLException("无法连接到数据库。");
            }

            // 检查用户名是否已存在
            if (isUsernameTaken(conn, username)) {
                return false;
            }

            // 插入新用户记录
            String sql = "INSERT INTO users (username, password, is_admin, borrow_count) VALUES (?, ?, 0, 0)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            int rowsInserted = pstmt.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                DatabaseConnection.disconnect(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 验证用户名是否合法
    private boolean isValidUsername(String username) {
        return username != null && username.length() >= 1 && username.length() <= 50;
    }

    // 验证密码是否合法
    private boolean isValidPassword(String password) {
        return password != null && password.length() >= 6 && password.length() <= 100;
    }

    // 检查用户名是否已存在
    private boolean isUsernameTaken(Connection conn, String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }


}