package com.mycompany.kindergartenkitchen.service.impl;

import com.mycompany.kindergartenkitchen.dao.MenuDao;
import com.mycompany.kindergartenkitchen.dao.MenuDetailDao;
import com.mycompany.kindergartenkitchen.dao.impl.MenuDaoImpl;
import com.mycompany.kindergartenkitchen.dao.impl.MenuDetailDaoImpl;
import com.mycompany.kindergartenkitchen.model.Menu;
import com.mycompany.kindergartenkitchen.service.MenuService;
import java.sql.Date;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;

public class MenuServiceImpl implements MenuService {

    private final MenuDao menuDao;
    private final MenuDetailDao menuDetailDao;

    public MenuServiceImpl() {
        this.menuDao = new MenuDaoImpl();
        this.menuDetailDao = new MenuDetailDaoImpl();
    }

    MenuServiceImpl(MenuDao menuDao, MenuDetailDao menuDetailDao) {
        this.menuDao = menuDao;
        this.menuDetailDao = menuDetailDao;
    }

    @Override
    public List<Menu> getAllMenu() throws SQLException {
        return menuDao.findAll();
    }

    @Override
    public List<Menu> getMenuByLevel(int levelId) throws SQLException {
        return menuDao.findByLevel(levelId);
    }

    @Override
    public Menu getById(int menuId) throws SQLException {
        return menuDao.findById(menuId);
    }

    @Override
    public Menu getPublishedMenuForDate(int levelId, Date anyDateInWeek) throws SQLException {
        Menu menu = menuDao.findByLevelAndDate(levelId, anyDateInWeek);
        if (menu != null && menu.isStatus()) {
            return menu;
        }
        return null;
    }

    @Override
    public int createWeeklyMenu(int levelId, Date weekStartDate, int createdBy) throws SQLException {
        LocalDate start = weekStartDate.toLocalDate();
        if (start.getDayOfWeek() != DayOfWeek.MONDAY) {
            return -1;
        }
        if (menuDao.findByLevelAndWeekStart(levelId, weekStartDate) != null) {
            return -1;
        }

        Date weekEndDate = Date.valueOf(start.plusDays(6));
        Menu menu = new Menu(0, levelId, weekStartDate, weekEndDate, createdBy, true);
        return menuDao.insert(menu);
    }

    @Override
    public boolean setStatus(int menuId, boolean status) throws SQLException {
        return menuDao.setStatus(menuId, status);
    }

    @Override
    public boolean deleteMenu(int menuId) throws SQLException {
        menuDetailDao.deleteByMenuId(menuId);
        return menuDao.delete(menuId);
    }
}
