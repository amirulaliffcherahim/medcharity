package com.MedCharity;

import com.MedCharity.CampaignDAO;
import com.MedCharity.Campaign;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class DonateServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CampaignDAO campaignDAO = new CampaignDAO();
        List<Campaign> campaigns = campaignDAO.getAllCampaigns();

        request.setAttribute("campaigns", campaigns);
        request.getRequestDispatcher("donate.jsp").forward(request, response);
    }
    
    private static final String URL = "jdbc:derby://localhost:1527/MedCharity";
    private static final String USER = "mcadmin";
    private static final String PASSWORD = "admin123";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userEmail = (String) request.getSession().getAttribute("userEmail");
        if (userEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String campaignIdStr = request.getParameter("campaignId");
        String amountStr = request.getParameter("amount");
        String anonymousStr = request.getParameter("anonymous");

        if (campaignIdStr == null || amountStr == null || campaignIdStr.isEmpty() || amountStr.isEmpty()) {
            response.sendRedirect("donate.jsp?error=Missing+input");
            return;
        }

        int campaignId = Integer.parseInt(campaignIdStr);
        double amount = Double.parseDouble(amountStr);
        boolean anonymous = (anonymousStr != null && anonymousStr.equals("on"));

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD)) {
                // Get user ID by email
                int userId = -1;
                try (PreparedStatement stmt = conn.prepareStatement("SELECT user_id FROM users WHERE email = ?")) {
                    stmt.setString(1, userEmail);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        userId = rs.getInt("user_id");
                    }
                }

                if (userId == -1) {
                    response.sendRedirect("donate.jsp?error=User+not+found");
                    return;
                }

                // Insert donation
                try (PreparedStatement stmt = conn.prepareStatement(
                        "INSERT INTO donations (user_id, campaign_id, amount, anonymous, donation_date) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)"
                )) {
                    stmt.setInt(1, userId);
                    stmt.setInt(2, campaignId);
                    stmt.setDouble(3, amount);
                    stmt.setBoolean(4, anonymous);
                    stmt.executeUpdate();
                }
            }

            response.sendRedirect("donate-success.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("donate.jsp?error=Internal+error");
        }
    }
}
