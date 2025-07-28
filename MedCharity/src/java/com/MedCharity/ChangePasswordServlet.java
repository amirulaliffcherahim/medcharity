package com.MedCharity;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || newPassword == null || confirmPassword == null ||
            currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("profile").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New passwords do not match.");
            request.getRequestDispatcher("profile").forward(request, response);
            return;
        }

        try (Connection conn = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/MedCharity", "mcadmin", "admin123")) {

            String checkQuery = "SELECT password FROM users WHERE user_id = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
                checkStmt.setInt(1, userId);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    String dbPassword = rs.getString("password");
                    if (!dbPassword.equals(currentPassword)) {
                        request.setAttribute("error", "Current password is incorrect.");
                        request.getRequestDispatcher("profile").forward(request, response);
                        return;
                    }
                } else {
                    request.setAttribute("error", "User not found.");
                    request.getRequestDispatcher("profile").forward(request, response);
                    return;
                }
            }

            String updateQuery = "UPDATE users SET password = ? WHERE user_id = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                updateStmt.setString(1, newPassword);
                updateStmt.setInt(2, userId);
                int rowsUpdated = updateStmt.executeUpdate();

                if (rowsUpdated > 0) {
                    request.setAttribute("message", "Password changed successfully.");
                } else {
                    request.setAttribute("error", "Failed to change password.");
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }

        request.getRequestDispatcher("profile").forward(request, response);
    }
}
