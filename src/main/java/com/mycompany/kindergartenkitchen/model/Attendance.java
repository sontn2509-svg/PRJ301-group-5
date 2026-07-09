/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.kindergartenkitchen.model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 *
 * @author VuongNguyen
 */
public class Attendance {

    private int attendanceID;
    private int studentID;
    private String studentCode;
    private String studentName;
    private String className;
    private Date attendanceDate;
    private String status;
    private int reportedBy;
    private String reportedByName;
    private Timestamp reportedTime;
    private boolean charged;
    private int confirmedBy;
    private String confirmedByName;
    private Timestamp confirmedTime;
    private String notificationStatus;
    private String note;

    public Attendance() {
    }

    public Attendance(int attendanceID, int studentID, String studentCode, String studentName,
            String className, Date attendanceDate, String status, int reportedBy,
            String reportedByName, Timestamp reportedTime, boolean charged,
            int confirmedBy, String confirmedByName, Timestamp confirmedTime,
            String notificationStatus, String note) {
        this.attendanceID = attendanceID;
        this.studentID = studentID;
        this.studentCode = studentCode;
        this.studentName = studentName;
        this.className = className;
        this.attendanceDate = attendanceDate;
        this.status = status;
        this.reportedBy = reportedBy;
        this.reportedByName = reportedByName;
        this.reportedTime = reportedTime;
        this.charged = charged;
        this.confirmedBy = confirmedBy;
        this.confirmedByName = confirmedByName;
        this.confirmedTime = confirmedTime;
        this.notificationStatus = notificationStatus;
        this.note = note;
    }

    public int getAttendanceID() {
        return attendanceID;
    }

    public void setAttendanceID(int attendanceID) {
        this.attendanceID = attendanceID;
    }

    public int getStudentID() {
        return studentID;
    }

    public void setStudentID(int studentID) {
        this.studentID = studentID;
    }

    public String getStudentCode() {
        return studentCode;
    }

    public void setStudentCode(String studentCode) {
        this.studentCode = studentCode;
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

    public Date getAttendanceDate() {
        return attendanceDate;
    }

    public void setAttendanceDate(Date attendanceDate) {
        this.attendanceDate = attendanceDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getReportedBy() {
        return reportedBy;
    }

    public void setReportedBy(int reportedBy) {
        this.reportedBy = reportedBy;
    }

    public String getReportedByName() {
        return reportedByName;
    }

    public void setReportedByName(String reportedByName) {
        this.reportedByName = reportedByName;
    }

    public Timestamp getReportedTime() {
        return reportedTime;
    }

    public void setReportedTime(Timestamp reportedTime) {
        this.reportedTime = reportedTime;
    }

    public boolean isCharged() {
        return charged;
    }

    public void setCharged(boolean charged) {
        this.charged = charged;
    }

    public int getConfirmedBy() {
        return confirmedBy;
    }

    public void setConfirmedBy(int confirmedBy) {
        this.confirmedBy = confirmedBy;
    }

    public String getConfirmedByName() {
        return confirmedByName;
    }

    public void setConfirmedByName(String confirmedByName) {
        this.confirmedByName = confirmedByName;
    }

    public Timestamp getConfirmedTime() {
        return confirmedTime;
    }

    public void setConfirmedTime(Timestamp confirmedTime) {
        this.confirmedTime = confirmedTime;
    }

    public String getNotificationStatus() {
        return notificationStatus;
    }

    public void setNotificationStatus(String notificationStatus) {
        this.notificationStatus = notificationStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getStatusText() {
        if ("Present".equalsIgnoreCase(status)) {
            return "Có mặt";
        }

        if ("Absent".equalsIgnoreCase(status)) {
            return "Vắng";
        }

        return status;
    }

    public String getChargedText() {
        return charged ? "Có tính tiền ăn" : "Không tính tiền ăn";
    }
}
