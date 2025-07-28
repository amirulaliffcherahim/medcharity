package com.MedCharity;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import javax.servlet.*;
import javax.servlet.http.*;

public class ProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/MedCharity", "mcadmin", "admin123")) {

            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT first_name, last_name, email, phone, address FROM users WHERE user_id = ?")) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("firstName", rs.getString("first_name"));
                    request.setAttribute("lastName", rs.getString("last_name"));
                    request.setAttribute("email", rs.getString("email"));
                    request.setAttribute("phone", rs.getString("phone"));
                    request.setAttribute("address", rs.getString("address"));
                }
            }

            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT COUNT(*) AS donation_count, COALESCE(SUM(amount), 0) AS total_given FROM donations WHERE user_id = ?")) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("donationCount", rs.getInt("donation_count"));
                    request.setAttribute("totalGiven", rs.getDouble("total_given"));
                }
            }

            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT COUNT(DISTINCT campaign_id) AS campaign_count FROM donations WHERE user_id = ?")) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("campaignCount", rs.getInt("campaign_count"));
                }
            }

            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT c.title, d.amount, d.donation_date " +
                    "FROM donations d JOIN campaigns c ON d.campaign_id = c.campaign_id " +
                    "WHERE d.user_id = ? ORDER BY d.donation_date DESC FETCH FIRST 5 ROWS ONLY")) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();

                ArrayList<String[]> donationList = new ArrayList<>();
                while (rs.next()) {
                    String[] data = {
                        rs.getString("title"),
                        String.format("RM %.2f", rs.getDouble("amount")),
                        rs.getTimestamp("donation_date").toString()
                    };
                    donationList.add(data);
                }
                request.setAttribute("recentDonations", donationList);
            }

        } catch (SQLException e) {
            throw new ServletException("DB error: " + e.getMessage(), e);
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}
