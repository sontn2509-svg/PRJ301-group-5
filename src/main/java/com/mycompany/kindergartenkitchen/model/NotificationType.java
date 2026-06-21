package com.mycompany.kindergartenkitchen.model;

/**
 * Hằng số dùng cho module Nguyên liệu - Thông báo.
 * Quy tắc đặt tên: UPPER_CASE.
 */
public final class NotificationType {

    public static final String ABSENCE_REPORT = "ABSENCE_REPORT";
    public static final String ATTENDANCE_UPDATE = "ATTENDANCE_UPDATE";
    public static final String INGREDIENT_IMPORT = "INGREDIENT_IMPORT";
    public static final String INGREDIENT_USAGE = "INGREDIENT_USAGE";
    public static final String MENU_UPDATE = "MENU_UPDATE";
    public static final String SYSTEM = "SYSTEM";

    private NotificationType() {
        /* Không cho khởi tạo */
    }
}
