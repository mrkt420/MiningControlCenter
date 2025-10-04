function calculateProfit() {
    const hashrate = parseFloat(document.getElementById('hashrate').value) || 0;
    const power = parseFloat(document.getElementById('power').value) || 0;
    const electricityCost = parseFloat(document.getElementById('electricity').value) || 0;
    
    if (hashrate <= 0 || power <= 0) {
        displayError("Please enter valid hashrate and power consumption values.");
        return;
    }
    
    // Calculate daily electricity cost
    const dailyPowerConsumption = (power / 1000) * 24;
    const dailyElectricityCost = dailyPowerConsumption * electricityCost;
    
    // Estimate daily revenue (simplified)
    const estimatedDailyRevenue = hashrate * 0.00001;
    
    // Calculate daily profit
    const dailyProfit = estimatedDailyRevenue - dailyElectricityCost;
    
    displayResults({
        dailyElectricityCost: dailyElectricityCost,
        estimatedDailyRevenue: estimatedDailyRevenue,
        dailyProfit: dailyProfit,
        monthlyProfit: dailyProfit * 30,
        yearlyProfit: dailyProfit * 365
    });
}

function displayResults(results) {
    const resultsDiv = document.getElementById('results');
    const profitClass = results.dailyProfit > 0 ? 'profit-positive' : 'profit-negative';
    
    resultsDiv.innerHTML = `
        <h3>💰 Profitability Analysis Results</h3>
        <p><strong>Daily Revenue:</strong> $${results.estimatedDailyRevenue.toFixed(4)}</p>
        <p><strong>Daily Electricity Cost:</strong> $${results.dailyElectricityCost.toFixed(4)}</p>
        <p class="${profitClass}"><strong>Daily Profit:</strong> $${results.dailyProfit.toFixed(4)}</p>
        <p class="${profitClass}"><strong>Monthly Profit:</strong> $${results.monthlyProfit.toFixed(2)}</p>
        <p class="${profitClass}"><strong>Yearly Profit:</strong> $${results.yearlyProfit.toFixed(2)}</p>
    `;
    
    resultsDiv.style.display = 'block';
}

function displayError(message) {
    const resultsDiv = document.getElementById('results');
    resultsDiv.innerHTML = `<div style="color: #ff4444;">❌ ${message}</div>`;
    resultsDiv.style.display = 'block';
}