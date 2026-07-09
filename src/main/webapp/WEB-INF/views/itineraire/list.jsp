<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Gestion des itinéraires - Administration</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<div class="dashboard">
    <c:set var="activeMenu" value="itineraire"/>
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">
        <div class="table-container">
            <div class="table-header">
                <h1>Gestion des itinéraires</h1>
                <a href="${pageContext.request.contextPath}/itineraire/new" class="btn-add">
                    Ajouter un itinéraire
                </a>
            </div>

            <form class="filter-form" method="get" action="${pageContext.request.contextPath}/itineraire">
                <div class="filter-row">
                    <div class="filter-group">
                        <label for="nomZone">Zone</label>
                        <input type="text" id="nomZone" name="nomZone"
                               value="${selectedNomZone}" placeholder="Nom de zone...">
                    </div>
                    <div class="filter-group">
                        <label for="jourSemaine">Jour</label>
                        <select id="jourSemaine" name="jourSemaine">
                            <option value="">Tous les jours</option>
                            <option value="LUNDI" ${selectedJourSemaine == 'LUNDI' ? 'selected' : ''}>Lundi</option>
                            <option value="MARDI" ${selectedJourSemaine == 'MARDI' ? 'selected' : ''}>Mardi</option>
                            <option value="MERCREDI" ${selectedJourSemaine == 'MERCREDI' ? 'selected' : ''}>Mercredi</option>
                            <option value="JEUDI" ${selectedJourSemaine == 'JEUDI' ? 'selected' : ''}>Jeudi</option>
                            <option value="VENDREDI" ${selectedJourSemaine == 'VENDREDI' ? 'selected' : ''}>Vendredi</option>
                            <option value="SAMEDI" ${selectedJourSemaine == 'SAMEDI' ? 'selected' : ''}>Samedi</option>
                            <option value="DIMANCHE" ${selectedJourSemaine == 'DIMANCHE' ? 'selected' : ''}>Dimanche</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="lieuExact">Lieu exact</label>
                        <input type="text" id="lieuExact" name="lieuExact"
                               value="${selectedLieuExact}" placeholder="Lieu...">
                    </div>
                    <div class="filter-actions">
                        <button type="submit" class="btn-filter">Filtrer</button>
                        <a href="${pageContext.request.contextPath}/itineraire" class="btn-reset">Réinitialiser</a>
                    </div>
                </div>
            </form>

            <table>
                <thead>
                    <tr>
                        <th>Zone</th>
                        <th>Lieu exact</th>
                        <th>Heure début</th>
                        <th>Heure fin</th>
                        <th>Jour</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty itineraires}">
                            <c:forEach items="${itineraires}" var="itineraire">
                                <tr>
                                    <td>${itineraire.nomZone}</td>
                                    <td>${itineraire.lieuExact}</td>
                                    <td>${itineraire.heureDebutPrevue}</td>
                                    <td>${itineraire.heureFinPrevue}</td>
                                    <td>${itineraire.jourSemaine}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/itineraire/${itineraire.id}/edit"
                                           class="btn-edit">
                                            <i class="fas fa-edit"></i> Modifier
                                        </a>
                                        <form action="${pageContext.request.contextPath}/itineraire/${itineraire.id}/delete"
                                              method="post"
                                              style="display:inline;"
                                              onsubmit="return confirm('Supprimer cet itinéraire ?');">
                                            <button type="submit" class="btn-delete">
                                                <i class="fas fa-trash"></i>delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6">
                                    <div class="empty-state">
                                        <p>Aucun itinéraire enregistré.</p>
                                    </div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>