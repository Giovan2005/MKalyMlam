<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Historique des statuts - Administration</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<div class="dashboard">
    <c:set var="activeMenu" value="maintenance"/>

    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">
        <div class="table-container">
            <div class="table-header">
                <h1>Historique des changements de statut</h1>
                <a href="${pageContext.request.contextPath}/maintenance/list" class="btn-add" style="background:#6b7280;">Retour aux maintenances</a>
            </div>

            <form class="filter-form" method="get" action="${pageContext.request.contextPath}/maintenance/status">
                <div class="filter-row">
                    <div class="filter-group">
                        <label for="truckId">Truck</label>
                        <select id="truckId" name="truckId">
                            <option value="">Tous les trucks</option>
                            <c:forEach var="t" items="${trucks}">
                                <option value="${t.id}" ${selectedTruckId != null && selectedTruckId == t.id ? 'selected' : ''}>
                                    ${t.immatriculation}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="statutId">Statut</label>
                        <select id="statutId" name="statutId">
                            <option value="">Tous les statuts</option>
                            <c:forEach var="s" items="${statuts}">
                                <option value="${s.id}" ${selectedStatutId != null && selectedStatutId == s.id ? 'selected' : ''}>
                                    ${s.libelle}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="filter-actions">
                        <button type="submit" class="btn-filter">Filtrer</button>
                        <a href="${pageContext.request.contextPath}/maintenance/status" class="btn-reset">Reinitialiser</a>
                    </div>
                </div>
            </form>

            <table>
                <thead>
                    <tr>
                        <th>Truck</th>
                        <th>Statut</th>
                        <th>Date de changement</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="s" items="${statusList}">
                        <tr>
                            <td><strong>${s.truck.immatriculation}</strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${s.statutDisponibilite.libelle == 'DISPONIBLE'}">
                                        <span class="badge badge-success">Disponible</span>
                                    </c:when>
                                    <c:when test="${s.statutDisponibilite.libelle == 'EN_MAINTENANCE'}">
                                        <span class="badge badge-secondary">En maintenance</span>
                                    </c:when>
                                    <c:when test="${s.statutDisponibilite.libelle == 'PANNE'}">
                                        <span class="badge badge-danger">En panne</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-secondary">${s.statutDisponibilite.libelle}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${s.dateChangement}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty statusList}">
                        <tr>
                            <td colspan="3">
                                <div class="empty-state">
                                    <p>Aucun changement de statut enregistree</p>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>
