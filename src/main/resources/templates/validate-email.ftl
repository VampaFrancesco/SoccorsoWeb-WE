<!DOCTYPE html>
<html>
<head>
    <title>Convalida Richiesta</title>
</head>
<body>
<#if status == "success">
    <h1>✅ Richiesta convalidata con successo!</h1>
    <p>La tua richiesta di soccorso è stata attivata.</p>
<#else>
    <h1>❌ Errore nella convalida</h1>
    <p>${message!"Errore sconosciuto"}</p>
</#if>
</body>
</html>