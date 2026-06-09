package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.model.ClassInfo;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ClassDAO extends DBContext {

    public List<ClassInfo> getAllClasses() {
        List<ClassInfo> list = new ArrayList<>();

        String sql = """
                     SELECT c.ClassID, c.ClassName, c.LevelID, l.LevelName,
                            ISNULL(c.TeacherID, 0) AS TeacherID,
                            ISNULL(u.FullName, N'Chưa có') AS TeacherName,
                            c.Status
                     FROM Classes c
                     JOIN Levels l ON c.LevelID = l.LevelID
                     LEFT JOIN Users u ON c.TeacherID = u.UserID
                     ORDER BY c.ClassID
                     """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new ClassInfo(
                        rs.getInt("ClassID"),
                        rs.getString("ClassName"),
                        rs.getInt("LevelID"),
                        rs.getString("LevelName"),
                        rs.getInt("TeacherID"),
                        rs.getString("TeacherName"),
                        rs.getBoolean("Status")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
