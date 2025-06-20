function calculateKDA(kills, deaths) {
    if (deaths === 0) {
        return kills > 0 ? kills.toFixed(2) : "0.00";
    }
    return (kills / deaths).toFixed(2);
}

function updatePerformance(kda) {
    const performanceFill = document.getElementById('performanceFill');
    const performanceText = document.getElementById('performanceText');

    let percentage = (kda / 5) * 100;
    if (percentage > 100) percentage = 100;
    if (percentage < 0) percentage = 0;

    performanceFill.style.width = `${percentage}%`;

    let text = "NORMAL";
    let color = KDAConfig.colors.NORMAL;

    if (kda >= 4.0) {
        text = "EFSANEVİ";
        color = KDAConfig.colors.EFSANEVİ;
    } else if (kda >= 3.0) {
        text = "MÜKEMMEL";
        color = KDAConfig.colors.MÜKEMMEL;
    } else if (kda >= 2.0) {
        text = "ÇOK İYİ";
        color = KDAConfig.colors.ÇOK_İYİ;
    } else if (kda >= 1.0) {
        text = "İYİ";
        color = KDAConfig.colors.İYİ;
    } else {
        text = "KÖTÜ";
        color = KDAConfig.colors.KÖTÜ;
    }

    performanceText.textContent = text;
    performanceText.style.color = color;
    performanceFill.style.backgroundColor = color;
}

function updateStats(kills, deaths) {
    const kda = parseFloat(calculateKDA(kills, deaths));

    document.getElementById('killCount').textContent = kills;
    document.getElementById('deathCount').textContent = deaths;
    document.getElementById('kdaRatio').textContent = kda.toFixed(2);

    updatePerformance(kda);
}

window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.type === 'updateStats') {
        updateStats(data.kills, data.deaths);
    }
});

document.addEventListener('DOMContentLoaded', function() {
    updateStats(0, 0);
}); 