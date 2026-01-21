<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${titolo!""}</title>
    <link href="css/index.css" rel="stylesheet">
</head>
<body>
<div class="wrapper">
    <div class="descrizione-home">
        <h2>${descrizione_h2!""}</h2>
        <h4>${descrizione_paragrafo!""}</h4>
    </div>

    <div class="form-richiesta">
        <form action="/richiesta" method="post" enctype="multipart/form-data">
            <label for="nome_segnalante">Nome Segnalante:</label>
            <input type="text" id="nome_segnalante" name="nome_segnalante" required>

            <label for="email_segnalante">Email Segnalante:</label>
            <input type="email" id="email_segnalante" name="email_segnalante" required>

            <label for="descrizione">Descrizione:</label>
            <textarea id="descrizione" name="descrizione" rows="4" required></textarea>

            <!-- Campi nascosti per latitudine e longitudine -->
            <input type="hidden" id="latitudine" name="latitudine">
            <input type="hidden" id="longitudine" name="longitudine">

            <label for="foto">Allega Foto:</label>
            <input type="file" id="foto" name="foto" accept="image/*">

            <button type="submit">Invia Richiesta</button>
        </form>
    </div>
</div>

<script src="js/index.js"></script>
</body>
<footer>
    <lable for="email_dev"></lable>
</footer>
</html>
