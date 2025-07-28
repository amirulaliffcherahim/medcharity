package com.MedCharity;

import java.sql.*;
import java.util.*;

public class CampaignDAO {

    private static final String URL = "jdbc:derby://localhost:1527/MedCharity";
    private static final String USER = "mcadmin";
    private static final String PASSWORD = "admin123";

    public static List<Campaign> getActiveCampaigns() {
        List<Campaign> list = new ArrayList<>();
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                 PreparedStatement stmt = conn.prepareStatement("SELECT campaign_id, title FROM campaigns WHERE status = 'active'");
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    Campaign c = new Campaign();
                    c.setCampaignId(rs.getInt("campaign_id"));
                    c.setTitle(rs.getString("title"));
                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Campaign> getAllCampaigns() {
        List<Campaign> list = new ArrayList<>();
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                 PreparedStatement stmt = conn.prepareStatement("SELECT * FROM campaigns");
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    Campaign c = new Campaign();
                    c.setCampaignId(rs.getInt("campaign_id"));
                    c.setTitle(rs.getString("title"));
                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
