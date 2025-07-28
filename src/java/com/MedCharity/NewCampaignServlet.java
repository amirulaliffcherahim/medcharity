package com.MedCharity;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;

public class NewCampaignServlet extends HttpServlet 
{@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.sendRedirect("campaign.jsp");
}
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String goalStr = request.getParameter("goal");
        String endDateStr = request.getParameter("endDate");
        String image = request.getParameter("image"); // Assuming a text/image name input

        if (title == null || description == null || goalStr == null || endDateStr == null ||
            title.isEmpty() || description.isEmpty() || goalStr.isEmpty() || endDateStr.isEmpty()) {
            response.sendRedirect("campaign.jsp?error=Missing+required+fields");
            return;
        }

        double goal;
        try {
            goal = Double.parseDouble(goalStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("campaign.jsp?error=Invalid+goal+amount");
            return;
        }

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            try (Connection conn = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/MedCharity", "mcadmin", "admin123");
                 PreparedStatement stmt = conn.prepareStatement(
                         "INSERT INTO campaigns (user_id, category_id, title, description, goal_amount, created_at, end_date, status, active, image) VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP, ?, 'active', true, ?)")) {

                stmt.setInt(1, 1); // Hardcoded user_id (replace with session user if needed)
                stmt.setInt(2, 1); // Hardcoded category_id (or add as form input)
                stmt.setString(3, title);
                stmt.setString(4, description);
                stmt.setDouble(5, goal);
                stmt.setDate(6, Date.valueOf(LocalDate.parse(endDateStr)));
                stmt.setString(7, image != null ? image : "default.jpg");

                stmt.executeUpdate();
            }
            response.sendRedirect("campaign.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("campaign.jsp?error=Database+error");
        }
    }


}
