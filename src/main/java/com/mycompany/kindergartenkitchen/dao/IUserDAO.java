package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.entity.User;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/*
  Data Access Object Interface cho bang Users.
  Bat buoc su dung interface theo coding convention.
 */
public interface IUserDAO {

    Optional<User> authenticate(String username, String password) throws SQLException;

    List<User> search(String keyword, Integer roleId, Integer status) throws SQLException;

    Optional<User> findById(int id) throws SQLException;

    Optional<User> findForPasswordReset(String username, String email, String phone) throws SQLException;

    int countAll() throws SQLException;

    int countActive() throws SQLException;

    int countBlocked() throws SQLException;

    int countPending() throws SQLException;

    int create(User user) throws SQLException;

    void update(User user, boolean changePassword) throws SQLException;

    void toggleStatus(int userId) throws SQLException;

    void resetPassword(int userId, String newPassword) throws SQLException;

    void delete(int userId) throws SQLException;

    boolean usernameExists(String username, Integer exceptUserId) throws SQLException;

    int countByRole(int roleId) throws SQLException;
}
