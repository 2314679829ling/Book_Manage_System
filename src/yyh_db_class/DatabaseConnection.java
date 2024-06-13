package yyh_db_class;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/book_manage?user=root&password=123456&useUnicode=true&characterEncoding=gbk&serverTimezone=Asia/Shanghai";

    // 连接数据库
    public static Connection connect() {
        Connection connection = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // 加载JDBC驱动
            connection = DriverManager.getConnection(URL);
            System.out.println("数据库连接成功！");
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC 驱动加载失败:");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("数据库连接失败:");
            e.printStackTrace();
        }

        return connection;
    }

    // 断开数据库连接
    public static void disconnect(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("数据库连接已断开！");
            } catch (SQLException e) {
                System.err.println("关闭数据库连接失败:");
                e.printStackTrace();
            }
        }
    }
}