<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Nouvelle demande de congé</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --brand: #da291c; --bg: #f5f5f5; --panel: #fff; --ink: #1a1a1a; --muted: #666; --line: #e0e0e0;
        }
        body { margin:0; font-family:'Segoe UI',Arial,sans-serif; background:var(--bg); color:var(--ink); }
        .dashboard { display:flex; min-height:100vh; }
        .main { flex:1; padding:30px; }
        .container { max-width:650px; margin:0 auto; background:var(--panel); border-radius:8px; padding:30px; box-shadow:0 2px 8px rgba(0,0,0,0.05); }
        .header { margin-bottom:30px; }
        .header h1 { margin:0; font-size:24px; color:var(--brand); }
        .btn {
            display:inline-flex; align-items:center; gap:8px; padding:10px 20px; border-radius:6px;
            font-size:14px; font-weight:600; text-decoration:none; cursor:pointer; border:none;
        }
        .btn-secondary { background:#f0f0f0; color:var(--ink); border:1px solid var(--line); }
        .btn-secondary:hover { background:#e0e0e0; }
        .btn-primary { background:var(--brand); color:#fff; margin-top:15px; }
        .btn-primary:hover { background:#b71c13; }
        .form-group { margin-bottom:20px; }
        label { display:block; margin-bottom:6px; font-weight:600; color:var(--muted); }
        input, select, textarea { width:100%; padding:10px; border:1px solid var(--line); border-radius:4px; font-size:14px; }
        .row { display:flex; gap:15px; }
        .row > div { flex:1; }
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
                <h1><i class="fas fa-calendar-plus"></i> Nouvelle demande de congé</h1>
                <a href="${pageContext.request.contextPath}/conges" class="btn btn-secondary" style="margin-top:10px;">
                    <i class="fas fa-arrow-left"></i> Retour
                </a>
            </div>
            <form action="${pageContext.request.contextPath}/conges/demande" method="post">
                <div class="form-group">
                    <label>Employé</label>
                    <select name="idUtilisateur" required>
                        <option value="">-- Sélectionner --</option>
                        <c:forEach items="${employes}" var="emp">
                            <option value="${emp.idUtilisateur}">${emp.prenom} ${emp.nom}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>Type de congé</label>
                    <select name="idTypeConge" required>
                        <option value="1">Congé payé</option>
                        <option value="2">Absence maladie</option>
                        <option value="3">Absence injustifiée</option>
                        <option value="4">Congé exceptionnel</option>
                    </select>
                </div>
                <div class="row">
                    <div class="form-group">
                        <label>Date début</label>
                        <input type="date" name="dateDebut" required>
                    </div>
                    <div class="form-group">
                        <label>Date fin</label>
                        <input type="date" name="dateFin" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Déduction salaire (Ar)</label>
                    <input type="number" step="0.01" name="deduction" value="0.00">
                </div>
                <div class="form-group">
                    <label>Remplaçant (optionnel)</label>
                    <select name="idRemplacant">
                        <option value="">-- Aucun --</option>
                        <c:forEach items="${employes}" var="emp">
                            <option value="${emp.idUtilisateur}">${emp.prenom} ${emp.nom}</option>
                        </c:forEach>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-paper-plane"></i> Soumettre la demande
                </button>
            </form>
        </div>
    </div>
</div>
</body>
</html>