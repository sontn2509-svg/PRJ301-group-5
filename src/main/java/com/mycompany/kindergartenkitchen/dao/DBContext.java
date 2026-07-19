/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.kindergartenkitchen.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    private final String serverName = "localhost";
    private final String dbName = "KindergartenKitchen";
    private final String portNumber = "1433";
    private final String userID = "sa";
    private final String password = "123";

    public Connection getConnection() throws SQLException {
       
        String url = "jdbc:sqlserver://" + serverName + "\\SQLEXPRESS:" + portNumber
                + ";databaseName=" + dbName
                + ";encrypt=true;trustServerCertificate=true;";

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Khong tim thay driver SQL Server", e);
        }
        return DriverManager.getConnection(url, userID, password);
    }

    public static void main(String[] args) {
        try {
            DBContext db = new DBContext();
            Connection conn = db.getConnection();
            if (conn != null) {
                System.out.println("=== Successful ===");
                conn.close();
            }
        } catch (Exception e) {
            System.out.println("bug " + e.getMessage());
        }
    }
}
