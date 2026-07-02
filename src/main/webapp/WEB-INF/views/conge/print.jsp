<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Impression - Congés</title>
    <style>
        @media print {
            body { margin:0; }
            .no-print { display:none; }
            table { width:100%; border-collapse:collapse; font-size:12px; }
            th, td { padding:6px; border:1px solid #ccc; text-align:left; }
            th { background:#eee; }
        }
        @media screen {
            body { font-family:Arial; margin:20px; }
            .no-print { margin-bottom:20px; }
            table { width:100%; border-collapse:collapse; margin-top:10px; }
            th, td { padding:8px; border:1px solid #ddd; }
            th { background:#f5f5f5; }
        }
        .btn { padding:8px 16px; font-size:14px; cursor:pointer; }
    </style>
</head>
<body>
    <div class="no-print">
        <button onclick="window.print()" class="btn">🖨️ Imprimer / Enregistrer en PDF</button>
        <a href="${pageContext.request.contextPath}/conges" style="margin-left:10px;">← Retour</a>
    </div>
    <h2>Liste des congés et absences</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th><th>Employé</th><th>Type</th><th>Début</th><th>Fin</th><th>Statut</th><th>Déduction</th><th>Remplaçant</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${absences}" var="a">
                <tr>
                    <td>${a.idAbsence}</td>
                    <td>
                        <c:set var="emp" value="${employeService.getEmployeById(a.idUtilisateur).orElse(null)}"/>
                        ${emp.prenom} ${emp.nom}
                    </td>
                    <td>${typeLibelle.apply(a.idTypeConge)}</td>
                    <td>${a.dateDebut}</td>
                    <td>${a.dateFin}</td>
                    <td>${statutLibelle.apply(a.idStatutValidation)}</td>
                    <td>${a.deductionSalaireAppliquee}</td>
                    <td>
                        <c:if test="${not empty a.idRemplacant}">
                            <c:set var="remp" value="${employeService.getEmployeById(a.idRemplacant).orElse(null)}"/>
                            ${remp.prenom} ${remp.nom}
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>