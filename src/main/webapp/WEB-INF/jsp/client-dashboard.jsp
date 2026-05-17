<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.dealvault.dealvault.model.Application" %>
<%@ page import="com.dealvault.dealvault.model.Project" %>
<%@ page import="com.dealvault.dealvault.model.User" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DealVault — Client Dashboard</title>
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

        /* ══════════════════════
           SIDEBAR
        ══════════════════════ */
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
            top: 20px; right: -12px;
            width: 24px; height: 24px;
            border-radius: 50%;
            background: var(--navy-card);
            border: 1px solid var(--navy-border);
            cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            z-index: 101;
        }
        .sidebar-toggle svg {
            width: 12px; height: 12px;
            stroke: var(--text-muted);
            fill: none; stroke-width: 2.5;
            transition: transform 0.25s;
        }
        .sidebar.collapsed .sidebar-toggle svg { transform: rotate(180deg); }

        .sidebar-nav {
            flex: 1;
            padding: 1rem 0.5rem;
            overflow-y: auto; overflow-x: hidden;
        }
        .sidebar-section-label {
            font-size: 0.65rem;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--text-muted);
            padding: 0.75rem 0.75rem 0.4rem;
            white-space: nowrap;
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
            white-space: nowrap;
            transition: background 0.15s, color 0.15s;
            margin-bottom: 2px;
        }
        .nav-item:hover { background: rgba(255,255,255,0.05); color: var(--text-primary); }
        .nav-item.active { background: var(--gold-dim); color: var(--gold); font-weight: 500; }
        .nav-item svg {
            width: 18px; height: 18px;
            stroke: currentColor; fill: none; stroke-width: 1.8;
            flex-shrink: 0;
        }
        .nav-label { transition: opacity 0.15s; }
        .sidebar.collapsed .nav-label { opacity: 0; }

        .sidebar-footer {
            padding: 1rem 0.5rem;
            border-top: 1px solid var(--navy-border);
        }
        .user-pill {
            display: flex; align-items: center; gap: 10px;
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
            font-size: 0.7rem; font-weight: 600; color: var(--gold);
            flex-shrink: 0;
        }
        .user-name { font-size: 0.8rem; font-weight: 500; color: var(--text-primary); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .user-role-label { font-size: 0.68rem; color: var(--text-muted); }
        .sidebar.collapsed .user-info { display: none; }

        /* ══════════════════════
           MAIN LAYOUT
        ══════════════════════ */
        .main {
            margin-left: var(--sidebar-w);
            min-height: 100vh;
            transition: margin-left 0.25s cubic-bezier(0.4,0,0.2,1);
        }
        .main.expanded { margin-left: var(--sidebar-collapsed); }

        .topbar {
            height: 64px;
            background: var(--navy-surface);
            border-bottom: 1px solid var(--navy-border);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 2rem;
            position: sticky; top: 0; z-index: 50;
        }
        .topbar-title {
            font-family: 'Syne', sans-serif;
            font-size: 1rem; font-weight: 600;
            color: var(--text-primary);
        }
        .topbar-right { display: flex; align-items: center; gap: 1rem; }

        .wallet-chip {
            display: flex; align-items: center; gap: 8px;
            background: var(--gold-dim);
            border: 1px solid rgba(201,168,76,0.3);
            border-radius: 20px;
            padding: 0.35rem 0.85rem;
            font-size: 0.82rem; font-weight: 600;
            color: var(--gold);
        }
        .wallet-chip svg { width: 14px; height: 14px; fill: var(--gold); }

        .locked-chip {
            display: flex; align-items: center; gap: 8px;
            background: var(--danger-dim);
            border: 1px solid rgba(224,92,92,0.25);
            border-radius: 20px;
            padding: 0.35rem 0.85rem;
            font-size: 0.82rem; font-weight: 600;
            color: #e05c5c;
        }
        .locked-chip svg { width: 14px; height: 14px; stroke: #e05c5c; fill: none; stroke-width: 2; }

        .page-content { padding: 2rem; }

        /* ══════════════════════
           STATS ROW
        ══════════════════════ */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
            margin-bottom: 1.75rem;
        }
        .stat-card {
            background: var(--navy-card);
            border: 1px solid var(--navy-border);
            border-radius: 12px;
            padding: 1.25rem 1.5rem;
        }
        .stat-label { font-size: 0.72rem; font-weight: 500; letter-spacing: 0.05em; text-transform: uppercase; color: var(--text-muted); margin-bottom: 0.5rem; }
        .stat-value { font-family: 'Syne', sans-serif; font-size: 1.6rem; font-weight: 700; color: var(--text-primary); letter-spacing: -0.02em; }
        .stat-value.gold { color: var(--gold); }
        .stat-value.danger { color: var(--danger); }
        .stat-sub { font-size: 0.72rem; color: var(--text-muted); margin-top: 0.2rem; }

        /* ══════════════════════
           SECTION TITLE
        ══════════════════════ */
        .section-title {
            font-family: 'Syne', sans-serif;
            font-size: 0.7rem; font-weight: 600;
            letter-spacing: 0.1em; text-transform: uppercase;
            color: var(--text-muted);
            margin-bottom: 1rem;
        }

        /* ══════════════════════
           PROJECTS TABLE CARD
        ══════════════════════ */
        .table-card {
            background: var(--navy-card);
            border: 1px solid var(--navy-border);
            border-radius: 14px;
            overflow: hidden;
            margin-bottom: 1.75rem;
        }
        .table-card-header {
            display: flex; align-items: center; justify-content: space-between;
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--navy-border);
        }
        .table-card-header h5 {
            font-family: 'Syne', sans-serif;
            font-size: 0.95rem; font-weight: 600;
            color: var(--text-primary); margin: 0;
        }
        .count-badge {
            font-size: 0.72rem;
            background: var(--gold-dim); color: var(--gold);
            border-radius: 20px; padding: 0.2rem 0.65rem; font-weight: 500;
        }

        .dv-table { width: 100%; border-collapse: collapse; }
        .dv-table thead tr { border-bottom: 1px solid var(--navy-border); }
        .dv-table thead th {
            padding: 0.75rem 1.5rem;
            font-size: 0.68rem; font-weight: 600;
            letter-spacing: 0.07em; text-transform: uppercase;
            color: var(--text-muted); text-align: left; white-space: nowrap;
        }
        .dv-table tbody tr {
            border-bottom: 1px solid rgba(42,49,72,0.6);
            transition: background 0.15s;
        }
        .dv-table tbody tr:last-child { border-bottom: none; }
        .dv-table tbody tr:hover { background: rgba(255,255,255,0.025); }
        .dv-table td {
            padding: 1rem 1.5rem;
            font-size: 0.855rem; color: var(--text-primary);
            vertical-align: top;
        }

        .id-cell { color: var(--text-muted); font-size: 0.78rem; font-family: monospace; }
        .title-cell { font-weight: 500; }
        .budget-cell { font-weight: 600; color: var(--gold); font-family: 'Syne', sans-serif; }

        /* ══════════════════════
           APPLICANT ACTIONS
        ══════════════════════ */
        .applicant-row {
            display: flex; align-items: center; gap: 10px;
            padding: 0.6rem 0.85rem;
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--navy-border);
            border-radius: 8px;
            margin-bottom: 6px;
        }
        .applicant-row:last-child { margin-bottom: 0; }
        .applicant-avatar {
            width: 28px; height: 28px;
            border-radius: 50%;
            background: var(--info-dim);
            border: 1px solid rgba(76,140,224,0.3);
            display: flex; align-items: center; justify-content: center;
            font-size: 0.62rem; font-weight: 600; color: #4c8ce0;
            flex-shrink: 0;
        }
        .applicant-id { font-size: 0.78rem; color: var(--text-muted); flex: 1; }

        .btn-select {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 0.3rem 0.75rem;
            background: var(--gold); color: #0d1117;
            border: none; border-radius: 6px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.72rem; font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, box-shadow 0.2s;
        }
        .btn-select:hover { background: var(--gold-hover); box-shadow: 0 3px 10px var(--gold-glow); }

        .status-pill {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 0.55rem 0.85rem;
            border-radius: 8px;
            font-size: 0.78rem; font-weight: 500;
            margin-bottom: 6px;
            width: 100%;
        }
        .status-pill.success { background: var(--success-dim); color: var(--success); border: 1px solid rgba(46,168,126,0.25); }
        .status-pill.warning { background: var(--warning-dim); color: var(--warning); border: 1px solid rgba(224,169,76,0.25); }
        .status-pill.info    { background: var(--info-dim);    color: #4c8ce0;        border: 1px solid rgba(76,140,224,0.25); }

        .btn-approve {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 0.4rem 0.9rem;
            background: var(--success); color: #fff;
            border: none; border-radius: 6px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.75rem; font-weight: 600;
            cursor: pointer;
            transition: opacity 0.2s, box-shadow 0.2s;
            margin-top: 6px;
        }
        .btn-approve:hover { opacity: 0.88; box-shadow: 0 4px 12px rgba(46,168,126,0.35); }
        .btn-approve svg { width: 13px; height: 13px; stroke: currentColor; fill: none; stroke-width: 2.5; }

        .no-apps { font-size: 0.78rem; color: var(--text-muted); }

        /* ══════════════════════
           CREATE PROJECT CARD
        ══════════════════════ */
        .create-card {
            background: var(--navy-card);
            border: 1px solid var(--navy-border);
            border-radius: 14px;
            overflow: hidden;
        }
        .create-card-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--navy-border);
            display: flex; align-items: center; gap: 10px;
        }
        .create-card-header h5 {
            font-family: 'Syne', sans-serif;
            font-size: 0.95rem; font-weight: 600;
            color: var(--text-primary); margin: 0;
        }
        .create-card-header svg {
            width: 16px; height: 16px;
            stroke: var(--gold); fill: none; stroke-width: 2;
        }
        .create-card-body { padding: 1.5rem; }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        .form-grid-full { grid-column: 1 / -1; }

        .field-group { display: flex; flex-direction: column; }
        .field-label {
            font-size: 0.72rem; font-weight: 500;
            letter-spacing: 0.06em; text-transform: uppercase;
            color: var(--text-muted); margin-bottom: 0.4rem;
        }
        .field-input, .field-textarea {
            background: var(--navy-surface);
            border: 1px solid var(--navy-border);
            border-radius: 8px;
            padding: 0.7rem 1rem;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.875rem; color: var(--text-primary);
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            width: 100%;
        }
        .field-input::placeholder, .field-textarea::placeholder { color: #4a5468; }
        .field-input:focus, .field-textarea:focus {
            border-color: var(--gold);
            box-shadow: 0 0 0 3px var(--gold-dim);
        }
        .field-textarea { resize: vertical; min-height: 80px; }

        /* remove number input arrows */
        .field-input[type=number]::-webkit-inner-spin-button,
        .field-input[type=number]::-webkit-outer-spin-button { -webkit-appearance: none; }
        .field-input[type=number] { -moz-appearance: textfield; }

        .btn-create {
            display: inline-flex; align-items: center; gap: 8px;
            padding: 0.75rem 1.5rem;
            background: var(--gold); color: #0d1117;
            border: none; border-radius: 8px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.875rem; font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, box-shadow 0.2s, transform 0.15s;
        }
        .btn-create:hover { background: var(--gold-hover); box-shadow: 0 6px 20px var(--gold-glow); }
        .btn-create:active { transform: scale(0.97); }
        .btn-create svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 2.2; }
        .error-box{
    background: rgba(224,92,92,0.12);
    border: 1px solid #e05c5c;
    color: #ff7b7b;
    padding: 14px 18px;
    border-radius: 14px;
    margin-bottom: 20px;
    font-weight: 600;
}
.wallet-topup-card{
    background: var(--navy-card);
    border: 1px solid var(--navy-border);
    border-radius: 18px;
    padding: 24px;
    margin-bottom: 28px;
}

.wallet-title{
    font-size: 1.1rem;
    font-weight: 700;
    margin-bottom: 18px;
    color: white;
}

.wallet-form{
    display:flex;
    gap:14px;
}

.wallet-form input{
    flex:1;
    background:#101728;
    border:1px solid var(--navy-border);
    border-radius:12px;
    padding:14px;
    color:white;
}

.wallet-form button{
    background:var(--gold);
    color:black;
    border:none;
    border-radius:12px;
    padding:14px 22px;
    font-weight:700;
}
    </style>
</head>
<body>
<%
String error = request.getParameter("error");
%>
<%
    List projects = (List) request.getAttribute("projects");
    List applications = (List) request.getAttribute("applications");
    User user = (User) request.getAttribute("user");
    Object lockedAmount = request.getAttribute("lockedAmount");
    int totalProjects = (projects != null) ? projects.size() : 0;
    int totalApplicants = (applications != null) ? applications.size() : 0;
%>

<!-- ══════ SIDEBAR ══════ -->
<aside class="sidebar" id="sidebar">
    <div class="sidebar-toggle" onclick="toggleSidebar()">
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
            <span class="nav-label">My Projects</span>
        </a>

        <a href="#create-section" class="nav-item">
            <svg viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            <span class="nav-label">New Project</span>
        </a>

        <div class="sidebar-section-label">Account</div>

        <a href="/api/users/logout" class="nav-item">
            <svg viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            <span class="nav-label">Logout</span>
        </a>
    </nav>

    <div class="sidebar-footer">
        <div class="user-pill">
            <div class="user-avatar">CL</div>
            <div class="user-info">
                <div class="user-name"><%= user != null ? user.getEmail() : "Client" %></div>
                <div class="user-role-label">Client</div>
            </div>
        </div>
    </div>
</aside>

<!-- ══════ MAIN ══════ -->
<div class="main" id="main">
<% if("insufficient".equals(error)){ %>

<div class="error-box">
    Insufficient wallet balance. Please add money first.
</div>

<% } %>
    <!-- Top Bar -->
    <div class="topbar">
        <span class="topbar-title">Client Dashboard</span>
        <div class="topbar-right">
            <div class="locked-chip">
                <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                ₹<%= lockedAmount != null ? lockedAmount : "0" %> locked
            </div>
            <div class="wallet-chip">
                <svg viewBox="0 0 24 24"><path d="M20 12V8H6a2 2 0 0 1-2-2c0-1.1.9-2 2-2h12v4"/><path d="M4 6v12c0 1.1.9 2 2 2h14v-4"/><path d="M18 12a2 2 0 0 0-2 2c0 1.1.9 2 2 2h4v-4h-4z"/></svg>
                ₹${user.balance}
            </div>
        </div>
    </div>

    <div class="page-content">

        <!-- Stats Row -->
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-label">Wallet Balance</div>
                <div class="stat-value gold">₹${user.balance}</div>
                <div class="stat-sub">Available funds</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Locked in Escrow</div>
                <div class="stat-value danger">₹<%= lockedAmount != null ? lockedAmount : "0" %></div>
                <div class="stat-sub">Held for active projects</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Total Projects</div>
                <div class="stat-value"><%= totalProjects %></div>
                <div class="stat-sub"><%= totalApplicants %> total applicants</div>
            </div>
        </div>
		<div class="wallet-topup-card">

    <div class="wallet-title">
        Add Money To Wallet
    </div>

    <form action="${pageContext.request.contextPath}/wallet/add" method="post" class="wallet-form">

        <input type="hidden"
               name="userId"
               value="${user.id}">

        <input type="number"
               name="amount"
               placeholder="Enter amount"
               required>

        <button type="submit">
            Add Money
        </button>

    </form>

</div>
        <!-- Projects Table -->
        <div id="projects-section" style="margin-bottom: 1.75rem;">
            <div class="section-title">Your Projects</div>
            <div class="table-card">
                <div class="table-card-header">
                    <h5>Project Overview</h5>
                    <span class="count-badge"><%= totalProjects %> projects</span>
                </div>

                <table class="dv-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Title</th>
                            <th>Budget</th>
                            <th>Applicants / Status</th>
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
                        <td class="id-cell">#<%= p.getId() %></td>
                        <td class="title-cell"><%= p.getTitle() %></td>
                        <td class="budget-cell">₹<%= p.getBudget() %></td>
                        <td>
                        <%
                            if (applications != null) {
                                for (Object a : applications) {
                                    Application app = (Application) a;
                                    if (app.getProjectId().equals(p.getId())) {

                                        if ("COMPLETION_REQUESTED".equals(app.getStatus())) {
                                        	accepted = true;
                        %>
                            <div class="status-pill warning">
                                ⚠ Freelancer #<%= app.getFreelancerId() %> submitted completion
                            </div>
                            <form action="/ui/projects/approve" method="post" style="margin:0">
                                <input type="hidden" name="projectId" value="<%= p.getId() %>">
                                <button type="submit" class="btn-approve">
                                    <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                    Approve & Release Payment
                                </button>
                            </form>
                        <%
                                        } else if ("ACCEPTED".equals(app.getStatus())) {
                                            accepted = true;
                        %>
                            <div class="status-pill success">
                                ✅ Freelancer #<%= app.getFreelancerId() %> — In Progress
                            </div>
                            <div class="status-pill info" style="margin-top:4px;">
                                💰 ₹<%= p.getBudget() %> locked in escrow
                            </div>
                        <%
                                        } else if ("APPLIED".equals(app.getStatus())) {
                                            hasApps = true;
                        %>
                            <div class="applicant-row">
                                <div class="applicant-avatar">F</div>
                                <span class="applicant-id">Freelancer #<%= app.getFreelancerId() %></span>
                                <form action="/ui/applications/select-ui" method="post" style="margin:0">
                                    <input type="hidden" name="projectId" value="<%= p.getId() %>">
                                    <input type="hidden" name="freelancerId" value="<%= app.getFreelancerId() %>">
                                    <input type="hidden" name="clientId" value="<%= user.getId() %>">
                                    <button type="submit" class="btn-select">Select</button>
                                </form>
                            </div>
                        <%
                                        }
                                    }
                                }
                            }
                            if (!hasApps && !accepted) {
                        %>
                            <span class="no-apps">No applications yet</span>
                        <%  } %>
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

        <!-- Create Project -->
        <div id="create-section">
            <div class="section-title">New Project</div>
            <div class="create-card">
                <div class="create-card-header">
                    <svg viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                    <h5>Post a New Project</h5>
                </div>
                <div class="create-card-body">
                    <form action="/ui/projects/create" method="post">
                        <div class="form-grid">
                            <div class="field-group form-grid-full">
                                <label class="field-label">Project Title</label>
                                <input class="field-input" type="text" name="title" placeholder="e.g. Build a React dashboard" required>
                            </div>
                            <div class="field-group form-grid-full">
                                <label class="field-label">Description</label>
                                <textarea class="field-textarea" name="description" placeholder="Describe the project scope, deliverables, and timeline..." required></textarea>
                            </div>
                            <div class="field-group">
                                <label class="field-label">Budget (₹)</label>
                                <input class="field-input" type="number" name="budget" placeholder="e.g. 25000" required>
                            </div>
                        </div>
                        <input type="hidden" name="clientId" value="<%= user != null ? user.getId() : "" %>">
                        <button type="submit" class="btn-create">
                            <svg viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                            Post Project
                        </button>
                    </form>
                </div>
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