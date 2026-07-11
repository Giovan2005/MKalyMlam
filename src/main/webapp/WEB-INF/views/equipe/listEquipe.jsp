<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion de l'équipe</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_form.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">

</head>
<body>

<div class="dashboard">
    <c:set var="activeMenu" value="equipe"/>

    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">

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

        
        <div class="table-container" style="margin-top:30px;">

            <div class="table-header">
                <h1>
                    <i class="fas fa-list" style="color: var(--primary); margin-right:10px;"></i>
                    equipe affecte par session
                </h1>
                <div style="display:flex;gap:0.5rem;">
                    <a href="${pageContext.request.contextPath}/equipe/import"
                       class="btn-add" style="background:#6366f1;color:#D1FAE5;">
                        <i class="fas fa-file-import"></i> Importer CSV/Excel
                    </a>
                    <a style="color: #D1FAE5;" href="${pageContext.request.contextPath}/equipe/affecter"
                       class="btn-add">ajouter equipe</a>
                </div>

                    <form action="${pageContext.request.contextPath}/equipe/list_equipe" method="get" class="filter-form">
                <div class="filter-row">
                    <div class="filter-group">
                        <label for="sessionId">Session</label>
                        <select name="sessionId" id="sessionId">
                            <option value="">Toutes les sessions</option>
                            <c:forEach items="${sessions}" var="s">
                                <option value="${s.id}" ${selectedSessionId == s.id ? 'selected' : ''}>
                                    #${s.id} — ${s.itineraire.nomZone} (${s.dateSession})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="roleId">Rôle</label>
                        <select name="roleId" id="roleId">
                            <option value="">Tous les rôles</option>
                            <c:forEach items="${roles}" var="r">
                                <option value="${r.id}" ${selectedRoleId == r.id ? 'selected' : ''}>
                                    ${r.libelle}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="nomEmploye">Employé</label>
                        <input type="text" name="nomEmploye" id="nomEmploye"
                               placeholder="Nom ou prénom..."
                               value="${selectedNomEmploye}">
                    </div>
                    <div class="filter-group">
                        <label for="dateSession">Date</label>
                        <input type="date" name="dateSession" id="dateSession"
                               value="${selectedDateSession}">
                    </div>
                    <div class="filter-actions">
                        <button type="submit" class="btn-filter">
                            <i class="fas fa-filter"></i> Filtrer
                        </button>
                        <a href="${pageContext.request.contextPath}/equipe/list_equipe" class="btn-reset">
                            <i class="fas fa-undo"></i> Réinitialiser
                        </a>
                    </div>
                </div>
            </form>

            <table>
                <thead>
                    <tr>
                        <th>Session</th>
                        <th>Employé</th>
                        <th>Rôle</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty equipeSessions}">
                        <tr>
                            <td colspan="6">
                                <div class="empty-state">
                                    <i class="fas fa-users" style="font-size:48px;color:#d1d5db;margin-bottom:15px;display:block;"></i>
                                    <p>Aucun employé affecté pour le moment.</p>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                    <c:forEach items="${equipeSessions}" var="es">
                        <tr>
                            <td>
                                <span class="badge badge-id">
                                    #${es.sessionTruck.id}
                                </span>
                                <br>
                                <small style="color:#6b7280;">
                                    ${es.sessionTruck.itineraire.nomZone} — ${es.sessionTruck.dateSession}
                                </small>
                            </td>
                            <td>
                                <strong>${es.utilisateur.prenom} ${es.utilisateur.nom}</strong>
                            </td>
                            <td>
                                <span style="display:inline-block;padding:4px 12px;border-radius:20px;font-size:12px;font-weight:600;background:#DBEAFE;color:#1E40AF;">
                                    ${es.roleDuJour.libelle}
                                </span>
                            </td>
                            <!-- <td>
                                <c:choose>
                                    <c:when test="${es.utilisateur.role.libelle == 'REMPLACANT'}">
                                        <span style="color:#D97706;font-weight:600;">
                                            <i class="fas fa-exchange-alt"></i>
                                            Remplaçant
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color:#16A34A;font-weight:600;">
                                            <i class="fas fa-check-circle"></i>
                                            Fixe
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td> -->
                            <!-- <td>
                                <c:choose>
                                    <c:when test="${es.salaireJournalierRemplacant != null}">
                                        <fmt:formatNumber value="${es.salaireJournalierRemplacant}" type="number" groupingUsed="true"/> Ar/jour
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color:#9ca3af;">—</span>
                                    </c:otherwise>
                                </c:choose>
                            </td> -->
                            <td>
                                <form action="${pageContext.request.contextPath}/equipe/retirer" method="post"
                                      onsubmit="return confirm('Retirer cet employé de la session ?');"
                                      style="display:inline;">
                                    <input type="hidden" name="idSession" value="${es.sessionTruck.id}">
                                    <input type="hidden" name="idUtilisateur" value="${es.utilisateur.id}">
                                    <button type="submit" class="btn-delete">
                                        <i class="fas fa-times"></i>
                                        Retirer
                                    </button>
                                </form>
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
