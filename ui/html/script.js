document.getElementById('jailForm').addEventListener('submit', function(event) {
    event.preventDefault();
    const playerId = document.getElementById('playerId').value;
    const time = document.getElementById('time').value;

    fetch(`https://${GetParentResourceName()}/sendJailData`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ playerId, time })
    }).then(() => {
        fetch(`https://${GetParentResourceName()}/closeMenu`, { method: 'POST' });
    });
});

document.getElementById('closeButton').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/closeMenu`, { method: 'POST' });
});

window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.action === 'openMenu') {
        document.querySelector('.menu').style.display = 'block'; // Muestra el menú
    }

    if (data.action === 'closeMenu') {
        document.querySelector('.menu').style.display = 'none'; // Oculta el menú
    }
});

document.getElementById('closeButton').addEventListener('click', function() {
    document.querySelector('.menu').style.display = 'none'; // Oculta el menú
    fetch(`https://${GetParentResourceName()}/closeMenu`, { method: 'POST' });
});
