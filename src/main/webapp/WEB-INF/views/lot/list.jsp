<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste des lots</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_form.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_badge.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<div class="dashboard">

    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">

        <div class="table-container">

            <!-- En-tête -->
            <div class="table-header">

                <h1>
                    <i class="fas fa-utensils"
                       style="color: var(--primary); margin-right:10px;"></i>
                    Liste des lots d'ingrédients
                </h1>

                <a href="${pageContext.request.contextPath}/lot/new"
                   class="btn-add">
                    Ajouter un nouveau lot
                </a>

            </div>

            <!-- Filtres -->
            <div class="filters-container">
                <form action="${pageContext.request.contextPath}/lot/findAll" method="get" class="filters-form">
                    
                    <!-- Filtre par nom d'ingrédient -->
                    <div class="filter-group">
                        <label for="nomIngredient" class="filter-label">
                            <i class="fas fa-search"></i>
                            Rechercher
                        </label>
                        <input 
                            type="text" 
                            id="nomIngredient" 
                            name="nomIngredient" 
                            value="${param.nomIngredient}" 
                            placeholder="Nom de l'ingrédient..."
                            class="filter-input">
                    </div>
                    
                    <!-- Filtre par alerte -->
                    <div class="filter-group filter-checkbox">
                        <label for="alerte" class="filter-label">
                            <i class="fas fa-exclamation-triangle"></i>
                            Alerte
                        </label>
                        <input 
                            type="checkbox" 
                            id="alerte" 
                            name="alerte" 
                            value="true"
                            ${param.alerte != null ? 'checked' : ''}
                            class="filter-checkbox">
                        <span class="filter-checkbox-label">Afficher uniquement les lots en alerte</span>
                    </div>
                    
                    <!-- Boutons d'action -->
                    <div class="filter-actions">
                        <button type="submit" class="btn-filter">
                            <i class="fas fa-filter"></i>
                            Filtrer
                        </button>
                        <a href="${pageContext.request.contextPath}/lot/findAll" class="btn-filter-reset">
                            <i class="fas fa-undo"></i>
                            Réinitialiser
                        </a>
                    </div>
                    
                </form>
            </div>

            <!-- Tableau -->
            <table>

                <thead>

                    <tr>
                        <th><i class="fas fa-tag"></i> Ingrédient</th>
                        <th><i class="fas fa-calendar-plus"></i> Date de réception</th>
                        <th><i class="fas fa-calendar-times"></i> Date de péremption</th>
                        <th><i class="fas fa-weight"></i> Qtt initiale</th>
                        <th><i class="fas fa-weight-hanging"></i> Qtt restante</th>
                        <th><i class="fas fa-euro-sign"></i> Prix d'achat unitaire</th>
                        <th><i class="fas fa-info-circle"></i> Statut</th>
                        <th><i class="fas fa-cog"></i> Actions</th>
                    </tr>

                </thead>

                <tbody>

                    <!-- Aucun lot -->
                    <c:if test="${empty lots}">
                        <tr>

                            <td colspan="8">

                                <div class="empty-state">

                                    <i class="fas fa-boxes"
                                       style="font-size:48px;color:#d1d5db;margin-bottom:15px;display:block;"></i>

                                    <p>Aucun lot d'ingrédient enregistré pour le moment.</p>

                                    <a href="${pageContext.request.contextPath}/lot/save"
                                       class="btn-add">

                                        <i class="fas fa-plus"></i>
                                        Ajouter le premier lot

                                    </a>

                                </div>

                            </td>

                        </tr>
                    </c:if>

                    <!-- Liste des lots -->
                    <c:forEach items="${lots}" var="lot">

                        <tr>

                            <td>
                                <strong>${lot.ingredient.nomIngredient}</strong>
                            </td>

                            <td>
                                    ${lot.dateReception}
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${lot.datePeremption != null}">
                                
                                            ${lot.datePeremption}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <span class="">
                                    ${lot.quantiteInitiale}
                                </span>
                            </td>

                            <td>
                                <span class="">
                                    ${lot.quantiteRestante}
                                </span>
                            </td>

                            <td>
                                <span class="price-tag">
                                    ${lot.prixAchatUnitaire} €
                                </span>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${lot.quantiteRestante == 0}">
                                        <span class="badge bg-danger">
                                            <i class="fas fa-times-circle"></i>
                                            Épuisé
                                        </span>
                                    </c:when>
                                    <c:when test="${lot.alerte}">
                                        <span class="badge bg-warning text-dark">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            ALERTE
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success">
                                            <i class="fas fa-check-circle"></i>
                                            OK
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>

                                <div class="actions">

                                    <!-- Modifier -->
                                    <a href="${pageContext.request.contextPath}/lot/update/${lot.idLot}"
                                    class="btn-edit">

                                        <i class="fas fa-edit"></i>
                                        Modifier

                                    </a>

                                    <!-- Supprimer -->
                                    <form action="${pageContext.request.contextPath}/lot/delete/${lot.idLot}"
                                          method="post"
                                          style="display:inline;"
                                          onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer ce lot ?');">

                                        <button type="submit"
                                                class="btn-delete">

                                            <i class="fas fa-trash-alt"></i>
                                            Supprimer

                                        </button>
                                    </form>

                                </div>

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