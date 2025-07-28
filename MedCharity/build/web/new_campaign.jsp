<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Check if user is logged in and is admin, otherwise redirect --%>
<%
    if (session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp"); // Or an unauthorized page
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Campaign | Medical Charity System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --secondary: #3f37c9;
            --accent: #4895ef;
            --light: #f8f9fa;
            --dark: #212529;
            --success: #4cc9f0;
            --white: #ffffff;
            --gray: #6c757d;
            --sidebar-width: 250px;
            --sidebar-collapsed: 80px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f5f7fa;
            color: var(--dark);
            display: flex;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* Sidebar Styles */
        .sidebar {
            width: var(--sidebar-width);
            background-color: var(--white);
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
            padding: 1.5rem 0;
            display: flex;
            flex-direction: column;
            transition: width 0.3s ease;
            position: fixed;
            height: 100%;
            overflow-y: auto;
        }

        .sidebar.collapsed {
            width: var(--sidebar-collapsed);
        }

        .sidebar-header {
            display: flex;
            align-items: center;
            padding: 0 1.5rem;
            margin-bottom: 2rem;
            gap: 1rem;
        }

        .sidebar-header .logo {
            font-size: 2rem;
            color: var(--primary);
            min-width: 40px; /* Ensure logo is visible when collapsed */
        }

        .sidebar-header .app-name {
            font-size: 1.4rem;
            font-weight: 600;
            color: var(--dark);
            white-space: nowrap;
            overflow: hidden;
            opacity: 1;
            transition: opacity 0.3s ease;
        }

        .sidebar.collapsed .app-name {
            opacity: 0;
            width: 0; /* Hide text */
            padding: 0;
        }

        .sidebar-menu {
            list-style: none;
            flex-grow: 1;
        }

        .sidebar-menu-item {
            margin-bottom: 0.5rem;
        }

        .sidebar-menu-item a {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.8rem 1.5rem;
            color: var(--dark);
            text-decoration: none;
            font-size: 1rem;
            font-weight: 500;
            transition: background-color 0.2s ease, color 0.2s ease;
            border-radius: 8px;
            margin: 0 1rem; /* Adjust for spacing */
        }

        .sidebar-menu-item a i {
            font-size: 1.1rem;
            color: var(--gray);
            transition: color 0.2s ease;
        }

        .sidebar-menu-item a.active,
        .sidebar-menu-item a:hover {
            background-color: var(--primary);
            color: var(--white);
        }

        .sidebar-menu-item a.active i,
        .sidebar-menu-item a:hover i {
            color: var(--white);
        }

        .sidebar-menu-item a span {
            white-space: nowrap;
            overflow: hidden;
            opacity: 1;
            transition: opacity 0.3s ease;
        }

        .sidebar.collapsed .sidebar-menu-item a span {
            opacity: 0;
            width: 0; /* Hide text */
        }

        /* Main Content Styles */
        .main-content {
            margin-left: var(--sidebar-width);
            flex-grow: 1;
            padding: 2rem;
            transition: margin-left 0.3s ease;
        }

        .main-content.shifted {
            margin-left: var(--sidebar-collapsed);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .menu-toggle {
            background: none;
            border: none;
            font-size: 1.5rem;
            color: var(--gray);
            cursor: pointer;
            padding: 0.5rem;
            border-radius: 5px;
            transition: background-color 0.2s ease;
        }

        .menu-toggle:hover {
            background-color: #e9ecef;
        }

        .page-title {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--dark);
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .notification-icon {
            position: relative;
            font-size: 1.3rem;
            color: var(--gray);
            cursor: pointer;
        }

        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background-color: var(--accent);
            color: var(--white);
            font-size: 0.7rem;
            border-radius: 50%;
            padding: 0.2em 0.5em;
            line-height: 1;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            cursor: pointer;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--primary);
            color: var(--white);
            display: flex;
            justify-content: center;
            align-items: center;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .user-info .user-name {
            font-weight: 600;
            color: var(--dark);
        }

        .user-info .user-role {
            font-size: 0.85rem;
            color: var(--gray);
        }

        /* Form specific styles */
        .form-container {
            background-color: var(--white);
            padding: 2.5rem;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            max-width: 800px;
            margin: 0 auto; /* Center the form */
        }

        .form-container h2 {
            font-size: 2rem;
            color: var(--dark);
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.6rem;
            font-weight: 500;
            color: var(--dark);
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            color: var(--dark);
            transition: all 0.3s ease;
            outline: none;
        }

        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }

        .form-row {
            display: flex;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .form-row .form-group {
            flex: 1;
            margin-bottom: 0; /* Remove bottom margin for groups within a row */
        }

        .file-upload {
            border: 2px dashed #e0e0e0;
            border-radius: 8px;
            padding: 2rem;
            text-align: center;
            cursor: pointer;
            transition: border-color 0.3s ease, background-color 0.3s ease;
            position: relative;
            overflow: hidden; /* Hide the default file input */
        }

        .file-upload:hover {
            border-color: var(--primary);
            background-color: #f5f7fa;
        }

        .file-upload i {
            font-size: 3rem;
            color: var(--gray);
            margin-bottom: 0.8rem;
        }

        .file-upload p {
            font-size: 0.9rem;
            color: var(--gray);
            margin: 0;
        }

        .file-upload input[type="file"] {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }

        .form-footer {
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            padding: 0.8rem 1.5rem;
            font-size: 1rem;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background-color: var(--primary);
            color: var(--white);
            border: none;
        }

        .btn-primary:hover {
            background-color: var(--secondary);
        }

        .btn-outline {
            background-color: transparent;
            border: 1px solid var(--gray);
            color: var(--gray);
        }

        .btn-outline:hover {
            background-color: #e9ecef;
            color: var(--dark);
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .sidebar {
                width: var(--sidebar-collapsed);
            }
            .main-content {
                margin-left: var(--sidebar-collapsed);
            }
            .sidebar-header .app-name,
            .sidebar-menu-item a span {
                opacity: 0;
                width: 0;
            }
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
            .form-row {
                flex-direction: column;
                gap: 0; /* Remove gap for vertical stacking */
            }
            .form-row .form-group {
                margin-bottom: 1.5rem; /* Re-add margin for stacked groups */
            }
        }
    </style>
</head>
<body>
    <div class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="logo">
                <i class="fas fa-heartbeat"></i>
            </div>
            <span class="app-name">MedCharity</span>
        </div>
        <ul class="sidebar-menu">
            <li class="sidebar-menu-item">
                <a href="dashboard.jsp">
                    <i class="fas fa-th-large"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li class="sidebar-menu-item">
                <a href="campaign.jsp" class="active">
                    <i class="fas fa-bullhorn"></i>
                    <span>Campaigns</span>
                </a>
            </li>
            <li class="sidebar-menu-item">
                <a href="donate.jsp">
                    <i class="fas fa-hand-holding-heart"></i>
                    <span>Donate</span>
                </a>
            </li>
            <li class="sidebar-menu-item">
                <a href="purchase.jsp">
                    <i class="fas fa-shopping-bag"></i>
                    <span>Purchases</span>
                </a>
            </li>
            <li class="sidebar-menu-item">
                <a href="profile.jsp">
                    <i class="fas fa-user-circle"></i>
                    <span>Profile</span>
                </a>
            </li>
            <li class="sidebar-menu-item">
                <a href="logout.jsp">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </li>
            <c:if test="${sessionScope.role eq 'admin'}">
                <li class="sidebar-menu-item">
                    <a href="AdminServlet">
                        <i class="fas fa-user-shield"></i>
                        <span>Admin Panel</span>
                    </a>
                </li>
            </c:if>
        </ul>
    </div>

    <div class="main-content" id="mainContent">
        <div class="header">
            <div class="header-left">
                <button class="menu-toggle" id="menuToggle">
                    <i class="fas fa-bars"></i>
                </button>
                <h2 class="page-title">Create New Campaign</h2>
            </div>
            <div class="header-right">
                <div class="notification-icon">
                    <i class="fas fa-bell"></i>
                    <span class="notification-badge">3</span>
                </div>
                <div class="user-profile">
                    <div class="user-avatar">
                        <c:out value="${fn:substring(sessionScope.username, 0, 1).toUpperCase()}"/>
                    </div>
                    <div class="user-info">
                        <div class="user-name">${sessionScope.username}</div>
                        <div class="user-role">${sessionScope.role}</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="form-container">
            <h2>Start a New Charity Campaign</h2>
            <c:if test="${not empty error}">
                <div style="color: red; margin-bottom: 1rem; text-align: center;">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div style="color: green; margin-bottom: 1rem; text-align: center;">${success}</div>
            </c:if>
            <form action="NewCampaignServlet" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="campaignTitle">Campaign Title</label>
                    <input type="text" id="campaignTitle" name="title" class="form-control" placeholder="e.g., Medical aid for flood victims" required>
                </div>

                <div class="form-group">
                    <label for="category">Category</label>
                    <select id="category" name="categoryId" class="form-control" required>
                        <option value="">Select a category</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.id}">${category.name}</option>
                        </c:forEach>
                        <%-- Example static categories if no servlet fetches them --%>
                        <%-- <option value="1">Emergency Relief</option>
                        <option value="2">Disease Treatment</option>
                        <option value="3">Medical Equipment</option>
                        <option value="4">Healthcare Access</option> --%>
                    </select>
                </div>

                <div class="form-group">
                    <label for="campaignDescription">Campaign Description</label>
                    <textarea id="campaignDescription" name="description" class="form-control" rows="6" placeholder="Describe the campaign..." required></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="goalAmount">Goal Amount (MYR)</label>
                        <input type="number" id="goalAmount" name="goalAmount" class="form-control" placeholder="20000" min="100" required>
                    </div>
                    <div class="form-group">
                        <label for="endDate">End Date</label>
                        <input type="date" id="endDate" name="endDate" class="form-control" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Campaign Image</label>
                    <div class="file-upload">
                        <i class="fas fa-cloud-upload-alt"></i>
                        <p>Click to upload or drag and drop</p>
                        <p>Recommended size: 800x600px</p>
                        <input type="file" name="campaignImage" accept="image/*" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>
                        <input type="checkbox" name="isUrgent"> Mark as Urgent Campaign
                    </label>
                </div>

                <div class="form-footer">
                    <button type="button" class="btn btn-outline" onclick="window.history.back()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Create Campaign</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const menuToggle = document.getElementById('menuToggle');
            const sidebar = document.getElementById('sidebar');
            const mainContent = document.getElementById('mainContent');

            menuToggle.addEventListener('click', function() {
                sidebar.classList.toggle('collapsed');
                mainContent.classList.toggle('shifted');
            });
        });
    </script>
</body>
</html>