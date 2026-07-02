<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ouvrir une session</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_form.css">

</head>
<body>

<div class="dashboard">
    <c:set var="activeMenu" value="sessionTruck"/>

    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">

        <a href="${pageContext.request.contextPath}/session/liste" class="back-link">
            <i class="fas fa-arrow-left"></i>
            Retour à la liste
        </a>

        <div class="form-section">

            <form action="${pageContext.request.contextPath}/session/ouvrir" method="post">

                <h1>
                    <i class="fas fa-play-circle" style="color: var(--primary); margin-right:12px;"></i>
                    Ouvrir une session
                </h1>

                <p style="color:#6b7280;margin-bottom:30px;">
                    Sélectionnez les informations nécessaires pour démarrer une nouvelle journée de travail.
                </p>

                <hr>
                <br>

                <!-- Sélection camion -->
                <div class="form-group">
                    <label for="idTruck">
                        Camion *
                    </label>
                    <select id="idTruck" name="idTruck" required>
                        <option value="">-- Sélectionner un camion --</option>
                        <c:forEach items="${trucks}" var="truck">
                            <option value="${truck.id}">${truck.immatriculation}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Sélection de l'itinéraire -->
                <div class="form-group">
                    <label for="idItineraire">
                        Itinéraire *
                    </label>
                    <select id="idItineraire" name="idItineraire" required>
                        <option value="">-- Sélectionner un itinéraire --</option>
                        <c:forEach items="${itineraires}" var="itineraire">
                            <option value="${itineraire.id}">${itineraire.nomZone} - ${itineraire.lieuExact}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Sélection du chauffeur -->
                <div class="form-group">
                    <label for="idChauffeur">
                        Chauffeur *
                    </label>
                    <select id="idChauffeur" name="idChauffeur" required>
                        <option value="">-- Sélectionner un chauffeur --</option>
                        <c:forEach items="${chauffeurs}" var="chauffeur">
                            <option value="${chauffeur.id}">${chauffeur.prenom} ${chauffeur.nom}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Fond de caisse -->
                <div class="form-group">
                    <label for="fondDeCaisseOuverture">
                        Fond de caisse (€) *
                    </label>
                    <input 
                        type="number" 
                        id="fondDeCaisseOuverture" 
                        name="fondDeCaisseOuverture"
                        step="0.01" 
                        min="0"
                        placeholder="Ex: 150.00"
                        required>
                    
                    <small style="color:#6b7280;display:block;margin-top:5px;">
                        <i class="fas fa-info-circle"></i>
                        Montant initial disponible dans la caisse pour démarrer la journée.
                    </small>
                </div>

                <!-- Boutons -->
                <div class="form-actions">
                    <button type="submit" class="btn-success">
                        <i class="fas fa-play"></i>
                        Démarrer la journée
                    </button>

                    <button type="reset" class="btn-secondary">
                        <i class="fas fa-undo"></i>
                        Réinitialiser
                    </button>

                    <a href="${pageContext.request.contextPath}/session/liste"
                       style="margin-left:auto;align-self:center;color:var(--primary);">
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