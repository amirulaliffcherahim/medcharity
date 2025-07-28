package controller;

import util.DBUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class CampaignServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Map<String, Object>> campaigns = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT c.campaign_id, c.title, c.description, c.goal_amount, c.start_date, c.end_date, " +
                "c.status, c.is_urgent, c.campaign_image, cat.name as category_name, " +
                "(SELECT COALESCE(SUM(amount), 0) FROM Donation WHERE campaign_id = c.campaign_id) AS current_amount " +
                "FROM Campaign c JOIN Category cat ON c.category_id = cat.category_id " +
                "WHERE c.status = 'active' ORDER BY c.is_urgent DESC, c.end_date ASC"
            ); // Assuming 'Category' table exists and is joined

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> campaign = new HashMap<>();
                campaign.put("campaignId", rs.getInt("campaign_id"));
                campaign.put("title", rs.getString("title"));
                campaign.put("description", rs.getString("description"));
                double goalAmount = rs.getDouble("goal_amount");
                campaign.put("goalAmount", goalAmount);
                campaign.put("startDate", rs.getDate("start_date"));
                
                // Calculate days left
                LocalDate endDate = rs.getDate("end_date").toLocalDate();
                LocalDate now = LocalDate.now();
                long daysLeft = ChronoUnit.DAYS.between(now, endDate);
                campaign.put("endDate", endDate);
                campaign.put("daysLeft", daysLeft > 0 ? daysLeft : 0); // Don't show negative days

                campaign.put("status", rs.getString("status"));
                campaign.put("urgent", rs.getBoolean("is_urgent"));
                campaign.put("campaignImage", rs.getString("campaign_image"));
                campaign.put("categoryName", rs.getString("category_name"));
                
                double currentAmount = rs.getDouble("current_amount");
                campaign.put("currentAmount", currentAmount);
                
                double progressPercent = (goalAmount > 0) ? (currentAmount / goalAmount) * 100 : 0;
                campaign.put("progressPercent", Math.min(progressPercent, 100)); // Cap at 100%

                campaigns.add(campaign);
            }

            request.setAttribute("campaigns", campaigns);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching campaigns: " + e.getMessage());
        }

        request.getRequestDispatcher("campaign.jsp").forward(request, response);
    }
}