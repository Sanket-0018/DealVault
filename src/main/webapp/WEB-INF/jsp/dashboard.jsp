<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.dealvault.dealvault.model.Application" %>
<%@ page import="com.dealvault.dealvault.model.Project" %>
<%@ page import="com.dealvault.dealvault.model.User" %>
<%@ page import="com.dealvault.dealvault.model.Escrow" %>

<!DOCTYPE html>
<html>
<head>
    <title>Freelancer Dashboard</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: #f4f7fa;
        }

        .navbar {
            background: #1e3c72;
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
    List escrows = (List) request.getAttribute("escrows"); // optional
%>
<%
Map<Long, Double> projectAmounts =
    (Map<Long, Double>) request.getAttribute("projectAmounts");
%>

<!-- NAVBAR -->
<nav class="navbar">
    <div class="container">
        <span class="navbar-brand">DealVault - Freelancer</span>
    </div>
</nav>

<div class="container mt-4">

    <!-- 🔥 WALLET -->
    <div class="card shadow p-3 mb-4">
        <h5>Your Wallet</h5>
        <h4>₹<%= user.getBalance() %></h4>
    </div>

    <!-- 🔥 PROJECT STATUS -->
    <div class="card shadow p-3 mb-4">
        <h5>Your Project Status</h5>

        <%
            boolean hasProject = false;

            if (applications != null && user != null) {
                for (Object a : applications) {
                    Application app = (Application) a;

                    if (app.getFreelancerId().equals(user.getId())
                    	    && ("ACCEPTED".equals(app.getStatus())
                    	    || "COMPLETION_REQUESTED".equals(app.getStatus())
                    	    || "COMPLETED".equals(app.getStatus()))) {

                        // 🔥 ACCEPTED
                        if ("ACCEPTED".equals(app.getStatus())) {
                            hasProject = true;
        %>

        <div class="alert alert-success">
            🎉 You are selected for Project ID: <%= app.getProjectId() %><br>
            👉 Start working on the project
        </div>

        <form action="/ui/projects/complete" method="post">
            <input type="hidden" name="projectId" value="<%= app.getProjectId() %>">
            <button class="btn btn-primary">Mark as Completed</button>
        </form>

        <%
                        }

                        // 🔥 WAITING FOR CLIENT
                        else if ("COMPLETION_REQUESTED".equals(app.getStatus())) {
                            hasProject = true;
        %>

        <div class="alert alert-warning">
            ⏳ Waiting for client approval...
        </div>

        <%
                        }

                        // 🔥 PAYMENT RECEIVED
                        else if ("COMPLETED".equals(app.getStatus())) {
                            hasProject = true;

                            double amount = 0;

                            if (escrows != null) {
                                for (Object e : escrows) {
                                    Escrow es = (Escrow) e;

                                    if (es.getProjectId().equals(app.getProjectId())) {
                                        amount = es.getAmount();
                                    }
                                }
                            }
        %>

        <div class="alert alert-success">
            💰 Payment Received ₹<%= projectAmounts.get(app.getProjectId()) %><br>
            🎉 Project Completed Successfully!
        </div>

        <%
                        }
                    }
                }
            }

            if (!hasProject) {
        %>

        <div class="alert alert-secondary">
            No project assigned yet. Apply to projects.
        </div>

        <%
            }
        %>
    </div>

    <!-- 🔥 PROJECT TABLE -->
    <div class="card shadow p-3">
        <h5>Available Projects</h5>

        <table class="table table-hover mt-3">
            <thead class="table-primary">
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Budget</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>

            <%
                if (projects != null && user != null) {
                    for (Object obj : projects) {
                        Project p = (Project) obj;

                        boolean applied = false;

                        if (applications != null) {
                            for (Object a : applications) {
                                Application app = (Application) a;

                                if (app.getProjectId().equals(p.getId())
                                    && app.getFreelancerId().equals(user.getId())) {
                                    applied = true;
                                }
                            }
                        }
            %>

            <tr>
                <td><%= p.getId() %></td>
                <td><%= p.getTitle() %></td>
                <td><%= p.getDescription() %></td>
                <td>₹<%= p.getBudget() %></td>

                <td>
                    <% if (applied) { %>
                        <span class="badge bg-secondary">Applied</span>
                    <% } else { %>
                        <form action="/ui/applications/apply" method="post">
                            <input type="hidden" name="projectId" value="<%= p.getId() %>">
                            <input type="hidden" name="freelancerId" value="<%= user.getId() %>">
                            <button class="btn btn-success btn-sm">Apply</button>
                        </form>
                    <% } %>
                </td>
            </tr>

            <%
                    }
                }
            %>

            </tbody>
        </table>
    </div>

</div>

</body>
</html>