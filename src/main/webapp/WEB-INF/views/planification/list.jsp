<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Planification des tournées - Administration</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="dashboard">
    <c:set var="activeMenu" value="planification"/>
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div class="main">
        <div class="table-container">
            <div class="table-header">
                <h1><i class="fas fa-route" style="color:var(--primary); margin-right:10px;"></i>Planification des tournées</h1>
                <a href="${pageContext.request.contextPath}/itineraire/new" class="btn-add">
                    Nouvelle tournée
                </a>
            </div>
            <c:if test="${not empty success}">
                <div style="background:#D1FAE5;color:#065F46;padding:15px 20px;border-radius:10px;margin-bottom:20px;display:flex;align-items:center;gap:10px;border-left:4px solid #16A34A;">
                    <i class="fas fa-check-circle"></i><span>${success}</span>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="background:#FEE2E2;color:#991B1B;padding:15px 20px;border-radius:10px;margin-bottom:20px;display:flex;align-items:center;gap:10px;border-left:4px solid #EF4444;">
                    <i class="fas fa-exclamation-circle"></i><span>${error}</span>
                </div>
            </c:if>
            <table>
                <thead>
                    <tr>
                        <th>Zone</th>
                        <th>Lieu exact</th>
                        <th>Horaire</th>
                        <th>Jour</th>
                        <th>Arrêts</th>
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
                                        <a href="${pageContext.request.contextPath}/planification/${itineraire.id}"
                                           class="btn-edit" style="background:var(--primary);">
                                            <i class="fas fa-map-pin"></i> Gérer les arrêts
                                        </a>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/itineraire/${itineraire.id}/edit"
                                           class="btn-edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <form action="${pageContext.request.contextPath}/itineraire/${itineraire.id}/delete"
                                              method="post" style="display:inline;"
                                              onsubmit="return confirm('Supprimer cette tournée ?');">
                                            <button type="submit" class="btn-delete">
                                                <i class="fas fa-trash"></i>
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
                                        <i class="fas fa-map-marked-alt" style="font-size:48px;color:#d1d5db;margin-bottom:15px;"></i>
                                        <p>Aucune tournée planifiée.</p>
                                        <a href="${pageContext.request.contextPath}/itineraire/new" class="btn-add" style="display:inline-flex;">
                                            Créer une tournée
                                        </a>
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
