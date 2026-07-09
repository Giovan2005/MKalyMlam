<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>
        <c:choose>
            <c:when test="${isEdit}">Modifier une maintenance</c:when>
            <c:otherwise>Ajouter une maintenance</c:otherwise>
        </c:choose>
    </title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_truck.css">

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
                <h1>
                    <c:choose>
                        <c:when test="${isEdit}">Modifier la maintenance</c:when>
                        <c:otherwise>Ajouter une maintenance</c:otherwise>
                    </c:choose>
                </h1>
            </div>

            <form action="${actionUrl}" method="post" class="form-card">
                <div class="field">
                    <label for="truckId">Truck</label>
                    <select id="truckId" name="truckId" class="input" required>
                        <option value="">Selectionner un truck</option>
                        <c:forEach var="t" items="${trucks}">
                            <option value="${t.id}" ${maintenance.truck != null && maintenance.truck.id == t.id ? 'selected' : ''}>
                                ${t.immatriculation}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="field">
                    <label for="dateDebut">Date debut</label>
                    <input type="date" id="dateDebut" name="dateDebut"
                           class="input" required
                           value="${maintenance.dateDebut != null ? maintenance.dateDebut : ''}">
                </div>

                <div class="field">
                    <label for="dateFin">Date fin</label>
                    <input type="date" id="dateFin" name="dateFin"
                           class="input"
                           value="${maintenance.dateFin != null ? maintenance.dateFin : ''}">
                </div>

                <div class="field">
                    <label for="description">Description</label>
                    <textarea id="description" name="description"
                              class="input" rows="3"
                              placeholder="Description de la maintenance">${maintenance.description != null ? maintenance.description : ''}</textarea>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/maintenance/list" class="btn-cancel">Annuler</a>
                    <button type="submit" class="btn-primary">
                        <c:choose>
                            <c:when test="${isEdit}">Modifier</c:when>
                            <c:otherwise>Enregistrer</c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
