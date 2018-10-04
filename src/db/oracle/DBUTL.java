package db.oracle;

import com.CMD;
import com.Proportion;
import oracle.jdbc.OracleDriver;
import oracle.jdbc.OracleTypes;

import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.Scanner;

public class DBUTL {
    private static Connection connection = null;

    public static class UserObjectType {
        public String Name;
        public String Type;
        public String DDL;
    }

    public static Connection connect(String Host, String Port, String DBName, String User, String Pass) {
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

        }

        if (connection != null) {
            System.out.println("You made it, take control your database now!");
        } else {
            System.out.println("Failed to make connection!");
        }
        return connection;
    }

    // Получение списка объектов пользователя
    public static ArrayList<UserObjectType> GetUserObjects(Connection Connect, String ObjectsType) throws Exception {

        java.sql.Array ObjTypsArr;

        // Получение текста файла
        String FileTxt = CMD.GetFileTxt(Proportion.PathAddDir + "DBScripts/user_objects.sql");

        //ObjTypsArr = Connect.createArrayOf("CHAR", ArrObjectsType);
        System.out.println("ObjectsType = " + ObjectsType);

        ArrayList<UserObjectType> UserObjectList = new ArrayList<>();

        CallableStatement cs = Connect.prepareCall(FileTxt);
        //cs.setArray(1, ObjTypsArr);
        cs.setString(1, ObjectsType);
        cs.registerOutParameter(2, OracleTypes.CURSOR);

        cs.execute();

        //System.out.println("Result = " + cs.getObject(2));

        ResultSet cursorResultSet = (ResultSet) cs.getObject(2);
        while (cursorResultSet.next()) {
            UserObjectType UserObject = new UserObjectType();
            UserObject.Name = cursorResultSet.getString("OBJECT_NAME");
            UserObject.Type = cursorResultSet.getString("OBJECT_TYPE");
            UserObjectList.add(UserObject);
        }
        cs.close();
        return UserObjectList;
    }

    // Удаление объекта
    public static void DropObjects(Connection Connect, String ObjectOwner, String ObjectName, String ObjectType) throws Exception {

        // Получение текста файла
        String FileTxt = CMD.GetFileTxt(Proportion.PathAddDir + "DBScripts/drop_object.sql");

        CallableStatement cs = Connect.prepareCall(FileTxt);

        cs.setString(1, ObjectType);
        cs.setString(2, ObjectOwner);
        cs.setString(3, ObjectName);
        cs.registerOutParameter(4, OracleTypes.VARCHAR);

        cs.execute();

        System.out.println("Error: " + cs.getString(4));

        cs.close();
    }

    // Получение DDL объекта
    public static String GetObjectsDDL(Connection Connect, String ObjectOwner, String ObjectName, String ObjectType, Integer EnableTCT) throws Exception {

        // Получение текста файла
        String FileTxt = CMD.GetFileTxt(Proportion.PathAddDir + "DBScripts/get_obj_ddl.sql");

        CallableStatement cs = Connect.prepareCall(FileTxt);

        cs.setString(1, ObjectOwner);
        cs.setString(2, ObjectName);
        cs.setString(3, ObjectType);
        cs.setInt(4, EnableTCT);
        cs.registerOutParameter(5, OracleTypes.CLOB);

        cs.execute();

        String ClobResultSet = cs.getString(5);

        cs.close();

        return ClobResultSet;
    }

    // Выполнение DDL
    public static void ExecuteDDL(Connection Connect, String DDL) throws Exception {

        // Получение текста файла
        String FileTxt = CMD.GetFileTxt(Proportion.PathAddDir + "DBScripts/execute_ddl.sql");

        CallableStatement cs = Connect.prepareCall(FileTxt);

        cs.setString(1, DDL);

        cs.execute();

        cs.close();
    }

    // Функция выполнения sql запроса
    public static void ExecuteSql(Connection Connect, String SQLText) throws Exception {

        //тут нужно проичитат файл sql и вызвать
        String sql = SQLText;
        Statement stmt = Connect.createStatement();
        stmt.execute(sql);
        ResultSet rs    = stmt.executeQuery(sql);
    }

    // Функция выполнения PlSql блока
    public static void GetDDL(Connection Connect) throws Exception {
        String plsql = "" +
                " declare " +
                "  res clob;" +
                " begin " +
                "    ? := dbms_metadata.get_ddl(object_type => 'SEQUENCE',name => 'CUR_RATES_CB_ID_SEQ');" +
                " end;";

        CallableStatement cs = Connect.prepareCall(plsql);
        //cs.setString(1, "12345");
        cs.registerOutParameter(1, Types.CLOB);
        //cs.registerOutParameter(1, OracleTypes.CURSOR);

        cs.execute();

        System.out.println("Result = " + cs.getString(1));

        cs.close();
    }

    // Функция выполнения sql запроса
    public static void ExecuteSqlExample(Connection Connect) throws Exception {

        //тут нужно проичитат файл sql и вызвать
        String sql = "CREATE TABLE CUR_RATES_CB \n" +
                "   (ID NUMBER, \n" +
                "CB_CODE VARCHAR2(10), \n" +
                "CUR_DATE DATE, \n" +
                "VALUE NUMBER, \n" +
                "LOAD_DATE DATE\n" +
                "   ) ;";
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
