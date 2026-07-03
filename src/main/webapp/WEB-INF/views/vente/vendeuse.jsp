<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>Nouvelle vente</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_form.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_list.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

</head>

<body>

<div class="dashboard">

    <c:set var="activeMenu" value="vente"/>

    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp"/>

    <div class="main">

        <div class="table-container">

            <div class="table-header">

                <h1>
                    <i class="fas fa-cash-register"
                       style="color:var(--primary);margin-right:10px;"></i>

                    Nouvelle vente
                </h1>

                <button
                        class="btn-add"
                        onclick="nouvelleCommande()">

                    <i class="fas fa-plus"></i>
                    Nouvelle commande

                </button>

            </div>

            <h2 style="margin:25px 0;">
                Commande N°
                <span id="cmdId">-</span>
            </h2>

            <table>

                <thead>

                <tr>

                    <th>Produit</th>

                    <th>Prix unitaire</th>

                    <th>Quantité</th>

                    <th>Montant</th>

                    <th>Action</th>

                </tr>

                </thead>

                <tbody id="lignes">

                </tbody>

                <tfoot>

                <tr>

                    <td>

                        <select id="selectProduit">

                            <option value="">

                                Choisir un produit

                            </option>

                        </select>

                    </td>

                    <td id="prixUnitaire">-</td>

                    <td>

                        <input
                                id="inputQuantite"
                                type="number"
                                min="1"
                                value="1">

                    </td>

                    <td id="previewMontant">-</td>

                    <td>

                        <button
                                class="btn-success"
                                onclick="ajouterLigne()">

                            <i class="fas fa-plus"></i>

                            Ajouter

                        </button>

                    </td>

                </tr>

                </tfoot>

            </table>

            <div class="total-container">

                <div class="total-card">

                    <div class="total-label">
                        Montant total
                    </div>

                    <div id="total" class="total-value">
                        0 Ar
                    </div>

                </div>

                <button
                        class="btn-success"
                        onclick="validerCommande()"
                        style="margin-top:15px;">

                    <i class="fas fa-check"></i>
                    Valider la commande

                </button>

            </div>
        </div>

    </div>

</div>

<script>

let cmdId = null;
let lignesLocales = [];
let produits = [];

window.onload = function () {

    fetch('${pageContext.request.contextPath}/produits/liste')
        .then(r => r.json())
        .then(data => {

            produits = data;

            const sel = document.getElementById("selectProduit");

            produits.forEach(p => {

                const opt = document.createElement("option");

                opt.value = p.idProduit;

                opt.textContent =
                    p.nomProduit + " (" + p.prixBase + " Ar)";

                sel.appendChild(opt);

            });

        });

};

document.getElementById("selectProduit").onchange = afficherPrix;

document.getElementById("inputQuantite").oninput = afficherPrix;

function afficherPrix(){

    const sel=document.getElementById("selectProduit");

    const qte=parseInt(document.getElementById("inputQuantite").value)||0;

    const p=produits.find(x=>x.idProduit==sel.value);

    document.getElementById("prixUnitaire").textContent=
        p?p.prixBase+" Ar":"-";

    document.getElementById("previewMontant").textContent=
        (p&&qte>0)?
        (p.prixBase*qte)+" Ar":"-";

}

function nouvelleCommande(){

    fetch('${pageContext.request.contextPath}/commande/ajouter',{
        method:'POST',
        headers:{'Content-Type':'application/json'},
        body:JSON.stringify({})
    })
    .then(r=>r.json())
    .then(c=>{
        cmdId=c.idCommande;
        document.getElementById("cmdId").textContent=cmdId;
        lignesLocales=[];
        afficherLignes();
        document.getElementById("total").textContent="0 Ar";
    });
}

function ajouterLigne(){

    if(!cmdId) return;

    const pId=document.getElementById("selectProduit").value;
    const qte=parseInt(document.getElementById("inputQuantite").value);
    if(!pId||!qte) return;

    const produit=produits.find(x=>x.idProduit==pId);
    if(!produit) return;

    const montant=produit.prixBase*qte;

    lignesLocales.push({
        idProduit:parseInt(pId),
        quantite:qte,
        nomProduit:produit.nomProduit,
        prixBase:produit.prixBase,
        montant:montant
    });

    afficherLignes();
    actualiserTotalLocal();
}

function supprimerLigne(index){
    lignesLocales.splice(index,1);
    afficherLignes();
    actualiserTotalLocal();
}

function afficherLignes(){
    const tbody=document.getElementById("lignes");
    tbody.innerHTML="";
    lignesLocales.forEach((l,i)=>{
        const tr=document.createElement("tr");
        tr.innerHTML=
            "<td>"+l.nomProduit+"</td>"+
            "<td>"+l.prixBase+" Ar</td>"+
            "<td>"+l.quantite+"</td>"+
            "<td>"+l.montant+" Ar</td>"+
            "<td><button class='btn-delete' onclick='supprimerLigne("+i+")'><i class='fas fa-trash-alt'></i></button></td>";
        tbody.appendChild(tr);
    });
}

function actualiserTotalLocal(){
    const total=lignesLocales.reduce((s,l)=>s+l.montant,0);
    document.getElementById("total").textContent=total+" Ar";
}

function validerCommande(){
    if(!cmdId||lignesLocales.length===0) return;

    const lignes=lignesLocales.map(l=>({
        idProduit:l.idProduit,
        quantite:l.quantite
    }));

    fetch('${pageContext.request.contextPath}/commande/valider?idCommande='+cmdId,{
        method:'POST',
        headers:{'Content-Type':'application/json'},
        body:JSON.stringify(lignes)
    })
    .then(r=>r.json())
    .then(c=>{
        nouvelleCommande();
    });
}

</script>

</body>
</html>