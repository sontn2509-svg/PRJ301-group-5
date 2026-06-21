package com.mycompany.kindergartenkitchen.dao.impl;

import com.mycompany.kindergartenkitchen.config.DbConnection;
import com.mycompany.kindergartenkitchen.dao.IngredientImportDao;
import com.mycompany.kindergartenkitchen.model.IngredientImport;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation của IngredientImportDao.
 * Quản lý phiếu nhập kho nguyên liệu.
 */
public class IngredientImportDaoImpl implements IngredientImportDao {

    private static final String SQL_FIND_ALL
            = "SELECT ii.ImportID, ii.IngredientID, ii.Quantity, ii.UnitPrice, ii.TotalPrice, "
            + "ii.ImportDate, ii.SupplierName, ii.CreatedBy, ii.Note, "
            + "i.IngredientName, i.Unit, u.FullName AS CreatedByName "
            + "FROM IngredientImports ii "
            + "JOIN Ingredients i ON ii.IngredientID = i.IngredientID "
            + "JOIN Users u ON ii.CreatedBy = u.UserID "
            + "ORDER BY ii.ImportDate DESC";

    private static final String SQL_FIND_BY_DATE_RANGE
            = "SELECT ii.ImportID, ii.IngredientID, ii.Quantity, ii.UnitPrice, ii.TotalPrice, "
            + "ii.ImportDate, ii.SupplierName, ii.CreatedBy, ii.Note, "
            + "i.IngredientName, i.Unit, u.FullName AS CreatedByName "
            + "FROM IngredientImports ii "
            + "JOIN Ingredients i ON ii.IngredientID = i.IngredientID "
            + "JOIN Users u ON ii.CreatedBy = u.UserID "
            + "WHERE ii.ImportDate BETWEEN ? AND ? "
            + "ORDER BY ii.ImportDate DESC";

    private static final String SQL_FIND_BY_ID
            = "SELECT ii.ImportID, ii.IngredientID, ii.Quantity, ii.UnitPrice, ii.TotalPrice, "
            + "ii.ImportDate, ii.SupplierName, ii.CreatedBy, ii.Note, "
            + "i.IngredientName, i.Unit, u.FullName AS CreatedByName "
            + "FROM IngredientImports ii "
            + "JOIN Ingredients i ON ii.IngredientID = i.IngredientID "
            + "JOIN Users u ON ii.CreatedBy = u.UserID "
            + "WHERE ii.ImportID = ?";

    private static final String SQL_INSERT
            = "INSERT INTO IngredientImports "
            + "(IngredientID, Quantity, UnitPrice, ImportDate, SupplierName, CreatedBy, Note) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?)";

    private static final String SQL_DELETE
            = "DELETE FROM IngredientImports WHERE ImportID = ?";

    private static final String SQL_SUM_TOTAL_COST
            = "SELECT ISNULL(SUM(TotalPrice), 0) AS TotalCost "
            + "FROM IngredientImports WHERE ImportDate BETWEEN ? AND ?";

    @Override
    public List<IngredientImport> findAll() throws SQLException {
        List<IngredientImport> importList = new ArrayList<>();
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_ALL);
                ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                importList.add(mapResultSetToIngredientImport(resultSet));
            }
        }
        return importList;
    }

    @Override
    public List<IngredientImport> findByDateRange(Date fromDate, Date toDate) throws SQLException {
        List<IngredientImport> importList = new ArrayList<>();
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_DATE_RANGE)) {

            statement.setDate(1, fromDate);
            statement.setDate(2, toDate);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    importList.add(mapResultSetToIngredientImport(resultSet));
                }
            }
        }
        return importList;
    }

    @Override
    public IngredientImport findById(int importId) throws SQLException {
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_ID)) {

            statement.setInt(1, importId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToIngredientImport(resultSet);
                }
            }
        }
        return null;
    }

    @Override
    public int insert(IngredientImport ingredientImport) throws SQLException {
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(
                        SQL_INSERT, Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(1, ingredientImport.getIngredientId());
            statement.setDouble(2, ingredientImport.getQuantity());
            statement.setDouble(3, ingredientImport.getUnitPrice());
            statement.setDate(4, ingredientImport.getImportDate());
            statement.setString(5, ingredientImport.getSupplierName());
            statement.setInt(6, ingredientImport.getCreatedBy());
            statement.setString(7, ingredientImport.getNote());
            statement.executeUpdate();

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        }
        return -1;
    }

    @Override
    public boolean delete(int importId) throws SQLException {
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_DELETE)) {

            statement.setInt(1, importId);
            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public double sumTotalCostByDateRange(Date fromDate, Date toDate) throws SQLException {
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_SUM_TOTAL_COST)) {

            statement.setDate(1, fromDate);
            statement.setDate(2, toDate);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getDouble("TotalCost");
                }
            }
        }
        return 0;
    }

    private IngredientImport mapResultSetToIngredientImport(ResultSet resultSet) throws SQLException {
        IngredientImport ingredientImport = new IngredientImport();
        ingredientImport.setImportId(resultSet.getInt("ImportID"));
        ingredientImport.setIngredientId(resultSet.getInt("IngredientID"));
        ingredientImport.setQuantity(resultSet.getDouble("Quantity"));
        ingredientImport.setUnitPrice(resultSet.getDouble("UnitPrice"));
        ingredientImport.setTotalPrice(resultSet.getDouble("TotalPrice"));
        ingredientImport.setImportDate(resultSet.getDate("ImportDate"));
        ingredientImport.setSupplierName(resultSet.getString("SupplierName"));
        ingredientImport.setCreatedBy(resultSet.getInt("CreatedBy"));
        ingredientImport.setNote(resultSet.getString("Note"));
        ingredientImport.setIngredientName(resultSet.getString("IngredientName"));
        ingredientImport.setUnit(resultSet.getString("Unit"));
        ingredientImport.setCreatedByName(resultSet.getString("CreatedByName"));
        return ingredientImport;
    }
}
