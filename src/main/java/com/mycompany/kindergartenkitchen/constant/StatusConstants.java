package com.mycompany.kindergartenkitchen.constant;

/*
  Cac hang so ve Status (Trang thai tai khoan nguoi dung).
 */
public final class StatusConstants {

    private StatusConstants() {
    }

    public static final int PENDING = 0;
    public static final int ACTIVE = 1;
    public static final int BLOCKED = 2;

    public static final String PENDING_TEXT = "Cho xac nhan";
    public static final String ACTIVE_TEXT = "Hoat dong";
    public static final String BLOCKED_TEXT = "Bi khoa";

    public static String getStatusText(int status) {
        return switch (status) {
            case PENDING -> PENDING_TEXT;
            case ACTIVE -> ACTIVE_TEXT;
            case BLOCKED -> BLOCKED_TEXT;
            default -> "Khong xac dinh";
        };
    }
}
