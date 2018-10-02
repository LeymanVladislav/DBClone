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
    private static String PKG_NAME = "JDBCDriverConnection";
    private static String DBDriver = "jdbc:oracle:thin";
    private static String Host = "LV";
    private static String Port = "1525";
    private static String DBName = "DBMAIN";
    private static String TNSName = "DB_MAIN";
    private static String SSLMode = "sslmode=require";
    //private static String url = DBDriver + "://" + Host + ":" + Port + "/" + DBName + "?" + SSLMode;
    String Url = DBDriver + ":@" + Host + ":" + Port + ":" + DBName;

    public static class UserObjectType {
        public String Name;
        public String Type;
        public String DDL;
    }


    public static void main(String[] argv) throws Exception {

        // Загрузка конфигурационных параметров
        try {
            Proportion.GetProporties();
        } catch (IOException e) {
            e.printStackTrace();
        }

        //ExecuteSqlExample(connection);

        //ExecutePlSqlBlockExample(connection);

        //importSQL(connection, new File(Proportion.PathAddDir + "DBScripts/test.sql"));

        /*for (int i = 0; i < Proportion.ArrSchemas.length; ++i) {
            //CMD.ExecuteDBScript(Proportion.ArrSchemas[i], Proportion.ArrSchemasPass[i], TNSName,Proportion.PathAddDir + "DBScripts/test.sql", Proportion.ArrSchemas[i]);
            CMD.ExecuteDBScript(Proportion.ArrSchemas[i], Proportion.ArrSchemasPass[i], TNSName,Proportion.PathAddDir + "DBScripts/user_tables.sql");
        }*/

        // Получаем список объектов пользователя базы источника
        ArrayList<UserObjectType> UserObjectList = null;
        for (int i = 0; i < Proportion.ArrSchemas.length; ++i) {

            // Устанавливаем соединение с базой источником
            Connection s_connection;
            s_connection = connect(Proportion.S_Host, Proportion.S_Port, Proportion.S_DBName, Proportion.ArrSchemas[i], Proportion.ArrSchemasPass[i]);

            // Получаем список объкетов схемы
            UserObjectList = GetUserObjects(s_connection, Proportion.ObjectsType);

            for (int j = 0; j < UserObjectList.size(); j++) {
                System.out.println(UserObjectList.get(j).Name + " " + UserObjectList.get(j).Type);

                String ObjectsDDL;
                // Получаем DDL объекта
                ObjectsDDL = GetObjectsDDL(s_connection, Proportion.ArrSchemas[i], UserObjectList.get(j).Name, UserObjectList.get(j).Type, 0, 1);
                // Записываем DDL объекта
                UserObjectList.get(j).DDL = ObjectsDDL;
            }
            s_connection.close();


            System.out.println("\n============== Удаление объектов базы приемника ==============\n");
            /**
             * чтенеие в обратном порядке чтобы начать с зависимых объектов
             */
            // Устанавливаем соединение с базой назначения под DBA
            Connection d_connection_dba;
            d_connection_dba = connect(Proportion.D_Host, Proportion.D_Port, Proportion.D_DBName, Proportion.D_UserDBA, Proportion.D_PassDBA);

            for (int j = UserObjectList.size() - 1; j > 0; j--) {
                System.out.println("Object Name:" + UserObjectList.get(j).Name);
                System.out.println("Object Type:" + UserObjectList.get(j).Type);
                DropObjects(d_connection_dba, UserObjectList.get(j).Name, UserObjectList.get(j).Type);
                System.out.println("\n-----------------------------------------------------------------------------\n");
            }
            d_connection_dba.close();

            System.out.println("\n============== Установка объектов базы источника в базу назначения ==============");

            System.out.println("\n============== Устанавливаем соединение с базой назначения под схемой " + Proportion.ArrSchemas[i] + " ==============\n");
            Connection d_connection;
            d_connection = connect(Proportion.D_Host, Proportion.D_Port, Proportion.D_DBName, Proportion.ArrSchemas[i], Proportion.ArrSchemasPass[i]);


               for (int j = 0; j < UserObjectList.size(); j++) {
                    System.out.println("Object Name:" + UserObjectList.get(j).Name);
                    System.out.println("Object DDL:" + UserObjectList.get(j).DDL);
                    try {
                        ExecuteDDL(d_connection, UserObjectList.get(j).DDL);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }

                    System.out.println("\n-----------------------------------------------------------------------------\n");
                }
            d_connection.close();
        }

        /*for (int i = 0; i < Proportion.ArrSchemas.length; ++i) {
            Connection s_connection;
            s_connection = connect(Proportion.S_Host, Proportion.S_Port, Proportion.S_DBName, Proportion.ArrSchemas[i], Proportion.ArrSchemasPass[i]);

            GetDDL(s_connection);
        }*/



       /* Reader reader = new InputStreamReader(new FileInputStream(Proportion.PathAddDir + "DBScripts/test.sql"));

        ScriptRunner SR = new ScriptRunner(connection,false,true);

        try {
            SR.runScript(reader);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        */


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
    public static void DropObjects(Connection Connect, String ObjectName, String ObjectType) throws Exception {

        // Получение текста файла
        String FileTxt = CMD.GetFileTxt(Proportion.PathAddDir + "DBScripts/drop_object.sql");

        CallableStatement cs = Connect.prepareCall(FileTxt);

        cs.setString(1, ObjectType);
        cs.setString(2, ObjectName);

        cs.execute();

        cs.close();
    }

    // Получение DDL объекта
    public static String GetObjectsDDL(Connection Connect, String ObjectOwner, String ObjectName, String ObjectType, Integer EnableTCT, Integer EnableIDX) throws Exception {

        // Получение текста файла
        String FileTxt = CMD.GetFileTxt(Proportion.PathAddDir + "DBScripts/get_obj_ddl.sql");

        CallableStatement cs = Connect.prepareCall(FileTxt);

        cs.setString(1, ObjectOwner);
        cs.setString(2, ObjectName);
        cs.setString(3, ObjectType);
        cs.setInt(4, EnableTCT);
        cs.setInt(5, EnableIDX);
        cs.registerOutParameter(6, OracleTypes.CLOB);

        cs.execute();

        String ClobResultSet = cs.getString(6);

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
