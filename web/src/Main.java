import yyh_db_class.DatabaseConnection;

import javax.xml.transform.Result;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Main {

    public static void main(String[] args) throws SQLException {

        Connection connection = DatabaseConnection.connect();
        String sql = "SELECT COUNT(*) AS available_count FROM books WHERE status='available'";
        ResultSet rs=   connection.createStatement().executeQuery(sql);
        int availableBooks = 0;
        if (rs.next()) {
            availableBooks = rs.getInt("available_count");
        }

        System.out.println(availableBooks);
        DatabaseConnection.disconnect();
    }
}