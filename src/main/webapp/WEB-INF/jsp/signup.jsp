<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DealVault — Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --navy-deep:    #0d1117;
            --navy-surface: #161b27;
            --navy-card:    #1e2535;
            --navy-border:  #2a3148;
            --gold:         #c9a84c;
            --gold-hover:   #e0bc6a;
            --gold-dim:     rgba(201,168,76,0.12);
            --gold-glow:    rgba(201,168,76,0.25);
            --text-primary: #e8eaf0;
            --text-muted:   #7a8499;
        }

        html, body {
            min-height: 100%;
            background-color: var(--navy-deep);
            font-family: 'DM Sans', sans-serif;
            color: var(--text-primary);
        }

        /* ── Background ── */
        .bg-scene {
            position: fixed;
            inset: 0;
            z-index: 0;
            overflow: hidden;
        }
        .bg-grid {
            position: absolute;
            inset: 0;
            background-image:
                linear-gradient(var(--navy-border) 1px, transparent 1px),
                linear-gradient(90deg, var(--navy-border) 1px, transparent 1px);
            background-size: 48px 48px;
            opacity: 0.35;
        }
        .bg-orb {
            position: absolute;
            border-radius: 50%;
            filter: blur(80px);
            opacity: 0.16;
        }
        .bg-orb-1 {
            width: 420px; height: 420px;
            background: var(--gold);
            top: -100px; left: -80px;
        }
        .bg-orb-2 {
            width: 300px; height: 300px;
            background: #3a4b8a;
            bottom: -60px; right: -60px;
        }

        /* ── Layout ── */
        .page-wrap {
            position: relative;
            z-index: 1;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2.5rem 1.5rem;
        }

        .register-panel {
            width: 100%;
            max-width: 460px;
            animation: slideUp 0.55s cubic-bezier(0.22, 1, 0.36, 1) both;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(28px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── Logo ── */
        .logo-mark {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 2rem;
            text-decoration: none;
        }
        .logo-icon {
            width: 38px; height: 38px;
            border-radius: 10px;
            background: var(--gold-dim);
            border: 1px solid var(--gold);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .logo-icon svg { width: 20px; height: 20px; fill: var(--gold); }
        .logo-wordmark {
            font-family: 'Syne', sans-serif;
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text-primary);
            letter-spacing: -0.02em;
        }
        .logo-wordmark span { color: var(--gold); }

        /* ── Card ── */
        .auth-card {
            background: var(--navy-card);
            border: 1px solid var(--navy-border);
            border-radius: 16px;
            padding: 2.25rem 2rem;
            box-shadow:
                0 0 0 1px rgba(201,168,76,0.06),
                0 24px 48px rgba(0,0,0,0.45);
        }

        .auth-card-header { margin-bottom: 1.5rem; }
        .auth-card-header h1 {
            font-family: 'Syne', sans-serif;
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--text-primary);
            letter-spacing: -0.03em;
            line-height: 1.2;
            margin-bottom: 0.4rem;
        }
        .auth-card-header p {
            font-size: 0.875rem;
            color: var(--text-muted);
        }

        .gold-divider {
            width: 36px; height: 2px;
            background: var(--gold);
            border-radius: 2px;
            margin-bottom: 1.5rem;
        }

        /* ── Form Fields ── */
        .field-group { margin-bottom: 1.1rem; }

        .field-label {
            display: block;
            font-size: 0.75rem;
            font-weight: 500;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--text-muted);
            margin-bottom: 0.45rem;
        }

        .field-input,
        .field-select {
            width: 100%;
            background: var(--navy-surface);
            border: 1px solid var(--navy-border);
            border-radius: 8px;
            padding: 0.75rem 1rem;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.9rem;
            color: var(--text-primary);
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            appearance: none;
            -webkit-appearance: none;
        }
        .field-input::placeholder { color: #4a5468; }
        .field-input:focus,
        .field-select:focus {
            border-color: var(--gold);
            box-shadow: 0 0 0 3px var(--gold-dim);
        }
        .field-input:-webkit-autofill,
        .field-input:-webkit-autofill:focus {
            -webkit-box-shadow: 0 0 0 100px var(--navy-surface) inset;
            -webkit-text-fill-color: var(--text-primary);
            caret-color: var(--text-primary);
        }

        /* ── Role Selector ── */
        .select-wrapper {
            position: relative;
        }
        .select-wrapper::after {
            content: '';
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            width: 0; height: 0;
            border-left: 5px solid transparent;
            border-right: 5px solid transparent;
            border-top: 5px solid var(--text-muted);
            pointer-events: none;
        }
        .field-select option {
            background: var(--navy-card);
            color: var(--text-primary);
        }

        /* ── Role Cards ── */
        .role-cards {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.75rem;
            margin-bottom: 1.1rem;
        }
        .role-card-label {
            cursor: pointer;
            display: block;
        }
        .role-card-label input[type="radio"] {
            display: none;
        }
        .role-card-inner {
            border: 1px solid var(--navy-border);
            border-radius: 10px;
            padding: 1rem 0.85rem;
            background: var(--navy-surface);
            transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            gap: 6px;
        }
        .role-card-label input[type="radio"]:checked + .role-card-inner {
            border-color: var(--gold);
            background: var(--gold-dim);
            box-shadow: 0 0 0 3px var(--gold-dim);
        }
        .role-card-inner svg {
            width: 22px; height: 22px;
            stroke: var(--text-muted);
            transition: stroke 0.2s;
            fill: none;
            stroke-width: 1.8;
        }
        .role-card-label input[type="radio"]:checked + .role-card-inner svg {
            stroke: var(--gold);
        }
        .role-card-title {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--text-primary);
        }
        .role-card-desc {
            font-size: 0.72rem;
            color: var(--text-muted);
            line-height: 1.4;
        }

        /* ── Hidden select (for form submit) ── */
        #roleSelect { display: none; }

        /* ── Button ── */
        .btn-gold {
            width: 100%;
            padding: 0.8rem 1.25rem;
            background: var(--gold);
            color: #0d1117;
            border: none;
            border-radius: 8px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, transform 0.15s, box-shadow 0.2s;
            margin-top: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .btn-gold:hover {
            background: var(--gold-hover);
            box-shadow: 0 6px 20px var(--gold-glow);
        }
        .btn-gold:active { transform: scale(0.98); }

        /* ── Footer ── */
        .auth-footer {
            margin-top: 1.5rem;
            text-align: center;
            font-size: 0.8rem;
            color: var(--text-muted);
        }
        .auth-footer a {
            color: var(--gold);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }
        .auth-footer a:hover { color: var(--gold-hover); text-decoration: underline; }

        /* ── Trust Strip ── */
        .trust-strip {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1.25rem;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--navy-border);
        }
        .trust-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 0.72rem;
            color: var(--text-muted);
        }
        .trust-item svg { flex-shrink: 0; }
    </style>
</head>
<body>

    <div class="bg-scene">
        <div class="bg-grid"></div>
        <div class="bg-orb bg-orb-1"></div>
        <div class="bg-orb bg-orb-2"></div>
    </div>

    <div class="page-wrap">
        <div class="register-panel">

            <!-- Logo -->
            <a href="/" class="logo-mark">
                <div class="logo-icon">
                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path d="M12 2L3 6v6c0 5.25 3.75 10.15 9 11.25C17.25 22.15 21 17.25 21 12V6L12 2zm0 4a3 3 0 1 1 0 6 3 3 0 0 1 0-6zm0 13c-2.5 0-4.71-1.28-6-3.22.03-1.99 4-3.08 6-3.08s5.96 1.09 6 3.08A7.2 7.2 0 0 1 12 19z"/>
                    </svg>
                </div>
                <span class="logo-wordmark">Deal<span>Vault</span></span>
            </a>

            <!-- Card -->
            <div class="auth-card">
                <div class="auth-card-header">
                    <h1>Create your account</h1>
                    <p>Join DealVault and start working securely</p>
                </div>
                <div class="gold-divider"></div>

                <form action="/api/users/register-ui" method="post" id="registerForm">

                    <div class="field-group">
                        <label class="field-label" for="email">Email address</label>
                        <input
                            class="field-input"
                            type="email"
                            id="email"
                            name="email"
                            placeholder="you@example.com"
                            autocomplete="email"
                            required
                        >
                    </div>

                    <div class="field-group">
                        <label class="field-label" for="password">Password</label>
                        <input
                            class="field-input"
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Create a strong password"
                            autocomplete="new-password"
                            required
                        >
                    </div>

                    <!-- Role Picker -->
                    <div class="field-group">
                        <span class="field-label">I want to join as</span>
                        <div class="role-cards">

                            <label class="role-card-label">
                                <input type="radio" name="roleUI" value="FREELANCER" checked onchange="syncRole(this.value)">
                                <div class="role-card-inner">
                                    <svg viewBox="0 0 24 24"><path d="M20 7H4a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
                                    <span class="role-card-title">Freelancer</span>
                                    <span class="role-card-desc">Find work &amp; get paid securely</span>
                                </div>
                            </label>

                            <label class="role-card-label">
                                <input type="radio" name="roleUI" value="CLIENT" onchange="syncRole(this.value)">
                                <div class="role-card-inner">
                                    <svg viewBox="0 0 24 24"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/><line x1="12" y1="12" x2="12" y2="16"/><line x1="10" y1="14" x2="14" y2="14"/></svg>
                                    <span class="role-card-title">Client</span>
                                    <span class="role-card-desc">Post projects &amp; hire talent</span>
                                </div>
                            </label>

                        </div>
                        <!-- Hidden select keeps the original name="role" for Spring MVC -->
                        <select name="role" id="roleSelect">
                            <option value="FREELANCER">FREELANCER</option>
                            <option value="CLIENT">CLIENT</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-gold">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/>
                        </svg>
                        Create my account
                    </button>

                </form>

                <p class="auth-footer">
                    Already have an account?&nbsp;
                    <a href="/api/users/login">Sign in instead</a>
                </p>
            </div>

            <!-- Trust Strip -->
            <div class="trust-strip">
                <div class="trust-item">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" opacity=".6"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    Secure signup
                </div>
                <div class="trust-item">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" opacity=".6"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    Escrow protected
                </div>
                <div class="trust-item">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" opacity=".6"><polyline points="20 6 9 17 4 12"/></svg>
                    Free to join
                </div>
            </div>

        </div>
    </div>

    <script>
        function syncRole(val) {
            document.getElementById('roleSelect').value = val;
        }
    </script>

</body>
</html>