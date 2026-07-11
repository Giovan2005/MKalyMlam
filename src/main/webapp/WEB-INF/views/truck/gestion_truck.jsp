<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des trucks - Administration</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_truck.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<div class="dashboard">
    <c:set var="activeMenu" value="truck"/>

    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">
        <div class="table-container">
            <div class="table-header">
                <h1>Gestion des trucks</h1>
                <div style="display:flex;gap:0.5rem;">
                    <!-- <a href="${pageContext.request.contextPath}/truck/import" class="btn-add" style="background:#6366f1;">
                        <i class="fas fa-file-import"></i> Importer CSV/Excel
                    </a> -->
                    <button class="btn-add" onclick="openAddModal()">Ajouter un truck</button>
                </div>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Immatriculation</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="truck" items="${trucks}">
                        <tr>
                            <td><strong>${truck.immatriculation}</strong></td>
                            <td>
                                <c:set var="display" value="${truckStatutDisplay[truck.id]}"/>
                                <c:choose>
                                    <c:when test="${display == 'Disponible'}">
                                        <span class="badge badge-success">${display}</span>
                                    </c:when>
                                    <c:when test="${display == 'Indisponnible - En session'}">
                                        <span class="badge badge-warning">${display}</span>
                                    </c:when>
                                    <c:when test="${display == 'Indisponnible - En maintenance'}">
                                        <span class="badge badge-secondary">${display}</span>
                                    </c:when>
                                    <c:when test="${display == 'Indisponnible - En panne'}">
                                        <span class="badge badge-danger">${display}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-secondary">${display}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="actions">
                                    <button class="btn-edit" onclick="openEditModal(${truck.id}, '${truck.immatriculation}', '${truck.statutDisponibilite.libelle}')">
                                        <i class="fas fa-edit"></i> Modifier
                                    </button>
                                    <button class="btn-delete" onclick="deleteTruck(${truck.id})">
                                        <i class="fas fa-trash"></i> Supprimer
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty trucks}">
                        <tr>
                            <td colspan="3">
                                <div class="empty-state">
                                    <p>Aucun truck enregistree</p>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div id="truckModal" class="modal" style="display:none;">
    <div class="modal-card">
        <div class="modal-head">
            <h3 id="modalTitle">Ajouter un truck</h3>
            <span class="modal-close" onclick="closeModal()">&times;</span>
        </div>
        <div class="modal-body">
            <input type="hidden" id="truckId">
            <div class="field">
                <label for="immatriculation">Immatriculation</label>
                <input type="text" id="immatriculation" class="input" placeholder="Ex: 1234 TAB" required>
            </div>
            <div class="field">
                <label for="statut">Statut</label>
                <select id="statut" class="input">
                    <c:forEach var="s" items="${statuts}">
                        <option value="${s.libelle}">${s.libelle}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="modal-actions">
                <button class="btn-secondary" onclick="closeModal()">Annuler</button>
                <button class="btn-primary" onclick="saveTruck()">Enregistrer</button>
            </div>
        </div>
    </div>
</div>

<script>
function openAddModal() {
    document.getElementById('modalTitle').textContent = 'Ajouter un truck';
    document.getElementById('truckId').value = '';
    document.getElementById('immatriculation').value = '';
    document.getElementById('statut').value = 'DISPONIBLE';
    document.getElementById('truckModal').style.display = 'flex';
}

function openEditModal(id, immatriculation, statutId) {
    document.getElementById('modalTitle').textContent = 'Modifier le truck';
    document.getElementById('truckId').value = id;
    document.getElementById('immatriculation').value = immatriculation;
    var select = document.getElementById('statut');
    for (var i = 0; i < select.options.length; i++) {
        if (select.options[i].value === statutId) {
            select.selectedIndex = i;
            break;
        }
    }
    document.getElementById('truckModal').style.display = 'flex';
}

function closeModal() {
    document.getElementById('truckModal').style.display = 'none';
}

function saveTruck() {
    var id = document.getElementById('truckId').value;
    var immatriculation = document.getElementById('immatriculation').value;
    var statut = document.getElementById('statut').value;

    if (!immatriculation.trim()) {
        alert('Veuillez saisir une immatriculation');
        return;
    }

    var url = id ? '/truck/update' : '/truck/save';
    var params = new URLSearchParams();
    if (id) params.append('id', id);
    params.append('immatriculation', immatriculation);
    if (statut) params.append('statut', statut);

    fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params
    })
    .then(function(r) { return r.text(); })
    .then(function() { location.reload(); })
    .catch(function(e) { alert('Erreur: ' + e); });
}

function deleteTruck(id) {
    if (!confirm('Confirmer la suppression de ce truck ?')) return;

    var params = new URLSearchParams();
    params.append('id', id);

    fetch('/truck/delete', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params
    })
    .then(function(r) { return r.text(); })
    .then(function() { location.reload(); })
    .catch(function(e) { alert('Erreur: ' + e); });
}

document.getElementById('truckModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
});
</script>

</body>
</html>
