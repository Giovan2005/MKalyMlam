<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

</head>
<div class="sidebar">

    <h2>ADMIN PANEL</h2>

    <%-- <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a> --%>

    <%-- <a href="${pageContext.request.contextPath}/produits">
        Produits
    </a>

    <a href="${pageContext.request.contextPath}/commandes">
        Commandes
    </a> --%>
<%-- 
    <a href="${pageContext.request.contextPath}/employes">
        Employés
    </a> --%>

    <%-- <a href="${pageContext.request.contextPath}/clients">
        Clients
    </a> --%>

    <%-- <a href="${pageContext.request.contextPath}/statistiques">
        Statistiques
    </a> --%>

    <%-- <a href="${pageContext.request.contextPath}/ingredients">
        Ingrédients
    </a> --%>

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
    

    <a href="${pageContext.request.contextPath}/conges"
   class="${activeMenu == 'conges' ? 'active' : ''}">
    Congés & Absences
</a>
<a href="${pageContext.request.contextPath}/conges/demande"
   class="${activeMenu == 'conges' ? 'active' : ''}">
    <i class="fas fa-plus-circle"></i> Demande de congé
</a>


</div>