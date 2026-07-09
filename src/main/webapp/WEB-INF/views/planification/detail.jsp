<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Détail tournée - ${itineraire.nomZone}</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="dashboard">
    <c:set var="activeMenu" value="planification"/>
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div class="main">
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
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:25px;">
            <div>
                <a href="${pageContext.request.contextPath}/planification" style="color:var(--primary);text-decoration:none;margin-bottom:10px;display:inline-block;">
                    <i class="fas fa-arrow-left"></i> Retour
                </a>
                <h1 style="font-size:24px;color:var(--dark);">
                    <i class="fas fa-route" style="color:var(--primary);margin-right:10px;"></i>
                    ${itineraire.nomZone}
                </h1>
            </div>
            <a href="${pageContext.request.contextPath}/planification/${itineraire.id}/edit" class="btn-edit">
                <i class="fas fa-edit"></i> Modifier les arrêts
            </a>
        </div>
        <div style="display:flex;gap:20px;margin-bottom:30px;flex-wrap:wrap;">
            <div style="flex:1;min-width:200px;background:white;padding:20px;border-radius:12px;box-shadow:var(--shadow);">
                <span style="color:#6b7280;font-size:13px;">Lieu exact</span>
                <p style="font-size:16px;font-weight:600;margin-top:5px;">${itineraire.lieuExact}</p>
            </div>
            <div style="flex:1;min-width:200px;background:white;padding:20px;border-radius:12px;box-shadow:var(--shadow);">
                <span style="color:#6b7280;font-size:13px;">Horaire</span>
                <p style="font-size:16px;font-weight:600;margin-top:5px;">${itineraire.heureDebutPrevue} - ${itineraire.heureFinPrevue}</p>
            </div>
            <div style="flex:1;min-width:200px;background:white;padding:20px;border-radius:12px;box-shadow:var(--shadow);">
                <span style="color:#6b7280;font-size:13px;">Jour</span>
                <p style="font-size:16px;font-weight:600;margin-top:5px;">${itineraire.jourSemaine}</p>
            </div>
        </div>
        <div class="table-container">
            <div class="table-header">
                <h2><i class="fas fa-map-pin" style="color:var(--secondary);margin-right:8px;"></i>Points de vente (arrêts)</h2>
                <a href="${pageContext.request.contextPath}/planification/${itineraire.id}/edit" class="btn-add">
                    <i class="fas fa-plus"></i> Gérer les arrêts
                </a>
            </div>
            <c:choose>
                <c:when test="${not empty arrets}">
                    <table>
                        <thead>
                            <tr>
                                <th>Ordre</th>
                                <th>Point de vente</th>
                                <th>Adresse</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${arrets}" var="arret">
                                <tr>
                                    <td>
                                        <span style="display:inline-flex;align-items:center;justify-content:center;width:32px;height:32px;background:var(--primary);color:white;border-radius:50%;font-weight:700;font-size:14px;">
                                            ${arret.ordre}
                                        </span>
                                    </td>
                                    <td><strong>${arret.pointDeVente.nom}</strong></td>
                                    <td>${arret.pointDeVente.adresse}</td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/planification/${itineraire.id}/arrets/${arret.id}/delete"
                                              method="post" style="display:inline;"
                                              onsubmit="return confirm('Retirer cet arrêt ?');">
                                            <button type="submit" class="btn-delete">
                                                <i class="fas fa-times"></i> Retirer
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-map-pin" style="font-size:48px;color:#d1d5db;margin-bottom:15px;"></i>
                        <p>Aucun point de vente associé à cette tournée.</p>
                        <a href="${pageContext.request.contextPath}/planification/${itineraire.id}/edit" class="btn-add" style="display:inline-flex;">
                            Ajouter des arrêts
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <div style="margin-top:20px;">
            <a href="${pageContext.request.contextPath}/consultation/${itineraire.id}" style="color:var(--primary);text-decoration:none;">
                <i class="fas fa-search"></i> Voir dans la consultation
            </a>
        </div>
    </div>
</div>
</body>
</html>
