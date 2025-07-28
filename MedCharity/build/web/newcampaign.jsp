<%@ page session="true" %>
<%
    String email = (String) session.getAttribute("userEmail");
    if (email == null) {
        response.sendRedirect("login.jsp");
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
            box-shadow: 2px 0 15px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            height: 100vh;
            position: fixed;
            z-index: 100;
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
        }

        .logo i {
            font-size: 1.8rem;
            margin-right: 10px;
            background: linear-gradient(45deg, var(--primary), var(--accent));
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .toggle-btn {
            background: none;
            border: none;
            color: var(--gray);
            font-size: 1.2rem;
            cursor: pointer;
            transition: all 0.3s;
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
        }

        .sidebar-menu li a.active {
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary);
            border-left: 3px solid var(--primary);
        }

        .sidebar-menu li a i {
            margin-right: 15px;
            width: 20px;
            text-align: center;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 1.5rem;
            transition: margin-left 0.3s ease;
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

        /* Campaign Form Styles */
        .campaign-form {
            max-width: 800px;
            margin: 0 auto;
            background-color: var(--white);
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
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

        .file-upload {
            border: 2px dashed #e0e0e0;
            border-radius: 8px;
            padding: 2rem;
            text-align: center;
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

        .form-footer {
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            padding: 0.8rem 1.5rem;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
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

        /* Responsive Design */
        @media (max-width: 768px) {
            .form-row {
                flex-direction: column;
            }
            
            .main-content {
                padding: 1rem;
            }
            
            .campaign-form {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>

    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Create New Campaign</h1>        </div>

        <div class="campaign-form">
            <form id="campaignForm">
                <div class="form-row">
                    <div class="form-group">
                        <label>Campaign Title</label>
                        <input type="text" class="form-control" placeholder="Help Baby Emma Fight Leukemia" required>
                    </div>
                    <div class="form-group">
                        <label>Category</label>
                        <select class="form-control" required>
                            <option value="">Select Category</option>
                            <option>Children</option>
                            <option>Cancer</option>
                            <option>Surgery</option>
                            <option>Emergency</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea class="form-control" rows="4" placeholder="Describe the campaign..." required></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Goal Amount (MYR)</label>
                        <input type="number" class="form-control" placeholder="20000" required>
                    </div>
                    <div class="form-group">
                        <label>End Date</label>
                        <input type="date" class="form-control" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Campaign Image</label>
                    <div class="file-upload">
                        <i class="fas fa-cloud-upload-alt"></i>
                        <p>Click to upload or drag and drop</p>
                        <p>Recommended size: 800x600px</p>
                        <input type="file" hidden>
                    </div>
                </div>

                <div class="form-group">
                    <label>
                        <input type="checkbox"> Mark as Urgent Campaign
                    </label>
                </div>

                <div class="form-footer">
                    <button type="button" class="btn btn-outline" onclick="window.history.back()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Create Campaign</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>