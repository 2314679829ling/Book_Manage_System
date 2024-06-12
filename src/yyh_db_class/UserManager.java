package yyh_db_class;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserManager {
    // 验证用户
    public boolean authenticateUser(String username, String password) {
        boolean isAuthenticated = false;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.connect();
            if (conn == null || conn.isClosed()) {
                throw new SQLException("无法连接到数据库。");
            }

            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                isAuthenticated = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                DatabaseConnection.disconnect();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return isAuthenticated;
    }
}