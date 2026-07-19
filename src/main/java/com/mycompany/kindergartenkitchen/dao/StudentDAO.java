package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.model.Student;
import com.mycompany.kindergartenkitchen.model.UserInfo;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO extends DBContext {

    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();

        String sql = "SELECT s.StudentID, s.StudentCode, s.StudentName, s.DateOfBirth, "
                + "s.Gender, s.ClassID, c.ClassName, l.LevelName, "
                + "ISNULL(s.ParentID, 0) AS ParentID, "
                + "ISNULL(p.FullName, N'Chưa có phụ huynh') AS ParentName, "
                + "s.Status AS StudentStatus "
                + "FROM Students s "
                + "JOIN Classes c ON s.ClassID = c.ClassID "
                + "JOIN Levels l ON c.LevelID = l.LevelID "
                + "LEFT JOIN Users p ON s.ParentID = p.UserID "
                + "WHERE s.Status = 1 "
                + "ORDER BY s.StudentID DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Student student = new Student(
                        rs.getInt("StudentID"),
                        rs.getString("StudentCode"),
                        rs.getString("StudentName"),
                        rs.getDate("DateOfBirth"),
                        rs.getBoolean("Gender"),
                        rs.getInt("ClassID"),
                        rs.getString("ClassName"),
                        rs.getString("LevelName"),
                        rs.getInt("ParentID"),
                        rs.getString("ParentName"),
                        rs.getBoolean("StudentStatus")
                );

                list.add(student);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Student getStudentById(int studentID) {
        String sql = "SELECT s.StudentID, s.StudentCode, s.StudentName, s.DateOfBirth, "
                + "s.Gender, s.ClassID, c.ClassName, l.LevelName, "
                + "ISNULL(s.ParentID, 0) AS ParentID, "
                + "ISNULL(p.FullName, N'Chưa có phụ huynh') AS ParentName, "
                + "s.Status AS StudentStatus "
                + "FROM Students s "
                + "JOIN Classes c ON s.ClassID = c.ClassID "
                + "JOIN Levels l ON c.LevelID = l.LevelID "
                + "LEFT JOIN Users p ON s.ParentID = p.UserID "
                + "WHERE s.StudentID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Student(
                            rs.getInt("StudentID"),
                            rs.getString("StudentCode"),
                            rs.getString("StudentName"),
                            rs.getDate("DateOfBirth"),
                            rs.getBoolean("Gender"),
                            rs.getInt("ClassID"),
                            rs.getString("ClassName"),
                            rs.getString("LevelName"),
                            rs.getInt("ParentID"),
                            rs.getString("ParentName"),
                            rs.getBoolean("StudentStatus")
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean insertStudent(Student student) {
        String sql = "INSERT INTO Students(StudentCode, StudentName, DateOfBirth, Gender, ClassID, ParentID, Status) "
                + "VALUES (?, ?, ?, ?, ?, ?, 1)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, student.getStudentCode());
            ps.setString(2, student.getStudentName());
            ps.setDate(3, student.getDateOfBirth());
            ps.setBoolean(4, student.isGender());
            ps.setInt(5, student.getClassID());

            if (student.getParentID() > 0) {
                ps.setInt(6, student.getParentID());
            } else {
                ps.setNull(6, Types.INTEGER);
            }

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateStudent(Student student) {
        String sql = "UPDATE Students "
                + "SET StudentCode = ?, StudentName = ?, DateOfBirth = ?, Gender = ?, ClassID = ?, ParentID = ? "
                + "WHERE StudentID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, student.getStudentCode());
            ps.setString(2, student.getStudentName());
            ps.setDate(3, student.getDateOfBirth());
            ps.setBoolean(4, student.isGender());
            ps.setInt(5, student.getClassID());

            if (student.getParentID() > 0) {
                ps.setInt(6, student.getParentID());
            } else {
                ps.setNull(6, Types.INTEGER);
            }

            ps.setInt(7, student.getStudentID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteStudent(int studentID) {
        // Chỉ cập nhật trạng thái Status = 0 (Xóa mềm)
        String sql = "UPDATE Students SET Status = 0 WHERE StudentID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentID);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<UserInfo> getActiveParents() {
        List<UserInfo> list = new ArrayList<>();

        String sql = "SELECT u.UserID, u.Username, u.FullName, r.RoleName, u.Status "
                + "FROM Users u "
                + "JOIN Roles r ON u.RoleID = r.RoleID "
                + "WHERE r.RoleName = 'Parent' "
                + "AND u.Status = 1 "
                + "ORDER BY u.FullName";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                UserInfo parent = new UserInfo(
                        rs.getInt("UserID"),
                        rs.getString("Username"),
                        rs.getString("FullName"),
                        rs.getString("RoleName"),
                        rs.getBoolean("Status")
                );

                list.add(parent);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Student> getStudentsByParent(int parentID) {
        List<Student> list = new ArrayList<>();

        String sql = "SELECT s.StudentID, s.StudentCode, s.StudentName, s.DateOfBirth, "
                + "s.Gender, s.ClassID, c.ClassName, l.LevelName, "
                + "ISNULL(s.ParentID, 0) AS ParentID, "
                + "ISNULL(p.FullName, N'Chưa có phụ huynh') AS ParentName, "
                + "s.Status AS StudentStatus "
                + "FROM Students s "
                + "JOIN Classes c ON s.ClassID = c.ClassID "
                + "JOIN Levels l ON c.LevelID = l.LevelID "
                + "LEFT JOIN Users p ON s.ParentID = p.UserID "
                + "WHERE s.ParentID = ? "
                + "AND s.Status = 1 "
                + "ORDER BY s.StudentName";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, parentID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Student student = new Student(
                            rs.getInt("StudentID"),
                            rs.getString("StudentCode"),
                            rs.getString("StudentName"),
                            rs.getDate("DateOfBirth"),
                            rs.getBoolean("Gender"),
                            rs.getInt("ClassID"),
                            rs.getString("ClassName"),
                            rs.getString("LevelName"),
                            rs.getInt("ParentID"),
                            rs.getString("ParentName"),
                            rs.getBoolean("StudentStatus")
                    );

                    list.add(student);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Student> getStudentsByClass(int classID) {
        List<Student> list = new ArrayList<>();

        String sql = "SELECT s.StudentID, s.StudentCode, s.StudentName, s.DateOfBirth, "
                + "s.Gender, s.ClassID, c.ClassName, l.LevelName, "
                + "ISNULL(s.ParentID, 0) AS ParentID, "
                + "ISNULL(p.FullName, N'Chưa có phụ huynh') AS ParentName, "
                + "s.Status AS StudentStatus "
                + "FROM Students s "
                + "JOIN Classes c ON s.ClassID = c.ClassID "
                + "JOIN Levels l ON c.LevelID = l.LevelID "
                + "LEFT JOIN Users p ON s.ParentID = p.UserID "
                + "WHERE s.ClassID = ? "
                + "AND s.Status = 1 "
                + "ORDER BY s.StudentName";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, classID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Student student = new Student(
                            rs.getInt("StudentID"),
                            rs.getString("StudentCode"),
                            rs.getString("StudentName"),
                            rs.getDate("DateOfBirth"),
                            rs.getBoolean("Gender"),
                            rs.getInt("ClassID"),
                            rs.getString("ClassName"),
                            rs.getString("LevelName"),
                            rs.getInt("ParentID"),
                            rs.getString("ParentName"),
                            rs.getBoolean("StudentStatus")
                    );

                    list.add(student);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean isStudentOfParent(int studentID, int parentID) {
        String sql = "SELECT COUNT(*) AS Total FROM Students "
                + "WHERE StudentID = ? AND ParentID = ? AND Status = 1";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentID);
            ps.setInt(2, parentID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("Total") > 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
