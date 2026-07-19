/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.kindergartenkitchen.model;

/**
 *
 * @author VuongNguyen
 */
/**
 * UserInfo – thông tin tóm tắt người dùng (dùng trong dropdown giáo viên, phụ
 * huynh…)
 *
 * Lưu ý: thêm getUserID() và getUsername() để các JSP có thể gọi đúng tên
 * method.
 */
public class UserInfo {

    private int userID;
    private String username;
    private String fullName;
    private String roleName;
    private boolean status;

    public UserInfo() {
    }

    public UserInfo(int userID, String username, String fullName,
            String roleName, boolean status) {
        this.userID = userID;
        this.username = username;
        this.fullName = fullName;
        this.roleName = roleName;
        this.status = status;
    }

    // ─── Getters / Setters ────────────────────────────────────────────────
    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}
