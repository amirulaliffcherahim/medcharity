<%@ page session="true" %>
<%@ page import="java.util.ArrayList" %>
<%
    String email = (String) session.getAttribute("userEmail");
    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Profile | Medical Charity System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style/dashboard.css">
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
            box-shadow: 2px 0 15px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            height: 100vh;
            position: fixed;
            z-index: 100;
        }

        .sidebar.collapsed {
            width: var(--sidebar-collapsed);
        }

        .sidebar-header {
            padding: 1.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            height: 80px;
        }

        .logo {
            display: flex;
            align-items: center;
            color: var(--primary);
            font-size: 1.5rem;
            font-weight: 600;
            white-space: nowrap;
            overflow: hidden;
        }

        .logo i {
            font-size: 1.8rem;
            margin-right: 10px;
            background: linear-gradient(45deg, var(--primary), var(--accent));
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .logo-text {
            transition: opacity 0.3s;
        }

        .sidebar.collapsed .logo-text {
            opacity: 0;
            width: 0;
        }

        .toggle-btn {
            background: none;
            border: none;
            color: var(--gray);
            font-size: 1.2rem;
            cursor: pointer;
            transition: all 0.3s;
        }

        .toggle-btn:hover {
            color: var(--primary);
        }

        .sidebar-menu {
            list-style: none;
            padding: 1rem 0;
        }

        .sidebar-menu li a {
            display: flex;
            align-items: center;
            padding: 0.8rem 1.5rem;
            color: var(--dark);
            text-decoration: none;
            transition: all 0.3s;
            white-space: nowrap;
            overflow: hidden;
        }

        .sidebar-menu li a:hover {
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary);
        }

        .sidebar-menu li a.active {
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary);
            border-left: 3px solid var(--primary);
        }

        .sidebar-menu li a i {
            font-size: 1.1rem;
            margin-right: 15px;
            width: 20px;
            text-align: center;
        }

        .sidebar.collapsed .sidebar-menu li a span {
            opacity: 0;
            width: 0;
        }

        /* Main Content Styles */
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            transition: margin-left 0.3s ease;
            padding: 1.5rem;
        }

        .sidebar.collapsed ~ .main-content {
            margin-left: var(--sidebar-collapsed);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .header h1 {
            color: var(--dark);
            font-size: 1.8rem;
            font-weight: 600;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-info img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        /* Profile Page Specific Styles */
        .profile-header {
            display: flex;
            align-items: center;
            margin-bottom: 2rem;
            background-color: var(--white);
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 2rem;
            border: 5px solid var(--white);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .profile-info h2 {
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
            color: var(--dark);
        }

        .profile-info p {
            color: var(--gray);
            margin-bottom: 1rem;
        }

        .profile-stats {
            display: flex;
            gap: 2rem;
        }

        .stat-item {
            text-align: center;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 0.3rem;
        }

        .stat-label {
            font-size: 0.9rem;
            color: var(--gray);
        }

        /* Profile Sections */
        .profile-section {
            background-color: var(--white);
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.3rem;
            margin-bottom: 1.5rem;
            color: var(--dark);
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 10px;
            color: var(--primary);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--dark);
        }

        .form-control {
            width: 100%;
            padding: 0.8rem 1rem;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
        }

        .form-row {
            display: flex;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .form-row .form-group {
            flex: 1;
        }

        .btn {
            padding: 0.8rem 1.5rem;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
            font-size: 1rem;
        }

        .btn-primary {
            background: linear-gradient(to right, var(--primary), var(--secondary));
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(to right, var(--secondary), var(--primary));
            box-shadow: 0 5px 15px rgba(63, 55, 201, 0.3);
        }

        .btn-outline {
            background-color: transparent;
            border: 1px solid var(--primary);
            color: var(--primary);
        }

        .btn-outline:hover {
            background-color: rgba(67, 97, 238, 0.1);
        }

        .btn-danger {
            background-color: #ef476f;
            color: white;
        }

        .btn-danger:hover {
            background-color: #e0355f;
        }

        /* Recent Donations */
        .donation-item {
            display: flex;
            padding: 1rem;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.3s;
        }

        .donation-item:last-child {
            border-bottom: none;
        }

        .donation-item:hover {
            background-color: rgba(67, 97, 238, 0.03);
        }

        .donation-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: rgba(67, 97, 238, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            color: var(--primary);
            font-size: 1.2rem;
        }

        .donation-details {
            flex: 1;
        }

        .donation-title {
            font-weight: 500;
            margin-bottom: 0.3rem;
        }

        .donation-date {
            color: var(--gray);
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }

        .donation-amount {
            font-weight: 600;
            color: var(--primary);
        }

        /* Responsive */
        @media (max-width: 992px) {
            .sidebar {
                width: var(--sidebar-collapsed);
            }
            
            .sidebar .logo-text,
            .sidebar .sidebar-menu li a span {
                opacity: 0;
                width: 0;
            }
            
            .main-content {
                margin-left: var(--sidebar-collapsed);
            }
        }

        @media (max-width: 768px) {
            .profile-header {
                flex-direction: column;
                text-align: center;
            }
            
            .profile-avatar {
                margin-right: 0;
                margin-bottom: 1.5rem;
            }
            
            .profile-stats {
                justify-content: center;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
        }

        @media (max-width: 480px) {
            .profile-stats {
                flex-direction: column;
                gap: 1rem;
            }
        }
                #toggle-password-form {
            display: none;
        }

        #toggle-password-form:checked ~ #password-form {
            display: block;
        }

        #password-form {
            display: none;
            margin-top: 1rem;
        }

        .password-form-group {
            margin-bottom: 1rem;
        }

        .password-form-group label {
            display: block;
            margin-bottom: 0.5rem;
        }

        .password-form-group input {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

    </style>
</head>
<body>
<div class="sidebar">
    <div class="sidebar-header">
        <div class="logo">
            <i class="fas fa-heartbeat"></i>
            <span class="logo-text">MedCharity</span>
        </div>
    </div>
    <ul class="sidebar-menu">
        <li><a href="dashboard" class="active"><i class="fas fa-home"></i> <span>Dashboard</span></a></li>
        <li><a href="campaign.jsp"><i class="fas fa-hand-holding-heart"></i> <span>Campaigns</span></a></li>
        <li><a href="donate"><i class="fas fa-donate"></i> <span>Donate</span></a></li>
        <li><a href="purchase.jsp"><i class="fas fa-shopping-cart"></i> <span>Purchases</span></a></li>
        <li><a href="profile"><i class="fas fa-user"></i> <span>Profile</span></a></li>
    </ul>
</div>

<div class="main-content">
    <div class="header">
        <h1>My Profile</h1>
        <div class="user-info">
            <span><%= request.getAttribute("firstName") %> <%= request.getAttribute("lastName") %></span>
        </div>
    </div>

    <div class="profile-header">
        <div class="profile-info">
            <h2><%= request.getAttribute("firstName") %> <%= request.getAttribute("lastName") %></h2>
            <p><%= request.getAttribute("email") %></p>
            <div class="profile-stats">
                <div class="stat-item">
                    <div class="stat-value"><%= request.getAttribute("donationCount") %></div>
                    <div class="stat-label">Donations</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">RM <%= request.getAttribute("totalGiven") %></div>
                    <div class="stat-label">Total Given</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value"><%= request.getAttribute("campaignCount") %></div>
                    <div class="stat-label">Campaigns</div>
                </div>
            </div>
        </div>
    </div>

    <div class="profile-section">
        <h3 class="section-title"><i class="fas fa-user-circle"></i> Personal Information</h3>
        <form method="post" action="updateProfile">
            <div class="form-row">
                <div class="form-group">
                    <label>First Name</label>
                    <input type="text" name="firstName" class="form-control" value="<%= request.getAttribute("firstName") %>">
                </div>
                <div class="form-group">
                    <label>Last Name</label>
                    <input type="text" name="lastName" class="form-control" value="<%= request.getAttribute("lastName") %>">
                </div>
            </div>
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" class="form-control" value="<%= request.getAttribute("email") %>" readonly>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="tel" name="phone" class="form-control" value="<%= request.getAttribute("phone") %>">
                </div>
            </div>
            <div class="form-group">
                <label>Address</label>
                <textarea name="address" class="form-control" rows="3"><%= request.getAttribute("address") %></textarea>
            </div>
            <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                <button type="submit" class="btn btn-primary">Save Changes</button>
                <button type="reset" class="btn btn-outline">Cancel</button>
            </div>
        </form>
    </div>

    <div class="profile-section">
        <h3 class="section-title"><i class="fas fa-donate"></i> Recent Donations</h3>
        <div style="max-height: 400px; overflow-y: auto;">
            <%
                ArrayList<String[]> donations = (ArrayList<String[]>) request.getAttribute("recentDonations");
                if (donations != null && !donations.isEmpty()) {
                    for (String[] d : donations) {
            %>
                <div class="donation-item">
                    <div class="donation-icon"><i class="fas fa-hand-holding-heart"></i></div>
                    <div class="donation-details">
                        <div class="donation-title"><%= d[0] %></div>
                        <div class="donation-date"><%= d[2] %></div>
                        <div class="donation-amount"><%= d[1] %></div>
                    </div>
                </div>
            <%
                    }
                } else {
            %>
                <p>No donations found.</p>
            <%
                }
            %>
        </div>
        <div style="text-align: center; margin-top: 1.5rem;">
            <a href="donate" class="btn btn-outline" style="text-decoration: none;">View All Donations</a>
        </div>
    </div>

    <div class="profile-section">
        <h3 class="section-title"><i class="fas fa-cog"></i> Account Settings</h3>
        <div class="form-group">
            <label for="toggle-password-form">Change Password</label>
            <form method="post" action="changePassword">
                <input type="checkbox" id="toggle-password-form" style="display:none;">
                <label for="toggle-password-form" class="btn btn-outline" style="width: 100%;">
                    <i class="fas fa-lock"></i> Update Password
                </label>
                <div id="password-form">
                    <div class="password-form-group">
                        <label>Current Password</label>
                        <input type="password" name="currentPassword" required>
                    </div>
                    <div class="password-form-group">
                        <label>New Password</label>
                        <input type="password" name="newPassword" required>
                    </div>
                    <div class="password-form-group">
                        <label>Confirm New Password</label>
                        <input type="password" name="confirmPassword" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Change Password</button>
                </div>
            </form>
        </div>

        <div style="margin-top: 2rem;">
            <form method="post" action="logout">
                <button type="submit" class="btn btn-danger" style="width: 100%;">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </button>
            </form>
        </div>
    </div>
</div>
</body>
</html>