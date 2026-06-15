package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.model.Attendance;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import com.mycompany.kindergartenkitchen.model.MealHistory;
import com.mycompany.kindergartenkitchen.model.MealCount;

public class AttendanceDAO extends DBContext {

    public boolean reportAbsent(int studentID, Date attendanceDate, int reportedBy, String note) {
        if (isAttendanceExists(studentID, attendanceDate)) {
            return updateAbsenceReport(studentID, attendanceDate, reportedBy, note);
        }

        String sql = "INSERT INTO Attendance "
                + "(StudentID, AttendanceDate, Status, ReportedBy, ReportedTime, IsCharged, NotificationStatus, Note) "
                + "VALUES (?, ?, 'Absent', ?, ?, ?, 'Pending', ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentID);
            ps.setDate(2, attendanceDate);
            ps.setInt(3, reportedBy);
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            ps.setBoolean(5, calculateIsCharged(attendanceDate));
            ps.setString(6, note);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private boolean updateAbsenceReport(int studentID, Date attendanceDate, int reportedBy, String note) {
        String sql = "UPDATE Attendance "
                + "SET Status = 'Absent', "
                + "ReportedBy = ?, "
                + "ReportedTime = ?, "
                + "IsCharged = ?, "
                + "NotificationStatus = 'Pending', "
                + "Note = ? "
                + "WHERE StudentID = ? AND AttendanceDate = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, reportedBy);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setBoolean(3, calculateIsCharged(attendanceDate));
            ps.setString(4, note);
            ps.setInt(5, studentID);
            ps.setDate(6, attendanceDate);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private boolean isAttendanceExists(int studentID, Date attendanceDate) {
        String sql = "SELECT AttendanceID FROM Attendance "
                + "WHERE StudentID = ? AND AttendanceDate = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentID);
            ps.setDate(2, attendanceDate);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private boolean calculateIsCharged(Date attendanceDate) {
        LocalDate selectedDate = attendanceDate.toLocalDate();
        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now();

        if (selectedDate.isAfter(today)) {
            return false;
        }

        if (selectedDate.isEqual(today) && now.isBefore(LocalTime.of(7, 0))) {
            return false;
        }

        return true;
    }

    public List<Attendance> getAttendanceHistoryByParent(int parentID) {
        List<Attendance> list = new ArrayList<>();

        String sql = "SELECT a.AttendanceID, a.StudentID, s.StudentCode, s.StudentName, "
                + "c.ClassName, a.AttendanceDate, a.Status, "
                + "ISNULL(a.ReportedBy, 0) AS ReportedBy, "
                + "ISNULL(reporter.FullName, N'') AS ReportedByName, "
                + "a.ReportedTime, a.IsCharged, "
                + "ISNULL(a.ConfirmedBy, 0) AS ConfirmedBy, "
                + "ISNULL(confirmer.FullName, N'') AS ConfirmedByName, "
                + "a.ConfirmedTime, a.NotificationStatus, a.Note "
                + "FROM Attendance a "
                + "JOIN Students s ON a.StudentID = s.StudentID "
                + "JOIN Classes c ON s.ClassID = c.ClassID "
                + "LEFT JOIN Users reporter ON a.ReportedBy = reporter.UserID "
                + "LEFT JOIN Users confirmer ON a.ConfirmedBy = confirmer.UserID "
                + "WHERE s.ParentID = ? "
                + "ORDER BY a.AttendanceDate DESC, a.AttendanceID DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, parentID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAttendance(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    private Attendance mapAttendance(ResultSet rs) throws Exception {
        return new Attendance(
                rs.getInt("AttendanceID"),
                rs.getInt("StudentID"),
                rs.getString("StudentCode"),
                rs.getString("StudentName"),
                rs.getString("ClassName"),
                rs.getDate("AttendanceDate"),
                rs.getString("Status"),
                rs.getInt("ReportedBy"),
                rs.getString("ReportedByName"),
                rs.getTimestamp("ReportedTime"),
                rs.getBoolean("IsCharged"),
                rs.getInt("ConfirmedBy"),
                rs.getString("ConfirmedByName"),
                rs.getTimestamp("ConfirmedTime"),
                rs.getString("NotificationStatus"),
                rs.getString("Note")
        );
    }

    public List<Attendance> getAttendanceByClassAndDate(int classID, Date attendanceDate) {
        List<Attendance> list = new ArrayList<>();

        String sql = "SELECT "
                + "ISNULL(a.AttendanceID, 0) AS AttendanceID, "
                + "s.StudentID, s.StudentCode, s.StudentName, c.ClassName, "
                + "? AS AttendanceDate, "
                + "ISNULL(a.Status, '') AS Status, "
                + "ISNULL(a.ReportedBy, 0) AS ReportedBy, "
                + "ISNULL(reporter.FullName, N'') AS ReportedByName, "
                + "a.ReportedTime, "
                + "ISNULL(a.IsCharged, 1) AS IsCharged, "
                + "ISNULL(a.ConfirmedBy, 0) AS ConfirmedBy, "
                + "ISNULL(confirmer.FullName, N'') AS ConfirmedByName, "
                + "a.ConfirmedTime, "
                + "ISNULL(a.NotificationStatus, N'') AS NotificationStatus, "
                + "ISNULL(a.Note, N'') AS Note "
                + "FROM Students s "
                + "JOIN Classes c ON s.ClassID = c.ClassID "
                + "LEFT JOIN Attendance a ON s.StudentID = a.StudentID AND a.AttendanceDate = ? "
                + "LEFT JOIN Users reporter ON a.ReportedBy = reporter.UserID "
                + "LEFT JOIN Users confirmer ON a.ConfirmedBy = confirmer.UserID "
                + "WHERE s.ClassID = ? "
                + "AND s.Status = 1 "
                + "ORDER BY s.StudentName";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, attendanceDate);
            ps.setDate(2, attendanceDate);
            ps.setInt(3, classID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAttendance(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean markAttendance(int studentID, Date attendanceDate, String status, int teacherID, String note) {
        if (isAttendanceExists(studentID, attendanceDate)) {
            return updateAttendanceByTeacher(studentID, attendanceDate, status, teacherID, note);
        }

        String sql = "INSERT INTO Attendance "
                + "(StudentID, AttendanceDate, Status, ReportedBy, ReportedTime, IsCharged, "
                + "ConfirmedBy, ConfirmedTime, NotificationStatus, Note) "
                + "VALUES (?, ?, ?, ?, ?, 1, ?, ?, 'Confirmed', ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            Timestamp now = Timestamp.valueOf(LocalDateTime.now());

            ps.setInt(1, studentID);
            ps.setDate(2, attendanceDate);
            ps.setString(3, status);
            ps.setInt(4, teacherID);
            ps.setTimestamp(5, now);
            ps.setInt(6, teacherID);
            ps.setTimestamp(7, now);
            ps.setString(8, note);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private boolean updateAttendanceByTeacher(int studentID, Date attendanceDate, String status, int teacherID, String note) {
        String sql = "UPDATE Attendance "
                + "SET Status = ?, "
                + "ConfirmedBy = ?, "
                + "ConfirmedTime = ?, "
                + "NotificationStatus = 'Confirmed', "
                + "IsCharged = CASE WHEN ? = 'Present' THEN 1 ELSE IsCharged END, "
                + "Note = CASE WHEN ? IS NULL OR ? = '' THEN Note ELSE ? END "
                + "WHERE StudentID = ? AND AttendanceDate = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            Timestamp now = Timestamp.valueOf(LocalDateTime.now());

            ps.setString(1, status);
            ps.setInt(2, teacherID);
            ps.setTimestamp(3, now);
            ps.setString(4, status);
            ps.setString(5, note);
            ps.setString(6, note);
            ps.setString(7, note);
            ps.setInt(8, studentID);
            ps.setDate(9, attendanceDate);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean confirmAbsence(int attendanceID, int teacherID) {
        String sql = "UPDATE Attendance "
                + "SET ConfirmedBy = ?, "
                + "ConfirmedTime = ?, "
                + "NotificationStatus = 'Confirmed' "
                + "WHERE AttendanceID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, teacherID);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(3, attendanceID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<MealHistory> getMealHistoryByParent(int parentID) {
        List<MealHistory> list = new ArrayList<>();

        String sql = "SELECT "
                + "s.StudentID, "
                + "s.StudentName, "
                + "c.ClassName, "
                + "l.LevelName, "
                + "md.MenuDate, "
                + "mt.MealTypeName, "
                + "d.DishName, "
                + "ISNULL(a.Status, '') AS AttendanceStatus, "
                + "ISNULL(a.IsCharged, 1) AS IsCharged, "
                + "ISNULL(a.Note, N'') AS Note "
                + "FROM Students s "
                + "JOIN Classes c ON s.ClassID = c.ClassID "
                + "JOIN Levels l ON c.LevelID = l.LevelID "
                + "JOIN Menus m ON m.LevelID = l.LevelID "
                + "JOIN MenuDetails md ON m.MenuID = md.MenuID "
                + "JOIN MealTypes mt ON md.MealTypeID = mt.MealTypeID "
                + "JOIN Dishes d ON md.DishID = d.DishID "
                + "LEFT JOIN Attendance a ON a.StudentID = s.StudentID "
                + "AND a.AttendanceDate = md.MenuDate "
                + "WHERE s.ParentID = ? "
                + "AND s.Status = 1 "
                + "AND m.Status = 1 "
                + "ORDER BY md.MenuDate DESC, s.StudentName, mt.MealTypeID";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, parentID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MealHistory history = new MealHistory(
                            rs.getInt("StudentID"),
                            rs.getString("StudentName"),
                            rs.getString("ClassName"),
                            rs.getString("LevelName"),
                            rs.getDate("MenuDate"),
                            rs.getString("MealTypeName"),
                            rs.getString("DishName"),
                            rs.getString("AttendanceStatus"),
                            rs.getBoolean("IsCharged"),
                            rs.getString("Note")
                    );

                    list.add(history);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<MealCount> getMealCountByDate(Date attendanceDate) {
        List<MealCount> list = new ArrayList<>();

        String sql = "SELECT "
                + "? AS AttendanceDate, "
                + "c.ClassID, "
                + "c.ClassName, "
                + "l.LevelName, "
                + "COUNT(s.StudentID) AS PresentCount "
                + "FROM Attendance a "
                + "JOIN Students s ON a.StudentID = s.StudentID "
                + "JOIN Classes c ON s.ClassID = c.ClassID "
                + "JOIN Levels l ON c.LevelID = l.LevelID "
                + "WHERE a.AttendanceDate = ? "
                + "AND a.Status = 'Present' "
                + "AND s.Status = 1 "
                + "AND c.Status = 1 "
                + "GROUP BY c.ClassID, c.ClassName, l.LevelName "
                + "ORDER BY c.ClassName";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, attendanceDate);
            ps.setDate(2, attendanceDate);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MealCount mealCount = new MealCount(
                            rs.getDate("AttendanceDate"),
                            rs.getInt("ClassID"),
                            rs.getString("ClassName"),
                            rs.getString("LevelName"),
                            rs.getInt("PresentCount")
                    );

                    list.add(mealCount);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Attendance> getPresentStudentsByDate(Date attendanceDate) {
        List<Attendance> list = new ArrayList<>();

        String sql = "SELECT "
                + "a.AttendanceID, "
                + "a.StudentID, "
                + "s.StudentCode, "
                + "s.StudentName, "
                + "c.ClassName, "
                + "a.AttendanceDate, "
                + "a.Status, "
                + "ISNULL(a.ReportedBy, 0) AS ReportedBy, "
                + "ISNULL(reporter.FullName, N'') AS ReportedByName, "
                + "a.ReportedTime, "
                + "a.IsCharged, "
                + "ISNULL(a.ConfirmedBy, 0) AS ConfirmedBy, "
                + "ISNULL(confirmer.FullName, N'') AS ConfirmedByName, "
                + "a.ConfirmedTime, "
                + "a.NotificationStatus, "
                + "a.Note "
                + "FROM Attendance a "
                + "JOIN Students s ON a.StudentID = s.StudentID "
                + "JOIN Classes c ON s.ClassID = c.ClassID "
                + "LEFT JOIN Users reporter ON a.ReportedBy = reporter.UserID "
                + "LEFT JOIN Users confirmer ON a.ConfirmedBy = confirmer.UserID "
                + "WHERE a.AttendanceDate = ? "
                + "AND a.Status = 'Present' "
                + "AND s.Status = 1 "
                + "ORDER BY c.ClassName, s.StudentName";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, attendanceDate);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAttendance(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
