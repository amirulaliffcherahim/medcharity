package com.MedCharity;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class DashboardServlet extends HttpServlet {

    public static class Activity {
        private String title;
        private String description;
        private Timestamp timestamp;

        public Activity(String title, String description, Timestamp timestamp) {
            this.title = title;
            this.description = description;
            this.timestamp = timestamp;
        }

        public String getTitle() {
            return title;
        }

        public String getDescription() {
            return description;
        }

        public Timestamp getTimestamp() {
            return timestamp;
        }
    }

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
                    "SELECT COALESCE(SUM(amount), 0) FROM donations WHERE user_id = ?")) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("totalDonations", rs.getDouble(1));
                }
            }

            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT COUNT(*) FROM campaigns WHERE status = 'active'")) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("activeCampaigns", rs.getInt(1));
                }
            }

            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT COUNT(DISTINCT campaign_id) FROM donations WHERE user_id = ?")) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("livesTouched", rs.getInt(1));
                }
            }

            try (PreparedStatement stmt = conn.prepareStatement(
                "SELECT COUNT(*) FROM campaigns WHERE status = 'active' AND end_date <= {fn TIMESTAMPADD(SQL_TSI_DAY, 3, CURRENT_DATE)}")) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("urgentCount", rs.getInt(1));
                }
            }

            List<Activity> activities = new ArrayList<>();
            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT c.title AS campaign_title, d.amount, d.donation_date " +
                    "FROM donations d JOIN campaigns c ON d.campaign_id = c.campaign_id " +
                    "WHERE d.user_id = ? ORDER BY d.donation_date DESC FETCH FIRST 5 ROWS ONLY")) {

                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    String title = "Donation Received";
                    String desc = "You donated RM " + rs.getDouble("amount") + " to \"" + rs.getString("campaign_title") + "\"";
                    Timestamp time = rs.getTimestamp("donation_date");
                    activities.add(new Activity(title, desc, time));
                }

                request.setAttribute("activities", activities);
            }

        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
