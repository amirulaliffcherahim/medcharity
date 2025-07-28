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

public class PurchaseServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        List<Map<String, Object>> purchases = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection()) {
            // Fetch purchases
            // Note: This query assumes a simplified `Purchase` table.
            // A more complete implementation would likely involve a `PurchaseItem` table
            // and more complex joins to get product details for each purchase.
            // For this example, we'll simulate some product details directly in the servlet.
            PreparedStatement ps = conn.prepareStatement(
                "SELECT purchase_id, purchase_date, total_amount FROM Purchase WHERE user_id = ? ORDER BY purchase_date DESC"
            );
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> purchase = new HashMap<>();
                purchase.put("purchaseId", rs.getInt("purchase_id"));
                purchase.put("purchaseDate", rs.getDate("purchase_date"));
                purchase.put("totalAmount", rs.getDouble("total_amount"));
                
                // Simulate items for demonstration. In a real app, this would be fetched from a PurchaseItem table.
                List<Map<String, Object>> items = new ArrayList<>();
                Map<String, Object> item1 = new HashMap<>();
                item1.put("productName", "First Aid Kit");
                item1.put("price", 89.50);
                item1.put("quantity", 1);
                item1.put("imageUrl", "https://via.placeholder.com/60/4361ee/ffffff?text=FAK"); // Placeholder image
                items.add(item1);

                Map<String, Object> item2 = new HashMap<>();
                item2.put("productName", "Bandages (Box)");
                item2.put("price", 15.00);
                item2.put("quantity", 2);
                item2.put("imageUrl", "https://via.placeholder.com/60/4895ef/ffffff?text=Band"); // Placeholder image
                items.add(item2);

                purchase.put("items", items);
                // Simulate donation for demonstration
                purchase.put("donationAmount", 5.00); // Example fixed donation

                purchases.add(purchase);
            }

            request.setAttribute("purchases", purchases);
        } catch (Exception e) {
            e.printStackTrace();
            // Handle error, maybe set an error message
            request.setAttribute("error", "Error fetching purchases: " + e.getMessage());
        }

        request.getRequestDispatcher("purchase.jsp").forward(request, response);
    }
}