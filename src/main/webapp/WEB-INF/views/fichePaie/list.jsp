<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <title>Liste des fiches de paie - Administration</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_form.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_liste_prod.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

<div class="dashboard">
    <c:set var="activeMenu" value="fiches-paie"/>

    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">

        <c:if test="${not empty successMessage}">
            <div style="margin-bottom:20px;padding:14px 18px;border-radius:12px;background:#ecfdf5;color:#047857;font-weight:600;">
                ${successMessage}
            </div>
        </c:if>

        <div class="table-container">
            <div class="table-header">
                <h1>
                    <i class="fas fa-file-invoice-dollar" style="color:var(--primary);margin-right:10px;"></i>
                    Fiches de paie
                </h1>

                <a href="${pageContext.request.contextPath}/fiches-paie/new" class="btn-add">
                    Générer une fiche de paie
                </a>
            </div>

            <table>
                <thead>
                <tr>
                    <th><i class="fas fa-hashtag"></i> ID</th>
                    <th><i class="fas fa-user"></i> Employé</th>
                    <th><i class="fas fa-calendar"></i> Mois</th>
                    <th><i class="fas fa-money-bill-wave"></i> Brut</th>
                    <th><i class="fas fa-wallet"></i> Net versé</th>
                    <th><i class="fas fa-clock"></i> Date paiement</th>
                </tr>
                </thead>

                <tbody>
                <c:if test="${empty fichesPaie}">
                    <tr>
                        <td colspan="6">
                            <div class="empty-state">
                                <i class="fas fa-file-invoice-dollar" style="font-size:48px;color:#d1d5db;margin-bottom:15px;display:block;"></i>
                                <p>Aucune fiche de paie générée pour le moment.</p>
                                <a href="${pageContext.request.contextPath}/fiches-paie/new" class="btn-add">
                                    <i class="fas fa-plus"></i>
                                    Générer la première fiche
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:if>

                <c:forEach var="fiche" items="${fichesPaie}">
                    <tr>
                        <td><span class="product-id">${fiche.idFiche}</span></td>
                        <td>
                            <strong>
                                ${fiche.utilisateur.nom}
                                ${fiche.utilisateur.prenom}
                            </strong>
                        </td>
                        <td>${fiche.moisAnnee}</td>
                        <td><span class="price-tag">${fiche.montantFixeBrut}</span></td>
                        <td><span class="price-tag">${fiche.montantNetVerse}</span></td>
                        <td>${fiche.datePaiement}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>