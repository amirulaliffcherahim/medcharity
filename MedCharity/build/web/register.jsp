<html>
<head>
    <title>Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5" style="max-width: 500px;">
    <div class="card">
        <div class="card-body">
            <h3 class="text-center">Sign Up</h3>
            <form action="RegisterServlet" method="post">
                <div class="mb-3">
                    <label>Username</label>
                    <input name="username" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required />
                </div>
                <button class="btn btn-success w-100">Register</button>
            </form>
            <div class="mt-2 text-center">
                <a href="login.jsp">Already have an account?</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
