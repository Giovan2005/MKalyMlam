<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Consultation des itinéraires - Administration</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="dashboard">
    <c:set var="activeMenu" value="consultation"/>
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div class="main">
        <div class="table-container">
            <div class="table-header">
                <h1><i class="fas fa-search" style="color:var(--primary);margin-right:10px;"></i>Consultation des itinéraires</h1>
            </div>
            <form class="filter-form" method="get" action="${pageContext.request.contextPath}/consultation">
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
                        <label for="disponible">Disponibilité</label>
                        <select id="disponible" name="disponible">
                            <option value="">Tous</option>
                            <option value="true" ${selectedDisponible ? 'selected' : ''}>
                                <i class="fas fa-check-circle"></i> Disponible
                            </option>
                        </select>
                    </div>
                    <div class="filter-actions">
                        <button type="submit" class="btn-filter">
                            <i class="fas fa-search"></i> Rechercher
                        </button>
                        <a href="${pageContext.request.contextPath}/consultation" class="btn-reset">
                            <i class="fas fa-undo"></i> Réinitialiser
                        </a>
                    </div>
                </div>
            </form>
            <table>
                <thead>
                    <tr>
                        <th>Zone</th>
                        <th>Lieu exact</th>
                        <th>Horaire</th>
                        <th>Jour</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty itineraires}">
                            <c:forEach items="${itineraires}" var="itineraire">
                                <tr>
                                    <td><strong>${itineraire.nomZone}</strong></td>
                                    <td>${itineraire.lieuExact}</td>
                                    <td>${itineraire.heureDebutPrevue} - ${itineraire.heureFinPrevue}</td>
                                    <td>${itineraire.jourSemaine}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/consultation/${itineraire.id}"
                                           class="btn-edit">
                                            <i class="fas fa-eye"></i> Détails
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5">
                                    <div class="empty-state">
                                        <i class="fas fa-search" style="font-size:48px;color:#d1d5db;margin-bottom:15px;"></i>
                                        <p>Aucun itinéraire trouvé.</p>
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
