package com.mycompany.kindergartenkitchen.entity;

/*
  Model cho bang Roles.
  - RoleID = 1 luon la Admin
  - Cac role khac (2, 3, ...) se duoc trien khai boi module khac
 */
public class Role {
    private int roleId;
    private String roleName;

    public Role() {
    }

    public Role(int roleId, String roleName) {
        this.roleId = roleId;
        this.roleName = roleName;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }
}
