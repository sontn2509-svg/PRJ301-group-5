package com.mycompany.kindergartenkitchen.util;

import java.text.DecimalFormat;

/**
 * Format số lượng nguyên liệu cho thân thiện: nếu đơn vị gốc là kg/lít mà số
 * quá nhỏ (dưới 1), tự đổi sang g/ml để dễ đọc hơn (VD "0.32 kg" -> "320 g").
 * Đơn vị khác (cái, hộp, quả...) giữ nguyên không đổi.
 */
public final class QuantityFormatter {

    private static final DecimalFormat WHOLE = new DecimalFormat("#,##0");
    private static final DecimalFormat DECIMAL = new DecimalFormat("#,##0.##");

    private QuantityFormatter() {
    }

    public static String format(double value, String unit) {
        if (unit == null) {
            return DECIMAL.format(value);
        }

        String normalizedUnit = unit.trim().toLowerCase();
        double absValue = Math.abs(value);
        String sign = value < 0 ? "-" : "";

        if (absValue > 0 && absValue < 1) {
            if (normalizedUnit.equals("kg")) {
                return sign + WHOLE.format(absValue * 1000) + " g";
            }
            if (normalizedUnit.equals("lít") || normalizedUnit.equals("lit") || normalizedUnit.equals("l")) {
                return sign + WHOLE.format(absValue * 1000) + " ml";
            }
        }

        return sign + DECIMAL.format(absValue) + " " + unit;
    }
}
