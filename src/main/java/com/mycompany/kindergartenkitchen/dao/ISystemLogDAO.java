package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.entity.SystemLog;

import java.sql.SQLException;
import java.util.List;

/*
  Data Access Object Interface cho bang SystemLogs.
  Bat buoc su dung interface theo coding convention.
 */
public interface ISystemLogDAO {

    void create(Integer userId, String action, String tableName, Integer recordId, String description) throws SQLException;

    List<SystemLog> findLatest(String actionKeyword, int limit) throws SQLException;
}
