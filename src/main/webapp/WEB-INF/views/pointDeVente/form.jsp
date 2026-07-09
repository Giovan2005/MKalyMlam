<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>
    <c:choose>
        <c:when test="${isEdit}">Modifier</c:when>
        <c:otherwise>Ajouter</c:otherwise>
    </c:choose>
    un point de vente
</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_form.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="dashboard">
    <c:set var="activeMenu" value="pointsVente"/>
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div class="main">
        <a href="${pageContext.request.contextPath}/points-vente" style="color:var(--primary);text-decoration:none;margin-bottom:15px;display:inline-block;">
            <i class="fas fa-arrow-left"></i> Retour
        </a>
        <div class="table-container" style="max-width:600px;">
            <div class="table-header">
                <h1>
                    <i class="fas fa-store" style="color:var(--primary);margin-right:10px;"></i>
                    <c:choose>
                        <c:when test="${isEdit}">Modifier</c:when>
                        <c:otherwise>Ajouter</c:otherwise>
                    </c:choose>
                    un point de vente
                </h1>
            </div>
            <form action="${actionUrl}" method="post" style="padding:20px 0;">
                <div class="form-group" style="margin-bottom:20px;">
                    <label for="nom" style="font-weight:600;color:#374151;display:block;margin-bottom:6px;">Nom *</label>
                    <input type="text" id="nom" name="nom" value="${pointDeVente.nom}" required
                           style="width:100%;padding:10px 12px;border:1px solid var(--gray);border-radius:8px;font-size:14px;">
                </div>
                <div class="form-group" style="margin-bottom:20px;">
                    <label for="adresse" style="font-weight:600;color:#374151;display:block;margin-bottom:6px;">Adresse *</label>
                    <input type="text" id="adresse" name="adresse" value="${pointDeVente.adresse}" required
                           style="width:100%;padding:10px 12px;border:1px solid var(--gray);border-radius:8px;font-size:14px;">
                </div>
                <div class="form-group" style="margin-bottom:20px;">
                    <label for="description" style="font-weight:600;color:#374151;display:block;margin-bottom:6px;">Description</label>
                    <textarea id="description" name="description" rows="3"
                              style="width:100%;padding:10px 12px;border:1px solid var(--gray);border-radius:8px;font-size:14px;">${pointDeVente.description}</textarea>
                </div>
                <div class="form-group" style="margin-bottom:20px;">
                    <label style="font-weight:600;color:#374151;display:block;margin-bottom:6px;">
                        <input type="checkbox" name="estActif" value="true"
                               ${pointDeVente.estActif != null && pointDeVente.estActif ? 'checked' : ''}>
                        Actif
                    </label>
                </div>
                <div style="display:flex;gap:10px;">
                    <button type="submit" class="btn-add" style="border:none;">
                        <i class="fas fa-save"></i>
                        <c:choose>
                            <c:when test="${isEdit}">Modifier</c:when>
                            <c:otherwise>Enregistrer</c:otherwise>
                        </c:choose>
                    </button>
                    <a href="${pageContext.request.contextPath}/points-vente" class="btn-reset" style="padding:10px 20px;border:1px solid var(--gray);border-radius:8px;color:#6b7280;text-decoration:none;">
                        Annuler
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
