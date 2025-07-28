<%@ page import="java.util.List" %>
<%@ page import="com.MedCharity.Campaign" %>
<%@ page session="true" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%
    String email = (String) session.getAttribute("userEmail");
    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }
List<Campaign> campaigns = (List<Campaign>) request.getAttribute("campaigns");
if (campaigns == null) campaigns = new java.util.ArrayList<Campaign>();

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donate | Medical Charity System</title>
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

        /* Sidebar Styles (same as dashboard) */
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

        /* Donation Form Styles */
        .donation-container {
            max-width: 600px;
            margin: 0 auto;
        }

        .donation-card {
            background-color: var(--white);
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .donation-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .donation-header h2 {
            font-size: 1.5rem;
            color: var(--dark);
            margin-bottom: 0.5rem;
        }

        .donation-header p {
            color: var(--gray);
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
            padding: 12px 15px;
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

        .input-group {
            position: relative;
        }

        .input-group .currency {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            font-weight: 500;
        }

        .input-group input {
            padding-left: 40px;
        }

        .amount-options {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-bottom: 1.5rem;
        }

        .amount-option {
            padding: 12px;
            text-align: center;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 500;
        }

        .amount-option:hover {
            border-color: var(--accent);
            color: var(--primary);
        }

        .amount-option.active {
            background-color: rgba(67, 97, 238, 0.1);
            border-color: var(--primary);
            color: var(--primary);
        }

        .payment-methods {
            margin-bottom: 1.5rem;
        }

        .payment-option {
            display: flex;
            align-items: center;
            padding: 12px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .payment-option:hover {
            border-color: var(--accent);
        }

        .payment-option.active {
            background-color: rgba(67, 97, 238, 0.1);
            border-color: var(--primary);
        }

        .payment-option input {
            margin-right: 10px;
        }

        .payment-icon {
            width: 30px;
            height: 30px;
            margin-right: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
        }

        .btn {
            padding: 12px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
            font-size: 1rem;
            width: 100%;
        }

        .btn-primary {
            background: linear-gradient(to right, var(--primary), var(--secondary));
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(to right, var(--secondary), var(--primary));
            box-shadow: 0 5px 15px rgba(63, 55, 201, 0.3);
        }

        .campaign-summary {
            background-color: rgba(67, 97, 238, 0.05);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .campaign-summary h3 {
            margin-bottom: 1rem;
            font-size: 1.2rem;
        }

        .campaign-info {
            display: flex;
            margin-bottom: 1rem;
        }

        .campaign-image {
            width: 80px;
            height: 80px;
            border-radius: 8px;
            object-fit: cover;
            margin-right: 1rem;
        }

        .campaign-details {
            flex: 1;
        }

        .campaign-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .campaign-description {
            color: var(--gray);
            font-size: 0.9rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .amount-options {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .main-content {
                padding: 1rem;
            }
            
            .donation-card {
                padding: 1.5rem;
            }
        }

        @media (max-width: 480px) {
            .amount-options {
                grid-template-columns: 1fr;
            }
            
            .campaign-info {
                flex-direction: column;
            }
            
            .campaign-image {
                margin-right: 0;
                margin-bottom: 1rem;
                width: 100%;
                height: 150px;
            }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-header">
            <div class="logo">
                <i class="fas fa-heartbeat"></i>
                <span class="logo-text">MedCharity</span>
            </div>
            <button class="toggle-btn">
                <i class="fas fa-chevron-left"></i>
            </button>
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
            <h1>Make a Donation</h1>
            <div class="user-info">
                <img src="https://randomuser.me/api/portraits/women/44.jpg" alt="User">
                <span><%= email %></span>
            </div>
        </div>

        <div class="donation-container">
<form method="post" action="donate">
    <div class="form-group">
        <label for="campaignId">Select Campaign</label>
        <select name="campaignId" id="campaignId" class="form-control" required>
            <option value="">-- choose one --</option>
            <% for (Campaign c: campaigns) { %>
                <option value="<%= c.getCampaignId() %>"><%= c.getTitle() %></option>
            <% } %>
        </select>
    </div>

    <div class="donation-card">
        <div class="donation-header">
            <h2>Donation Amount</h2>
            <p>Your contribution helps save lives</p>
        </div>

        <div class="form-group">
            <label>Select Amount (MYR)</label>
            <div class="amount-options" id="amount-options">
                <div class="amount-option" data-amount="50">RM 50</div>
                <div class="amount-option" data-amount="100">RM 100</div>
                <div class="amount-option" data-amount="200">RM 200</div>
                <div class="amount-option" data-amount="500">RM 500</div>
                <div class="amount-option" data-amount="1000">RM 1000</div>
                <div class="amount-option" data-amount="custom">Other</div>
            </div>
        </div>

        <div class="form-group">
            <label for="custom-amount">Or enter custom amount</label>
            <div class="input-group">
                <span class="currency">RM</span>
                <input type="number" name="amount" id="custom-amount" class="form-control" placeholder="0.00" min="10" step="1" required>
            </div>
        </div>

        <div class="form-group">
            <label for="message">Optional Message</label>
            <textarea name="message" id="message" class="form-control" rows="3" placeholder="Add a message…"></textarea>
        </div>

        <div class="form-group">
            <label>
                <input type="checkbox" name="anonymous" value="true" checked>
                Donate anonymously
            </label>
        </div>

        <input type="hidden" name="email" value="<%= email %>" />

        <button type="submit" class="btn btn-primary">
            <i class="fas fa-heart"></i> Donate Now
        </button>
    </div>
</form>
        </div>
    </div>

<script>
    document.querySelectorAll('.amount-option').forEach(opt => {
        opt.addEventListener('click', () => {
            document.querySelectorAll('.amount-option').forEach(o => o.classList.remove('active'));
            opt.classList.add('active');
            const amt = opt.getAttribute('data-amount');
            const input = document.getElementById('custom-amount');
            if (amt === 'custom') {
                input.value = '';
                input.focus();
            } else {
                input.value = amt;
            }
        });
    });
</script>
</body>
</html>