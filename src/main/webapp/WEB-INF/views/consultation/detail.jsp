<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Consultation - ${itineraire.nomZone}</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="dashboard">
    <c:set var="activeMenu" value="consultation"/>
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div class="main">
        <a href="${pageContext.request.contextPath}/consultation" style="color:var(--primary);text-decoration:none;margin-bottom:15px;display:inline-block;">
            <i class="fas fa-arrow-left"></i> Retour à la recherche
        </a>
        <div style="display:flex;gap:20px;margin-bottom:30px;flex-wrap:wrap;">
            <div style="flex:1;min-width:200px;background:white;padding:20px;border-radius:12px;box-shadow:var(--shadow);">
                <span style="color:#6b7280;font-size:13px;">Zone</span>
                <p style="font-size:18px;font-weight:700;margin-top:5px;color:var(--primary);">${itineraire.nomZone}</p>
            </div>
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
                <h2><i class="fas fa-store" style="color:var(--secondary);margin-right:8px;"></i>Points de vente</h2>
            </div>
            <c:choose>
                <c:when test="${not empty arrets}">
                    <table>
                        <thead>
                            <tr>
                                <th>Ordre</th>
                                <th>Point de vente</th>
                                <th>Adresse</th>
                                <th>Description</th>
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
                                    <td>${arret.pointDeVente.description}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-store" style="font-size:48px;color:#d1d5db;margin-bottom:15px;"></i>
                        <p>Aucun point de vente associé à cet itinéraire.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>
