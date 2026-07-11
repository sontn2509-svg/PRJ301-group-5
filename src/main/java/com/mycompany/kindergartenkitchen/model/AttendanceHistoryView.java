package com.mycompany.kindergartenkitchen.model;

import java.sql.Date;

/**
 * DTO 1 dòng lịch sử điểm danh/ăn uống của con, dùng cho trang
 * parent/history.jsp.
 *
 * status: "present" | "absent_meal" | "absent"
 */
public class AttendanceHistoryView {

    private Date date;
    private String studentName;
    private String className;
    private String status;
    private String note;

    public AttendanceHistoryView() {
    }

    public AttendanceHistoryView(Date date, String studentName, String className, String status, String note) {
        this.date = date;
        this.studentName = studentName;
        this.className = className;
        this.status = status;
        this.note = note;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
