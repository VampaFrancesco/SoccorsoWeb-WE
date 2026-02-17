document.addEventListener('DOMContentLoaded', function() {
    console.log("Aggiungi Missione JS inizializzato");

    const form = document.getElementById('missionForm');
    if (form) {
        form.addEventListener('submit', async function(event) {
            event.preventDefault(); // Previene il comportamento di submit standard

            // Raccogli i dati dal form
            const nome = document.getElementById('nome').value;
            const descrizione = document.getElementById('descrizione').value;
            const dataInizio = document.getElementById('data_inizio').value;
            const dataFine = document.getElementById('data_fine').value;

            // Crea un oggetto con i dati della missione
            const missioneData = {
                nome: nome,
                descrizione: descrizione,
                dataInizio: dataInizio,
                dataFine: dataFine
            };

            try {
                // Invia i dati al backend
                const response = await fetch('/api/missioni', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(missioneData)
                });

                if (response.ok) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Missione aggiunta',
                        text: 'La missione è stata aggiunta con successo.'
                    }).then(() => {
                        // Reindirizza o resetta il form
                        form.reset();
                        window.location.href = '/admin/missioni'; // Adatta l'URL se necessario
                    });
                } else {
                    const errorData = await response.json();
                    throw new Error(errorData.message || 'Errore sconosciuto');
                }
            } catch (error) {
                console.error('Errore durante l\'aggiunta della missione:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'Errore',
                    text: `Impossibile aggiungere la missione: ${error.message}`
                });
            }
        });
    } else {
        console.error("Form con id 'missionForm' non trovato.");
    }           
}