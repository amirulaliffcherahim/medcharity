package com.MedCharity;

import java.sql.*;

public class DonationDAO {
    public static void saveDonation(String email, int campaignId, double amount, boolean anonymous, String message) throws Exception {
        Class.forName("org.apache.derby.jdbc.ClientDriver");

        try (Connection conn = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/MedCharity", "mcadmin", "admin123");
             PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO donations (user_email, campaign_id, amount, anonymous, message, donation_date) VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)"
             )
        ) {
            stmt.setString(1, email);
            stmt.setInt(2, campaignId);
            stmt.setDouble(3, amount);
            stmt.setBoolean(4, anonymous);
            stmt.setString(5, message);
            stmt.executeUpdate();
        }
    }
}
