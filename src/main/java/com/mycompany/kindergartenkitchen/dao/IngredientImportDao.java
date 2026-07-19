package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.model.IngredientImport;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO Rules: bắt buộc sử dụng Interface.
 * Định nghĩa thao tác cho bảng IngredientImports (phiếu nhập kho).
 */
public interface IngredientImportDao {

    List<IngredientImport> findAll() throws SQLException;

    List<IngredientImport> findByDateRange(Date fromDate, Date toDate) throws SQLException;

    IngredientImport findById(int importId) throws SQLException;

    int insert(IngredientImport ingredientImport) throws SQLException;

    boolean update(IngredientImport ingredientImport) throws SQLException;

    boolean delete(int importId) throws SQLException;

    double sumTotalCostByDateRange(Date fromDate, Date toDate) throws SQLException;
}
