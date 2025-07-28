package com.MedCharity;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class SignupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address"); // optional
        String profileImage = null; 
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = "donor"; 

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/MedCharity", "mcadmin", "admin123")) {

            String checkEmailSQL = "SELECT email FROM users WHERE email = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkEmailSQL)) {
                checkStmt.setString(1, email);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("error", "Email already registered.");
                    request.getRequestDispatcher("signup.jsp").forward(request, response);
                    return;
                }
            }

            String insertSQL = "INSERT INTO users (first_name, last_name, email, password, phone, address, profile_image, role) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSQL)) {
                insertStmt.setString(1, firstName);
                insertStmt.setString(2, lastName);
                insertStmt.setString(3, email);
                insertStmt.setString(4, password);
                insertStmt.setString(5, phone);
                insertStmt.setString(6, address);
                insertStmt.setString(7, profileImage);
                insertStmt.setString(8, role);

                int rowsInserted = insertStmt.executeUpdate();
                if (rowsInserted > 0) {
                    response.sendRedirect("login.jsp");
                } else {
                    request.setAttribute("error", "Registration failed. Try again.");
                    request.getRequestDispatcher("signup.jsp").forward(request, response);
                }
            }

        } catch (SQLException e) {
            throw new ServletException("DB error: " + e.getMessage(), e);
        }
    }
}
