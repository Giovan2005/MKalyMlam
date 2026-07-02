<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - FoodTruck</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>
<div class="page">
    <div class="header">
        <h1>Inscription</h1>
        <p>Créez votre compte FoodTruck</p>
    </div>

    <div class="card" style="max-width: 450px; margin: 0 auto;">
        <% if (request.getAttribute("error") != null) { %>
            <div class="error" style="display:block; margin-bottom: 14px;">${error}</div>
        <% } %>
        <form action="${pageContext.request.contextPath}/register" method="post">
            <div style="margin-bottom: 12px;">
                <label style="display:block; margin-bottom:4px; font-weight:500; color:var(--muted);">Nom</label>
                <input type="text" name="nom" required 
                       style="width:100%; padding:10px; border:1px solid var(--line); border-radius:4px; font-size:14px;">
            </div>
            <div style="margin-bottom: 12px;">
                <label style="display:block; margin-bottom:4px; font-weight:500; color:var(--muted);">Prénom</label>
                <input type="text" name="prenom" 
                       style="width:100%; padding:10px; border:1px solid var(--line); border-radius:4px; font-size:14px;">
            </div>
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
                S'inscrire
            </button>
        </form>
        <div style="margin-top: 14px; text-align: center; font-size: 14px;">
            Déjà un compte ? <a href="${pageContext.request.contextPath}/login" style="color:var(--brand); text-decoration:none;">Connectez-vous</a>
        </div>
    </div>
</div>
</body>
</html>