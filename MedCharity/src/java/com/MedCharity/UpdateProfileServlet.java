package com.MedCharity;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String email = (session != null) ? (String) session.getAttribute("userEmail") : null;

        if (email == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        try (Connection conn = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/MedCharity", "mcadmin", "admin123");
             PreparedStatement stmt = conn.prepareStatement(
                "UPDATE users SET first_name=?, last_name=?, phone=?, address=? WHERE email=?")) {

            stmt.setString(1, firstName);
            stmt.setString(2, lastName);
            stmt.setString(3, phone);
            stmt.setString(4, address);
            stmt.setString(5, email);
            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Update error: " + e.getMessage(), e);
        }

        response.sendRedirect("profile");
    }
}
