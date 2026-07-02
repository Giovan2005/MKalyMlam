<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste des employés (impression)</title>
    <style>
        /* Styles pour l'impression */
        @media print {
            body { margin: 0; padding: 0; }
            .no-print { display: none; }
            table { width: 100%; border-collapse: collapse; font-size: 12px; }
            th, td { padding: 6px; border: 1px solid #ccc; text-align: left; }
            th { background-color: #eee; }
        }
        /* Styles à l'écran */
        @media screen {
            body { font-family: Arial, sans-serif; margin: 20px; }
            .no-print { margin-bottom: 20px; }
            table { width: 100%; border-collapse: collapse; margin-top: 10px; }
            th, td { padding: 8px; border: 1px solid #ddd; }
            th { background-color: #f5f5f5; }
        }
    </style>
</head>
<body>
    <div class="no-print">
        <button onclick="window.print()" style="padding: 8px 16px; font-size: 14px;">
            🖨️ Imprimer / Enregistrer en PDF
        </button>
        <a href="${pageContext.request.contextPath}/employes" style="margin-left: 10px;">← Retour à la liste</a>
    </div>

    <h2>Liste des employés</h2>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Prénom</th>
                <th>Email</th>
                <th>Rôle</th>
                <th>Salaire</th>
                <th>Statut</th>
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
                    <td>${emp.statutActif ? 'Actif' : 'Inactif'}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>