<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Points de vente - Administration</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="dashboard">
    <c:set var="activeMenu" value="pointsVente"/>
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div class="main">
        <div class="table-container">
            <div class="table-header">
                <h1><i class="fas fa-store" style="color:var(--primary);margin-right:10px;"></i>Points de vente</h1>
                <a href="${pageContext.request.contextPath}/points-vente/new" class="btn-add">
                    Ajouter un point de vente
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
                        <th>Nom</th>
                        <th>Adresse</th>
                        <th>Description</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty pointsDeVente}">
                            <c:forEach items="${pointsDeVente}" var="pdv">
                                <tr>
                                    <td><strong>${pdv.nom}</strong></td>
                                    <td>${pdv.adresse}</td>
                                    <td>${pdv.description}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${pdv.estActif}">
                                                <span class="badge badge-success">Actif</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-warning">Inactif</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/points-vente/${pdv.id}/edit"
                                           class="btn-edit">
                                            <i class="fas fa-edit"></i> Modifier
                                        </a>
                                        <form action="${pageContext.request.contextPath}/points-vente/${pdv.id}/delete"
                                              method="post" style="display:inline;"
                                              onsubmit="return confirm('Supprimer ce point de vente ?');">
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
                                <td colspan="5">
                                    <div class="empty-state">
                                        <i class="fas fa-store" style="font-size:48px;color:#d1d5db;margin-bottom:15px;"></i>
                                        <p>Aucun point de vente enregistré.</p>
                                        <a href="${pageContext.request.contextPath}/points-vente/new" class="btn-add" style="display:inline-flex;">
                                            Ajouter un point de vente
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
