package controller;
import util.DBUtil;
import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class DonateServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        int userId = (int) session.getAttribute("userId");
        String donorName = req.getParameter("donor_name");
        double amount = Double.parseDouble(req.getParameter("amount"));
        java.sql.Date date = java.sql.Date.valueOf(req.getParameter("date"));

        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
              "INSERT INTO donations (user_id, donor_name, amount, donation_date) VALUES (?, ?, ?, ?)");
            ps.setInt(1, userId);
            ps.setString(2, donorName);
            ps.setDouble(3, amount);
            ps.setDate(4, date);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect("dashboard.jsp");
    }
}
