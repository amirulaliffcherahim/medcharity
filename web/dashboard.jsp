<%@ page session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


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
    <title>Dashboard | Medical Charity System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style/dashboard.css"><!-- If using external CSS -->
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

        .user-name {
            font-weight: 500;
        }

        .notification-icon {
            position: relative;
            color: var(--gray);
            font-size: 1.2rem;
            cursor: pointer;
        }

        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background-color: var(--accent);
            color: white;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            font-size: 0.7rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Dashboard Cards */
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .card {
            background-color: var(--white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .card-header h3 {
            font-size: 1rem;
            color: var(--gray);
            font-weight: 500;
        }

        .card-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }

        .card-icon.donations {
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary);
        }

        .card-icon.campaigns {
            background-color: rgba(72, 149, 239, 0.1);
            color: var(--accent);
        }

        .card-icon.impact {
            background-color: rgba(76, 201, 240, 0.1);
            color: var(--success);
        }

        .card-icon.urgent {
            background-color: rgba(239, 71, 111, 0.1);
            color: #ef476f;
        }

        .card-body {
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--dark);
        }

        .card-footer {
            font-size: 0.85rem;
            color: var(--gray);
            display: flex;
            align-items: center;
        }

        .card-footer.positive {
            color: #06d6a0;
        }

        .card-footer.negative {
            color: #ef476f;
        }

        .card-footer i {
            margin-right: 5px;
            font-size: 0.7rem;
        }

        /* Recent Activity */
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

        .activity-list {
            background-color: var(--white);
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            overflow: hidden;
        }

        .activity-item {
            display: flex;
            padding: 1.2rem 1.5rem;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            transition: background-color 0.3s;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-item:hover {
            background-color: rgba(67, 97, 238, 0.03);
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            margin-right: 15px;
            flex-shrink: 0;
        }

        .activity-details {
            flex: 1;
        }

        .activity-title {
            font-weight: 500;
            margin-bottom: 0.3rem;
        }

        .activity-description {
            color: var(--gray);
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }

        .activity-meta {
            display: flex;
            font-size: 0.8rem;
            color: var(--gray);
        }

        .activity-time {
            display: flex;
            align-items: center;
        }

        .activity-time i {
            margin-right: 5px;
            font-size: 0.7rem;
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
            .cards {
                grid-template-columns: 1fr;
            }
            
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
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
        <h1>Dashboard Overview</h1>
        <div class="user-info">
            <span class="user-name">${sessionScope.userEmail}</span>
        </div>
    </div>

    <!-- Cards -->
    <div class="cards">
        <div class="card">
            <div class="card-header">
                <h3>Total Donations</h3>
                <div class="card-icon donations"><i class="fas fa-donate"></i></div>
            </div>
            <div class="card-body">$<c:out value="${totalDonations}" /></div>
            <div class="card-footer positive">
                <i class="fas fa-arrow-up"></i> Nice work!
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3>Active Campaigns</h3>
                <div class="card-icon campaigns"><i class="fas fa-heartbeat"></i></div>
            </div>
            <div class="card-body"><c:out value="${activeCampaigns}" /></div>
            <div class="card-footer positive">
                <i class="fas fa-plus"></i> Join one today
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3>Your Impact</h3>
                <div class="card-icon impact"><i class="fas fa-hands-helping"></i></div>
            </div>
            <div class="card-body"><c:out value="${livesTouched}" /></div>
            <div class="card-footer">lives touched</div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3>Urgent Needs</h3>
                <div class="card-icon urgent"><i class="fas fa-exclamation"></i></div>
            </div>
            <div class="card-body"><c:out value="${urgentCount}" /></div>
            <div class="card-footer negative">
                <i class="fas fa-clock"></i> Ending soon
            </div>
        </div>
    </div>

    <h2 class="section-title">
        <i class="fas fa-clock"></i> Recent Activity
    </h2>

    <div class="activity-list">
        <c:forEach var="act" items="${activities}">
            <div class="activity-item">
                <div class="activity-icon">
                    <i class="fas fa-donate"></i>
                </div>
                <div class="activity-details">
                    <h4 class="activity-title">${act.title}</h4>
                    <p class="activity-description">${act.description}</p>
                    <div class="activity-meta">
                        <div class="activity-time">
                            <i class="fas fa-clock"></i>
                            <fmt:formatDate value="${act.timestamp}" pattern="dd MMM yyyy HH:mm" />
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>
