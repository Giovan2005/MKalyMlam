<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste des sessions - Administration</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_form.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<div class="dashboard">
    <c:set var="activeMenu" value="sessionTruck"/>

    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">

        <!-- Messages de succès/erreur -->
        <c:if test="${not empty success}">
            <div style="background: #D1FAE5; color: #065F46; padding: 15px 20px; border-radius: 10px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; border-left: 4px solid #16A34A;">
                <i class="fas fa-check-circle" style="font-size: 20px;"></i>
                <span>${success}</span>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div style="background: #FEE2E2; color: #991B1B; padding: 15px 20px; border-radius: 10px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; border-left: 4px solid #EF4444;">
                <i class="fas fa-exclamation-circle" style="font-size: 20px;"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <div class="table-container">

            <!-- En-tête -->
            <div class="table-header">

                <h1>
                    <i class="fas fa-calendar-day"
                       style="color: var(--primary); margin-right:10px;"></i>
                    Sessions du jour
                </h1>

                <a href="${pageContext.request.contextPath}/session/ouvrir"
                   class="btn-add">
                    Ouvrir une session
                </a>

            </div>

            <!-- Tableau -->
            <table>

                <thead>

                <tr>
                    <th><i class="fas fa-hashtag"></i> ID</th>
                    <th><i class="fas fa-truck"></i> Camion</th>
                    <th><i class="fas fa-user"></i> Chauffeur</th>
                    <th><i class="fas fa-route"></i> Itinéraire</th>
                    <th><i class="fas fa-circle"></i> Statut</th>
                    <th><i class="fas fa-coins"></i> Fond caisse départ</th>
                    <th><i class="fas fa-cog"></i> Actions</th>
                </tr>

                </thead>

                <tbody>

                <!-- Aucune session -->
                <c:if test="${empty sessions}">
                    <tr>

                        <td colspan="7">

                            <div class="empty-state">

                                <i class="fas fa-calendar-day"
                                   style="font-size:48px;color:#d1d5db;margin-bottom:15px;display:block;"></i>

                                <p>Aucune session pour aujourd'hui.</p>

                                <a href="${pageContext.request.contextPath}/session/ouvrir"
                                   class="btn-add">

                                    <i class="fas fa-plus"></i>
                                    Ouvrir la première session

                                </a>

                            </div>

                        </td>

                    </tr>
                </c:if>

                <!-- Liste des sessions -->
                <c:forEach var="session" items="${sessions}" varStatus="loop">

                    <tr>

                        <td>
                            <span class="badge badge-id">
                                ${session.id}
                            </span>
                        </td>

                        <td>
                            <strong>${session.truck.immatriculation}</strong>
                        </td>

                        <td>
                            ${chauffeurs[loop.index]}
                        </td>

                        <td>
                            ${session.itineraire.nomZone}
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${session.statutSession.libelle == 'OUVERTE'}">
                                    <span style="display:inline-block;padding:4px 12px;border-radius:20px;font-size:12px;font-weight:600;background:#D1FAE5;color:#065F46;">
                                        <i class="fas fa-circle" style="font-size:8px;margin-right:5px;color:#16A34A;"></i>
                                        OUVERTE
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span style="display:inline-block;padding:4px 12px;border-radius:20px;font-size:12px;font-weight:600;background:#FEE2E2;color:#991B1B;">
                                        <i class="fas fa-circle" style="font-size:8px;margin-right:5px;color:#EF4444;"></i>
                                        FERMÉE
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <span style="font-weight:600;color:var(--primary);">
                                € ${session.fondDeCaisseOuverture}
                            </span>
                        </td>

                        <td>

                            <div class="actions">

                                <!-- Clôturer (uniquement si OUVERTE) -->
                                <c:if test="${session.statutSession.libelle == 'OUVERTE'}">

                                    <form action="${pageContext.request.contextPath}/session/cloturer"
                                          method="post"
                                          style="display:flex;gap:5px;align-items:center;flex-wrap:wrap;"
                                          onsubmit="return confirm('Êtes-vous sûr de vouloir clôturer cette session ?');">

                                        <input type="hidden" name="idSession" value="${session.id}">

                                        <input type="number" 
                                               name="fondDeCaisseCloture"
                                               step="0.01" 
                                               min="0" 
                                               placeholder="Fond clôture"
                                               required
                                               style="padding:6px 10px;border:1px solid var(--gray);border-radius:8px;font-size:13px;width:120px;">

                                        <button type="submit" 
                                                class="btn-delete"
                                                style="background:#16A34A;">

                                            <i class="fas fa-lock"></i>
                                            Clôturer

                                        </button>

                                    </form>

                                </c:if>

                                <c:if test="${session.statutSession.libelle != 'OUVERTE'}">
                                    <span style="color:#9ca3af;font-size:13px;">
                                        <i class="fas fa-check-circle" style="color:#16A34A;"></i>
                                        Terminée
                                    </span>
                                </c:if>

                            </div>

                        </td>

                    </tr>

                </c:forEach>

                </tbody>

            </table>

        </div>

    </div>

</div>

</body>
</html>