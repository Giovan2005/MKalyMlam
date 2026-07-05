<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fiche employé</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --brand: #da291c;
            --brand-dark: #b71c13;
            --accent: #ffc72c;
            --bg: #f5f5f5;
            --panel: #ffffff;
            --ink: #1a1a1a;
            --muted: #666666;
            --line: #e0e0e0;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            background: var(--bg);
            color: var(--ink);
            font-size: 16px; /* base plus grande */
        }

        .dashboard {
            display: flex;
            min-height: 100vh;
        }

        .main {
            flex: 1;
            padding: 40px; /* plus d'espace autour */
        }

        .form-container {
            max-width: 750px;
            margin: 0 auto;
            background: var(--panel);
            border-radius: 10px;
            padding: 40px; /* bien plus large */
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .form-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px; /* espace accru */
        }

        .form-header h1 {
            margin: 0;
            font-size: 28px; /* titre plus grand */
            color: var(--brand);
            font-weight: 700;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 12px 24px;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
            border: none;
            cursor: pointer;
            line-height: 1.4;
        }

        .btn-secondary {
            background: #f0f0f0;
            color: var(--ink);
            border: 1px solid var(--line);
        }

        .btn-secondary:hover {
            background: #e0e0e0;
        }

        .btn-primary {
            background: var(--brand);
            color: #fff;
            padding: 14px 28px; /* bouton plus grand */
            font-size: 16px;
        }

        .btn-primary:hover {
            background: var(--brand-dark);
        }

        .alert {
            padding: 14px 24px;
            border-radius: 6px;
            margin-bottom: 30px;
            font-weight: 500;
            font-size: 15px;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .card {
            background: transparent; /* pas de double fond */
        }

        .card-body h2 {
            margin: 0 0 35px; /* plus d'espace sous le nom */
            color: var(--brand);
            font-size: 26px;
            font-weight: 700;
        }

        .info-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 40px;
        }

        .info-table th {
            text-align: right;
            width: 180px; /* un peu plus large */
            padding: 16px 20px 16px 0; /* plus d'espace vertical */
            font-weight: 600;
            color: var(--muted);
            font-size: 16px; /* texte plus grand */
            vertical-align: top;
            border-bottom: 1px solid var(--line);
        }

        .info-table td {
            padding: 16px 0;
            font-size: 16px;
            border-bottom: 1px solid var(--line);
            line-height: 1.6;
        }

        .badge {
            display: inline-block;
            padding: 8px 18px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-success {
            background: #d4edda;
            color: #155724;
        }

        .badge-danger {
            background: #f8d7da;
            color: #721c24;
        }

        /* Sidebar conservée pour cohérence */
        .sidebar {
            width: 250px;
            background: #1a1a1a;
            color: white;
            padding: 20px;
            min-height: 100vh;
        }

        /* Espacement entre le bouton d'action et le tableau */
        .form-action {
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="dashboard">
    <c:set var="activeMenu" value="employes"/>
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">
        <div class="form-container">

            <div class="form-header">
                <h1><i class="fas fa-id-card"></i> Fiche employé</h1>
                <a href="${pageContext.request.contextPath}/employes" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Retour à la liste
                </a>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <div class="card">
                <div class="card-body">
                    <h2>${employe.prenom} ${employe.nom}</h2>

                    <table class="info-table">
                        <tr>
                            <th>ID</th>
                            <td>${employe.idUtilisateur}</td>
                        </tr>
                        <tr>
                            <th>Email</th>
                            <td>${employe.email}</td>
                        </tr>
                        <tr>
                            <th>Rôle</th>
                            <td>${roleLibelle}</td>
                        </tr>
                        <tr>
                            <th>Salaire</th>
                            <td>${employe.salaireBaseFixe} Ar</td>
                        </tr>
                        <tr>
                            <th>Statut</th>
                            <td>
                                <c:choose>
                                    <c:when test="${employe.statutActif}">
                                        <span class="badge badge-success">Actif</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">Inactif</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </table>

                    <form action="${pageContext.request.contextPath}/employes/${employe.idUtilisateur}/toggle-status" method="post" class="form-action">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-power-off"></i>
                            <c:choose>
                                <c:when test="${employe.statutActif}">Désactiver le compte</c:when>
                                <c:otherwise>Activer le compte</c:otherwise>
                            </c:choose>
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>