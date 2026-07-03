<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Avis Clients</title>
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
        .note-stars {
            color: #f59e0b;
            letter-spacing: 2px;
        }
        .popular-badge {
            color: #f59e0b;
            margin-left: 6px;
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
                    <i class="fas fa-star" style="color:var(--secondary);margin-right:10px;"></i>
                    Avis Clients
                </h1>
                <a href="${pageContext.request.contextPath}/retour" class="btn-add">
                    <i class="fas fa-plus"></i>
                    Nouvel avis
                </a>
            </div>
            <table>
                <thead>
                <tr>
                    <th><i class="fas fa-hashtag"></i> ID</th>
                    <th><i class="fas fa-smile"></i> Sentiment</th>
                    <th><i class="fas fa-star"></i> Note</th>
                    <th><i class="fas fa-comment"></i> Message</th>
                    <th><i class="fas fa-calendar"></i> Date</th>
                </tr>
                </thead>
                <tbody>
                <c:if test="${empty retours}">
                    <tr>
                        <td colspan="5">
                            <div class="empty-state">
                                <i class="fas fa-star" style="font-size:48px;color:#d1d5db;margin-bottom:15px;display:block;"></i>
                                <p>Aucun avis client pour le moment.</p>
                                <a href="${pageContext.request.contextPath}/retour" class="btn-add">
                                    <i class="fas fa-plus"></i>
                                    Ajouter un avis
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:if>
                <c:forEach var="r" items="${retours}">
                    <tr>
                        <td><span class="product-id">${r.idRetour}</span></td>
                        <td>
                            <c:if test="${r.classificationSentiment != null}">
                                <span class="sentiment-badge ${r.classificationSentiment}">
                                    <i class="fas ${r.classificationSentiment == 'POSITIF' ? 'fa-thumbs-up' : r.classificationSentiment == 'NEGATIF' ? 'fa-thumbs-down' : 'fa-minus'}"></i>
                                    ${r.classificationSentiment == 'POSITIF' ? 'Positif' : r.classificationSentiment == 'NEGATIF' ? 'Négatif' : 'Neutre'}
                                </span>
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${r.noteSur10 != null}">
                                <span class="note-stars">
                                    <c:forEach var="i" begin="1" end="${r.noteSur10 / 2}">
                                        <i class="fas fa-star"></i>
                                    </c:forEach>
                                    <c:if test="${r.noteSur10 % 2 != 0}">
                                        <i class="fas fa-star-half-alt"></i>
                                    </c:if>
                                    (${r.noteSur10}/10)
                                </span>
                            </c:if>
                            <c:if test="${r.estPopulaire}">
                                <span class="popular-badge" title="Avis populaire">
                                    <i class="fas fa-fire"></i>
                                </span>
                            </c:if>
                        </td>
                        <td style="max-width:300px;">
                            <c:choose>
                                <c:when test="${r.contenuTexte.length() > 100}">
                                    ${r.contenuTexte.substring(0, 100)}...
                                </c:when>
                                <c:otherwise>
                                    ${r.contenuTexte}
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${r.dateSoumission}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
