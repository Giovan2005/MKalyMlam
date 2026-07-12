<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des notifications - Administration</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_badge.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<div class="dashboard">
    <c:set var="activeMenu" value="notification"/>

    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">
        <div class="table-container">
            <div class="table-header">
                <h1>Gestion des notifications</h1>
                <button class="btn-add" onclick="openAddModal()">Publier une notification</button>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Type</th>
                        <th>Titre</th>
                        <th>Message</th>
                        <th>Lien</th>
                        <th>Date de publication</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="notif" items="${notifications}">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${notif.typeNotification.libelle == 'GENERALE'}">
                                        <span class="badge bg-primary">Generale</span>
                                    </c:when>
                                    <c:when test="${notif.typeNotification.libelle == 'BOOST_NOUVEAU_PRODUIT'}">
                                        <span class="badge bg-success">Nouveau produit</span>
                                    </c:when>
                                    <c:when test="${notif.typeNotification.libelle == 'ARRIVEE_POINT_DE_VENTE'}">
                                        <span class="badge bg-info">Point de vente</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">${notif.typeNotification.libelle}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><strong>${notif.titre}</strong></td>
                            <td>${notif.message}</td>
                            <td>
                                <c:if test="${notif.produitLie != null}">
                                    <i class="fas fa-box"></i> ${notif.produitLie.nomProduit}
                                </c:if>
                                <c:if test="${notif.sessionLiee != null}">
                                    <i class="fas fa-truck"></i> Session #${notif.sessionLiee.id}
                                </c:if>
                            </td>
                            <td>${notif.dateHeureEnvoi}</td>
                            <td>
                                <div class="actions">
                                    <button class="btn-edit"
                                            data-id="${notif.id}"
                                            data-titre="${notif.titre}"
                                            data-message="${notif.message}"
                                            onclick="openEditModal(this)">
                                        <i class="fas fa-edit"></i> Modifier
                                    </button>
                                    <button class="btn-delete" onclick="deleteNotification(${notif.id})">
                                        <i class="fas fa-trash"></i> Supprimer
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty notifications}">
                        <tr>
                            <td colspan="6">
                                <div class="empty-state">
                                    <p>Aucune notification publiee</p>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal : publier une notification -->
<div id="addModal" class="modal" style="display:none;">
    <div class="modal-card">
        <div class="modal-head">
            <h3>Publier une notification</h3>
            <span class="modal-close" onclick="closeAddModal()">&times;</span>
        </div>
        <div class="modal-body">
            <div class="field">
                <label for="typeNotif">Type de notification</label>
                <select id="typeNotif" class="input" onchange="onTypeChange()">
                    <option value="GENERALE">Notification generale</option>
                    <option value="PRODUIT">Annoncer un nouveau produit</option>
                    <option value="POINT_DE_VENTE">Annoncer le point de vente actuel</option>
                </select>
            </div>

            <div id="blocGenerale">
                <div class="field">
                    <label for="titreGenerale">Titre</label>
                    <input type="text" id="titreGenerale" class="input" placeholder="Ex: Fermeture exceptionnelle">
                </div>
                <div class="field">
                    <label for="messageGenerale">Message</label>
                    <textarea id="messageGenerale" class="input" rows="4" placeholder="Contenu de la notification..."></textarea>
                </div>
            </div>

            <div id="blocProduit" style="display:none;">
                <div class="field">
                    <label for="produitSelect">Produit</label>
                    <select id="produitSelect" class="input">
                        <c:forEach var="p" items="${produits}">
                            <option value="${p.idProduit}">${p.nomProduit}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="field">
                    <label for="titreProduit">Titre (optionnel)</label>
                    <input type="text" id="titreProduit" class="input" placeholder="Genere automatiquement si vide">
                </div>
                <div class="field">
                    <label for="messageProduit">Message (optionnel)</label>
                    <textarea id="messageProduit" class="input" rows="3" placeholder="Genere automatiquement si vide"></textarea>
                </div>
            </div>

            <div id="blocPointDeVente" style="display:none;">
                <div class="field">
                    <label for="sessionSelect">Session en cours</label>
                    <select id="sessionSelect" class="input">
                        <c:forEach var="s" items="${sessions}">
                            <option value="${s.id}">
                                Session #${s.id} - ${s.dateSession}
                                <c:if test="${s.truck != null}"> - ${s.truck.immatriculation}</c:if>
                                <c:if test="${s.statutSession != null}"> (${s.statutSession.libelle})</c:if>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="field">
                    <label for="messagePointDeVente">Message (optionnel)</label>
                    <textarea id="messagePointDeVente" class="input" rows="3" placeholder="Ex: Nous sommes actuellement a Analakely !"></textarea>
                </div>
                <p style="font-size:0.85rem;color:#6c757d;">
                    <i class="fas fa-info-circle"></i>
                    Il ne s'agit pas d'un suivi GPS en temps reel : l'emplacement doit etre publie manuellement,
                    et la session choisie doit etre actuellement ouverte.
                </p>
            </div>

            <div class="modal-actions">
                <button class="btn-secondary" onclick="closeAddModal()">Annuler</button>
                <button class="btn-primary" onclick="publierNotification()">Publier</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal : modifier une notification -->
<div id="editModal" class="modal" style="display:none;">
    <div class="modal-card">
        <div class="modal-head">
            <h3>Modifier la notification</h3>
            <span class="modal-close" onclick="closeEditModal()">&times;</span>
        </div>
        <div class="modal-body">
            <input type="hidden" id="editId">
            <div class="field">
                <label for="editTitre">Titre</label>
                <input type="text" id="editTitre" class="input">
            </div>
            <div class="field">
                <label for="editMessage">Message</label>
                <textarea id="editMessage" class="input" rows="4"></textarea>
            </div>
            <div class="modal-actions">
                <button class="btn-secondary" onclick="closeEditModal()">Annuler</button>
                <button class="btn-primary" onclick="saveEdit()">Enregistrer</button>
            </div>
        </div>
    </div>
</div>

<script>
function openAddModal() {
    document.getElementById('typeNotif').value = 'GENERALE';
    onTypeChange();
    document.getElementById('titreGenerale').value = '';
    document.getElementById('messageGenerale').value = '';
    document.getElementById('titreProduit').value = '';
    document.getElementById('messageProduit').value = '';
    document.getElementById('messagePointDeVente').value = '';
    document.getElementById('addModal').style.display = 'flex';
}

function closeAddModal() {
    document.getElementById('addModal').style.display = 'none';
}

function onTypeChange() {
    var type = document.getElementById('typeNotif').value;
    document.getElementById('blocGenerale').style.display = (type === 'GENERALE') ? 'block' : 'none';
    document.getElementById('blocProduit').style.display = (type === 'PRODUIT') ? 'block' : 'none';
    document.getElementById('blocPointDeVente').style.display = (type === 'POINT_DE_VENTE') ? 'block' : 'none';
}

function publierNotification() {
    var type = document.getElementById('typeNotif').value;
    var url;
    var params = new URLSearchParams();

    if (type === 'GENERALE') {
        var titre = document.getElementById('titreGenerale').value.trim();
        var message = document.getElementById('messageGenerale').value.trim();
        if (!titre || !message) {
            alert('Veuillez saisir un titre et un message');
            return;
        }
        url = '${pageContext.request.contextPath}/notification/publier';
        params.append('titre', titre);
        params.append('message', message);
    } else if (type === 'PRODUIT') {
        var idProduit = document.getElementById('produitSelect').value;
        if (!idProduit) {
            alert('Veuillez selectionner un produit');
            return;
        }
        url = '${pageContext.request.contextPath}/notification/annoncerProduit';
        params.append('idProduit', idProduit);
        params.append('titre', document.getElementById('titreProduit').value.trim());
        params.append('message', document.getElementById('messageProduit').value.trim());
    } else {
        var idSession = document.getElementById('sessionSelect').value;
        if (!idSession) {
            alert('Veuillez selectionner une session');
            return;
        }
        url = '${pageContext.request.contextPath}/notification/annoncerPointDeVente';
        params.append('idSession', idSession);
        params.append('message', document.getElementById('messagePointDeVente').value.trim());
    }

    fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params
    })
    .then(function(r) {
        if (!r.ok) { return r.text().then(function(t) { throw new Error(t); }); }
        return r.text();
    })
    .then(function() { location.reload(); })
    .catch(function(e) { alert('Erreur : ' + e.message); });
}

function openEditModal(btn) {
    document.getElementById('editId').value = btn.getAttribute('data-id');
    document.getElementById('editTitre').value = btn.getAttribute('data-titre');
    document.getElementById('editMessage').value = btn.getAttribute('data-message');
    document.getElementById('editModal').style.display = 'flex';
}

function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
}

function saveEdit() {
    var id = document.getElementById('editId').value;
    var titre = document.getElementById('editTitre').value.trim();
    var message = document.getElementById('editMessage').value.trim();

    var params = new URLSearchParams();
    params.append('id', id);
    params.append('titre', titre);
    params.append('message', message);

    fetch('${pageContext.request.contextPath}/notification/modifier', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params
    })
    .then(function(r) { return r.text(); })
    .then(function() { location.reload(); })
    .catch(function(e) { alert('Erreur : ' + e); });
}

function deleteNotification(id) {
    if (!confirm('Confirmer la suppression de cette notification ?')) return;

    var params = new URLSearchParams();
    params.append('id', id);

    fetch('${pageContext.request.contextPath}/notification/delete', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params
    })
    .then(function(r) { return r.text(); })
    .then(function() { location.reload(); })
    .catch(function(e) { alert('Erreur : ' + e); });
}

document.getElementById('addModal').addEventListener('click', function(e) {
    if (e.target === this) closeAddModal();
});
document.getElementById('editModal').addEventListener('click', function(e) {
    if (e.target === this) closeEditModal();
});
</script>

</body>
</html>
