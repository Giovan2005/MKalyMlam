<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - FoodTruck</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>
<div class="page">
    <div class="header">
        <h1>Connexion</h1>
        <p>Accédez à votre espace FoodTruck</p>
    </div>

    <div class="card" style="max-width: 450px; margin: 0 auto;">
        <%-- Affichage des erreurs éventuelles (transmises par le contrôleur via request) --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error" style="display:block; margin-bottom: 14px;">${error}</div>
        <% } %>
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div style="margin-bottom: 12px;">
                <label style="display:block; margin-bottom:4px; font-weight:500; color:var(--muted);">Email</label>
                <input type="email" name="email" required 
                       style="width:100%; padding:10px; border:1px solid var(--line); border-radius:4px; font-size:14px;">
            </div>
            <div style="margin-bottom: 12px;">
                <label style="display:block; margin-bottom:4px; font-weight:500; color:var(--muted);">Mot de passe</label>
                <input type="password" name="motDePasse" required 
                       style="width:100%; padding:10px; border:1px solid var(--line); border-radius:4px; font-size:14px;">
            </div>
            <button type="submit" 
                    style="width:100%; padding:12px; background:var(--brand); color:#fff; border:none; border-radius:4px; font-size:16px; cursor:pointer; transition: background 0.2s;">
                Se connecter
            </button>
        </form>
        <div style="margin-top: 14px; text-align: center; font-size: 14px;">
            Pas encore de compte ? <a href="${pageContext.request.contextPath}/register" style="color:var(--brand); text-decoration:none;">Inscrivez-vous</a>
        </div>
    </div>
</div>
</body>
</html>