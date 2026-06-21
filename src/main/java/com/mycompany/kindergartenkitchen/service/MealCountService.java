package com.mycompany.kindergartenkitchen.service;

import com.mycompany.kindergartenkitchen.dao.AttendanceDAO;
import com.mycompany.kindergartenkitchen.model.Attendance;
import com.mycompany.kindergartenkitchen.model.LevelMealCount;
import com.mycompany.kindergartenkitchen.model.MealCount;
import java.sql.Date;
import java.util.List;

public class MealCountService {

    private final AttendanceDAO attendanceDAO = new AttendanceDAO();

    public List<MealCount> getMealCountByDate(Date attendanceDate) {
        return attendanceDAO.getMealCountByDate(attendanceDate);
    }

    public List<Attendance> getPresentStudentsByDate(Date attendanceDate) {
        return attendanceDAO.getPresentStudentsByDate(attendanceDate);
    }

    public List<LevelMealCount> getMealCountByLevel(Date attendanceDate) {
        return attendanceDAO.getMealCountByLevel(attendanceDate);
    }

    public int getTotalMealCount(Date attendanceDate) {
        List<MealCount> mealCounts = attendanceDAO.getMealCountByDate(attendanceDate);

        int total = 0;

        if (mealCounts != null) {
            for (MealCount mealCount : mealCounts) {
                total += mealCount.getMealCount();
            }
        }

        return total;
    }
}
