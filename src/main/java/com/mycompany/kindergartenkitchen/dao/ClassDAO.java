/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.model.ClassInfo;
import com.mycompany.kindergartenkitchen.model.LevelInfo;
import com.mycompany.kindergartenkitchen.model.UserInfo;
import java.sql.Types;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author VuongNguyen
 */
public class ClassDAO extends DBContext {

    public List<ClassInfo> getAllClasses() {
        List<ClassInfo> list = new ArrayList<>();

        String sql = "SELECT c.ClassID, c.ClassName. c.LevelID, l.LevelName, "
                + "ISNULL(c.TeacherID, 0) AS TeacherID, "
                + "ISNULL(u.FullName, N'Chưa có giáo viên') AS TeacherName, "
                + "c.Status "
                + "FROM Classes c "
                + "JOIN Levels l ON c.LevelID = l.LevelID "
                + "LEFT JOIN User u ON c.TeacherID = u.UserID "
                + "WHERE c.Status = 1 "
                + "ORDER BY c.ClassID DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ClassInfo classInfo = new ClassInfo(
                        rs.getInt("ClassID"),
                        rs.getString("ClassName"),
                        rs.getInt("LevelID"),
                        rs.getString("LevelName"),
                        rs.getInt("TeacherID"),
                        rs.getString("TeacherName"),
                        rs.getBoolean("Status")
                );

                list.add(classInfo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ClassInfo getClassById(int classID) {
        String sql = "SELECT c.ClassID, c.ClassName, c.LevelID, l.LevelName,"
                + "ISNULL(c.TeacherID, 0) AS TeacherID,"
                + "ISNULL(u.FullName, N'Chưa có giáo viên') AS TeacherName, "
                + "c.Status "
                + "FROM Classes c "
                + "JOIN Levels l ON c.LevelID = l.LevelID "
                + "LEFT JOIN User u ON c.TeacherID = u.UserID "
                + "WHERE c.ClassID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, classID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new ClassInfo(
                            rs.getInt("ClassID"),
                            rs.getString("ClassName"),
                            rs.getInt("LevelID"),
                            rs.getString("LevelName"),
                            rs.getInt("TeacherID"),
                            rs.getString("TeacherName"),
                            rs.getBoolean("Status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean insertClass(ClassInfo classInfo) {
        String sql = "INSERT INTO Classes(ClassName, LevelID, TeacherID, Status) "
                + "VALUE (?, ?, ?, 1)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, classInfo.getClassName());
            ps.setInt(2, classInfo.getLevelID());

            if (classInfo.getTeacherID() > 0) {
                ps.setInt(3, classInfo.getTeacherID());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateClass(ClassInfo classInfo) {
        String sql = "UPDATE Classes "
                + "SET ClassName = ?, LevelID = ?, TeacherID = ? "
                + "WHERE ClassID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, classInfo.getClassName());
            ps.setInt(2, classInfo.getLevelID());

            if (classInfo.getTeacherID() > 0) {
                ps.setInt(3, classInfo.getTeacherID());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setInt(4, classInfo.getClassID());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteClass(int classID) {
        String sql = "UPDATE Classes SET Status = 0 WHERE ClassID = ? ";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, classID);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<LevelInfo> getAllLevels() {
        List<LevelInfo> list = new ArrayList<>();

        String sql = "SELECT LevelID, LevelName, Description "
                + "FROM Levels "
                + "ORDER BY LevelID";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                LevelInfo level = new LevelInfo(
                        rs.getInt("LevelID"),
                        rs.getString("LevelName"),
                        rs.getString("Description")
                );
                list.add(level);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<UserInfo> getActiveTeachers() {
        List<UserInfo> list = new ArrayList<>();

        String sql = "SELECT u.UserID, u.Username, u.Fullname, r.RoleName, u.Status"
                + "FROM User u"
                + "JOIN Roles r ON u.RoleID = r.RoleID "
                + "WHERE r.RoleName  = 'Teacher'"
                + "AND u.status = 1"
                + "ORDER BY uFullname";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                UserInfo user = new UserInfo(
                        rs.getInt("UserID"),
                        rs.getString("Username"),
                        rs.getString("Fullname"),
                        rs.getString("RoleName "),
                        rs.getBoolean("Status")
                );
                list.add(user);

            }
        } catch (Exception e) {
            e.printStackTrace();

        }
        return list;
    }
}
