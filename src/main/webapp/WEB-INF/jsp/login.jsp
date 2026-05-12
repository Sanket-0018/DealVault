<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #1e3c72, #2a5298);
            height: 100vh;
        }

        .login-card {
            width: 350px;
            border-radius: 15px;
        }

        .btn-custom {
            background-color: #4CAF50;
            color: white;
        }

        .btn-custom:hover {
            background-color: #45a049;
        }
    </style>
</head>

<body class="d-flex justify-content-center align-items-center">


    <div class="card p-4 shadow login-card">
        <h3 class="text-center mb-3">DealVault Login</h3>

        <form action="/api/users/login-ui" method="post">

            <input type="email" name="email"
                   class="form-control mb-3"
                   placeholder="Enter Email" required>

            <input type="password" name="password"
                   class="form-control mb-3"
                   placeholder="Enter Password" required>

            <button class="btn btn-custom w-100">Login</button>
 <p>
    Don't have an account?
    <a href="/api/users/signup">Register here</a>
</p>
        </form>
    </div>

</body>
</html>