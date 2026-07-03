<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Demandes de produits</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sentiment-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }
        .sentiment-badge.POSITIF {
            background: #dcfce7;
            color: #166534;
        }
        .sentiment-badge.NEUTRE {
            background: #fef9c3;
            color: #854d0e;
        }
        .sentiment-badge.NEGATIF {
            background: #fef2f2;
            color: #991b1b;
        }
        .popular-badge {
            color: #f59e0b;
            margin-left: 6px;
        }
        .request-card {
            background: #fff;
            border: 1px solid var(--gray);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 16px;
            transition: box-shadow 0.2s;
        }
        .request-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .request-card h3 {
            margin: 0 0 8px 0;
            font-size: 16px;
        }
        .request-card .meta {
            font-size: 13px;
            color: #6b7280;
        }
    </style>
</head>
<body>
<div class="dashboard">
    <c:set var="activeMenu" value="retours"/>
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div class="main">
        <div class="table-container">
            <div class="table-header">
                <h1>
                    <i class="fas fa-lightbulb" style="color:var(--secondary);margin-right:10px;"></i>
                    Demandes de produits
                </h1>
                <a href="${pageContext.request.contextPath}/retour" class="btn-add">
                    <i class="fas fa-plus"></i>
                    Nouvelle demande
                </a>
            </div>
            <c:if test="${empty retours}">
                <div class="empty-state">
                    <i class="fas fa-lightbulb" style="font-size:48px;color:#d1d5db;margin-bottom:15px;display:block;"></i>
                    <p>Aucune demande de produit pour le moment.</p>
                    <a href="${pageContext.request.contextPath}/retour" class="btn-add">
                        <i class="fas fa-plus"></i>
                        Faire une demande
                    </a>
                </div>
            </c:if>
            <c:forEach var="r" items="${retours}">
                <div class="request-card">
                    <div style="display:flex;justify-content:space-between;align-items:flex-start;">
                        <div style="flex:1;">
                            <h3>
                                ${r.contenuTexte}
                                <c:if test="${r.estPopulaire}">
                                    <span class="popular-badge" title="Demande populaire">
                                        <i class="fas fa-fire"></i>
                                    </span>
                                </c:if>
                            </h3>
                            <div class="meta">
                                <span><i class="far fa-calendar-alt"></i> ${r.dateSoumission}</span>
                                <c:if test="${r.classificationSentiment != null}">
                                    <span style="margin-left:16px;">
                                        <span class="sentiment-badge ${r.classificationSentiment}">
                                            <i class="fas ${r.classificationSentiment == 'POSITIF' ? 'fa-thumbs-up' : r.classificationSentiment == 'NEGATIF' ? 'fa-thumbs-down' : 'fa-minus'}"></i>
                                            ${r.classificationSentiment == 'POSITIF' ? 'Positif' : r.classificationSentiment == 'NEGATIF' ? 'Négatif' : 'Neutre'}
                                        </span>
                                    </span>
                                </c:if>
                                <c:if test="${r.noteSur10 != null}">
                                    <span style="margin-left:16px;">Note: ${r.noteSur10}/10</span>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>
</body>
</html>
