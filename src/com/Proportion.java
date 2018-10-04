package com;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

public class Proportion
{
    private static int SOME_INT_VALUE = 1;
    private static String SOME_STRING_VALUE;
    private static int[] SOME_INT_ARRAY;
    private static double SOME_DOUBLE_VALUE;
    private static String parts;

    /** [DB_SOURCE]*/
    public static String S_Host;
    public static String S_Port;
    public static String S_DBName;
    public static String S_TNSName;

    /** [DB_DESTINATION]*/
    public static String D_Host;
    public static String D_Port;
    public static String D_DBName;
    public static String D_TNSName;
    public static String D_UserDBA;
    public static String D_PassDBA;

    /** [CLON_SETTINGS]*/
    public static String Schemas;
    public static String SchemasPass;
    public static String ObjectTypes;

    /** [INSTALL_DISTR]*/
    public static String InstallFilePath;
    public static String InstallFileName;
    public static String InstallFilePathSchema;
    public static String InstallFileNameSchema;
    public static String CharsetName;


    public static String PathAddDir;
    public static String PathForIdea = "src/";
    public static String PathConfig = "config/config.ini";

    public static String[] ArrSchemas;
    public static String[] ArrSchemasPass;
    private static boolean isIdea = true; //Если 1, то запуск для idea, т.е. к пути прибавляется src/, после компиляции он не нужен

    public static void main(String[] args) throws IOException {
        GetProporties();
    }

    public static void GetProporties() throws IOException
    {

        if(isIdea){
            PathAddDir = PathForIdea;
        }

        Properties props = new Properties();

        props.load(new FileInputStream(new File(PathAddDir + PathConfig)));

        if(!props.isEmpty()) {
            //[Example]
            SOME_INT_VALUE = Integer.valueOf(props.getProperty("SOME_INT_VALUE", "1"));
            SOME_STRING_VALUE = props.getProperty("SOME_STRING_VALUE");
            SOME_DOUBLE_VALUE = Double.valueOf(props.getProperty("SOME_DOUBLE_VALUE", "1.0"));

            //[DB_SOURCE]
            S_Host = props.getProperty("S_HOST");
            S_Port = props.getProperty("S_PORT");
            S_DBName = props.getProperty("S_DB_NAME");
            S_TNSName = props.getProperty("S_TNS_NAME");

            //[DB_DESTINATION]
            D_Host = props.getProperty("D_HOST");
            D_Port = props.getProperty("D_PORT");
            D_DBName = props.getProperty("D_DB_NAME");
            D_TNSName = props.getProperty("D_TNS_NAME");
            D_UserDBA = props.getProperty("D_USER_DBA");
            D_PassDBA = props.getProperty("D_PASS_DBA");

            //[INSTALL_DISTR]
            InstallFilePath = props.getProperty("INSTALL_FILE_PATH");
            InstallFileName = props.getProperty("INSTALL_FILE_NAME");
            InstallFilePathSchema = props.getProperty("INSTALL_FILE_PATH_SCHEMA");
            InstallFileNameSchema = props.getProperty("INSTALL_FILE_NAME_SCHEMA");
            CharsetName = props.getProperty("CHARSET_NAME");


            ObjectTypes = props.getProperty("OBJECT_TYPES");

            // Читаем список через точку с запятой
            Schemas = props.getProperty("SCHEMAS");
            if((Schemas != null)&&(Schemas != "")) {
                ArrSchemas = Schemas.split(";");
                System.out.println("Load schemas:");
                for (int i = 0; i < ArrSchemas.length; ++i) {
                    System.out.println(ArrSchemas[i]);
                }
            }
            // Читаем список через точку с запятой
            SchemasPass = props.getProperty("SCHEMAS_PASS");
            if((SchemasPass != null)&&(SchemasPass != "")) {
                ArrSchemasPass = SchemasPass.split(";");
                System.out.println("Load schemas:");
                for (int i = 0; i < ArrSchemasPass.length; ++i) {
                    System.out.println(ArrSchemasPass[i]);
                }
            }
        }
    }

}
