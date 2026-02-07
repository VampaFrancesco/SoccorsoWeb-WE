# Corso di Web Engineering<br/>*Progetti A.A. 2024/2025* - Specifica 1

<section class="specifica">

## Progetto "SoccorsoWeb"
> Versione 1.0

### Premessa

I progetti di fine corso si ispirano sempre ad esigenze
reali, e fanno solitamente riferimento a tipologie di sito già presenti sulla
rete. Nello svolgere il progetto, gli studenti dovranno attenersi alla
specifica data in questo documento, ma potranno raffinarla tramite l'interazione
col docente e l'analisi di siti web analoghi. In ogni caso, la realizzazione
finale dovrà essere completamente originale. Le informazioni pubblicate
dovranno essere sempre ben organizzate ed accessibili, date le varie tipologie
di utenza associate alle applicazioni web pubbliche.  

### Specifiche del Sito

<section class="descrizione">



Il sito *SoccorsoWeb* rappresenta un generico portale per la ricezione e la gestione di *richieste di soccorso*. La tipologia di soccorso offerto non ci interessa: ci concentreremo solo sul modo generale di realizzare questo tipo di applicazione. Il sito avrà una parte riservata ad *amministratori* (che configureranno il sistema, smisteranno le richieste e le monitoreranno) e *operatori* (a cui verranno inviate le richieste e che le gestiranno in prima persona). La parte pubblica del sito, invece, permetterà unicamente di inviare una richieste di soccorso senza la necessità di alcuna registrazione.

Gli amministratori del sito potranno creare account per nuovi amministratori ed operatori. Per entrambe le categorie di utenza, oltre ai dati anagrafici, dovrà essere possibile inserire delle informazioni extra quali le *patenti* possedute (A, B, C, nautica,...) e una lista (generica) di *abilità* (ad esempio un operatore potrebbe avere un diploma infermieristico, un altro potrebbe essere un elettricista, ecc.) utili per deciderne l'assegnazione alle missioni. L'inserimento di un nuovo utente ne creerà automaticamente le credenziali per l'accesso al portale, che verranno inviate via mail. 

Per effettuare le operazioni di soccorso, gli operatori avranno a disposizione dei *mezzi* (auto, ambulanze, autopompe... dipende dal tipo di emergenza che verrà gestita effettivamente dal sito) e dei *materiali* (kit medici, scale, estintori,...). Tali elementi saranno censiti nel database del sito (sempre per essere molto generici, essi avranno solo un nome e una descrizione), e gli amministratori potranno aggiungerli, modificarli o eliminarli.

La home page del sito conterrà una descrizione del servizio offerto e un modulo per inviare delle *richieste* di soccorso; tali richieste dovranno essere necessariamente accompagnate da una breve descrizione, dall'indicazione della posizione (indirizzo, coordinate, ecc.), dal nome e dell'indirizzo email del *segnalante*, e potranno essere opzionalmente corredate da una foto. *Attenzione a realizzare questa parte in maniera corretta per evitare spam e attacchi vari. Ad esempio, provate ad inserire quantomeno un sistema di captcha (anche molto semplice) in questa form. Inoltre, il sistema non dovrebbe accettare più richieste consecutive dallo stesso segnalante (indirizzo email) e possibilmente dallo stesso indirizzo IP di origine*. Ogni richiesta *inviata*, prima di diventare *attiva*, dovrà essere *convalidata* inviandone il contenuto per email all'indirizzo del segnalante, corredata da un link da cliccare per confermarla. *Suggerimento: create una stringa lunga e casuale e associatela alla richiesta; create un link a una servlet del vostro progetto che contenga solo questa stringa come parametro e inseritela nell'email. All'arrivo della relativa chiamata al server, il sistema potrà quindi sapere quale richiesta deve essere convalidata. Non è necessario che spediate realmente le email se non riuscite a configurarle nel progetto: potete, a scopo illustrativo, generarne il contenuto e mostrarlo a schermo*.

Gli amministratori disporranno di una dashboard in cui sono visualizzate opportunamente le richieste inviate e convalidate (attive), quelle gestite (in corso) e quelle concluse (chiuse). Le liste conterranno le informazioni di base di ciascuna richiesta con possibilità di vederne tutti i dettagli tramite un popup o una pagina dedicata.

Le richieste attive potranno essere ignorate (annullate) o gestite creando una *missione*. Tale missione avrà associati la richiesta scatenante, un obiettivo, una posizione, una *squadra* (composta da almeno un operatore *caposquadra* e da zero o più altri operatori), zero o più mezzi, zero o più materiali, oltre che ovviamente un timestamp di inizio.   
La creazione di una missione e quindi l’assegnazione di una richiesta a una squadra dovrà attivare l’invio di notifiche (email) a tutti gli operatori coinvolti. Tali notifiche conterranno  i dati necessari per partecipare alla missione (che potranno comunque essere consultati dagli operatori anche accedendo al sito, come descritto più avanti).   
*Attenzione: il sistema dovrà tener traccia degli operatori, dei mezzi e dei materiali impegnati nelle missioni. Dovrà quindi essere possibile, all'atto della creazione dei una nuova missione, scegliere solo gli elementi disponili, cioè non già coinvolti in missioni attive. Ogni elemento disporrà anche di un proprio storico delle missioni in cui è stato coinvolto, accessibile come dettaglio a partire dalla rispettiva lista (operatori, mezzi o materiali)*.

Gli amministratori potranno in ogni momento inserire degli *aggiornamenti* (blocchi di testo descrittivo) in una missione. Tali aggiornamenti verranno mostrati nel dettaglio della missione in ordine temporale (ciascuno verrà associato con il timestamp di immissione), e determineranno l’invio di una notifica (sempre almeno per email) agli operatori coinvolti.

Infine, gli amministratori (a seguito di un’opportuna comunicazione da parte degli operatori) potranno marcare una missione come conclusa (chiusa), inserendo data/ora di fine, un generico *livello si successo* (anche questo dipendente dal tipo di soccorso, possiamo genericamente usare un numero che va da 0=fallimento a 5=successo pieno) e dei commenti opzionali relativi all’intervento eseguito. Questo servirà anche a marcare tutte le risorse coinvolte nella missione come nuovamente libere. La conclusione di una missione determinerà anche l’invio di una relativa notifica (email) a tutti gli operatori coinvolti.

Gli utenti operatori avranno accesso alla propria anagrafica e alle missioni associate (chiuse o in corso, queste ultime evidenziate).


</section>


Di seguito sono illustrati schematicamente i contenuti e le
funzionalità minime che dovrebbero essere inseriti nel sito. Ovviamente, ogni
ulteriore raffinamento o arricchimento di queste specifiche aumenterà il valore
del progetto.

  <section class="operazioni">
  


- L'accesso al modulo di richiesta di soccorso del sito sarà libero e non richiederà alcuna autenticazione.

- Le richieste di soccorso inserite nel sistema diverranno attive, e quindi visibili agli amministratori, solo dopo la loro convalida, come descritto in precedenza. *Opzionalmente*, si può fare in modo che le richieste non confermate vengano periodicamente eliminate dal sistema.

- La registrazione di operatori e amministratori sarà possibile solo da parte di un amministratore (quindi si suppone che il sistema venga avviato con un amministratore iniziale di default).

- Gli amministratori avranno a disposizione almeno le seguenti viste:
  1) richieste di soccorso attive, in corso, chiuse, e ignorate, opportunamente paginate e/o filtrate in base alla data e alla tipologia (con possibilità di risalire alla missione associata nel caso di richieste attive e chiuse). E' consigliabile dividere questa vista in più viste distinte per tipologia;
  2) missioni in corso;
  2) operatori;
  3) mezzi;
  4) materiali.
  
- Per ogni richiesta attiva, gli amministratori potranno scegliere se ignorarla o associarla a una nuova missione.

- Le missioni potranno essere create dagli amministratori solo a partire da una richiesta attiva, fornendo tutti i dati richiesti, compresa la composizione della squadra e gli eventuali mezzi/materiali assegnati. Ovviamente non si potranno assegnare a una missione operatori, mezzi o materiali già impegnati in una missione in corso.

- L'amministratore potrà in ogni momento aggiungere aggiornamenti a una missione in corso e chiuderla al suo termine. Non deve essere possibile inserire aggiornamenti in missioni chiuse.

- Nelle viste operatori, mezzi e materiali, dovranno essere evidenziati gli elementi attualmente coinvolti in una missione attiva, con la possibilità di vederne il dettaglio. Dovrà inoltre essere possibile accedere allo storico delle missioni in cui sono stati coinvolti.

- Gli operatori avranno a disposizione almeno le seguenti viste:
  1) missioni in cui sono coinvolti (in corso o chiuse)
  2) anagrafica personale (con possibilità di aggiornare le proprie specializzazioni, patenti, ecc.)
  
  

  
  </section>

<section class="indicazioni break">

# Indicazioni per lo Sviluppo del Progetto

### Tecnologie da utilizzare

- La *struttura* base del sito deve essere realizzata in **HTML5**. La validazione
delle principali pagine del sito è parte integrante dello sviluppo e deve essere
riportata nella documentazione.

- Per la realizzazione del *layout* devono essere utilizzati il più
possibile i figli di stile CSS. Il layout può liberamente basarsi su quelli
disponibili in rete o utilizzati a lezione. Il grado di **personalizzazione**
del layout sarà comunque tenuto in considerazione in sede di valutazione. **Un
layout responsive non è strettamente richiesto ma fortemente consigliato.**

- Per la programmazione lato *client* il linguaggio richiesto
è JavaScript. Si possono liberamente includere nel progetto librerie sviluppate
da terze parti, a patto che la loro portabilità cross-browser sia adeguata e
che nella relazione siano citate e descritte. È in ogni caso **sconsigliato
l'abuso di tali tecnologie** , soprattutto quando sia possibile sostituirle
con un adeguato uso di HTML, CSS, ecc. In linea generale, è **ammissibile che gli
script giochino un ruolo più importante nelle funzionalità la cui utenza è
ristretta e predeterminata**, ad esempio nelle funzionalità *back-end*
per gli amministratori, ma non nel *front-end* pubblico del sito o in una
procedura di login. Su queste parti, invece, **l'uso del sito senza script potrebbe
essere meno "agevole" o permettere di accedere solo alle funzionalità "vitali"**. 

- Per la programmazione lato *server* è **richiesto** l'uso
di Java (*servlet*), eventualmente associato a qualsiasi *DBMS* (se necessario)
e a un *template engine* (come *Freemarker*). Anche in questo caso è
possibile avvalersi di librerie esterne.

- Il sito, in generale, deve funzionare ed avere un buon *rendering*
sulle versioni più recenti di Edge, Firefox e Chrome, e *possibilmente*
essere compatibile con i browser più datati (in questo caso non c'è bisogno che
tutto funzioni perfettamente, ma almeno che le funzionalità *degradino bene*)
e con le ultime versioni di altri browser, come Opera. Tale compatibilità **deve**
essere esplicitamente dichiarata nella documentazione.  

### Svolgimento e Documentazione del Progetto

Le specifiche fornite potrebbero non risultare esaustive o
completamente definite. Ogni funzionalità aggiunta o raffinata, anche tramite
l'interazione con il committente o con gli utenti finali del sito, sarà
adeguatamente valutata. Tutte le scelte progettuali vanno comunque discusse e
motivate.

Il progetto, svolto secondo le linee guida date dalle
specifiche, dovrà essere consegnato nella forma di un sito web completamente
funzionante, i cui contenuti e le cui caratteristiche saranno valutati in sede
d'esame. Le parti della specifica marcate come *opzionali*, se omesse, non
renderanno il progetto insufficiente ma non gli permetteranno comunque di
raggiungere il massimo dei voti. Nel caso si decida di realizzarle, non sarà
necessario che siano perfette o complete, ma che dimostrino chiaramente il
vostro impegno nell'affrontare una tematica avanzata.

La documentazione (**in formato elettronico**) che
accompagna il progetto **deve** contenere almeno le seguenti informazioni:

- Indicazione delle dipendenze software (di quali librerie avete
bisogno dal lato server e client?).

- Indicazione delle funzionalità realizzate e di quelle
eventualmente non realizzate. Descrizione dettagliata delle eventuali
funzionalità extra o opzionali inserite nel progetto.

- Diagramma che illustra la struttura e la navigabilità del sito (ad es.
un *navigation diagram*).

- Schema relazionale della base di dati (se presente).

- Descrizione analitica del layout del sito, con indicazione delle
sue principali componenti statiche/dinamiche.

- Descrizione delle eventuali tecnologie avanzate (linguaggi,
framework, plugin, librerie, ...) utilizzate, del motivo per cui sono state
adottate e del contributo effettivo che hanno dato alla realizzazione del
progetto.

- Descrizione di *eventuali* problemi riscontrati nella
fruizione del sito su browser differenti, lista dei browser compatibili.

- Screenshot delle pagine più importanti del sito (*opzionale*).

Nel caso di gruppi di lavoro composti da più componenti, *il
contributo effettivo offerto da ciascun componente* alla realizzazione
finale **deve** essere descritto nella documentazione (indicando, ad
esempio, chi si è dedicato prevalentemente alla programmazione server, chi ha
realizzato il layout, chi ha programmato lato client, ecc.). In sede di esame,
i responsabili potranno essere chiamati a riferire sugli aspetti loro delegati.  

### Consegna del Progetto

La *documentazione* del progetto, redatta come indicato nelle sezioni precedenti,
dovrà essere consegnata al docente **almeno due giorni prima** della data d'esame, 
inviandola semplicemente per email.   
*Non verranno in alcun caso concesse proroghe a questo termine*, perchè concedere 
un giorno in più a uno studente vorrebbe dire svantaggiare tutti gli altri che hanno 
consegnato per tempo o hanno organizzato i loro impegni per farlo, e che avrebbero 
anch'essi sicuramente beneficiato di un po' di tempo aggiuntivo, quantomeno per 
migliorare o rifinire il proprio lavoro.

*Non è necessario consegnare il codice*, che verrà analizzato e provato in sede d'esame
(portate quindi con voi una copia funzionante del progetto sul vostro PC portatile), 
ma è utile (se possibile) allegare alla documentazione la URL di un repository pubblico da 
cui questo può essere scaricato e ispezionato se necessario.


### Valutazione del Progetto

Nel valutare il progetto consegnato saranno prese in
considerazione le seguenti caratteristiche (in ordine di importanza):
1. Rispetto delle specifiche.
2. Correttezza tecnica.
3. Chiarezza e correttezza organizzativa dei contenuti.
4. Accessibilità e conformità agli standard.
5. Uso appropriato di contenuti statici e dinamici.
6. Qualità del design.
7. Adeguatezza della documentazione.

A questa valutazione si aggiungerà quella generale derivata
dalla discussione del progetto in sede d'esame.  

### Ulteriori Informazioni

Questa specifica è disponibile nel repository del corso di Web Engineering, 
all'indirizzo https://github.com/WebEngineering-Univaq/WE_Project_Specifications.
Ulteriori informazioni e chiarimenti sulle specifiche possono essere richiesti
direttamente via email all'indirizzo giuseppe.dellapenna@univaq.it.

Si ricorda che i progetti vanno svolti in *piccoli* gruppi (tre persone è il numero consigliato). 
Eccezioni a questa regola andranno concordate direttamente col docente.

An English translation of this project specification is also available in the course repository (https://github.com/WebEngineering-Univaq/WE_Project_Specifications).
If the translation is not there, ask the teacher to publish it :smile:
</section>

