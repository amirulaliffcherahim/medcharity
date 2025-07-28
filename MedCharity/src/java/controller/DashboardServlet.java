package controller;

import util.DBUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Map<String, Object> dashboardStats = new HashMap<>();
        List<Map<String, Object>> recentCampaigns = new ArrayList<>();
        List<Map<String, Object>> recentActivity = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection()) {
            // --- Fetch Dashboard Stats ---
            // Total Donations
            PreparedStatement ps1 = conn.prepareStatement("SELECT COALESCE(SUM(amount), 0) AS total_donations FROM donations");
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                dashboardStats.put("totalDonations", rs1.getDouble("total_donations"));
            }

            // Active Campaigns
            PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) AS active_campaigns FROM Campaign WHERE status = 'active'");
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) {
                dashboardStats.put("activeCampaigns", rs2.getInt("active_campaigns"));
            }

            // Registered Users
            PreparedStatement ps3 = conn.prepareStatement("SELECT COUNT(*) AS total_users FROM users WHERE role = 'donor'");
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) {
                dashboardStats.put("totalUsers", rs3.getInt("total_users"));
            }

            // Total Purchases (if you have a purchases table)
            PreparedStatement ps4 = conn.prepareStatement("SELECT COALESCE(SUM(total_amount), 0) AS total_purchases FROM Purchase");
            ResultSet rs4 = ps4.executeQuery();
            if (rs4.next()) {
                dashboardStats.put("totalPurchases", rs4.getDouble("total_purchases"));
            }
            
            request.setAttribute("dashboardStats", dashboardStats);

            // --- Fetch Recent Campaigns ---
            PreparedStatement psCampaigns = conn.prepareStatement(
                "SELECT c.campaign_id, c.title, c.goal_amount, c.campaign_image, c.end_date, " +
                "(SELECT COALESCE(SUM(amount), 0) FROM Donation WHERE campaign_id = c.campaign_id) AS current_amount " +
                "FROM Campaign c WHERE c.status = 'active' ORDER BY c.end_date ASC LIMIT 3"
            );
            ResultSet rsCampaigns = psCampaigns.executeQuery();
            while (rsCampaigns.next()) {
                Map<String, Object> campaign = new HashMap<>();
                campaign.put("title", rsCampaigns.getString("title"));
                campaign.put("goalAmount", rsCampaigns.getDouble("goal_amount"));
                campaign.put("campaignImage", rsCampaigns.getString("campaign_image"));
                
                double currentAmount = rsCampaigns.getDouble("current_amount");
                double goalAmount = rsCampaigns.getDouble("goal_amount");
                double progressPercent = (goalAmount > 0) ? (currentAmount / goalAmount) * 100 : 0;
                campaign.put("progressPercent", Math.min(progressPercent, 100)); // Cap at 100%
                recentCampaigns.add(campaign);
            }
            request.setAttribute("recentCampaigns", recentCampaigns);

            // --- Fetch Recent Activity (Example - you'd fetch from donations, new campaigns etc.) ---
            // Example activity: recent donations
            PreparedStatement psActivity = conn.prepareStatement(
                "SELECT d.amount, d.donation_date, u.username, c.title as campaign_title " +
                "FROM donations d JOIN users u ON d.user_id = u.id " +
                "LEFT JOIN Campaign c ON d.campaign_id = c.campaign_id " +
                "ORDER BY d.donation_date DESC LIMIT 5"
            );
            ResultSet rsActivity = psActivity.executeQuery();
            while (rsActivity.next()) {
                Map<String, Object> activity = new HashMap<>();
                activity.put("iconClass", "fas fa-donate"); // Default icon for donation
                activity.put("title", "New Donation");
                String campaignTitle = rsActivity.getString("campaign_title");
                if (campaignTitle != null) {
                     activity.put("description", "RM " + rsActivity.getDouble("amount") + " donated to \"" + campaignTitle + "\"");
                } else {
                     activity.put("description", "RM " + rsActivity.getDouble("amount") + " donated by " + rsActivity.getString("username"));
                }
               
                // Calculate time ago (simple example)
                LocalDate donationDate = rsActivity.getDate("donation_date").toLocalDate();
                long daysAgo = ChronoUnit.DAYS.between(donationDate, LocalDate.now());
                if (daysAgo == 0) activity.put("timeAgo", "today");
                else if (daysAgo == 1) activity.put("timeAgo", "1 day ago");
                else activity.put("timeAgo", daysAgo + " days ago");

                recentActivity.add(activity);
            }
             // Add other types of activities (e.g., new campaigns created)
             // For example, you could fetch recent campaigns and add them as activity items too.
            request.setAttribute("recentActivity", recentActivity);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching dashboard data: " + e.getMessage());
        }

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}