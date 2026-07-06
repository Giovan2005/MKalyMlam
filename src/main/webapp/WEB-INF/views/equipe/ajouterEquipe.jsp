<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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

        <div class="form-section">

            <form action="${pageContext.request.contextPath}/equipe/affecter" method="post">

                <h1>
                    <i class="fas fa-users" style="color: var(--primary); margin-right:12px;"></i>
                    Gestion de l'équipe du jour
                </h1>

                <p style="color:#6b7280;margin-bottom:30px;">
                    Affecter un ou plusieurs employés à une session de travail.
                </p>

                <hr>
                <br>

                <div class="form-group">
                    <label for="idSession">Session</label>
                    <select id="idSession" name="idSession" required>
                        <option value="">Selectionner une session</option>
                        <c:forEach items="${sessions}" var="session">
                            <option value="${session.id}">
                             ${session.itineraire.nomZone} — ${session.dateSession}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group" style="margin-bottom:10px;">
                    <label>Employés affectés</label>
                </div>

                <div id="employesContainer">

                    <div class="employe-row">
                        <div class="employe-fields">
                            <div class="form-group">
                                <label>Employé</label>
                                <select name="idUtilisateur"
                                        onchange="toggleSalaryVisibility(this)">
                                    <option value="0">Selectionner un employé</option>
                                    <c:forEach items="${utilisateurs}" var="user">
                                        <option value="${user.id}" data-role="${user.role.libelle}">
                                            ${user.prenom} ${user.nom}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Rôle du jour</label>
                                <select name="roleDuJour">
                                    <option value="0">Selectionner un rôle</option>
                                    <c:forEach items="${roles}" var="role">
                                        <option value="${role.id}">${role.libelle}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group salaire-group" style="display: none;">
                                <label>Salaire journalier (Ar)</label>
                                <input type="number" class="salaireInput"
                                       step="0.01" min="0"
                                       placeholder="Ex: 25000">
                                <small style="color:#6b7280;display:block;margin-top:5px;">
                                    <i class="fas fa-info-circle"></i>
                                    Obligatoire pour les remplaçants.
                                </small>
                            </div>
                            <div class="form-group remove-group">
                                <button type="button" class="btn-remove-row"
                                        onclick="removeEmployeeRow(this)">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                </div>

                <div style="margin-bottom:20px;">
                    <button type="button" class="btn-add-row"
                            onclick="addEmployeeRow()">
                        <i class="fas fa-plus"></i> Ajouter un employé
                    </button>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-success">
                        <i class="fas fa-check"></i>
                        Affecter à la session
                    </button>
                    <button type="reset" class="btn-secondary">
                        <i class="fas fa-undo"></i>
                        Réinitialiser
                    </button>
                </div>

            </form>

        </div>

    </div>
</div>

<script>
    function addEmployeeRow() {
        var container = document.getElementById('employesContainer');
        var firstRow = container.querySelector('.employe-row');
        var newRow = firstRow.cloneNode(true);

        resetRowFields(newRow);

        container.appendChild(newRow);
    }

    function removeEmployeeRow(button) {
        var container = document.getElementById('employesContainer');
        var rows = container.querySelectorAll('.employe-row');

        if (rows.length <= 1) {
            alert('Vous devez garder au moins un employé.');
            return;
        }

        var row = button.closest('.employe-row');
        row.remove();
    }

    function resetRowFields(row) {
        var selects = row.querySelectorAll('select');
        for (var i = 0; i < selects.length; i++) {
            selects[i].selectedIndex = 0;
        }

        var salaireGroup = row.querySelector('.salaire-group');
        var salaireInput = salaireGroup.querySelector('.salaireInput');

        salaireGroup.style.display = 'none';
        salaireInput.value = '';
        salaireInput.removeAttribute('name');
    }

    function toggleSalaryVisibility(select) {
        var row = select.closest('.employe-row');
        var salaireGroup = row.querySelector('.salaire-group');
        var salaireInput = salaireGroup.querySelector('.salaireInput');

        var selectedOption = select.options[select.selectedIndex];
        var userRole = selectedOption ? selectedOption.getAttribute('data-role') : '';

        if (userRole === 'REMPLACANT') {
            salaireGroup.style.display = 'block';
            salaireInput.name = 'salaireJournalierRemplacant';
        } else {
            salaireGroup.style.display = 'none';
            salaireInput.removeAttribute('name');
            salaireInput.value = '';
        }
    }
</script>

<style>
    .employe-row {
        background: #f9fafb;
        border: 1px solid var(--gray);
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 15px;
    }

    .employe-fields {
        display: flex;
        gap: 15px;
        align-items: flex-start;
        flex-wrap: wrap;
    }

    .employe-fields .form-group {
        flex: 1;
        min-width: 180px;
        margin-bottom: 0;
    }

    .employe-fields .form-group label {
        font-size: 13px;
        font-weight: 600;
        color: #374151;
        margin-bottom: 5px;
        display: block;
    }

    .employe-fields .form-group select,
    .employe-fields .form-group input {
        width: 100%;
    }

    .remove-group {
        flex: 0 0 auto;
        padding-top: 24px;
    }

    .btn-remove-row {
        background: #FEE2E2;
        color: #DC2626;
        border: none;
        border-radius: 8px;
        padding: 10px 14px;
        cursor: pointer;
        font-size: 16px;
        transition: all 0.3s;
    }

    .btn-remove-row:hover {
        background: #FECACA;
    }

    .btn-add-row {
        background: transparent;
        color: var(--primary);
        border: 2px dashed var(--primary);
        border-radius: 10px;
        padding: 12px 25px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.3s;
        width: 100%;
    }

    .btn-add-row:hover {
        background: rgba(198, 40, 40, 0.05);
        border-style: solid;
    }

    .form-actions {
        margin-top: 25px;
    }
</style>

</body>
</html>
