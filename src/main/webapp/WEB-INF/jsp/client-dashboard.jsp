<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.dealvault.dealvault.model.Application" %>
<%@ page import="com.dealvault.dealvault.model.Project" %>
<%@ page import="com.dealvault.dealvault.model.User" %>

<!DOCTYPE html>
<html>
<head>
    <title>Client Dashboard</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: #f4f7fa;
        }

        .navbar {
            background: #2a5298;
        }

        .navbar-brand {
            color: white !important;
        }
    </style>
</head>

<body>

<%
    List projects = (List) request.getAttribute("projects");
    List applications = (List) request.getAttribute("applications");
    User user = (User) request.getAttribute("user");
%>

<!-- NAVBAR -->
<nav class="navbar">
    <div class="container">
        <span class="navbar-brand">DealVault - Client</span>
    </div>
</nav>

<div class="container mt-4">

    <!-- WALLET -->
    <div class="card shadow p-3 mb-4">
        <h5>Client Wallet</h5>
        <p>Total Balance: ₹50000</p>
        <p>Locked Amount: ₹<%= request.getAttribute("lockedAmount") %></p>
    </div>

    <!-- PROJECTS -->
    <div class="card shadow p-3 mb-4">
        <h5>Your Projects</h5>

        <table class="table table-bordered mt-3">
            <thead class="table-primary">
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Budget</th>
                    <th>Status / Applicants</th>
                </tr>
            </thead>

            <tbody>

            <%
                if (projects != null && user != null) {
                    for (Object obj : projects) {
                        Project p = (Project) obj;

                        boolean hasApps = false;
                        boolean accepted = false;
            %>

            <tr>
                <td><%= p.getId() %></td>
                <td><%= p.getTitle() %></td>
                <td>₹<%= p.getBudget() %></td>

                <td>

                <%
                    if (applications != null) {
                        for (Object a : applications) {
                            Application app = (Application) a;

                            if (app.getProjectId().equals(p.getId())) {

                                // 🔥 COMPLETION REQUESTED
                                if ("COMPLETION_REQUESTED".equals(app.getStatus())) {
                %>

                    <div class="alert alert-warning p-2">
                        ⚠ Freelancer <b><%= app.getFreelancerId() %></b> completed the project
                    </div>

                    <form action="/ui/projects/approve" method="post">
                        <input type="hidden" name="projectId" value="<%= p.getId() %>">
                        <button class="btn btn-success btn-sm">Approve Completion</button>
                    </form>

                <%
                                }

                                // 🔥 ACCEPTED (IN PROGRESS)
                                else if ("ACCEPTED".equals(app.getStatus())) {
                                    accepted = true;
                %>

                    <div class="alert alert-success p-2">
                        ✅ Freelancer <b><%= app.getFreelancerId() %></b> Selected <br>
                        Status: <b>IN_PROGRESS</b>
                    </div>

                    <div class="alert alert-info p-2">
                        💰 ₹<%= p.getBudget() %> locked in escrow
                    </div>

                <%
                                }

                                // 🔥 APPLIED
                                else if ("APPLIED".equals(app.getStatus())) {
                                    hasApps = true;
                %>

                    <div class="mb-2">
                        Freelancer ID: <%= app.getFreelancerId() %>

                        <form action="/ui/applications/select-ui" method="post" style="display:inline;">
                            <input type="hidden" name="projectId" value="<%= p.getId() %>">
                            <input type="hidden" name="freelancerId" value="<%= app.getFreelancerId() %>">
                            <input type="hidden" name="clientId" value="<%= user.getId() %>">

                            <button class="btn btn-primary btn-sm">Select</button>
                        </form>
                    </div>

                <%
                                }
                            }
                        }
                    }

                    if (!hasApps && !accepted) {
                %>
                    <span class="text-muted">No applications yet</span>
                <%
                    }
                %>

                </td>
            </tr>

            <%
                    }
                }
            %>

            </tbody>
        </table>
    </div>

    <!-- ADD PROJECT -->
    <div class="card shadow p-3">
        <h5>Add Project</h5>

        <form action="/ui/projects/create" method="post">
            <input class="form-control mb-2" type="text" name="title" placeholder="Title" required>
            <input class="form-control mb-2" type="text" name="description" placeholder="Description" required>
            <input class="form-control mb-2" type="number" name="budget" placeholder="Budget" required>

            <input type="hidden" name="clientId" value="<%= user.getId() %>">

            <button class="btn btn-success">Create Project</button>
        </form>
    </div>

</div>

</body>
</html>