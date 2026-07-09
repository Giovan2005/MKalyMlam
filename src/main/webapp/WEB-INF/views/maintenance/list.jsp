<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des maintenances - Administration</title>

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
                <h1>Gestion des maintenances</h1>
                <div style="display:flex;gap:10px;">
                    <a href="${pageContext.request.contextPath}/maintenance/status" class="btn-add" style="background:#6b7280;">Historique des statuts</a>
                    <a href="${pageContext.request.contextPath}/maintenance/new" class="btn-add">Ajouter une maintenance</a>
                </div>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Truck</th>
                        <th>Date debut</th>
                        <th>Date fin</th>
                        <th>Description</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="m" items="${maintenances}">
                        <tr>
                            <td><strong>${m.truck.immatriculation}</strong></td>
                            <td>${m.dateDebut}</td>
                            <td>${m.dateFin != null ? m.dateFin : '-'}</td>
                            <td>${m.description != null ? m.description : '-'}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${m.dateFin != null}">
                                        <span class="badge badge-success">Terminée</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-warning">En cours</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/maintenance/${m.id}/edit" class="btn-edit">
                                        <i class="fas fa-edit"></i> Modifier
                                    </a>
                                    <c:if test="${m.dateFin == null}">
                                        <form action="${pageContext.request.contextPath}/maintenance/${m.id}/cloturer"
                                              method="post" style="display:inline;">
                                            <button type="submit" class="btn-edit" style="background:#10B981;">
                                                <i class="fas fa-check"></i> Cloturer
                                            </button>
                                        </form>
                                    </c:if>
                                    <form action="${pageContext.request.contextPath}/maintenance/${m.id}/delete"
                                          method="post" style="display:inline;"
                                          onsubmit="return confirm('Confirmer la suppression de cette maintenance ?');">
                                        <button type="submit" class="btn-delete">
                                            <i class="fas fa-trash"></i> Supprimer
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty maintenances}">
                        <tr>
                            <td colspan="6">
                                <div class="empty-state">
                                    <p>Aucune maintenance enregistre</p>
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
