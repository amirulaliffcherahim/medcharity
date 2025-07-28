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

public class ProfileServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        Map<String, Object> user = new HashMap<>();
        List<Map<String, Object>> donations = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection()) {
            // Fetch user details
            PreparedStatement psUser = conn.prepareStatement(
                "SELECT username, email, join_date, role FROM users WHERE id = ?"
            );
            psUser.setInt(1, userId);
            ResultSet rsUser = psUser.executeQuery();
            if (rsUser.next()) {
                user.put("username", rsUser.getString("username"));
                // Assuming email, join_date exist in your 'users' table or ERD
                user.put("email", "user@example.com"); // Placeholder, replace with actual column if exists
                user.put("joinDate", "January 1, 2023"); // Placeholder, replace with actual column if exists
                user.put("role", rsUser.getString("role"));
            }
            request.setAttribute("user", user);

            // Fetch user's donation history
            PreparedStatement psDonations = conn.prepareStatement(
                "SELECT d.amount, d.donation_date, d.is_anonymous, d.donor_name, c.title as campaign_title " +
                "FROM donations d LEFT JOIN Campaign c ON d.campaign_id = c.campaign_id " +
                "WHERE d.user_id = ? ORDER BY d.donation_date DESC LIMIT 5" // Limit to recent 5
            );
            psDonations.setInt(1, userId);
            ResultSet rsDonations = psDonations.executeQuery();
            while (rsDonations.next()) {
                Map<String, Object> donation = new HashMap<>();
                donation.put("amount", rsDonations.getDouble("amount"));
                donation.put("donationDate", rsDonations.getDate("donation_date"));
                donation.put("anonymous", rsDonations.getBoolean("is_anonymous"));
                donation.put("donorName", rsDonations.getString("donor_name"));
                donation.put("campaignTitle", rsDonations.getString("campaign_title"));
                donations.add(donation);
            }
            request.setAttribute("donations", donations);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching profile data: " + e.getMessage());
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    // You might add doPost methods for updating user info or password
    // protected void doPost(...) { ... }
}