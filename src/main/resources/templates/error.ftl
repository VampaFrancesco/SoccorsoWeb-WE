<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${errorTitle!"Errore"} - SoccorsoWeb</title>
    <link rel="stylesheet" href="/css/login.css">
    <style>
        .error-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            text-align: center;
        }

        .error-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            max-width: 500px;
            width: 100%;
        }

        .error-code {
            font-size: 80px;
            font-weight: bold;
            color: #667eea;
            margin: 0;
            line-height: 1;
        }

        .error-title {
            font-size: 28px;
            font-weight: 600;
            color: #333;
            margin: 20px 0 10px 0;
        }

        .error-message {
            font-size: 16px;
            color: #666;
            margin: 0 0 30px 0;
            line-height: 1.5;
        }

        .error-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-block;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #f5f5f5;
            color: #333;
        }

        .btn-secondary:hover {
            background: #e0e0e0;
        }

        .error-icon {
            font-size: 60px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-card">
            <div class="error-icon">⚠️</div>
            <#if statusCode??>
                <h1 class="error-code">${statusCode}</h1>
            </#if>
            <h2 class="error-title">${errorTitle!"Errore"}</h2>
            <p class="error-message">${errorMessage!"Si è verificato un errore imprevisto."}</p>

            <div class="error-actions">
                <a href="/" class="btn btn-primary">Torna alla Home</a>
                <button onclick="history.back()" class="btn btn-secondary">Indietro</button>
            </div>
        </div>
    </div>
</body>
</html>
