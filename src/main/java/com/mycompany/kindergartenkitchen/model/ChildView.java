package com.mycompany.kindergartenkitchen.model;

import java.sql.Date;

/**
 * DTO hiển thị thông tin 1 con của phụ huynh, dùng cho các trang
 * parent/my-children.jsp, parent/absences.jsp, parent/dashboard.jsp.
 *
 * todayStatus có thể là: "present", "absent_meal", "absent" hoặc null (chưa
 * điểm danh hôm nay).
 */
public class ChildView {

    private int studentId;
    private String studentCode;
    private String fullName;
    private String className;
    private Date dateOfBirth;
    private String todayStatus;

    public ChildView() {
    }

    public ChildView(int studentId, String studentCode, String fullName, String className, Date dateOfBirth, String todayStatus) {
        this.studentId = studentId;
        this.studentCode = studentCode;
        this.fullName = fullName;
        this.className = className;
        this.dateOfBirth = dateOfBirth;
        this.todayStatus = todayStatus;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getStudentCode() {
        return studentCode;
    }

    public void setStudentCode(String studentCode) {
        this.studentCode = studentCode;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getTodayStatus() {
        return todayStatus;
    }

    public void setTodayStatus(String todayStatus) {
        this.todayStatus = todayStatus;
    }
}
