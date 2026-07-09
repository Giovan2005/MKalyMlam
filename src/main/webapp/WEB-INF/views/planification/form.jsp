<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Gérer les arrêts - ${itineraire.nomZone}</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_form.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="dashboard">
    <c:set var="activeMenu" value="planification"/>
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div class="main">
        <a href="${pageContext.request.contextPath}/planification/${itineraire.id}" style="color:var(--primary);text-decoration:none;margin-bottom:15px;display:inline-block;">
            <i class="fas fa-arrow-left"></i> Retour
        </a>
        <div class="table-container">
            <div class="table-header">
                <div>
                    <h1><i class="fas fa-route" style="color:var(--primary);margin-right:10px;"></i>${itineraire.nomZone}</h1>
                    <p style="color:#6b7280;margin-top:5px;">${itineraire.jourSemaine} | ${itineraire.heureDebutPrevue} - ${itineraire.heureFinPrevue}</p>
                </div>
            </div>
            <c:if test="${not empty success}">
                <div style="background:#D1FAE5;color:#065F46;padding:15px 20px;border-radius:10px;margin-bottom:20px;">
                    <i class="fas fa-check-circle"></i> ${success}
                </div>
            </c:if>
            <h2 style="margin-bottom:20px;font-size:18px;">
                <i class="fas fa-map-pin" style="color:var(--primary);margin-right:8px;"></i>
                Définir l'ordre des arrêts
            </h2>
            <form action="${pageContext.request.contextPath}/planification/${itineraire.id}/arrets/save" method="post">
                <c:if test="${not empty pointsDeVente}">
                    <div style="margin-bottom:20px;padding:20px;background:#f9fafb;border-radius:12px;border:1px solid var(--gray);">
                        <p style="margin-bottom:15px;color:#374151;font-weight:500;">
                            <i class="fas fa-info-circle"></i> Sélectionnez les points de vente dans l'ordre souhaité (maintenez Ctrl pour sélection multiple) :
                        </p>
                        <select name="pointsDeVente" multiple style="width:100%;min-height:200px;padding:10px;border:1px solid var(--gray);border-radius:8px;font-size:14px;">
                            <c:forEach items="${pointsDeVente}" var="pdv">
                                <option value="${pdv.id}"
                                    <c:forEach items="${arrets}" var="arret">
                                        <c:if test="${arret.pointDeVente.id == pdv.id}">selected</c:if>
                                    </c:forEach>
                                >${pdv.nom} - ${pdv.adresse}</option>
                            </c:forEach>
                        </select>
                        <p style="margin-top:10px;font-size:13px;color:#6b7280;">
                            <i class="fas fa-sort-numeric-up"></i> L'ordre dans la liste correspond à l'ordre des arrêts
                        </p>
                    </div>
                    <div style="display:flex;gap:10px;">
                        <button type="submit" class="btn-add" style="border:none;">
                            <i class="fas fa-save"></i> Enregistrer les arrêts
                        </button>
                        <a href="${pageContext.request.contextPath}/points-vente/new" class="btn-edit" style="background:#6b7280;">
                            <i class="fas fa-plus"></i> Nouveau point de vente
                        </a>
                    </div>
                </c:if>
                <c:if test="${empty pointsDeVente}">
                    <div class="empty-state">
                        <i class="fas fa-store" style="font-size:48px;color:#d1d5db;margin-bottom:15px;"></i>
                        <p>Aucun point de vente disponible.</p>
                        <a href="${pageContext.request.contextPath}/points-vente/new" class="btn-add" style="display:inline-flex;">
                            Créer un point de vente
                        </a>
                    </div>
                </c:if>
            </form>
            <c:if test="${not empty arrets}">
                <h3 style="margin-top:30px;margin-bottom:15px;font-size:16px;">
                    <i class="fas fa-list"></i> Arrêts actuels
                </h3>
                <table>
                    <thead>
                        <tr>
                            <th>Ordre</th>
                            <th>Point de vente</th>
                            <th>Adresse</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${arrets}" var="arret">
                            <tr>
                                <td>
                                    <span style="display:inline-flex;align-items:center;justify-content:center;width:32px;height:32px;background:var(--primary);color:white;border-radius:50%;font-weight:700;">
                                        ${arret.ordre}
                                    </span>
                                </td>
                                <td><strong>${arret.pointDeVente.nom}</strong></td>
                                <td>${arret.pointDeVente.adresse}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/planification/${itineraire.id}/arrets/${arret.id}/delete"
                                          method="post" style="display:inline;"
                                          onsubmit="return confirm('Retirer cet arrêt ?');">
                                        <button type="submit" class="btn-delete"><i class="fas fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>
