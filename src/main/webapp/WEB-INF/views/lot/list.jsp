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

                <a href="${pageContext.request.contextPath}/lot/save"
                   class="btn-add">
                    Ajouter un nouveau lot
                </a>

            </div>

            <!-- Tableau -->
            <table>

                <thead>

                    <tr>
                        <th><i class="fas fa-tag"></i> Ingrédient</th>
                        <th><i class="fas fa-calendar-plus"></i> Date de réception</th>
                        <th><i class="fas fa-calendar-times"></i> Date de péremption</th>
                        <th><i class="fas fa-weight"></i> Quantité initiale</th>
                        <th><i class="fas fa-weight-hanging"></i> Quantité restante</th>
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
                                <span class="badge badge-date">
                                    <i class="fas fa-calendar-day"></i>
                                    ${lot.dateReception}
                                </span>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${lot.datePeremption != null}">
                                        <span class="badge badge-date">
                                            <i class="fas fa-calendar-day"></i>
                                            ${lot.datePeremption}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <span class="badge badge-quantity">
                                    ${lot.quantiteInitiale}
                                </span>
                            </td>

                            <td>
                                <span class="badge badge-quantity">
                                    ${lot.quantiteRestante}
                                </span>
                            </td>

                            <td>
                                <span class="badge badge-price">
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