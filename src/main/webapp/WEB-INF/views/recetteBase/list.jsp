<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <title>Liste des recettes - Administration</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_form.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_liste_prod.css">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

<div class="dashboard">

    <c:set var="activeMenu" value="recettes"/>

    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">

        <div class="table-container">

            <!-- Header -->
            <div class="table-header">

                <h1>

                    <i class="fas fa-utensils"
                       style="color:var(--primary);margin-right:10px;"></i>

                    Liste des recettes

                </h1>

                <a href="${pageContext.request.contextPath}/recetteBase/new"
                   class="btn-add">

                    <%-- <i class="fas fa-plus"></i> --%>
                    Ajouter une recette

                </a>

                <a href="${pageContext.request.contextPath}/recetteBase/import"
                   class="btn-add" style="background:#6366f1;">
                    <i class="fas fa-file-import"></i> Importer CSV/Excel
                </a>

            </div>

            <!-- Table -->
            <table>

                <thead>

                <tr>

                    <th><i class="fas fa-box"></i> Produit</th>

                    <th><i class="fas fa-carrot"></i> Ingrédient</th>

                    <th><i class="fas fa-weight-hanging"></i> Quantité</th>

                    <th><i class="fas fa-cog"></i> Actions</th>

                </tr>

                </thead>

                <tbody>

                <!-- Vide -->
                <c:if test="${empty recettes}">
                    <tr>
                        <td colspan="4">

                            <div class="empty-state">

                                <i class="fas fa-utensils"
                                   style="font-size:48px;color:#d1d5db;margin-bottom:15px;display:block;"></i>

                                <p>
                                    Aucune recette enregistrée pour le moment.
                                </p>

                                <a href="${pageContext.request.contextPath}/recetteBase/new"
                                   class="btn-add">

                                    <i class="fas fa-plus"></i>
                                    Ajouter la première recette

                                </a>

                            </div>

                        </td>
                    </tr>
                </c:if>

                <!-- Liste -->
                <c:forEach items="${recettes}" var="recette">

                    <tr>

                        <!-- Produit -->
                        <td>
                            <c:forEach items="${produits}" var="produit">
                                <c:if test="${produit.idProduit == recette.idProduit}">
                                    <strong>${produit.nomProduit}</strong>
                                </c:if>
                            </c:forEach>
                        </td>

                        <!-- Ingrédient -->
                        <td>
                            <c:forEach items="${ingredients}" var="ingredient">
                                <c:if test="${ingredient.idIngredient == recette.idIngredient}">
                                    ${ingredient.nomIngredient}
                                </c:if>
                            </c:forEach>
                        </td>

                        <!-- Quantité -->
                        <td>
                            <span class="price-tag">
                                ${recette.quantiteRecette}
                            </span>
                        </td>

                        <!-- Actions -->
                        <td>

                            <div class="table-actions">

                                <!-- Modifier -->
                                <a href="${pageContext.request.contextPath}/recetteBase/${recette.idProduit}/${recette.idIngredient}/edit"
                                   class="btn-edit">

                                    <i class="fas fa-edit"></i>
                                    Modifier

                                </a>

                                <!-- Supprimer -->
                                <form action="${pageContext.request.contextPath}/recetteBase/${recette.idProduit}/${recette.idIngredient}/delete"
                                      method="post"
                                      style="display:inline;"
                                      onsubmit="return confirm('Supprimer cette recette ?');">

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