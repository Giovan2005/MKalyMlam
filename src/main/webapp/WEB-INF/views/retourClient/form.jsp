<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Donner mon avis</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_form.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .rating-slider {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .rating-slider input {
            flex: 1;
            accent-color: var(--primary);
        }
        .rating-slider span {
            font-size: 24px;
            font-weight: 700;
            min-width: 40px;
            text-align: center;
        }
        .toast {
            display: none;
            padding: 15px 25px;
            border-radius: 10px;
            margin-top: 20px;
            font-weight: 500;
            text-align: center;
        }
        .toast.success {
            display: block;
            background: #dcfce7;
            color: #166534;
            border: 1px solid #bbf7d0;
        }
        .toast.error {
            display: block;
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }
        .client-form {
            max-width: 600px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<div class="dashboard">
    <c:set var="activeMenu" value="retours"/>
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div class="main">
        <div class="form-section client-form">
            <h1>
                <i class="fas fa-star" style="color:var(--secondary);margin-right:10px;"></i>
                Donner mon avis
            </h1>
            <p style="color:#6b7280;margin-bottom:30px;">
                Partagez votre expérience ou faites une demande de produit.
            </p>
            <hr style="border:none;border-top:1px solid var(--gray);margin:20px 0;">
            <br>
            <div class="form-group">
                <label for="typeRetour">
                    Type de retour <span class="required-star">*</span>
                </label>
                <select id="typeRetour" required onchange="toggleProduit()">
                    <option value="">Choisir...</option>
                    <option value="REMARQUE_AVIS">Avis / Remarque</option>
                    <option value="DEMANDE_PRODUIT">Demande de produit</option>
                </select>
            </div>
            <div id="produitGroup" class="form-group" style="display:none;">
                <label for="selectProduit">
                    Produit concerné <span class="required-star">*</span>
                </label>
                <select id="selectProduit">
                    <option value="">Choisir un produit...</option>
                </select>
            </div>
            <div class="form-group">
                <label for="noteSur10">
                    Note sur 10 <span style="color:#9ca3af;font-weight:400;">(optionnel)</span>
                </label>
                <div class="rating-slider">
                    <input type="range" id="noteSur10" min="0" max="10" value="5">
                    <span id="noteValue">5</span>
                </div>
            </div>
            <div class="form-group">
                <label for="contenuTexte">
                    Votre message <span class="required-star">*</span>
                </label>
                <textarea id="contenuTexte" rows="5" placeholder="Décrivez votre expérience ou votre demande..." required></textarea>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn-success" onclick="envoyerAvis()">
                    <i class="fas fa-paper-plane"></i>
                    Envoyer mon avis
                </button>
                <button type="reset" class="btn-secondary" onclick="reinitialiser()">
                    <i class="fas fa-undo"></i>
                    Réinitialiser
                </button>
            </div>
            <div id="toast" class="toast"></div>
        </div>
    </div>
</div>
<script>
var produits = [];

window.onload = function() {
    fetch('${pageContext.request.contextPath}/produits/liste')
        .then(function(r) { return r.json(); })
        .then(function(data) {
            produits = data;
            var sel = document.getElementById("selectProduit");
            produits.forEach(function(p) {
                var opt = document.createElement("option");
                opt.value = p.idProduit;
                opt.textContent = p.nomProduit + " (" + p.prixBase + " Ar)";
                sel.appendChild(opt);
            });
        });
};

document.getElementById("noteSur10").oninput = function() {
    document.getElementById("noteValue").textContent = this.value;
};

function toggleProduit() {
    var type = document.getElementById("typeRetour").value;
    var group = document.getElementById("produitGroup");
    var sel = document.getElementById("selectProduit");
    if (type === "REMARQUE_AVIS") {
        group.style.display = "block";
        sel.required = true;
    } else {
        group.style.display = "none";
        sel.required = false;
        sel.value = "";
    }
}

function envoyerAvis() {
    var type = document.getElementById("typeRetour").value;
    var note = document.getElementById("noteSur10").value;
    var texte = document.getElementById("contenuTexte").value;
    if (!type || !texte.trim()) {
        afficherToast("Veuillez remplir tous les champs obligatoires.", "error");
        return;
    }
    var data = {
        typeRetour: type,
        noteSur10: parseInt(note),
        contenuTexte: texte.trim()
    };
    if (type === "REMARQUE_AVIS") {
        var pId = document.getElementById("selectProduit").value;
        if (!pId) {
            afficherToast("Veuillez sélectionner un produit.", "error");
            return;
        }
        data.idProduit = parseInt(pId);
    }
    fetch("${pageContext.request.contextPath}/retour/save", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
    })
    .then(function(r) { return r.json(); })
    .then(function() {
        afficherToast("Merci ! Votre avis a été enregistré.", "success");
        reinitialiser();
    })
    .catch(function() {
        afficherToast("Une erreur est survenue. Veuillez réessayer.", "error");
    });
}
function afficherToast(msg, type) {
    var t = document.getElementById("toast");
    t.textContent = msg;
    t.className = "toast " + type;
    t.style.display = "block";
}
function reinitialiser() {
    document.getElementById("selectProduit").value = "";
    document.getElementById("typeRetour").value = "";
    document.getElementById("produitGroup").style.display = "none";
    document.getElementById("noteSur10").value = 5;
    document.getElementById("noteValue").textContent = "5";
    document.getElementById("contenuTexte").value = "";
    document.getElementById("toast").style.display = "none";
}
</script>
</body>
</html>
