<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistiques</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_form.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .filter-panel { background: #fff; border-radius: 8px; padding: 16px 18px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); border: 1px solid #e8e8e8; }
        .filter-row { display: flex; gap: 12px; flex-wrap: wrap; align-items: end; }
        .filter-row label { display: flex; flex-direction: column; font-size: 13px; color: #666; gap: 4px; }
        .filter-row input { min-width: 180px; padding: 8px 10px; border: 1px solid #ddd; border-radius: 6px; }
        .filter-row button { padding: 8px 14px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; }
        .filter-row button.primary { background: #2953d9; color: #fff; }
        .filter-row button.secondary { background: #f0f0f0; color: #333; }

        .segmented { display: inline-flex; background: #f0f2f5; border-radius: 8px; padding: 3px; gap: 2px; }
        .segmented button { border: none; background: transparent; padding: 7px 16px; border-radius: 6px; font-size: 13px; font-weight: 600; color: #555; cursor: pointer; transition: 0.15s; }
        .segmented button.active { background: #2953d9; color: #fff; box-shadow: 0 1px 3px rgba(0,0,0,0.15); }

        .chart-legend { display: flex; gap: 18px; margin-top: 10px; justify-content: center; font-size: 13px; color: #555; }
        .chart-legend span { display: inline-flex; align-items: center; gap: 6px; }
        .chart-legend .dot { width: 9px; height: 9px; border-radius: 50%; display: inline-block; }
    </style>
</head>
<body>

<div class="dashboard">
    <c:set var="activeMenu" value="statistique"/>
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div class="main">
        <div class="table-container">
            <div class="table-header" style="flex-direction: column; align-items: flex-start; gap: 5px;">
                <h1>
                    <i class="fas fa-chart-line" style="color:#da291c; margin-right:10px;"></i>
                    Dashboard statistique
                </h1>
                <p style="color: #666; margin: 0 0 15px 40px;">Suivi du chiffre d'affaires et des performances du food truck.</p>
            </div>

            <section class="filter-panel" aria-label="Filtres de période">
                <div class="filter-row">
                    <label>
                        Date début
                        <input type="date" id="dateDebut">
                    </label>
                    <label>
                        Date fin
                        <input type="date" id="dateFin">
                    </label>
                    <button class="primary" id="btnFiltrer" type="button">Appliquer</button>
                    <button class="secondary" id="btnReset" type="button">Réinitialiser</button>
                </div>
                <div id="filterHint" style="margin-top: 10px; color: #666; font-size: 13px;">Chargement des données…</div>
            </section>

            <section class="cards" aria-label="Indicateurs principaux" style="display: flex; gap: 20px; margin-bottom: 30px; flex-wrap: wrap;">
                <article class="card" style="flex: 1; min-width: 260px; padding: 20px; background: #fff; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); border-left: 4px solid #da291c;">
                    <span style="display: block; color: #666; font-size: 14px; margin-bottom: 5px;"><i class="fas fa-wallet"></i> Chiffre d'affaires global</span>
                    <strong id="chiffreAffaire" style="font-size: 24px; color: #1a1a1a;">...</strong>
                </article>
                <article class="card" style="flex: 1; min-width: 260px; padding: 20px; background: #fff; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); border-left: 4px solid #ffc72c;">
                    <span style="display: block; color: #666; font-size: 14px; margin-bottom: 5px;"><i class="fas fa-coins"></i> Bénéfice total</span>
                    <strong id="beneficeTotal" style="font-size: 24px; color: #1a1a1a;">...</strong>
                </article>
            </section>

            <section class="dashboard-grid">
                <article class="chart-panel" style="background: #fff; padding: 20px; border-radius: 8px; margin-bottom: 30px; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
                    <div class="panel-head" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; flex-wrap: wrap; gap: 10px;">
                        <h2 style="margin: 0;"><i class="fas fa-chart-area" style="color:#da291c;"></i> Évolution du chiffre d'affaires</h2>
                        <div style="display:flex; align-items:center; gap:12px;">
                            <div class="segmented" role="group" aria-label="Granularité du graphique">
                                <button type="button" class="active" data-granularite="jour">Journalier</button>
                                <button type="button" data-granularite="semaine">Hebdomadaire</button>
                                <button type="button" data-granularite="mois">Mensuel</button>
                            </div>
                            <small id="lastUpdate" style="color: #999;"></small>
                        </div>
                    </div>
                    <div class="chart-wrap" style="overflow-x: auto;">
                        <canvas id="statsChart" width="800" height="320" style="max-width: 100%; height: auto;"></canvas>
                    </div>
                    <div class="chart-legend">
                        <span><i class="dot" style="background:#da291c;"></i> Chiffre d'affaires (Ar)</span>
                        <span><i class="dot" style="background:#ffc72c;"></i> Bénéfice (Ar)</span>
                    </div>
                </article>

                <article class="table-panel">
                    <div class="panel-head" style="margin-bottom: 15px;">
                        <h2><i class="fas fa-list"></i> Données détaillées</h2>
                    </div>
                    <div class="table-wrap">
                        <table>
                            <thead>
                            <tr>
                                <th><i class="fas fa-calendar-alt"></i> Période</th>
                                <th><i class="fas fa-dollar-sign"></i> CA</th>
                                <th><i class="fas fa-hand-holding-usd"></i> Bénéfice</th>
                            </tr>
                            </thead>
                            <tbody id="statsRows">
                            <tr>
                                <td colspan="3" style="text-align: center; padding: 20px; color: #666;">
                                    <i class="fas fa-spinner fa-spin"></i> Chargement...
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </article>
            </section>

            <div class="error" id="errorBox" style="display: none; margin-top: 20px; padding: 15px; background-color: #f8d7da; color: #721c24; border-radius: 4px; border: 1px solid #f5c6cb;"></div>
        </div>
    </div>
</div>

<script>
    const contextPath = '${pageContext.request.contextPath}';
    const numberFormat = new Intl.NumberFormat('fr-FR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    const compactFormat = new Intl.NumberFormat('fr-FR', { notation: 'compact', maximumFractionDigits: 1 });
    const money = value => numberFormat.format(Number(value || 0)) + ' Ar';
    const endpoint = path => contextPath + '/statistiques' + path;

    let granulariteActuelle = 'jour';

    function getFilterParams(extra) {
        const params = new URLSearchParams();
        const debut = document.getElementById('dateDebut').value;
        const fin = document.getElementById('dateFin').value;
        if (debut) params.set('dateDebut', debut);
        if (fin) params.set('dateFin', fin);
        if (extra) Object.entries(extra).forEach(([k, v]) => params.set(k, v));
        return params;
    }

    function buildUrl(path, extra) {
        const query = getFilterParams(extra).toString();
        return endpoint(path) + (query ? '?' + query : '');
    }

    async function getJson(path, extra) {
        const response = await fetch(buildUrl(path, extra), { headers: { 'Accept': 'application/json' } });
        if (!response.ok) throw new Error('Erreur HTTP ' + response.status);
        return response.json();
    }

    function normalizeRows(rows) {
        return (rows || []).map(row => ({
            periode: String(row.periode || ''),
            chiffreAffaire: Number(row.chiffreAffaire || 0),
            benefice: Number(row.benefice || 0)
        }));
    }

    function formatPeriodeLabel(periode, granularite) {
        if (!periode) return '';
        if (granularite === 'mois') {
            const d = new Date(periode);
            return isNaN(d) ? periode : d.toLocaleDateString('fr-FR', { month: 'short', year: 'numeric' });
        }
        if (granularite === 'semaine') {
            const d = new Date(periode);
            return isNaN(d) ? periode : 'Sem. du ' + d.toLocaleDateString('fr-FR', { day: '2-digit', month: '2-digit' });
        }
        return periode.substring(0, 10);
    }

    // ---------- graphique : diagramme à bandes (style proche de la maquette) ----------

    function drawChart(rows, granularite) {
        const canvas = document.getElementById('statsChart');
        if (!canvas) return;
        const ctx = canvas.getContext('2d');
        const width = canvas.width;
        const height = canvas.height;
        const padding = { top: 20, right: 20, bottom: 40, left: 65 };
        const chartWidth = width - padding.left - padding.right;
        const chartHeight = height - padding.top - padding.bottom;

        ctx.clearRect(0, 0, width, height);
        ctx.fillStyle = '#ffffff';
        ctx.fillRect(0, 0, width, height);

        if (rows.length === 0) {
            ctx.fillStyle = '#666'; ctx.font = '14px Arial'; ctx.textAlign = 'center';
            ctx.fillText('Aucune donnée pour cette période', width / 2, height / 2);
            return;
        }

        const maxValue = Math.max(1, ...rows.flatMap(row => [row.chiffreAffaire, row.benefice]));

        // Grille + axe Y au format "k" / "M"
        ctx.strokeStyle = '#eef1f4'; ctx.lineWidth = 1; ctx.fillStyle = '#8a8f98'; ctx.font = '11px Arial';
        for (let i = 0; i <= 5; i++) {
            const y = padding.top + chartHeight - (chartHeight * i / 5);
            ctx.beginPath(); ctx.moveTo(padding.left, y); ctx.lineTo(width - padding.right, y); ctx.stroke();
            ctx.textAlign = 'right';
            ctx.fillText(compactFormat.format(maxValue * i / 5), padding.left - 10, y + 4);
        }

        const groupWidth = chartWidth / rows.length;
        const barWidth = Math.max(4, Math.min(28, groupWidth / 3));
        const radius = Math.min(4, barWidth / 2);

        function roundedBar(x, y, w, h, r) {
            const top = Math.max(y, padding.top);
            const actualH = padding.top + chartHeight - top;
            if (actualH <= 0) return;
            ctx.beginPath();
            ctx.moveTo(x, top + actualH);
            ctx.lineTo(x, top + r);
            ctx.arcTo(x, top, x + r, top, r);
            ctx.lineTo(x + w - r, top);
            ctx.arcTo(x + w, top, x + w, top + r, r);
            ctx.lineTo(x + w, top + actualH);
            ctx.closePath();
            ctx.fill();
        }

        rows.forEach((row, index) => {
            const groupX = padding.left + index * groupWidth + groupWidth / 2;
            const caHeight = (row.chiffreAffaire / maxValue) * chartHeight;
            const benHeight = (row.benefice / maxValue) * chartHeight;

            ctx.fillStyle = '#da291c';
            roundedBar(groupX - barWidth - 2, padding.top + chartHeight - caHeight, barWidth, caHeight, radius);

            ctx.fillStyle = '#ffc72c';
            roundedBar(groupX + 2, padding.top + chartHeight - benHeight, barWidth, benHeight, radius);
        });

        ctx.fillStyle = '#1a1a1a'; ctx.textAlign = 'center'; ctx.font = '11px Arial';
        const labelEvery = rows.length > 12 ? Math.ceil(rows.length / 12) : 1;
        rows.forEach((row, index) => {
            if (index % labelEvery !== 0 && index !== rows.length - 1) return;
            const groupX = padding.left + index * groupWidth + groupWidth / 2;
            ctx.fillText(formatPeriodeLabel(row.periode, granularite), groupX, height - 12);
        });
    }

    function renderRows(rows, granularite) {
        const tbody = document.getElementById('statsRows'); if (!tbody) return;
        if (rows.length === 0) {
            tbody.innerHTML = '<tr><td colspan="3" style="text-align:center;">' +
                '<div class="empty-state" style="padding:20px; color:#666;">' +
                '<i class="fas fa-chart-bar" style="font-size:32px;color:#d1d5db;margin-bottom:10px;display:block;"></i>' +
                'Aucune donnée statistique enregistrée.' +
                '</div></td></tr>';
            return;
        }
        tbody.innerHTML = rows.map(row =>
            '<tr><td><strong>' + formatPeriodeLabel(row.periode, granularite) + '</strong></td>' +
            '<td><span class="price-tag" style="background:#fff5f5; color:#da291c; padding:3px 8px; border-radius:4px; font-weight:bold;">' + money(row.chiffreAffaire) + '</span></td>' +
            '<td><span class="price-tag" style="background:#fffdf0; color:#b08600; padding:3px 8px; border-radius:4px; font-weight:bold;">' + money(row.benefice) + '</span></td></tr>'
        ).join('');
    }

    function updateFilterHint() {
        const debut = document.getElementById('dateDebut').value;
        const fin = document.getElementById('dateFin').value;
        const hint = document.getElementById('filterHint');
        if (!hint) return;
        hint.textContent = (debut || fin)
            ? ('Filtre actif : du ' + (debut || 'début') + ' au ' + (fin || 'fin') + '.')
            : 'Aucun filtre de date actif.';
    }

    function setGranulariteActive(granularite) {
        granulariteActuelle = granularite;
        document.querySelectorAll('.segmented button').forEach(btn => {
            btn.classList.toggle('active', btn.dataset.granularite === granularite);
        });
    }

    // ---------- chargement principal ----------

    async function loadDashboard() {
        updateFilterHint();
        const errorBox = document.getElementById('errorBox'); if (errorBox) errorBox.style.display = 'none';
        try {
            const [chiffreAffaire, benefice, graphique] = await Promise.all([
                getJson('/chiffreAffaire'),
                getJson('/benefice'),
                getJson('/graphique', { granularite: granulariteActuelle })
            ]);
            document.getElementById('chiffreAffaire').textContent = money(chiffreAffaire);
            document.getElementById('beneficeTotal').textContent = money(benefice);
            document.getElementById('lastUpdate').textContent = 'Mis à jour à l\'instant';

            const rows = normalizeRows(graphique);
            drawChart(rows, granulariteActuelle);
            renderRows(rows, granulariteActuelle);
        } catch (error) {
            if (errorBox) {
                errorBox.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Impossible de charger les statistiques: ' + error.message;
                errorBox.style.display = 'block';
            }
        }
    }

    document.getElementById('btnFiltrer').addEventListener('click', loadDashboard);
    document.getElementById('btnReset').addEventListener('click', () => {
        document.getElementById('dateDebut').value = '';
        document.getElementById('dateFin').value = '';
        setGranulariteActive('jour');
        loadDashboard();
    });
    document.querySelectorAll('.segmented button').forEach(btn => {
        btn.addEventListener('click', () => {
            setGranulariteActive(btn.dataset.granularite);
            loadDashboard();
        });
    });

    window.addEventListener('load', loadDashboard);
</script>
</body>
</html>