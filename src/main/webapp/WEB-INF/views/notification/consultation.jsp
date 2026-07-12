<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Notifications - M'Kaly M'Lam</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_badge.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="dashboard">
    <c:set var="activeMenu" value="notification"/>
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">
        <div class="table-container">
            <div class="table-header">
                <h1><i class="fas fa-bell" style="color:var(--primary);margin-right:10px;"></i>Notifications</h1>
            </div>

            <form class="filter-form" method="get" action="${pageContext.request.contextPath}/notification/consultation">
                <div class="filter-row">
                    <div class="filter-group">
                        <label for="filtre">Affichage</label>
                        <select id="filtre" name="filtre" onchange="this.form.submit()">
                            <option value="" ${empty selectedFiltre ? 'selected' : ''}>Toutes les notifications</option>
                            <option value="recentes" ${selectedFiltre == 'recentes' ? 'selected' : ''}>Dernieres notifications (7 jours)</option>
                            <option value="anciennes" ${selectedFiltre == 'anciennes' ? 'selected' : ''}>Anciens messages</option>
                            <option value="produit" ${selectedFiltre == 'produit' ? 'selected' : ''}>Annonces d'un produit</option>
                            <option value="session" ${selectedFiltre == 'session' ? 'selected' : ''}>Annonces liees a une session</option>
                        </select>
                    </div>

                    <c:if test="${selectedFiltre == 'produit'}">
                        <div class="filter-group">
                            <label for="idProduit">Produit</label>
                            <select id="idProduit" name="idProduit" onchange="this.form.submit()">
                                <option value="">-- Choisir un produit --</option>
                                <c:forEach var="p" items="${produits}">
                                    <option value="${p.idProduit}" ${selectedIdProduit == p.idProduit ? 'selected' : ''}>${p.nomProduit}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </c:if>

                    <c:if test="${selectedFiltre == 'session'}">
                        <div class="filter-group">
                            <label for="idSession">Session</label>
                            <select id="idSession" name="idSession" onchange="this.form.submit()">
                                <option value="">-- Choisir une session --</option>
                                <c:forEach var="s" items="${sessions}">
                                    <option value="${s.id}" ${selectedIdSession == s.id ? 'selected' : ''}>
                                        Session #${s.id} - ${s.dateSession}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </c:if>
                </div>
            </form>

            <div class="notif-list" style="display:flex;flex-direction:column;gap:14px;margin-top:20px;">
                <c:forEach var="notif" items="${notifications}">
                    <div class="notif-card" style="border:1px solid #e9ecef;border-radius:10px;padding:16px 20px;background:#fff;">
                        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
                            <c:choose>
                                <c:when test="${notif.typeNotification.libelle == 'GENERALE'}">
                                    <span class="badge bg-primary"><i class="fas fa-bullhorn"></i> Annonce</span>
                                </c:when>
                                <c:when test="${notif.typeNotification.libelle == 'BOOST_NOUVEAU_PRODUIT'}">
                                    <span class="badge bg-success"><i class="fas fa-star"></i> Nouveau produit</span>
                                </c:when>
                                <c:when test="${notif.typeNotification.libelle == 'ARRIVEE_POINT_DE_VENTE'}">
                                    <span class="badge bg-info"><i class="fas fa-map-marker-alt"></i> Point de vente</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">${notif.typeNotification.libelle}</span>
                                </c:otherwise>
                            </c:choose>
                            <span style="font-size:0.85rem;color:#6c757d;">${notif.dateHeureEnvoi}</span>
                        </div>
                        <h3 style="margin:0 0 6px 0;">${notif.titre}</h3>
                        <p style="margin:0;color:#495057;">${notif.message}</p>
                        <c:if test="${notif.produitLie != null}">
                            <p style="margin:8px 0 0 0;font-size:0.85rem;">
                                <i class="fas fa-box"></i> Produit concerne : <strong>${notif.produitLie.nomProduit}</strong>
                            </p>
                        </c:if>
                        <c:if test="${notif.sessionLiee != null}">
                            <p style="margin:8px 0 0 0;font-size:0.85rem;">
                                <i class="fas fa-truck"></i> Session concernee : <strong>#${notif.sessionLiee.id}</strong>
                            </p>
                        </c:if>
                    </div>
                </c:forEach>

                <c:if test="${empty notifications}">
                    <div class="empty-state">
                        <p>Aucune notification a afficher</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>
</body>
</html>
