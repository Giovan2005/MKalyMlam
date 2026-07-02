<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<div class="sidebar">

    <h2>ADMIN PANEL</h2>

    <%-- Affichage de l'utilisateur connecté --%>
    <c:if test="${not empty sessionScope.user}">
        <div style="padding: 10px 15px; color: #fff; font-size: 14px; border-bottom: 1px solid rgba(255,255,255,0.2); margin-bottom: 10px;">
            <i class="fas fa-user-circle"></i>
            ${sessionScope.user.prenom} ${sessionScope.user.nom}
        </div>
    </c:if>

    <a href="${pageContext.request.contextPath}/dashboard"
       class="${activeMenu == 'dashboard' ? 'active' : ''}">
        Dashboard
    </a>

    <a href="${pageContext.request.contextPath}/produits"
       class="${activeMenu == 'produits' ? 'active' : ''}">
        Produits
    </a>

    <a href="${pageContext.request.contextPath}/ingredients"
       class="${activeMenu == 'ingredients' ? 'active' : ''}">
        Ingrédients
    </a>

    <a href="${pageContext.request.contextPath}/recetteBase"
       class="${activeMenu == 'recetteBase' ? 'active' : ''}">
        Recette de Base
    </a>

    <a href="${pageContext.request.contextPath}/vente/vendeuse"
       class="${activeMenu == 'commandes' ? 'active' : ''}">
        Commandes
    </a>

    <a href="${pageContext.request.contextPath}/statistiques"
       class="${activeMenu == 'statistiques' ? 'active' : ''}">
        Statistiques
    </a>

    <a href="${pageContext.request.contextPath}/clients"
       class="${activeMenu == 'clients' ? 'active' : ''}">
        Clients
    </a>

    <a href="${pageContext.request.contextPath}/employes"
       class="${activeMenu == 'employes' ? 'active' : ''}">
        Employés
    </a>

    <%-- Bouton de déconnexion --%>
    <div style="margin-top: auto; padding: 15px;">
        <a href="${pageContext.request.contextPath}/logout"
           style="display: block; width: 100%; padding: 10px; text-align: center;
                  background-color: #da291c; color: #fff; border-radius: 4px;
                  text-decoration: none; font-weight: bold;">
            <i class="fas fa-sign-out-alt"></i> Se déconnecter
        </a>
    </div>

</div>