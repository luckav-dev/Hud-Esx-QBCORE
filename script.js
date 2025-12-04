window.addEventListener('message', function (event) {
    const data = event.data;
    
    if (data.action === 'updateStatus') {
        updateStatus('health', data.health);
        updateStatus('armor', data.armor);
        updateStatus('hunger', data.hunger);
        updateStatus('thirst', data.thirst);
        updateStatus('stamina', data.stamina);
        updateStatus('stress', data.stress);
        
    } else if (data.action === 'toggleHud') {
        const hud = document.querySelector('.hud-container');
        if (hud) {
            hud.style.display = data.show ? 'flex' : 'none';
        }
        
    } else if (data.action === 'updateVehicle') {
        const carHud = document.getElementById('car-hud');
        const streetContainer = document.getElementById('street-container');
        
        if (!carHud || !streetContainer) return;
        
        if (data.show) {
            carHud.style.display = 'block';
            streetContainer.style.display = 'block';
            
            const speedEl = document.getElementById('speed-val');
            const fuelEl = document.getElementById('fuel-val');
            const gearEl = document.getElementById('gear-val');
            const streetEl = document.getElementById('street-name');
            const rpmFillEl = document.getElementById('rpm-fill');
            
            if (speedEl) speedEl.innerText = data.speed;
            if (fuelEl) fuelEl.innerText = data.fuel + 'L';
            if (gearEl) gearEl.innerText = data.gear;
            if (streetEl) streetEl.innerText = data.street;
            
            if (rpmFillEl) {
                const rpmPercent = data.rpm * 100;
                rpmFillEl.style.width = rpmPercent + '%';
                
                const startRpm = 0.5;
                let r, g, b;
                
                if (data.rpm > startRpm) {
                    const t = (data.rpm - startRpm) / (1.0 - startRpm);
                    r = Math.round(51 - (51 - 19) * t);
                    g = Math.round(0 - (0 - 0) * t);
                    b = Math.round(145 - (145 - 56) * t);
                } else {
                    r = 51; g = 0; b = 145;
                }
                
                rpmFillEl.style.background = `rgb(73, 0, 209)`;
            }
        } else {
            carHud.style.display = 'none';
            streetContainer.style.display = 'none';
        }
    }
});

function updateStatus(type, value) {
    const fill = document.getElementById(`${type}-fill`);
    const card = document.querySelector(`.status-card.${type}`);
    
    if (fill) {
        fill.style.width = `${value}%`;
    }
    
    if (!card) return;
    
    if (type === 'health' && value < 20) {
        card.classList.add('low-health');
    } else if (type === 'health') {
        card.classList.remove('low-health');
    }
    
    if (type === 'armor') {
    card.style.display = value <= 0 ? 'none' : 'flex'
    }
}

const isBrowser = !window.invokeNative;
if (isBrowser) {
    console.log("Debug Mode: Active");
    document.body.style.backgroundColor = "#333";
    document.body.style.backgroundImage = "url('https://files.catbox.moe/00bsru.png')";
    document.body.style.backgroundSize = "cover";
    
    let mockData = {
        health: 100,
        armor: 50,
        hunger: 90,
        thirst: 85,
        stamina: 100,
        stress: 15,
        inVehicle: true,
        speed: 120,
        fuel: 65,
        gear: 3,
        rpm: 0.7,
        street: 'Vinewood Blvd'
    };
    
    setInterval(() => {
        mockData.health = Math.max(0, mockData.health - 0.05);
        if (mockData.health <= 0) mockData.health = 100;
        
        mockData.rpm += 0.01;
        if (mockData.rpm > 1.0) mockData.rpm = 0.2;
        
        mockData.speed = Math.floor(mockData.rpm * 200);
        mockData.gear = Math.ceil(mockData.speed / 50) || 1;
        
        window.postMessage({
            action: 'updateStatus',
            health: mockData.health,
            armor: mockData.armor,
            hunger: mockData.hunger,
            thirst: mockData.thirst,
            stamina: mockData.stamina,
            stress: mockData.stress
        });
        
        window.postMessage({
            action: 'updateVehicle',
            show: mockData.inVehicle,
            speed: mockData.speed,
            fuel: mockData.fuel,
            gear: mockData.gear,
            rpm: mockData.rpm,
            street: mockData.street
        });
    }, 200);
    
    setInterval(() => {
        mockData.inVehicle = !mockData.inVehicle;
        console.log("Debug: Toggling Vehicle Mode -> " + mockData.inVehicle);
    }, 10000);
}