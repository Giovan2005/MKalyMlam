<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Demandes de changement d'itinéraire</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_form.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

</head>

<body>

<div class="dashboard">

    <c:set var="activeMenu" value="changementItineraire"/>

    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp"/>

    <div class="main">

        <!-- Message succès -->

        <c:if test="${not empty success}">
            <div style="background:#D1FAE5;color:#065F46;padding:15px 20px;border-radius:10px;margin-bottom:20px;border-left:4px solid #16A34A;">
                <i class="fas fa-check-circle"></i>
                ${success}
            </div>
        </c:if>

        <!-- Message erreur -->

        <c:if test="${not empty error}">
            <div style="background:#FEE2E2;color:#991B1B;padding:15px 20px;border-radius:10px;margin-bottom:20px;border-left:4px solid #EF4444;">
                <i class="fas fa-times-circle"></i>
                ${error}
            </div>
        </c:if>

        <div class="table-container">

            <div class="table-header">

                <h1>

                    <i class="fas fa-route"
                       style="color:var(--primary);margin-right:10px;"></i>

                    Demandes de changement d'itinéraire

                </h1>

                <a href="${pageContext.request.contextPath}/changement-itineraire/nouveau"
                   class="btn-add">

                    <i class="fas fa-plus"></i>
                    Nouvelle demande

                </a>

            </div>

            <table>

                <thead>

                <tr>

                    <th>ID</th>

                    <th>Session</th>

                    <th>Demandeur</th>

                    <th>Itinéraire actuel</th>

                    <th>Itinéraire proposé</th>

                    <th>Raison</th>

                    <th>Autre lieu</th>

                    <th>Date demande</th>

                    <th>Validation</th>

                </tr>

                </thead>

                <tbody>

                <c:if test="${empty demandes}">

                    <tr>

                        <td colspan="9">

                            <div class="empty-state">

                                <i class="fas fa-route"
                                   style="font-size:48px;color:#d1d5db;margin-bottom:15px;"></i>

                                <p>Aucune demande enregistrée.</p>

                            </div>

                        </td>

                    </tr>

                </c:if>

                <c:forEach items="${demandes}" var="demande">

                    <tr>

                        <td>

                            <span class="badge badge-id">

                                ${demande.idDemande}

                            </span>

                        </td>

                        <td>

                            ${demande.sessionTruck.id}

                        </td>

                        <td>

                            ${demande.demandeur.nom}
                            ${demande.demandeur.prenom}

                        </td>

                        <td>

                            ${demande.sessionTruck.itineraire.nomZone}

                        </td>

                        <td>

                            <strong>

                                ${demande.itinerairePropose.nomZone}

                            </strong>

                        </td>

                        <td>

                            ${demande.raison}

                        </td>

                        <td>

                            <c:choose>

                                <c:when test="${empty demande.autreLieuPrecise}">
                                    -
                                </c:when>

                                <c:otherwise>

                                    ${demande.autreLieuPrecise}

                                </c:otherwise>

                            </c:choose>

                        </td>

                        <td>

                            ${demande.dateHeureDemande}

                        </td>

                        <td>

                            <c:choose>


                                <c:when test="${demande.statutValidation.libelle == 'EN_ATTENTE'}">

                                    <div class="actions">

                                        <form action="${pageContext.request.contextPath}/changement-itineraire/valider/${demande.idDemande}"
                                            method="post">

                                            <button class="btn-success"
                                                    onclick="return confirm('Valider cette demande ?')">

                                                <i class="fas fa-check"></i>

                                                Valider

                                            </button>

                                        </form>

                                        <form action="${pageContext.request.contextPath}/changement-itineraire/refuser/${demande.idDemande}"
                                            method="post">

                                            <button class="btn-delete"
                                                    onclick="return confirm('Refuser cette demande ?')">

                                                <i class="fas fa-times"></i>

                                                Refuser

                                            </button>

                                        </form>

                                    </div>

                                </c:when>


                                <c:when test="${demande.statutValidation.libelle == 'VALIDE'}">

                                    <span style="
                                        display:inline-block;
                                        padding:6px 14px;
                                        border-radius:20px;
                                        background:#D1FAE5;
                                        color:#065F46;
                                        font-weight:600;">

                                        <i class="fas fa-check-circle"></i>

                                        VALIDÉE

                                    </span>

                                </c:when>


                                <c:otherwise>

                                    <span style="
                                        display:inline-block;
                                        padding:6px 14px;
                                        border-radius:20px;
                                        background:#FEE2E2;
                                        color:#991B1B;
                                        font-weight:600;">

                                        <i class="fas fa-times-circle"></i>

                                        REFUSÉE

                                    </span>

                                </c:otherwise>

                            </c:choose>

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