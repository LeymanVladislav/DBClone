package db.oracle;

import java.io.*;
import java.sql.*;
import java.util.Scanner;

import com.Proportion;
import oracle.jdbc.OracleDriver;
import oracle.jdbc.OracleTypes;

public class DBConnection {

    private static Connection connection = null;
    private static String PKG_NAME = "JDBCDriverConnection";
    private static String DBDriver = "jdbc:oracle:thin";
    private static String Host = "LV";
    private static String Port = "1525";
    private static String DBName = "DBMAIN";
    private static String TNSName = "DB_MAIN";
    private static String SSLMode = "sslmode=require";
    private static String User = "CB";
    private static String Pass = "1";
    //private static String url = DBDriver + "://" + Host + ":" + Port + "/" + DBName + "?" + SSLMode;
    String Url = DBDriver + ":@" + Host + ":" + Port + ":" + DBName;


    public static void main(String[] argv) throws Exception {

        // Загрузка конфигурационных параметров
        try {
            Proportion.GetProporties();
        } catch (IOException e) {
            e.printStackTrace();
        }

        connect(User,Pass);

        ExecuteSqlExample(connection);

        ExecutePlSqlBlockExample(connection);

        importSQL(connection, new File(Proportion.PathAddDir + "DBScripts/test.sql"));

    }

    public static void connect(String User, String Pass) {
        String DBDriver = "jdbc:oracle:thin";
        String Url = DBDriver + ":@" + Host + ":" + Port + ":" + DBName;

        System.out.println("-------- Oracle JDBC Connection Testing ------");

        try {

            DriverManager.registerDriver(new OracleDriver());
            System.out.println("Oracle JDBC Driver Registered!");


        } catch (SQLException e) {

            System.out.println("Where is your Oracle JDBC Driver?");
            e.printStackTrace();

        }

        try {

            System.out.println("Url: " + Url);
            connection = DriverManager.getConnection(Url, User, Pass);

        } catch (SQLException e) {

            System.out.println("Connection Failed! Check output console");
            e.printStackTrace();
            return;

        }

        if (connection != null) {
            System.out.println("You made it, take control your database now!");
        } else {
            System.out.println("Failed to make connection!");
        }
    }

    // Функция выполнения sql запроса
    public static void ExecuteSqlExample(Connection Connect) throws Exception {

        //тут нужно проичитат файл sql и вызвать
        String sql = "select * from dual";
            Statement stmt = Connect.createStatement();
            stmt.execute(sql);
            ResultSet rs    = stmt.executeQuery(sql);
        while (rs.next()) {
            String result = rs.getString("DUMMY");
            System.out.println("ExecuteSqlExample: " + result);
        }

    }

    // Функция выполнения PlSql блока
    public static void ExecutePlSqlBlockExample(Connection Connect) throws Exception {
        String plsql = "" +
                " declare " +
                "    p_id varchar2(20) := null; " +
                "    l_rc sys_refcursor;" +
                " begin " +
                "    p_id := ?; " +
                "    ? := 'input parameter was = ' || p_id;" +
                "    open l_rc for " +
                "        select 1 id, 'hello' name from dual " +
                "        union " +
                "        select 2, 'peter' from dual; " +
                "    ? := l_rc;" +
                " end;";

        CallableStatement cs = Connect.prepareCall(plsql);
        cs.setString(1, "12345");
        cs.registerOutParameter(2, Types.VARCHAR);
        cs.registerOutParameter(3, OracleTypes.CURSOR);


        cs.execute();

        System.out.println("Result = " + cs.getObject(2));

        ResultSet cursorResultSet = (ResultSet) cs.getObject(3);
        while (cursorResultSet.next()) {
            System.out.println(cursorResultSet.getInt(1) + " " + cursorResultSet.getString(2));
        }
        cs.close();
    }

    // Функция выполнения sql файла
    public static void importSQL(Connection conn, File inputFile) throws SQLException, FileNotFoundException {
        String delimiter = "(;(\r)?\n)|(--\n)";
        Scanner s = new Scanner(inputFile).useDelimiter(delimiter);
        Statement st = null;
        try
        {
            st = conn.createStatement();
            while (s.hasNext())
            {
                String line = s.next();
                if (line.startsWith("/*!") && line.endsWith("*/"))
                {
                    int i = line.indexOf(' ');
                    line = line.substring(i + 1, line.length() - " */".length());
                }

                if (line.trim().length() > 0)
                {
                    st.execute(line);
                }
            }
        }
        finally
        {
            if (st != null) st.close();
        }
    }

}
