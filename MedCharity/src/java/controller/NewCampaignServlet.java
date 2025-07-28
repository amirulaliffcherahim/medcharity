package controller;

import util.DBUtil;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.sql.Date; // Use java.sql.Date for database
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig; // For handling file uploads
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part; // For handling file uploads

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2 MB
    maxFileSize = 1024 * 1024 * 10,       // 10 MB
    maxRequestSize = 1024 * 1024 * 50     // 50 MB
)
public class NewCampaignServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Map<String, Object>> categories = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT category_id, name FROM Category ORDER BY name");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> category = new HashMap<>();
                category.put("id", rs.getInt("category_id"));
                category.put("name", rs.getString("name"));
                categories.add(category);
            }
            request.setAttribute("categories", categories);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading categories: " + e.getMessage());
        }
        request.getRequestDispatcher("newcampaign.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId"); // Campaign creator
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        double goalAmount = Double.parseDouble(request.getParameter("goalAmount"));
        String endDateStr = request.getParameter("endDate");
        boolean isUrgent = request.getParameter("isUrgent") != null; // Checkbox returns "on" if checked

        // Handle file upload
        String campaignImageFileName = null;
        try {
            Part filePart = request.getPart("campaignImage");
            if (filePart != null && filePart.getSize() > 0) {
                // Define the upload directory relative to the web application context
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "campaign_images";
                
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs(); // Create directories if they don't exist
                }
                
                campaignImageFileName = System.currentTimeMillis() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); // Ensure unique name
                String filePath = uploadPath + File.separator + campaignImageFileName;

                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, Paths.get(filePath));
                }
                campaignImageFileName = "uploads/campaign_images/" + campaignImageFileName; // Store relative path in DB
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error uploading image: " + e.getMessage());
            doGet(request, response); // Forward back to form with error
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            // Insert campaign data
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO Campaign (user_id, category_id, title, description, goal_amount, start_date, end_date, status, is_urgent, campaign_image) " +
                "VALUES (?, ?, ?, ?, ?, CURDATE(), ?, 'active', ?, ?)",
                Statement.RETURN_GENERATED_KEYS // To get the generated campaign_id if needed
            );
            ps.setInt(1, userId);
            ps.setInt(2, categoryId);
            ps.setString(3, title);
            ps.setString(4, description);
            ps.setDouble(5, goalAmount);
            ps.setDate(6, Date.valueOf(endDateStr)); // Convert String to java.sql.Date
            ps.setBoolean(7, isUrgent);
            ps.setString(8, campaignImageFileName); // Store the file path

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                // Optionally retrieve generated ID
                // ResultSet generatedKeys = ps.getGeneratedKeys();
                // if (generatedKeys.next()) {
                //     int newCampaignId = generatedKeys.getInt(1);
                // }
                request.setAttribute("success", "Campaign created successfully!");
                response.sendRedirect("CampaignServlet"); // Redirect to campaign list
            } else {
                request.setAttribute("error", "Failed to create campaign.");
                doGet(request, response); // Forward back to form with error
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            doGet(request, response); // Forward back to form with error
        }
    }
}