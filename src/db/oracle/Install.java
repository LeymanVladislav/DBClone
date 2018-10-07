package db.oracle;

import com.CMD;
import com.Proportion;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

public class Install {

    public static void main(String[] argv) throws Exception {

        // Загрузка конфигурационных параметров
        try {
            Proportion.GetProporties();
        } catch (IOException e) {
            e.printStackTrace();
        }
        // Полный путь файла инсталятора
        String FilePath = Proportion.PathAddDir + Proportion.InstallFilePath + "/" + Proportion.InstallFileName + ".sql";

        CreateInstall(FilePath);


        for (int i = 0; i < Proportion.ArrSchemas.length; ++i) {

            // Полный путь файла инсталятора схемы
            String SchemaFilePath = Proportion.PathAddDir + Proportion.InstallFilePathSchema + "/" + Proportion.InstallFileNameSchema + "_" + Proportion.ArrSchemas[i] + ".sql";

            // Соединение со схемой
            Connection s_connection;
            s_connection = DBUTL.connect(Proportion.S_Host, Proportion.S_Port, Proportion.S_DBName, Proportion.ArrSchemas[i],Proportion.ArrSchemasPass[i]);

            // Получаем коллекцию объектов пользователя
            ArrayList<DBUTL.UserObjectType> UserObjectList = null;
            UserObjectList = DBUTL.GetUserObjects(s_connection, Proportion.ObjectTypes);

            // Создание файла-инсталятора объектов схем
            CreateInstallForSchema(s_connection,Proportion.ArrSchemas[i],UserObjectList,SchemaFilePath);

            // Завершение сессии
            s_connection.close();

            // Удаление объектов схемы
            DropObjectsDestinationDB(Proportion.ArrSchemas[i],UserObjectList);
        }

        // Запуск инсталятора
        //ExecuteInstallFile(Proportion.D_UserDBA,Proportion.D_PassDBA,FilePath);

    }

    /**
     * Создание файла-инсталятора
     * */
    public static void CreateInstall(String FilePath) throws Exception {
        System.out.println("\n============== Запись файла инсталятора ==============");

        CMD.WriteFileTxt(FilePath, "--=============================== SQLPLUS settings ===============================\n" +
                "SET VERIFY OFF TIMING ON TERMOUT ON ECHO OFF HEADING OFF FEEDBACK ON SERVEROUTPUT ON LINESIZE 80 PAGESIZE 50\n", Boolean.FALSE,Proportion.CharsetName);

        // Добавление инсталятора для схем
        for (int i = 0; i < Proportion.ArrSchemas.length; ++i) {

            // Полный путь файла инсталятора схемы
            String SchemaFilePath = Proportion.PathAddDir + Proportion.InstallFilePathSchema + "/" + Proportion.InstallFileNameSchema + "_" + Proportion.ArrSchemas[i] + ".sql";

            CMD.WriteFileTxt(FilePath, "PROMPT\n" +
                "PROMPT =============================== Connect " + Proportion.ArrSchemas[i] + " user ===============================\n" +
                "CONNECT " + Proportion.ArrSchemas[i] + "/" + Proportion.ArrSchemasPass[i] + "@" + Proportion.D_TNSName + "\n\n" +
                "PROMPT\n" +
                "PROMPT =============================== Execute " + Proportion.InstallFileNameSchema + "_" + Proportion.ArrSchemas[i] + ".sql" + " ===============================\n" +
                "@" + SchemaFilePath +
                "\n", Boolean.TRUE,Proportion.CharsetName);
        }

    }


    /**
     * Запуск файла-инсталятора
     * */
    public static void ExecuteInstallFile(String Schema, String Pass,String  File){

        System.out.println("\n============== Выполнение файла инсталятора ==============");
        CMD.ExecuteCMD("sqlplus " + Schema + "/" + Pass + "@" + Proportion.D_TNSName + " @" + File);
    }


    /**
     * Создание файла-инсталятора объектов для схемы
     * */
    public static void CreateInstallForSchema(Connection Connect, String Schema,ArrayList<DBUTL.UserObjectType> UserObjectList, String SchemaFilePath) throws FileNotFoundException {


        System.out.println("\n============== Получаем список объкетов схемы " + Schema + " БД источника ==============\n");

            for (int j = 0; j < UserObjectList.size(); j++) {
                System.out.println(UserObjectList.get(j).Name + " " + UserObjectList.get(j).Type);

                String ObjectsDDL = null;
                // Получаем DDL объекта
                try {
                    ObjectsDDL = DBUTL.GetObjectsDDL(Connect, Schema, UserObjectList.get(j).Name, UserObjectList.get(j).Type, 1);
                } catch (Exception e) {
                    System.out.println("Error DBUTL.GetObjectsDDL:");
                    e.printStackTrace();
                }

                // Записываем DDL объекта
                UserObjectList.get(j).DDL = ObjectsDDL;
            }

        System.out.println("\n============== Запись файла инсталятора для схемы " + Schema + " ==============");

        for (int j = 0; j < UserObjectList.size(); j++) {
            System.out.println("Object Name:" + UserObjectList.get(j).Name);
            System.out.println("Object DDL:" + UserObjectList.get(j).DDL);

            // Первая запись создает новый файл
            Boolean Append = true;
            if (j == 0) {
                Append = false;
            }

            CMD.WriteFileTxt(SchemaFilePath, "\nPROMPT\nPROMPT =============================== CREATE " + UserObjectList.get(j).Type + " " + UserObjectList.get(j).Name + " ===============================", Append,Proportion.CharsetName);
            // Запись DDL в файл
            CMD.WriteFileTxt(SchemaFilePath, UserObjectList.get(j).DDL, Boolean.TRUE,Proportion.CharsetName);

        }
        CMD.WriteFileTxt(SchemaFilePath, "Exit;", Boolean.TRUE,Proportion.CharsetName);
    }

    /**
     * Удаление объектов базы приемника
     * */
    public static void DropObjectsDestinationDB(String Schema,ArrayList<DBUTL.UserObjectType> UserObjectList) throws Exception {
        System.out.println("\n============== Удаление объектов схемы " + Schema + " базы приемника ==============\n");

        // Устанавливаем соединение с базой назначения под DBA
        Connection d_connection_dba;
        d_connection_dba = DBUTL.connect(Proportion.D_Host, Proportion.D_Port, Proportion.D_DBName, Proportion.D_UserDBA, Proportion.D_PassDBA);

        for (int j = UserObjectList.size() - 1; j >= 0; j--) {
            System.out.println("Object Name:" + UserObjectList.get(j).Name);
            System.out.println("Object Type:" + UserObjectList.get(j).Type);
            DBUTL.DropObjects(d_connection_dba, Schema, UserObjectList.get(j).Name, UserObjectList.get(j).Type);
            System.out.println("\n-----------------------------------------------------------------------------\n");
        }
        d_connection_dba.close();
    }
}
