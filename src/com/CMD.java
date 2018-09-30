package com;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.SQLException;

import com.Proportion;

public class CMD {
    private static Connection connection = null;
    //private static String url = DBDriver + "://" + Host + ":" + Port + "/" + DBName + "?" + SSLMode;
    String Url;


    public static void main(String[] argv) throws IOException {
        //String Url = DBDriver + ":@" + TNSName;


        // Загрузка конфигурационных параметров
        Proportion.GetProporties();

        //ExecuteDBScript(Proportion.PathAddDir + "DBSCRIPTS\\test.sql");

        //connect(Proportion.Host,Proportion.Port,Proportion.DBName,Proportion.User,Proportion.Pass);
        //Url = DBDriver + ":@" + Host + ":" + Port + ":" + DBName;


    }

    public static void ExecuteCMD(String Command) {

        try {
            ProcessBuilder builder = new ProcessBuilder(
                    "cmd.exe", "/c", Command);
            builder.redirectErrorStream(true);
            Process p = builder.start();
            BufferedReader r = new BufferedReader(new InputStreamReader(p.getInputStream(),"CP1251"));
            String line;
            while (true) {
                line = r.readLine();
                if (line == null) { break; }
                System.out.println(line);
            }

        }
        catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    /**
     * Runs an SQL script
     *
     * @param FileName
     *            - full path to script
     * @param Params
     *            - parameter value, delimiters = " "
     */
    public static void ExecuteDBScript(String User, String Pass, String TNSName, String FileName, String Params) {
        String Command = "sqlplus " + User + "/" + Pass + "@" + TNSName + " @" + FileName + " " + Params;
        ExecuteCMD(Command);
    }
    public static void ExecuteDBScript(String User, String Pass, String TNSName, String FileName) {
        ExecuteDBScript(User, Pass, TNSName, FileName, null);
    }

    public static String GetFileTxt(String File) {

        String st = "";
        try(FileReader reader = new FileReader(File))
        {
            // читаем посимвольно
            int c;
            while((c=reader.read())!=-1){

                //System.out.print((char)c);
                st += (char)c;
            }

            st = st.replaceAll("'&[0-9]+'|&[0-9]+","?");
            //System.out.print(st);

            return st;
        }
        catch(IOException ex){

            System.out.println(ex.getMessage());
            return null;
        }
    }

    public static String CastStrArrToStr(String[] ArrStr) {
        String[] ArrStr_tmp = new String[ArrStr.length];
        for (int i = 0; i < ArrStr.length; i++) {
            ArrStr_tmp[i] = ArrStr[i];
        }
        String st = String.join(",", ArrStr_tmp);
        return st;
    }
}