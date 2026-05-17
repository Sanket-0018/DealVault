<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.dealvault.dealvault.model.Application" %>
<%@ page import="com.dealvault.dealvault.model.Project" %>
<%@ page import="com.dealvault.dealvault.model.User" %>
<%@ page import="com.dealvault.dealvault.model.Escrow" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DealVault — Freelancer Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --navy-deep:    #0d1117;
            --navy-surface: #161b27;
            --navy-card:    #1e2535;
            --navy-sidebar: #13192a;
            --navy-border:  #2a3148;
            --gold:         #c9a84c;
            --gold-hover:   #e0bc6a;
            --gold-dim:     rgba(201,168,76,0.12);
            --gold-glow:    rgba(201,168,76,0.25);
            --text-primary: #e8eaf0;
            --text-muted:   #7a8499;
            --success:      #2ea87e;
            --success-dim:  rgba(46,168,126,0.12);
            --warning:      #e0a94c;
            --warning-dim:  rgba(224,169,76,0.12);
            --danger:       #e05c5c;
            --danger-dim:   rgba(224,92,92,0.12);
            --info:         #4c8ce0;
            --info-dim:     rgba(76,140,224,0.12);
            --sidebar-w:    240px;
            --sidebar-collapsed: 64px;
        }

        html, body {
            height: 100%;
            background: var(--navy-deep);
            font-family: 'DM Sans', sans-serif;
            color: var(--text-primary);
            overflow-x: hidden;
        }

        /* ═══════════════════════════════
           SIDEBAR
        ═══════════════════════════════ */
        .sidebar {
            position: fixed;
            top: 0; left: 0;
            height: 100vh;
            width: var(--sidebar-w);
            background: var(--navy-sidebar);
            border-right: 1px solid var(--navy-border);
            display: flex;
            flex-direction: column;
            z-index: 100;
            transition: width 0.25s cubic-bezier(0.4,0,0.2,1);
            overflow: hidden;
        }
        .sidebar.collapsed { width: var(--sidebar-collapsed); }

        .sidebar-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 1.25rem 1rem;
            border-bottom: 1px solid var(--navy-border);
            min-height: 64px;
            text-decoration: none;
        }
        .sidebar-logo-icon {
            width: 36px; height: 36px;
            border-radius: 9px;
            background: var(--gold-dim);
            border: 1px solid var(--gold);
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }
        .sidebar-logo-icon svg { width: 18px; height: 18px; fill: var(--gold); }
        .sidebar-logo-text {
            font-family: 'Syne', sans-serif;
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--text-primary);
            letter-spacing: -0.02em;
            white-space: nowrap;
            opacity: 1;
            transition: opacity 0.15s;
        }
        .sidebar-logo-text span { color: var(--gold); }
        .sidebar.collapsed .sidebar-logo-text { opacity: 0; pointer-events: none; }

        .sidebar-toggle {
            position: absolute;
            top: 16px; right: -12px;
            width: 24px; height: 24px;
            border-radius: 50%;
            background: var(--navy-card);
            border: 1px solid var(--navy-border);
            cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            z-index: 101;
            transition: background 0.2s;
        }
        .sidebar-toggle:hover { background: var(--navy-border); }
        .sidebar-toggle svg {
            width: 12px; height: 12px;
            stroke: var(--text-muted);
            fill: none;
            stroke-width: 2.5;
            transition: transform 0.25s;
        }
        .sidebar.collapsed .sidebar-toggle svg { transform: rotate(180deg); }

        .sidebar-nav {
            flex: 1;
            padding: 1rem 0.5rem;
            overflow-y: auto;
            overflow-x: hidden;
        }
        .sidebar-section-label {
            font-size: 0.65rem;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--text-muted);
            padding: 0.75rem 0.75rem 0.4rem;
            white-space: nowrap;
            opacity: 1;
            transition: opacity 0.15s;
        }
        .sidebar.collapsed .sidebar-section-label { opacity: 0; }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 0.6rem 0.75rem;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            color: var(--text-muted);
            font-size: 0.875rem;
            font-weight: 400;
            white-space: nowrap;
            transition: background 0.15s, color 0.15s;
            margin-bottom: 2px;
        }
        .nav-item:hover { background: rgba(255,255,255,0.05); color: var(--text-primary); }
        .nav-item.active {
            background: var(--gold-dim);
            color: var(--gold);
            font-weight: 500;
        }
        .nav-item svg {
            width: 18px; height: 18px;
            stroke: currentColor;
            fill: none;
            stroke-width: 1.8;
            flex-shrink: 0;
        }
        .nav-label {
            opacity: 1;
            transition: opacity 0.15s;
        }
        .sidebar.collapsed .nav-label { opacity: 0; }

        .sidebar-footer {
            padding: 1rem 0.5rem;
            border-top: 1px solid var(--navy-border);
        }
        .user-pill {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 0.6rem 0.75rem;
            border-radius: 8px;
            background: rgba(255,255,255,0.03);
        }
        .user-avatar {
            width: 30px; height: 30px;
            border-radius: 50%;
            background: var(--gold-dim);
            border: 1px solid var(--gold);
            display: flex; align-items: center; justify-content: center;
            font-size: 0.7rem;
            font-weight: 600;
            color: var(--gold);
            flex-shrink: 0;
        }
        .user-info { overflow: hidden; }
        .user-name {
            font-size: 0.8rem;
            font-weight: 500;
            color: var(--text-primary);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .user-role {
            font-size: 0.68rem;
            color: var(--text-muted);
        }
        .sidebar.collapsed .user-info { display: none; }

        /* ═══════════════════════════════
           MAIN CONTENT
        ═══════════════════════════════ */
        .main {
            margin-left: var(--sidebar-w);
            min-height: 100vh;
            transition: margin-left 0.25s cubic-bezier(0.4,0,0.2,1);
        }
        .main.expanded { margin-left: var(--sidebar-collapsed); }

        /* ═══════════════════════════════
           TOP BAR
        ═══════════════════════════════ */
        .topbar {
            height: 64px;
            background: var(--navy-surface);
            border-bottom: 1px solid var(--navy-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 2rem;
            position: sticky;
            top: 0;
            z-index: 50;
        }
        .topbar-title {
            font-family: 'Syne', sans-serif;
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-primary);
        }
        .topbar-right { display: flex; align-items: center; gap: 1rem; }

        .wallet-chip {
            display: flex;
            align-items: center;
            gap: 8px;
            background: var(--gold-dim);
            border: 1px solid rgba(201,168,76,0.3);
            border-radius: 20px;
            padding: 0.35rem 0.85rem;
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--gold);
        }
        .wallet-chip svg {
            width: 14px; height: 14px;
            fill: var(--gold);
        }

        /* ═══════════════════════════════
           PAGE CONTENT
        ═══════════════════════════════ */
        .page-content {
            padding: 2rem;
        }

        .section-title {
            font-family: 'Syne', sans-serif;
            font-size: 0.7rem;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--text-muted);
            margin-bottom: 1rem;
        }

        /* ═══════════════════════════════
           STATUS CARD
        ═══════════════════════════════ */
        .status-card {
            background: var(--navy-card);
            border: 1px solid var(--navy-border);
            border-radius: 14px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .status-banner {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            padding: 1.1rem 1.25rem;
            border-radius: 10px;
            margin-bottom: 1rem;
        }
        .status-banner:last-child { margin-bottom: 0; }
        .status-banner.success { background: var(--success-dim); border: 1px solid rgba(46,168,126,0.25); }
        .status-banner.warning { background: var(--warning-dim); border: 1px solid rgba(224,169,76,0.25); }
        .status-banner.neutral { background: rgba(255,255,255,0.03); border: 1px solid var(--navy-border); }

        .status-icon {
            width: 36px; height: 36px;
            border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
            font-size: 1rem;
        }
        .status-icon.success { background: rgba(46,168,126,0.2); }
        .status-icon.warning { background: rgba(224,169,76,0.2); }
        .status-icon.neutral { background: rgba(255,255,255,0.05); }

        .status-body { flex: 1; }
        .status-body h6 {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.2rem;
        }
        .status-body p {
            font-size: 0.8rem;
            color: var(--text-muted);
            margin: 0;
        }

        .btn-complete {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 0.55rem 1.1rem;
            background: var(--gold);
            color: #0d1117;
            border: none;
            border-radius: 7px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, box-shadow 0.2s, transform 0.15s;
            margin-top: 0.75rem;
            text-decoration: none;
        }
        .btn-complete:hover {
            background: var(--gold-hover);
            box-shadow: 0 4px 14px var(--gold-glow);
        }
        .btn-complete:active { transform: scale(0.97); }
        .btn-complete svg {
            width: 14px; height: 14px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2.2;
        }

        /* ═══════════════════════════════
           STATS ROW
        ═══════════════════════════════ */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        .stat-card {
            background: var(--navy-card);
            border: 1px solid var(--navy-border);
            border-radius: 12px;
            padding: 1.25rem 1.5rem;
        }
        .stat-label {
            font-size: 0.72rem;
            font-weight: 500;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            color: var(--text-muted);
            margin-bottom: 0.5rem;
        }
        .stat-value {
            font-family: 'Syne', sans-serif;
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--text-primary);
            letter-spacing: -0.02em;
        }
        .stat-value.gold { color: var(--gold); }
        .stat-sub {
            font-size: 0.72rem;
            color: var(--text-muted);
            margin-top: 0.2rem;
        }

        /* ═══════════════════════════════
           PROJECTS TABLE
        ═══════════════════════════════ */
        .table-card {
            background: var(--navy-card);
            border: 1px solid var(--navy-border);
            border-radius: 14px;
            overflow: hidden;
        }
        .table-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--navy-border);
        }
        .table-card-header h5 {
            font-family: 'Syne', sans-serif;
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
        }
        .project-count {
            font-size: 0.72rem;
            background: var(--gold-dim);
            color: var(--gold);
            border-radius: 20px;
            padding: 0.2rem 0.65rem;
            font-weight: 500;
        }

        .dv-table { width: 100%; border-collapse: collapse; }
        .dv-table thead tr {
            border-bottom: 1px solid var(--navy-border);
        }
        .dv-table thead th {
            padding: 0.75rem 1.5rem;
            font-size: 0.68rem;
            font-weight: 600;
            letter-spacing: 0.07em;
            text-transform: uppercase;
            color: var(--text-muted);
            text-align: left;
            white-space: nowrap;
        }
        .dv-table tbody tr {
            border-bottom: 1px solid rgba(42,49,72,0.6);
            transition: background 0.15s;
        }
        .dv-table tbody tr:last-child { border-bottom: none; }
        .dv-table tbody tr:hover { background: rgba(255,255,255,0.025); }
        .dv-table td {
            padding: 1rem 1.5rem;
            font-size: 0.855rem;
            color: var(--text-primary);
            vertical-align: middle;
        }

        .project-title-cell { font-weight: 500; }
        .project-desc-cell {
            color: var(--text-muted);
            max-width: 260px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .budget-cell {
            font-weight: 600;
            color: var(--gold);
            font-family: 'Syne', sans-serif;
        }
        .id-cell {
            color: var(--text-muted);
            font-size: 0.78rem;
            font-family: monospace;
        }

        /* ═══════════════════════════════
           BADGES & BUTTONS
        ═══════════════════════════════ */
        .badge-applied {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 0.3rem 0.75rem;
            background: rgba(255,255,255,0.05);
            border: 1px solid var(--navy-border);
            border-radius: 20px;
            font-size: 0.72rem;
            color: var(--text-muted);
            font-weight: 500;
        }
        .badge-applied svg {
            width: 11px; height: 11px;
            stroke: var(--success);
            fill: none;
            stroke-width: 2.5;
        }

        .btn-apply {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 0.38rem 0.9rem;
            background: transparent;
            border: 1px solid var(--gold);
            border-radius: 7px;
            color: var(--gold);
            font-family: 'DM Sans', sans-serif;
            font-size: 0.78rem;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s, box-shadow 0.2s;
        }
        .btn-apply:hover {
            background: var(--gold-dim);
            box-shadow: 0 0 0 3px var(--gold-dim);
        }
        .btn-apply svg {
            width: 12px; height: 12px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2.5;
        }

        .empty-state {
            padding: 3rem 1.5rem;
            text-align: center;
            color: var(--text-muted);
            font-size: 0.875rem;
        }
        .empty-state svg {
            width: 36px; height: 36px;
            stroke: var(--navy-border);
            fill: none;
            stroke-width: 1.5;
            margin-bottom: 0.75rem;
        }
    </style>
</head>
<body>

<%
    List projects = (List) request.getAttribute("projects");
    List applications = (List) request.getAttribute("applications");
    User user = (User) request.getAttribute("user");
    List escrows = (List) request.getAttribute("escrows");
    Map<Long, Double> projectAmounts = (Map<Long, Double>) request.getAttribute("projectAmounts");

    int totalApplied = 0;
    int totalCompleted = 0;
    if (applications != null && user != null) {
        for (Object a : applications) {
            Application app = (Application) a;
            if (app.getFreelancerId().equals(user.getId())) {
                totalApplied++;
                if ("COMPLETED".equals(app.getStatus())) totalCompleted++;
            }
        }
    }
    int totalAvailable = (projects != null) ? projects.size() : 0;
%>

<!-- ═══ SIDEBAR ═══ -->
<aside class="sidebar" id="sidebar">
    <div class="sidebar-toggle" onclick="toggleSidebar()" title="Toggle sidebar">
        <svg viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>
    </div>

    <a href="#" class="sidebar-logo">
        <div class="sidebar-logo-icon">
            <svg viewBox="0 0 24 24"><path d="M12 2L3 6v6c0 5.25 3.75 10.15 9 11.25C17.25 22.15 21 17.25 21 12V6L12 2zm0 4a3 3 0 1 1 0 6 3 3 0 0 1 0-6zm0 13c-2.5 0-4.71-1.28-6-3.22.03-1.99 4-3.08 6-3.08s5.96 1.09 6 3.08A7.2 7.2 0 0 1 12 19z"/></svg>
        </div>
        <span class="sidebar-logo-text">Deal<span>Vault</span></span>
    </a>

    <nav class="sidebar-nav">
        <div class="sidebar-section-label">Main</div>

        <a href="#" class="nav-item active">
            <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
            <span class="nav-label">Dashboard</span>
        </a>

        <a href="#projects-section" class="nav-item">
            <svg viewBox="0 0 24 24"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/></svg>
            <span class="nav-label">Projects</span>
        </a>

        <a href="#status-section" class="nav-item">
            <svg viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
            <span class="nav-label">My Status</span>
        </a>

        <div class="sidebar-section-label">Account</div>

        <a href="/api/users/logout" class="nav-item">
            <svg viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            <span class="nav-label">Logout</span>
        </a>
    </nav>

    <div class="sidebar-footer">
        <div class="user-pill">
            <div class="user-avatar">FL</div>
            <div class="user-info">
                <div class="user-name"><%= user != null ? user.getEmail() : "Freelancer" %></div>
                <div class="user-role">Freelancer</div>
            </div>
        </div>
    </div>
</aside>

<!-- ═══ MAIN ═══ -->
<div class="main" id="main">

    <!-- Top Bar -->
    <div class="topbar">
        <span class="topbar-title">Freelancer Dashboard</span>
        <div class="topbar-right">
            <div class="wallet-chip">
                <svg viewBox="0 0 24 24"><path d="M20 12V8H6a2 2 0 0 1-2-2c0-1.1.9-2 2-2h12v4"/><path d="M4 6v12c0 1.1.9 2 2 2h14v-4"/><path d="M18 12a2 2 0 0 0-2 2c0 1.1.9 2 2 2h4v-4h-4z"/></svg>
                ₹<%= user != null ? user.getBalance() : "0" %>
            </div>
        </div>
    </div>

    <!-- Page Content -->
    <div class="page-content">

        <!-- Stats Row -->
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-label">Wallet Balance</div>
                <div class="stat-value gold">₹<%= user != null ? user.getBalance() : "0" %></div>
                <div class="stat-sub">Available to withdraw</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Applications</div>
                <div class="stat-value"><%= totalApplied %></div>
                <div class="stat-sub">Total submitted</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Completed</div>
                <div class="stat-value"><%= totalCompleted %></div>
                <div class="stat-sub">Projects finished</div>
            </div>
        </div>

        <!-- Project Status -->
        <div id="status-section">
            <div class="section-title">Your Project Status</div>
            <div class="status-card">

                <%
                    boolean hasProject = false;
                    if (applications != null && user != null) {
                        for (Object a : applications) {
                            Application app = (Application) a;
                            if (app.getFreelancerId().equals(user.getId())
                                && ("ACCEPTED".equals(app.getStatus())
                                || "COMPLETION_REQUESTED".equals(app.getStatus())
                                || "COMPLETED".equals(app.getStatus()))) {

                                if ("ACCEPTED".equals(app.getStatus())) {
                                    hasProject = true;
                %>
                <div class="status-banner success">
                    <div class="status-icon success">🎉</div>
                    <div class="status-body">
                        <h6>You're selected for Project #<%= app.getProjectId() %></h6>
                        <p>You have been hired. Start working and mark as complete when done.</p>
                        <form action="/ui/projects/complete" method="post" style="margin:0">
                            <input type="hidden" name="projectId" value="<%= app.getProjectId() %>">
                            <button type="submit" class="btn-complete">
                                <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                Mark as Completed
                            </button>
                        </form>
                    </div>
                </div>
                <%
                                } else if ("COMPLETION_REQUESTED".equals(app.getStatus())) {
                                    hasProject = true;
                %>
                <div class="status-banner warning">
                    <div class="status-icon warning">⏳</div>
                    <div class="status-body">
                        <h6>Awaiting client approval</h6>
                        <p>You've submitted completion for Project #<%= app.getProjectId() %>. Waiting for the client to approve and release payment.</p>
                    </div>
                </div>
                <%
                                } else if ("COMPLETED".equals(app.getStatus())) {
                                    hasProject = true;
                %>
                <div class="status-banner success">
                    <div class="status-icon success">💰</div>
                    <div class="status-body">
                        <h6>Payment received — Project #<%= app.getProjectId() %> complete!</h6>
                        <p>₹<%= (projectAmounts != null && projectAmounts.get(app.getProjectId()) != null) ? projectAmounts.get(app.getProjectId()) : "—" %> has been credited to your wallet. Great work!</p>
                    </div>
                </div>
                <%
                                }
                            }
                        }
                    }
                    if (!hasProject) {
                %>
                <div class="status-banner neutral">
                    <div class="status-icon neutral">📋</div>
                    <div class="status-body">
                        <h6>No active project yet</h6>
                        <p>Browse available projects below and apply to get started.</p>
                    </div>
                </div>
                <% } %>

            </div>
        </div>

        <!-- Projects Table -->
        <div id="projects-section">
            <div class="section-title">Available Projects</div>
            <div class="table-card">
                <div class="table-card-header">
                    <h5>Open Projects</h5>
                    <span class="project-count"><%= totalAvailable %> available</span>
                </div>

                <% if (projects != null && !projects.isEmpty() && user != null) { %>
                <table class="dv-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Project Title</th>
                            <th>Description</th>
                            <th>Budget</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
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
                        <td class="id-cell">#<%= p.getId() %></td>
                        <td class="project-title-cell"><%= p.getTitle() %></td>
                        <td class="project-desc-cell"><%= p.getDescription() %></td>
                        <td class="budget-cell">₹<%= p.getBudget() %></td>
                        <td>
                            <% if (applied) { %>
                            <span class="badge-applied">
                                <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                Applied
                            </span>
                            <% } else { %>
                            <form action="/ui/applications/apply" method="post" style="margin:0">
                                <input type="hidden" name="projectId" value="<%= p.getId() %>">
                                <input type="hidden" name="freelancerId" value="<%= user.getId() %>">
                                <button type="submit" class="btn-apply">
                                    <svg viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                                    Apply
                                </button>
                            </form>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <div class="empty-state">
                    <svg viewBox="0 0 24 24"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/></svg>
                    <p>No projects available right now. Check back soon.</p>
                </div>
                <% } %>
            </div>
        </div>

    </div>
</div>

<script>
    function toggleSidebar() {
        document.getElementById('sidebar').classList.toggle('collapsed');
        document.getElementById('main').classList.toggle('expanded');
    }
</script>

</body>
</html>