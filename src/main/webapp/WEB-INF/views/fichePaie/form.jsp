<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <title>Générer une fiche de paie</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_form.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

<div class="dashboard">
    <c:set var="activeMenu" value="fiches-paie"/>

    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">

        <a href="${pageContext.request.contextPath}/fiches-paie" class="back-link">
            <i class="fas fa-arrow-left"></i>
            Retour à la liste des fiches de paie
        </a>

        <div class="form-section">
            <form action="${pageContext.request.contextPath}/fiches-paie/generate" method="post">

                <h1>
                    <i class="fas fa-file-invoice-dollar product-icon"></i>
                    Générer une fiche de paie
                </h1>

                <p style="color:#6b7280;margin-bottom:30px;">
                    Sélectionnez un employé et un mois. Le montant brut sera repris automatiquement depuis son salaire de base fixe.
                </p>

                <hr style="border:none;border-top:1px solid var(--gray);margin:20px 0;">
                <br>

                <div class="form-group">
                    <label for="idUtilisateur">
                        Employé <span class="required-star">*</span>
                    </label>

                    <select name="idUtilisateur" id="idUtilisateur" required>
                        <option value="">-- Choisir un employé --</option>
                        <c:forEach items="${utilisateurs}" var="utilisateur">
                            <option value="${utilisateur.id}">
                                ${utilisateur.nom} ${utilisateur.prenom} - ${utilisateur.salaireBaseFixe}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="moisAnnee">
                        Mois / Année <span class="required-star">*</span>
                    </label>

                    <input type="month"
                           id="moisAnnee"
                           name="moisAnnee"
                           required>
                    <small>Format attendu : année-mois.</small>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-success">
                        <i class="fas fa-bolt"></i>
                        Générer
                    </button>

                    <button type="reset" class="btn-secondary">
                        <i class="fas fa-undo"></i>
                        Réinitialiser
                    </button>

                    <a href="${pageContext.request.contextPath}/fiches-paie"
                       style="margin-left:auto;align-self:center;color:var(--primary);text-decoration:none;">
                        <i class="fas fa-times"></i>
                        Annuler
                    </a>
                </div>

            </form>
        </div>
    </div>
</div>

</body>
</html>