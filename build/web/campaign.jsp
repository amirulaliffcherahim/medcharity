<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campaigns | Medical Charity System</title>
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

        /* Campaign Page Specific Styles */
        .campaign-actions {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .btn {
            padding: 0.7rem 1.2rem;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
            font-size: 0.9rem;
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

        .btn-success {
            background-color: #06d6a0;
            color: white;
        }

        .btn-success:hover {
            background-color: #05b888;
        }

        .btn-danger {
            background-color: #ef476f;
            color: white;
        }

        .btn-danger:hover {
            background-color: #e0355f;
        }

        /* Filter Section */
        .filter-section {
            background-color: var(--white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            margin-bottom: 2rem;
        }

        .filter-title {
            font-size: 1.1rem;
            margin-bottom: 1rem;
            color: var(--dark);
            font-weight: 500;
            display: flex;
            align-items: center;
        }

        .filter-title i {
            margin-right: 10px;
            color: var(--primary);
        }

        .filter-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 0.8rem;
        }

        .filter-tag {
            padding: 0.5rem 1rem;
            background-color: var(--light);
            border-radius: 20px;
            font-size: 0.85rem;
            cursor: pointer;
            transition: all 0.3s;
        }

        .filter-tag:hover, .filter-tag.active {
            background-color: var(--primary);
            color: white;
        }

        /* Campaign List */
        .campaign-list {
            background-color: var(--white);
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            overflow: hidden;
        }

        .campaign-item {
            display: flex;
            padding: 1.5rem;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.3s;
        }

        .campaign-item:last-child {
            border-bottom: none;
        }

        .campaign-item:hover {
            background-color: rgba(67, 97, 238, 0.03);
        }

        .campaign-urgent {
            border-left: 4px solid #ef476f;
        }

        .campaign-image {
            width: 120px;
            height: 120px;
            border-radius: 8px;
            object-fit: cover;
            margin-right: 1.5rem;
            flex-shrink: 0;
        }

        .campaign-details {
            flex: 1;
        }

        .campaign-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 0.8rem;
        }

        .campaign-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 0.5rem;
        }

        .campaign-category {
            display: inline-block;
            padding: 0.3rem 0.8rem;
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary);
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
            margin-bottom: 0.8rem;
        }

        .campaign-description {
            color: var(--gray);
            margin-bottom: 1rem;
            font-size: 0.95rem;
            line-height: 1.5;
        }

        .campaign-progress {
            height: 8px;
            background-color: #e9ecef;
            border-radius: 4px;
            margin-bottom: 0.8rem;
            overflow: hidden;
        }

        .progress-bar {
            height: 100%;
            background: linear-gradient(to right, var(--primary), var(--accent));
            border-radius: 4px;
        }

        .campaign-meta {
            display: flex;
            justify-content: space-between;
            font-size: 0.85rem;
            color: var(--gray);
        }

        .campaign-stats {
            display: flex;
            gap: 1.5rem;
        }

        .stat-item {
            display: flex;
            align-items: center;
        }

        .stat-item i {
            margin-right: 5px;
            font-size: 0.9rem;
        }

        .campaign-actions {
            display: flex;
            gap: 0.8rem;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background-color: var(--white);
            border-radius: 12px;
            box-shadow: 0 5px 30px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 600px;
            max-height: 90vh;
            overflow-y: auto;
            animation: modalFadeIn 0.3s ease;
        }

        @keyframes modalFadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .modal-header {
            padding: 1.5rem;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h2 {
            font-size: 1.5rem;
            color: var(--dark);
        }

        .close-btn {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--gray);
            transition: color 0.3s;
        }

        .close-btn:hover {
            color: var(--dark);
        }

        .modal-body {
            padding: 1.5rem;
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

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }

        .form-row {
            display: flex;
            gap: 1rem;
        }

        .form-row .form-group {
            flex: 1;
        }

        .file-upload {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 2rem;
            border: 2px dashed #e0e0e0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .file-upload:hover {
            border-color: var(--accent);
        }

        .file-upload i {
            font-size: 2rem;
            color: var(--primary);
            margin-bottom: 1rem;
        }

        .file-upload p {
            color: var(--gray);
            text-align: center;
        }

        .modal-footer {
            padding: 1.5rem;
            border-top: 1px solid rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
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
            .campaign-item {
                flex-direction: column;
            }
            
            .campaign-image {
                width: 100%;
                height: 180px;
                margin-right: 0;
                margin-bottom: 1rem;
            }
            
            .campaign-header {
                flex-direction: column;
            }
            
            .campaign-actions {
                margin-top: 1rem;
                justify-content: flex-start;
            }
            
            .campaign-stats {
                flex-wrap: wrap;
                gap: 0.8rem;
            }

            .form-row {
                flex-direction: column;
                gap: 0;
            }
        }

        @media (max-width: 480px) {
            .modal-content {
                width: 95%;
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

    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Medical Campaigns</h1>
            <div class="user-info">
                <img src="https://randomuser.me/api/portraits/women/44.jpg" alt="User">
                <span class="user-name">Sarah Johnson</span>
            </div>
        </div>

        <!-- Campaign Actions -->
        <div class="campaign-actions">
            <a href="newcampaign.html" class="btn btn-primary" id="openModalBtn">
                <i class="fas fa-plus"></i> Start New Campaign
            </a>
            <button class="btn btn-outline">
                <i class="fas fa-filter"></i> Filter
            </button>
            <button class="btn btn-outline">
                <i class="fas fa-search"></i> Search
            </button>
        </div>

        <!-- Campaign List -->
        <div class="campaign-list">
            <!-- Campaign 1 - Urgent -->
            <div class="campaign-item campaign-urgent">
                <img src="https://images.unsplash.com/photo-1505751172876-fa1923c5c528?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" alt="Baby Emma" class="campaign-image">
                <div class="campaign-details">
                    <div class="campaign-header">
                        <div>
                            <h3 class="campaign-title">Help Baby Emma Fight Leukemia</h3>
                            <span class="campaign-category">Children ? Urgent</span>
                        </div>
                        <div class="campaign-actions">
                            <button class="btn btn-outline">
                                <i class="fas fa-share-alt"></i>
                            </button>
                            <a href="donate.html" class="btn btn-primary">
                                <i class="fas fa-donate"></i> Donate
                            </a>
                        </div>
                    </div>
                    <p class="campaign-description">
                        2-year-old Emma needs urgent treatment for acute lymphoblastic leukemia. Her family cannot afford the full treatment cost and needs your help to raise $20,000 for chemotherapy and medications.
                    </p>
                    <div class="campaign-progress">
                        <div class="progress-bar" style="width: 65%"></div>
                    </div>
                    <div class="campaign-meta">
                        <div class="campaign-stats">
                            <div class="stat-item">
                                <i class="fas fa-dollar-sign"></i> $13,000 raised
                            </div>
                            <div class="stat-item">
                                <i class="fas fa-bullseye"></i> $20,000 goal
                            </div>
                            <div class="stat-item">
                                <i class="fas fa-users"></i> 142 donors
                            </div>
                            <div class="stat-item">
                                <i class="fas fa-clock"></i> 25 days left
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Campaign 2 -->
            <div class="campaign-item">
                <img src="https://images.unsplash.com/photo-1576091160550-2173dba999ef?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" alt="Mr. Rodriguez" class="campaign-image">
                <div class="campaign-details">
                    <div class="campaign-header">
                        <div>
                            <h3 class="campaign-title">Cancer Treatment for Mr. Rodriguez</h3>
                            <span class="campaign-category">Adults ? Cancer</span>
                        </div>
                        <div class="campaign-actions">
                            <button class="btn btn-outline">
                                <i class="fas fa-share-alt"></i>
                            </button>
                            <a href="donate.html" class="btn btn-primary">
                                <i class="fas fa-donate"></i> Donate
                            </a>
                        </div>
                    </div>
                    <p class="campaign-description">
                        Support chemotherapy for a father of three battling stage 3 cancer. He's the sole breadwinner for his family and needs help covering treatment costs of $15,000.
                    </p>
                    <div class="campaign-progress">
                        <div class="progress-bar" style="width: 42%"></div>
                    </div>
                    <div class="campaign-meta">
                        <div class="campaign-stats">
                            <div class="stat-item">
                                <i class="fas fa-dollar-sign"></i> $6,300 raised
                            </div>
                            <div class="stat-item">
                                <i class="fas fa-bullseye"></i> $15,000 goal
                            </div>
                            <div class="stat-item">
                                <i class="fas fa-users"></i> 89 donors
                            </div>
                            <div class="stat-item">
                                <i class="fas fa-clock"></i> 12 days left
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Campaign Modal -->
    <div class="modal" id="campaignModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Create New Campaign</h2>
                <button class="close-btn" href="modal.html">&times;</button>
            </div>
            <div class="modal-body">
                <form id="campaignForm">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="campaignTitle">Campaign Title</label>
                            <input type="text" id="campaignTitle" class="form-control" placeholder="e.g., Help Baby Emma Fight Leukemia" required>
                        </div>
                        <div class="form-group">
                            <label for="campaignCategory">Category</label>
                            <select id="campaignCategory" class="form-control" required>
                                <option value="">Select a category</option>
                                <option value="Children">Children</option>
                                <option value="Cancer">Cancer</option>
                                <option value="Surgery">Surgery</option>
                                <option value="Emergency">Emergency</option>
                                <option value="Chronic Illness">Chronic Illness</option>
                                <option value="Transplant">Transplant</option>
                                <option value="Veterans">Veterans</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="campaignDescription">Description</label>
                        <textarea id="campaignDescription" class="form-control" placeholder="Tell the story of who you're helping and why..." required></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="goalAmount">Goal Amount (MYR)</label>
                            <input type="number" id="goalAmount" class="form-control" placeholder="e.g., 20000" min="100" required>
                        </div>
                        <div class="form-group">
                            <label for="endDate">End Date</label>
                            <input type="date" id="endDate" class="form-control" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Campaign Image</label>
                        <div class="file-upload" id="fileUpload">
                            <i class="fas fa-cloud-upload-alt"></i>
                            <p>Click to upload or drag and drop</p>
                            <p>Recommended size: 800x600px</p>
                            <input type="file" id="campaignImage" accept="image/*" style="display: none;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>
                            <input type="checkbox" id="isUrgent"> 
                            Mark as Urgent Campaign
                        </label>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-outline" id="cancelBtn">Cancel</button>
                <button class="btn btn-primary" id="saveCampaignBtn">Create Campaign</button>
            </div>
        </div>
    </div>
</body>
</html>