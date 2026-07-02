<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employés</title>
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
        }

        .dashboard {
            display: flex;
            min-height: 100vh;
        }

        .main {
            flex: 1;
            padding: 30px;
        }

        .table-container {
            background: var(--panel);
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 25px;
        }

        .table-header h1 {
            margin: 0;
            font-size: 24px;
            color: var(--brand);
        }

        .export-buttons {
            display: flex;
            gap: 10px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
            border: none;
            cursor: pointer;
        }

        .btn-secondary {
            background: #f0f0f0;
            color: var(--ink);
            border: 1px solid var(--line);
        }

        .btn-secondary:hover {
            background: #e0e0e0;
        }

        .btn-icon {
            background: none;
            border: none;
            color: var(--brand);
            cursor: pointer;
            font-size: 18px;
            padding: 4px 8px;
            border-radius: 4px;
            transition: background 0.2s;
        }

        .btn-icon:hover {
            background: #fce4e4;
        }

        .alert {
            padding: 12px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        .data-table th {
            background: #f8f9fa;
            padding: 14px 16px;
            text-align: left;
            font-weight: 600;
            color: var(--muted);
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            border-bottom: 2px solid var(--line);
        }

        .data-table td {
            padding: 12px 16px;
            border-bottom: 1px solid var(--line);
            vertical-align: middle;
        }

        .data-table tbody tr:hover {
            background-color: #fafafa;
        }

        .badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .badge-success { background: #d4edda; color: #155724; }
        .badge-danger  { background: #f8d7da; color: #721c24; }

        .actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .actions a {
            color: var(--brand);
        }

        /* Sidebar (conservée pour cohérence, mais style de base déjà dans l'include) */
        .sidebar {
            width: 250px;
            background: #1a1a1a;
            color: white;
            padding: 20px;
            min-height: 100vh;
        }
    </style>
</head>
<body>
<div class="dashboard">
    <c:set var="activeMenu" value="employes"/>
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">
        <div class="table-container">

            <!-- Titre + boutons d'export -->
            <div class="table-header">
                <h1><i class="fas fa-users"></i> Liste des employés</h1>
                <div class="export-buttons">
                    <a href="${pageContext.request.contextPath}/employes/export/csv" class="btn btn-secondary">
                        <i class="fas fa-file-csv"></i> Exporter CSV
                    </a>
                    <a href="${pageContext.request.contextPath}/employes/print" target="_blank" class="btn btn-secondary">
                        <i class="fas fa-print"></i> Imprimer / PDF
                    </a>
                </div>
            </div>

            <!-- Alertes -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <!-- Tableau -->
            <table class="data-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Nom</th>
                    <th>Prénom</th>
                    <th>Email</th>
                    <th>Rôle</th>
                    <th>Salaire (Ar)</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${employes}" var="emp">
                    <tr>
                        <td>${emp.idUtilisateur}</td>
                        <td>${emp.nom}</td>
                        <td>${emp.prenom}</td>
                        <td>${emp.email}</td>
                        <td>${roleLibelle.apply(emp.idRole)}</td>
                        <td>${emp.salaireBaseFixe}</td>
                        <td>
                            <c:choose>
                                <c:when test="${emp.statutActif}">
                                    <span class="badge badge-success">Actif</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">Inactif</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="actions">
                            <a href="${pageContext.request.contextPath}/employes/${emp.idUtilisateur}" title="Détail">
                                <i class="fas fa-eye"></i>
                            </a>
                            <form action="${pageContext.request.contextPath}/employes/${emp.idUtilisateur}/toggle-status" method="post" style="display: inline;">
                                <button type="submit" class="btn-icon" title="Activer / Désactiver">
                                    <i class="fas fa-power-off"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>