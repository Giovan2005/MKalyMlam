<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
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

    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">

        <a href="${pageContext.request.contextPath}/lot/findAll" class="back-link">
            <i class="fas fa-arrow-left"></i>
            Retour à la liste des lots
        </a>

        <div class="form-section">

            <form action="${actionUrl}" method="post">

                <h1>
                    <i class="fas fa-utensils" style="color: var(--primary); margin-right:12px;"></i>

                    <c:choose>
                        <c:when test="${isEdit}">
                            Mettre à jour un lot
                        </c:when>
                        <c:otherwise>
                            Ajouter un nouveau lot
                        </c:otherwise>
                    </c:choose>

                </h1>

                <p style="color:#6b7280;margin-bottom:30px;">

                    <c:choose>
                        <c:when test="${isEdit}">
                            Modifiez les informations du lot sélectionné.
                        </c:when>
                        <c:otherwise>
                            Remplissez tous les champs pour enregistrer un lot dans la base de données.
                        </c:otherwise>
                    </c:choose>

                </p>

                <hr>
                <br>

                <!-- ID caché -->
                <c:if test="${isEdit}">
                    <input type="hidden" name="idLot" value="${lot.idLot}">
                </c:if>

                <!-- ingredient -->
                <div class="form-group">

                    <label for="nomIngredient">
                        Nom de l'ingrédient *
                    </label>

                    <select name="ingredient.idIngredient" id="idIngredient" required>
                        <option value="">-- Choisir un ingredient --</option>
                        <c:forEach items="${ingredients}" var="ingredient">
                            <option value="${ingredient.idIngredient}"
                                ${ingredient.idIngredient == lot.ingredient.idIngredient ? 'selected' : ''}>
                                ${ingredient.nomIngredient}
                            </option>
                        </c:forEach>
                    </select>

                </div>

                <!-- Quantité reçue -->
                <div class="form-group">

                    <c:choose>
                        <c:when test="${isEdit}">
                            <label for="quantiteInitiale">
                                Quantité reçue
                            </label>

                            <input
                                    type="number"
                                    id="quantiteInitiale"
                                    name="quantiteInitiale"
                                    step="0.01"
                                    min="0"
                                    value="${lot.quantiteInitiale}"
                                    placeholder="Ex: 5">

                            <!-- quantiteRestante -->
                            <label for="quantiteRestante">
                                Quantité restante 
                            </label>

                            <input
                                    type="number"
                                    id="quantiteRestante"
                                    name="quantiteRestante"
                                    step="0.01"
                                    min="0"
                                    value="${lot.quantiteRestante}"
                                    placeholder="Ex: 5">
                        </c:when>

                        <c:otherwise>
                            <label for="quantiteInitiale">
                                Quantité reçue
                            </label>

                            <input
                                    type="number"
                                    id="quantiteInitiale"
                                    name="quantiteInitiale"
                                    step="0.01"
                                    min="0"
                                    value="${lot.quantiteInitiale}"
                                    placeholder="Ex: 5">
                        </c:otherwise>
                    </c:choose>

                </div>

                <!-- Prix d achat -->
                <div class="form-group">

                    <label for="prixAchatUnitaire">
                        Prix d'achat unitaire
                    </label>

                    <input
                            type="number"
                            id="prixAchatUnitaire"
                            name="prixAchatUnitaire"
                            step="0.01"
                            min="0"
                            value="${lot.prixAchatUnitaire}"
                            placeholder="Ex: 5000">

                </div>

                <!-- date de péremption -->

                <div class="form-group">

                    <label for="datePeremption">
                        Date de péremption
                    </label>

                    <input
                            type="date"
                            id="datePeremption"
                            name="datePeremption"
                            step="0.01"
                            min="0"
                            value="${lot.datePeremption}">

                    <small style="color:#6b7280;display:block;margin-top:5px;">
                        <i class="fas fa-bell"></i>
                        Recevoir une notification lorsque le lot atteint sa date de péremption.
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

                    <a href="${pageContext.request.contextPath}/lot/findAll"
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