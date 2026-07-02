<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Congés et Absences</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --brand: #da291c;
            --bg: #f5f5f5;
            --panel: #fff;
            --ink: #1a1a1a;
            --muted: #666;
            --line: #e0e0e0;
        }
        body { margin:0; font-family:'Segoe UI',Arial,sans-serif; background:var(--bg); color:var(--ink); }
        .dashboard { display:flex; min-height:100vh; }
        .main { flex:1; padding:30px; }
        .container { background:var(--panel); border-radius:8px; padding:30px; box-shadow:0 2px 8px rgba(0,0,0,0.05); }
        .header { display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:15px; margin-bottom:25px; }
        .header h1 { margin:0; font-size:24px; color:var(--brand); }
        .buttons { display:flex; gap:10px; flex-wrap:wrap; }
        .btn {
            display:inline-flex; align-items:center; gap:8px; padding:10px 20px; border-radius:6px;
            font-size:14px; font-weight:600; text-decoration:none; transition:all 0.2s; border:none; cursor:pointer;
        }
        .btn-primary { background:var(--brand); color:#fff; }
        .btn-primary:hover { background:#b71c13; }
        .btn-secondary { background:#f0f0f0; color:var(--ink); border:1px solid var(--line); }
        .btn-secondary:hover { background:#e0e0e0; }
        .btn-success { background:#28a745; color:#fff; }
        .btn-success:hover { background:#1e7e34; }
        .btn-danger { background:#dc3545; color:#fff; }
        .btn-danger:hover { background:#bd2130; }
        .btn-sm { padding:6px 12px; font-size:13px; }
        .alert { padding:12px 20px; border-radius:6px; margin-bottom:20px; font-weight:500; }
        .alert-success { background:#d4edda; color:#155724; }
        .alert-danger { background:#f8d7da; color:#721c24; }
        .data-table { width:100%; border-collapse:collapse; margin-top:10px; }
        .data-table th { background:#f8f9fa; padding:12px 14px; text-align:left; font-weight:600; color:var(--muted);
                         font-size:13px; text-transform:uppercase; letter-spacing:0.4px; border-bottom:2px solid var(--line); }
        .data-table td { padding:10px 14px; border-bottom:1px solid var(--line); font-size:14px; vertical-align:middle; }
        .data-table tbody tr:hover { background:#fafafa; }
        .badge { display:inline-block; padding:4px 10px; border-radius:4px; font-size:12px; font-weight:600; text-transform:uppercase; }
        .badge-warning { background:#fff3cd; color:#856404; }
        .badge-success { background:#d4edda; color:#155724; }
        .badge-danger { background:#f8d7da; color:#721c24; }
        .actions { display:flex; gap:8px; }
        .sidebar { width:250px; background:#1a1a1a; color:#fff; padding:20px; min-height:100vh; }
    </style>
</head>
<body>
<div class="dashboard">
    <c:set var="activeMenu" value="conges"/>
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div class="main">
        <div class="container">
            <div class="header">
                <h1><i class="fas fa-calendar-alt"></i> Congés et Absences</h1>
                <div class="buttons">
                    <a href="${pageContext.request.contextPath}/conges/demande" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Nouvelle demande
                    </a>
                    <a href="${pageContext.request.contextPath}/conges/export/csv" class="btn btn-secondary">
                        <i class="fas fa-file-csv"></i> CSV
                    </a>
                    <a href="${pageContext.request.contextPath}/conges/print" target="_blank" class="btn btn-secondary">
                        <i class="fas fa-print"></i> Imprimer
                    </a>
                </div>
            </div>

            <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
            <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Employé</th>
                        <th>Type</th>
                        <th>Du</th>
                        <th>Au</th>
                        <th>Statut</th>
                        <th>Déduction (Ar)</th>
                        <th>Remplaçant</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${absences}" var="abs">
                        <tr>
                            <td>${abs.idAbsence}</td>
                            <td>
                                <c:set var="emp" value="${employeService.getEmployeById(abs.idUtilisateur).orElse(null)}"/>
                                ${emp.prenom} ${emp.nom}
                            </td>
                            <td>${typeLibelle.apply(abs.idTypeConge)}</td>
                            <td>${abs.dateDebut}</td>
                            <td>${abs.dateFin}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${abs.idStatutValidation == 1}">
                                        <span class="badge badge-warning">En attente</span>
                                    </c:when>
                                    <c:when test="${abs.idStatutValidation == 2}">
                                        <span class="badge badge-success">Validé</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">Refusé</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${abs.deductionSalaireAppliquee}</td>
                            <td>
                                <c:if test="${not empty abs.idRemplacant}">
                                    <c:set var="remp" value="${employeService.getEmployeById(abs.idRemplacant).orElse(null)}"/>
                                    ${remp.prenom} ${remp.nom}
                                </c:if>
                            </td>
                            <td class="actions">
                                <c:if test="${abs.idStatutValidation == 1}">
                                    <form action="${pageContext.request.contextPath}/conges/valider/${abs.idAbsence}" method="post" style="display:inline;">
                                        <button type="submit" class="btn btn-success btn-sm" title="Valider">
                                            <i class="fas fa-check"></i>
                                        </button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/conges/refuser/${abs.idAbsence}" method="post" style="display:inline;">
                                        <button type="submit" class="btn btn-danger btn-sm" title="Refuser">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </form>
                                </c:if>
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