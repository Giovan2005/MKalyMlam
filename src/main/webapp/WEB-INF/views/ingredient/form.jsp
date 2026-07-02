<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <title>
        <c:choose>
            <c:when test="${isEdit}">
                Modifier un ingrédient
            </c:when>
            <c:otherwise>
                Ajouter un ingrédient
            </c:otherwise>
        </c:choose>
    </title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_form.css">

</head>
<body>

<div class="dashboard">
    <c:set var="activeMenu" value="ingredients"/>

    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">

        <a href="${pageContext.request.contextPath}/ingredients" class="back-link">
            <i class="fas fa-arrow-left"></i>
            Retour à la liste
        </a>

        <div class="form-section">

            <form action="${actionUrl}" method="post">

                <h1>
                    <i class="fas fa-utensils" style="color: var(--primary); margin-right:12px;"></i>

                    <c:choose>
                        <c:when test="${isEdit}">
                            Mettre à jour un ingrédient
                        </c:when>
                        <c:otherwise>
                            Ajouter un nouvel ingrédient
                        </c:otherwise>
                    </c:choose>

                </h1>

                <p style="color:#6b7280;margin-bottom:30px;">

                    <c:choose>
                        <c:when test="${isEdit}">
                            Modifiez les informations de l'ingrédient sélectionné.
                        </c:when>
                        <c:otherwise>
                            Remplissez tous les champs pour enregistrer un ingrédient dans la base de données.
                        </c:otherwise>
                    </c:choose>

                </p>

                <hr>
                <br>

                <!-- ID caché -->
                <c:if test="${isEdit}">
                    <input
                            type="hidden"
                            name="id"
                            value="${ingredient.idIngredient}">
                </c:if>

                <!-- Nom -->
                <div class="form-group">

                    <label for="nomIngredient">
                        Nom de l'ingrédient *
                    </label>

                    <input
                            type="text"
                            id="nomIngredient"
                            name="nomIngredient"
                            value="${ingredient.nomIngredient}"
                            placeholder="Ex: Tomate, Poulet..."
                            required>

                </div>

                <!-- Unité -->

                <div class="form-group">

                    <label for="uniteMesure">
                        Unité de mesure *
                    </label>

                    <select
                            id="uniteMesure"
                            name="uniteMesure"
                            required>

                        <option value="">Sélectionner une unité</option>

                        <option value="kg" ${ingredient.uniteMesure == 'kg' ? 'selected' : ''}>
                            Kilogramme (kg)
                        </option>

                        <option value="g" ${ingredient.uniteMesure == 'g' ? 'selected' : ''}>
                            Gramme (g)
                        </option>

                        <option value="l" ${ingredient.uniteMesure == 'l' ? 'selected' : ''}>
                            Litre (l)
                        </option>

                        <option value="ml" ${ingredient.uniteMesure == 'ml' ? 'selected' : ''}>
                            Millilitre (ml)
                        </option>

                        <option value="unite" ${ingredient.uniteMesure == 'unite' ? 'selected' : ''}>
                            Pièce (unité)
                        </option>

                        <option value="bot" ${ingredient.uniteMesure == 'bot' ? 'selected' : ''}>
                            Botte
                        </option>

                    </select>

                </div>

                <!-- Seuil -->

                <div class="form-group">

                    <label for="seuilAlerteQuantite">
                        Seuil d'alerte
                    </label>

                    <input
                            type="number"
                            id="seuilAlerteQuantite"
                            name="seuilAlerteQuantite"
                            step="0.01"
                            min="0"
                            value="${ingredient.seuilAlerteQuantite}"
                            placeholder="Ex: 5">

                    <small style="color:#6b7280;display:block;margin-top:5px;">
                        <i class="fas fa-bell"></i>
                        Recevoir une notification lorsque le stock descend en dessous de ce seuil.
                    </small>

                </div>

                <!-- Boutons -->

                <div class="form-actions">

                    <button type="submit" class="btn-success">

                        <c:choose>

                            <c:when test="${isEdit}">
                                <i class="fas fa-pen"></i>
                                Modifier
                            </c:when>

                            <c:otherwise>
                                <i class="fas fa-save"></i>
                                Enregistrer l'ingrédient
                            </c:otherwise>

                        </c:choose>

                    </button>

                    <button type="reset" class="btn-secondary">
                        <i class="fas fa-undo"></i>
                        Réinitialiser
                    </button>

                    <a href="${pageContext.request.contextPath}/ingredients"
                       style="margin-left:auto;align-self:center;color:var(--primary);">

                        <i class="fas fa-times"></i>
                        Annuler

                    </a>

                </div>

            </form>

        </div>

    </div>

</div>

</body>
</html>