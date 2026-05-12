<!DOCTYPE html>
<html>
<head link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>Register</title>
</head>
<body>

<h2>Register</h2>

<form action="/api/users/register-ui" method="post">
    Email: <input type="text" name="email"><br><br>
    Password: <input type="password" name="password"><br><br>

    Role:
    <select name="role">
        <option value="FREELANCER">Freelancer</option>
        <option value="CLIENT">Client</option>
    </select><br><br>

    <button type="submit">Register</button>
</form>

</body>
</html>