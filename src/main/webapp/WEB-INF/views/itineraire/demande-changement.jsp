<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>

        <c:choose>
            <c:when test="${isEdit}">
                Modifier une demande de changement d'itinéraire
            </c:when>
            <c:otherwise>
                Nouvelle demande de changement d'itinéraire
            </c:otherwise>
        </c:choose>

    </title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style_form.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

</head>

<body>

<div class="dashboard">

    <c:set var="activeMenu" value="changementItineraire"/>

    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp"/>

    <div class="main">

        <a href="${pageContext.request.contextPath}/changement-itineraire"
           class="back-link">

            <i class="fas fa-arrow-left"></i>
            Retour à la liste

        </a>

        <div class="form-section">

            <form action="${pageContext.request.contextPath}${actionUrl}" method="post">

                <h1>

                    <i class="fas fa-route"
                       style="color:var(--primary);"></i>

                    <c:choose>

                        <c:when test="${isEdit}">
                            Modifier une demande
                        </c:when>

                        <c:otherwise>
                            Nouvelle demande de changement d'itinéraire
                        </c:otherwise>

                    </c:choose>

                </h1>

                <p style="color:#6b7280;margin-bottom:30px;">

                    <c:choose>

                        <c:when test="${isEdit}">
                            Modifiez les informations de la demande.
                        </c:when>

                        <c:otherwise>
                            Remplissez les informations ci-dessous.
                        </c:otherwise>

                    </c:choose>

                </p>

                <hr style="border:none;border-top:1px solid var(--gray);margin:20px 0;">
                <br>

                <!-- SESSION -->

                <div class="form-group">

                    <label for="sessionTruck">
                        Session *
                    </label>

                    <select
                            id="sessionTruck"
                            name="sessionTruck.id"
                            required>

                        <option value="">
                            -- Choisir une session --
                        </option>

                        <c:forEach items="${sessions}" var="session">

                            <option
                                    value="${session.id}"

                                    <c:if test="${demande.sessionTruck != null && demande.sessionTruck.id == session.id}">
                                        selected
                                    </c:if>>

                                ${session.id}

                            </option>

                        </c:forEach>

                    </select>

                </div>

                <!-- UTILISATEUR -->

                <div class="form-group">

                    <label for="demandeur">
                        Utilisateur *
                    </label>

                    <select
                            id="demandeur"
                            name="demandeur.id"
                            required>

                        <option value="">
                            -- Choisir un utilisateur --
                        </option>

                        <c:forEach items="${utilisateurs}" var="utilisateur">

                            <option
                                    value="${utilisateur.id}"

                                    <c:if test="${demande.demandeur != null && demande.demandeur.id == utilisateur.id}">
                                        selected
                                    </c:if>>

                                ${utilisateur.nom}

                            </option>

                        </c:forEach>

                    </select>

                </div>

                <!-- ITINERAIRE -->

                <div class="form-group">

                    <label for="itinerairePropose">
                        Nouvel itinéraire *
                    </label>

                    <select
                            id="itinerairePropose"
                            name="itinerairePropose.id"
                            required>

                        <option value="">
                            -- Choisir un itinéraire --
                        </option>

                        <c:forEach items="${itineraires}" var="itineraire">

                            <option
                                    value="${itineraire.id}"

                                    <c:if test="${demande.itinerairePropose != null && demande.itinerairePropose.id == itineraire.id}">
                                        selected
                                    </c:if>>

                                ${itineraire.nomZone}

                            </option>

                        </c:forEach>

                    </select>

                </div>

                <!-- RAISON -->

                <div class="form-group">

                    <label for="raison">
                        Raison *
                    </label>

                    <textarea
                            id="raison"
                            name="raison"
                            rows="5"
                            placeholder="Expliquez pourquoi vous souhaitez changer d'itinéraire..."
                            required>${demande.raison}</textarea>

                </div>

                <!-- AUTRE LIEU -->

                <div class="form-group">

                    <label for="autreLieuPrecise">
                        Autre lieu
                    </label>

                    <input
                            type="text"
                            id="autreLieuPrecise"
                            name="autreLieuPrecise"
                            value="${demande.autreLieuPrecise}"
                            placeholder="Lieu supplémentaire (facultatif)">

                </div>

                <!-- BOUTONS -->

                <div class="form-actions">

                    <button
                            type="submit"
                            class="btn-success">

                        <c:choose>

                            <c:when test="${isEdit}">

                                <i class="fas fa-save"></i>
                                Modifier

                            </c:when>

                            <c:otherwise>

                                <i class="fas fa-paper-plane"></i>
                                Envoyer la demande

                            </c:otherwise>

                        </c:choose>

                    </button>

                    <button
                            type="reset"
                            class="btn-secondary">

                        <i class="fas fa-undo"></i>
                        Réinitialiser

                    </button>

                    <a
                            href="${pageContext.request.contextPath}/changement-itineraire"
                            style="margin-left:auto;
                                   align-self:center;
                                   color:var(--primary);
                                   text-decoration:none;">

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