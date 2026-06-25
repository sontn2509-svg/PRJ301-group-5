package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.entity.Role;

import java.sql.SQLException;
import java.util.List;

/*
  Data Access Object Interface cho bang Roles.
  Bat buoc su dung interface theo coding convention.
 */
public interface IRoleDAO {

    List<Role> findAll() throws SQLException;
}
