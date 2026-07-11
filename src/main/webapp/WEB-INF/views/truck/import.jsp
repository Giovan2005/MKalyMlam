<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Import trucks - Administration</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<div class="dashboard">
    <c:set var="activeMenu" value="truck"/>
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">
        <div class="table-container">
            <div class="table-header">
                <h1>Import de trucks</h1>
                <a href="${pageContext.request.contextPath}/truck/gestion_truck" class="btn-add">
                    <i class="fas fa-arrow-left"></i> Retour
                </a>
            </div>

            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty warning}">
                <div class="alert alert-warning">${warning}</div>
            </c:if>

            <div class="form-card" style="max-width:600px;margin:2rem auto;padding:2rem;background:#fff;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,.08);">
                <h3 style="margin-bottom:1rem;">Importer un fichier CSV ou Excel</h3>
                <p style="margin-bottom:1.5rem;color:#666;font-size:0.9rem;">
                    Le fichier doit contenir les colonnes : <strong>immatriculation</strong>, <strong>statut</strong> (optionnel : DISPONIBLE, EN_MAINTENANCE, PANNE).
                </p>

                <form method="post" action="${pageContext.request.contextPath}/truck/import"
                      enctype="multipart/form-data" id="importForm">
                    <div class="field">
                        <label for="file">Choisir un fichier (.csv ou .xlsx)</label>
                        <input type="file" id="file" name="file" accept=".csv,.xlsx,.xls" required
                               class="input" style="padding:0.75rem;">
                    </div>
                    <div id="fileInfo" style="margin:0.5rem 0;color:#888;font-size:0.85rem;"></div>
                    <div class="modal-actions" style="margin-top:1.5rem;">
                        <button type="submit" class="btn-primary">
                            <i class="fas fa-upload"></i> Importer
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
document.getElementById('file').addEventListener('change', function(e) {
    var file = e.target.files[0];
    if (file) {
        document.getElementById('fileInfo').textContent =
            'Fichier : ' + file.name + ' (' + (file.size / 1024).toFixed(1) + ' Ko)';
    }
});
</script>

</body>
</html>
