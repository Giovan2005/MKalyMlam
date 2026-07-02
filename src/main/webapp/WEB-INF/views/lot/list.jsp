<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Liste des lots</title>
</head>
<body>

<h1>Gestion des lots</h1>

<hr>

<a href="${pageContext.request.contextPath}/lot/save">
    Ajouter un lot
</a>

<br><br>

<table border="1" cellpadding="8">

    <thead>

    <tr>
        <th>Ingrédient</th>
        <th>Date de réception</th>
        <th>Date de péremption</th>
        <th>Quantité initiale</th>
        <th>Quantité restante</th>
        <th>Prix d'achat unitaire</th>
        <th>Statut</th>
    </tr>

    </thead>

    <tbody>

    <c:choose>

        <c:when test="${not empty lots}">

            <c:forEach items="${lots}" var="lot">

                <tr>

                    <td>${lot.ingredient.nomIngredient}</td>
                    <td>${lot.dateReception}</td>
                    <td>${lot.datePeremption}</td>
                    <td>${lot.quantiteInitiale}</td>
                    <td>${lot.quantiteRestante}</td>
                    <td>${lot.prixAchatUnitaire}</td>

                    <td>

                        <a href="${pageContext.request.contextPath}/lot/update/${lot.idLot}">
                            Modifier
                        </a>

                        |

                        <form action="${pageContext.request.contextPath}/lot/delete/${lot.idLot}"
                              method="post"
                              style="display:inline;"
                              onsubmit="return confirm('Supprimer ce lot ?');">
                            
                              <button type="submit">
                                Supprimer
                            </button>

                        </form>


                    </td>

                </tr>

            </c:forEach>

        </c:when>

        <c:otherwise>

            <tr>
                <td colspan="6" align="center">
                    Aucun lot d'ingrédient enregistré.
                </td>
            </tr>

        </c:otherwise>

    </c:choose>

    </tbody>

</table>

</body>
</html>