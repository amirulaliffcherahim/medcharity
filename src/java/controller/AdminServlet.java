package controller;
import util.DBUtil;
import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AdminServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect("login.jsp");
            return;
        }
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
              "SELECT d.id, u.username, d.donor_name, d.amount, d.donation_date " +
              "FROM donations d JOIN users u ON d.user_id = u.id ORDER BY d.donation_date DESC");
            ResultSet rs = ps.executeQuery();
            List<Map<String,Object>> list = new ArrayList<>();
            while (rs.next()) {
                Map<String,Object> m = new HashMap<>();
                m.put("id", rs.getInt("id"));
                m.put("user", rs.getString("username"));
                m.put("donor", rs.getString("donor_name"));
                m.put("amt", rs.getDouble("amount"));
                m.put("date", rs.getDate("donation_date"));
                list.add(m);
            }
            req.setAttribute("records", list);
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.getRequestDispatcher("admin.jsp").forward(req, resp);
    }
}
