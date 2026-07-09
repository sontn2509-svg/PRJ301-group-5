package com.mycompany.kindergartenkitchen.service.impl;

import com.mycompany.kindergartenkitchen.dao.MenuDao;
import com.mycompany.kindergartenkitchen.dao.MenuDetailDao;
import com.mycompany.kindergartenkitchen.dao.impl.MenuDaoImpl;
import com.mycompany.kindergartenkitchen.dao.impl.MenuDetailDaoImpl;
import com.mycompany.kindergartenkitchen.model.Menu;
import com.mycompany.kindergartenkitchen.model.MenuDetail;
import com.mycompany.kindergartenkitchen.service.MenuDetailService;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

public class MenuDetailServiceImpl implements MenuDetailService {

    private final MenuDetailDao menuDetailDao;
    private final MenuDao menuDao;

    public MenuDetailServiceImpl() {
        this.menuDetailDao = new MenuDetailDaoImpl();
        this.menuDao = new MenuDaoImpl();
    }

    MenuDetailServiceImpl(MenuDetailDao menuDetailDao, MenuDao menuDao) {
        this.menuDetailDao = menuDetailDao;
        this.menuDao = menuDao;
    }

    @Override
    public List<MenuDetail> getByMenuId(int menuId) throws SQLException {
        return menuDetailDao.findByMenuId(menuId);
    }

    @Override
    public boolean addDish(int menuId, Date menuDate, int mealTypeId, int dishId) throws SQLException {
        Menu menu = menuDao.findById(menuId);
        if (menu == null) {
            return false;
        }
        if (menuDate.before(menu.getWeekStartDate()) || menuDate.after(menu.getWeekEndDate())) {
            return false;
        }
        if (menuDetailDao.exists(menuId, menuDate, mealTypeId, dishId)) {
            return false;
        }

        MenuDetail menuDetail = new MenuDetail(0, menuId, menuDate, mealTypeId, dishId);
        return menuDetailDao.insert(menuDetail) > 0;
    }

    @Override
    public boolean removeDish(int menuDetailId) throws SQLException {
        return menuDetailDao.deleteById(menuDetailId);
    }
}
