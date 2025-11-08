####CREAZIONE BASE DI DATI####

DROP DATABASE IF EXISTS ProgettoImpresaEdile;
CREATE DATABASE IF NOT EXISTS ProgettoImpresaEdile;
USE ProgettoImpresaEdile;

####CREAZIONE TABELLE####

DROP TABLE IF EXISTS Edificio;

CREATE TABLE IF NOT EXISTS Edificio (
	Codice INT PRIMARY KEY,
    Tipologia VARCHAR(20),
    Indirizzo VARCHAR(100)
) ENGINE=INNODB;

DROP TABLE IF EXISTS Piano;

CREATE TABLE IF NOT EXISTS Piano (
	Codice INT PRIMARY KEY,
    Edificio INT,
    Pianta INT,
    FOREIGN KEY(Edificio)
		REFERENCES Edificio(Codice)
) ENGINE=INNODB;

DROP TABLE IF EXISTS Stanza;

CREATE TABLE IF NOT EXISTS Stanza (
	Codice INT PRIMARY KEY AUTO_INCREMENT,
    Funzione VARCHAR(20),
    Altezza DECIMAL(3,2),
    Lunghezza DECIMAL(4,2),
    Larghezza DECIMAL(4,2),
    Piano INT,
    FOREIGN KEY(Piano)
		REFERENCES Piano(Codice)
) ENGINE=INNODB;

DROP TABLE IF EXISTS Apertura;

CREATE TABLE IF NOT EXISTS Apertura (  
	Codice INT PRIMARY KEY AUTO_INCREMENT,
    Ubicazione ENUM('Nord','Sud','Est','Ovest'),
    Tipo ENUM('Finestra','Porta','Terrazza'),
    Altezza DECIMAL(3,2),
    Larghezza DECIMAL(3,2)
) ENGINE=INNODB;

DROP TABLE IF EXISTS Collegamento;

CREATE TABLE IF NOT EXISTS Collegamento (  
	Apertura INT,
    Stanza INT,
    PRIMARY KEY(Apertura,Stanza),
    FOREIGN KEY (Apertura)
		REFERENCES Apertura(Codice),
	FOREIGN KEY (Stanza)
		REFERENCES Stanza(Codice)
) ENGINE=INNODB;

DROP TABLE IF EXISTS ProgettoEdilizio;

CREATE TABLE IF NOT EXISTS ProgettoEdilizio (  
	Codice INT PRIMARY KEY,
    Tipo ENUM('Ristrutturazione','Costruzione'),
    DataInizio DATE,
    DataFine DATE,
    Edificio INT,
    FOREIGN KEY (Edificio)
		REFERENCES Edificio(Codice)
) ENGINE=INNODB;

DROP TABLE IF EXISTS Stadio;

CREATE TABLE IF NOT EXISTS Stadio (  
	Codice INT PRIMARY KEY,
    ProgettoEdilizio INT,
    FOREIGN KEY (ProgettoEdilizio)
		REFERENCES ProgettoEdilizio(Codice)
) ENGINE=INNODB;

DROP TABLE IF EXISTS Lavoro;

CREATE TABLE IF NOT EXISTS Lavoro (  
	Tipologia VARCHAR(50) PRIMARY KEY,
    Costo INT
) ENGINE=INNODB;

DROP TABLE IF EXISTS Eseguito;

CREATE TABLE IF NOT EXISTS Eseguito (
	Stadio INT,
    Lavoro VARCHAR(100),
    DataInizio DATE,
    DataFine DATE,
    PRIMARY KEY(Stadio,Lavoro),
    FOREIGN KEY (Stadio)
		REFERENCES Stadio(Codice),
	FOREIGN KEY (Lavoro)
		REFERENCES Lavoro(Tipologia)
)ENGINE=INNODB;

DROP TABLE IF EXISTS InEsecuzione;

CREATE TABLE IF NOT EXISTS InEsecuzione (
	Stadio INT,
    Lavoro VARCHAR(100),
    DataInizio DATE,
    PRIMARY KEY(Stadio,Lavoro),
    FOREIGN KEY (Stadio)
		REFERENCES Stadio(Codice),
	FOREIGN KEY (Lavoro)
		REFERENCES Lavoro(Tipologia)
)ENGINE=INNODB;

DROP TABLE IF EXISTS Turno;

CREATE TABLE IF NOT EXISTS Turno (  
	Codice INT PRIMARY KEY AUTO_INCREMENT,
    Orario TIME,
    Durata INT,
    NumeroMaxOperai INT,
    Stadio INT,
    FOREIGN KEY (Stadio)
		REFERENCES Stadio(Codice)
) ENGINE=INNODB;

DROP TABLE IF EXISTS Operaio;

CREATE TABLE IF NOT EXISTS Operaio (  
	Codice INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(20)
) ENGINE=INNODB;

DROP TABLE IF EXISTS Partecipazione;

CREATE TABLE IF NOT EXISTS Partecipazione (  
	Turno INT,
    Operaio INT,
    PRIMARY KEY(Turno,Operaio),
    FOREIGN KEY (Turno)
		REFERENCES Turno(Codice),
	FOREIGN KEY (Operaio)
		REFERENCES Operaio(Codice)
) ENGINE=INNODB;

DROP TABLE IF EXISTS CapoCantiere;

CREATE TABLE IF NOT EXISTS CapoCantiere (  
	Codice INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(20),
    NumOperai INT
) ENGINE=INNODB;

DROP TABLE IF EXISTS Direzione;

CREATE TABLE IF NOT EXISTS Direzione (  
	Turno INT,
    CapoCantiere INT,
    PRIMARY KEY(Turno,CapoCantiere),
    FOREIGN KEY (Turno)
		REFERENCES Turno(Codice),
	FOREIGN KEY (CapoCantiere)
		REFERENCES CapoCantiere(Codice)
) ENGINE=INNODB;

####POPOLAMENTO DELLE TABELLE####

INSERT INTO Edificio VALUES
	(238,"Villetta","Via dei Cappuccini, 54"),
	(392,"Villetta","Via della Piovola, 4"),
	(297,"Condominio","Via del Sole, 18"),
	(103,"Villetta","Via Sanzio, 97");

INSERT INTO Piano (Codice,Edificio,Pianta) VALUES
	(37,238,01),
	(39,103,26),
	(12,297,12),
	(41,297,13),
	(43,392,19),
	(52,103,33);
    
INSERT INTO Stanza(Funzione, Altezza, Larghezza, Lunghezza, Piano) VALUES
	('soggiorno', 3.50, 5.25, 4.80, 52),
	('camera da letto', 3.35, 4.00, 3.55, 41),
	('cucina', 2.20, 3.60, 3.25, 43),
	('bagno', 3.05, 2.50, 2.00, 39),
	('sgabuzzino', 3.10, 1.55, 1.80, 37),
	('sala da pranzo', 3.40, 4.55, 4.00, 41),
	('camera da letto', 3.25, 3.00, 3.55, 52),
	('soggiorno', 3.00, 2.55, 1.50, 12),
	('sgabuzzino', 3.10, 4.00, 5.00, 37),
	('soggiorno', 3.20, 2.00, 2.55, 12);
    
INSERT INTO Apertura  (Larghezza, Altezza, Ubicazione, Tipo) VALUES
    (2.50, 2.10, 'nord', 'Porta'),
    (1.80, 2.50, 'sud', 'Finestra'),
    (8.20, 1.80, 'est', 'Terrazza'),
    (2.70, 2.20, 'ovest', 'Porta'),
    (1.95, 2.70, 'nord', 'Finestra'),
    (4.60, 1.70, 'sud', 'Terrazza'),
    (3.20, 2.40, 'est', 'Porta'),
    (1.60, 2.90, 'ovest', 'Finestra'),
    (7.80, 1.50, 'nord', 'Terrazza'),
    (2.90, 2.30, 'sud', 'Porta'),
    (1.75, 2.60, 'est', 'Finestra'),
    (5.20, 1.90, 'ovest', 'Terrazza');
    
INSERT INTO Collegamento(Apertura,Stanza) VALUES
	(6, 6),
	(11, 5),
	(4, 9),
	(9, 1),
	(2, 10),
	(12, 3),
	(1, 10),
	(8, 2),
	(7, 4),
    (5, 10),
    (10, 4),
    (6, 2),
	(3, 8);
    
INSERT INTO ProgettoEdilizio (Codice, Tipo, DataInizio, DataFine, Edificio) VALUES
	(218, 'Costruzione', '2023-01-01', '2023-06-30', 103),
	(357, 'Costruzione', '2023-02-15', '2023-09-30', 392),
	(182, 'Ristrutturazione', '2023-03-01', '2023-07-31', 238),
	(439, 'Costruzione', '2023-04-10', '2023-11-30', 297),
	(125, 'Ristrutturazione', '2023-05-15', '2024-02-28', 238);

INSERT INTO Stadio(Codice,ProgettoEdilizio) VALUES
	(2947,182),
    (5398,125),
    (4729,218),
    (7593,357),
    (1385,218),
    (4723,439),
    (3920,125);

INSERT INTO Lavoro (Tipologia, Costo) VALUES 
	('Muratura', 1500),
	('Pavimentazione', 2000),
	('Impianto idraulico', 3000),
	('Impianto elettrico', 2500),
	('Imbiancatura', 1000);

INSERT INTO Eseguito (Stadio,Lavoro,DataInizio,DataFine) VALUES
	(2947, 'Pavimentazione', '2023-01-09', '2023-01-20'),
    (4723, 'Impianto idraulico', '2023-04-12', '2023-05-03'),
    (4729, 'Imbiancatura', '2023-02-23', '2023-02-27'),
    (1385, 'Impianto elettrico', '2023-03-01', '2023-04-10'),
    (7593, 'Impianto idraulico', '2023-02-24', '2023-03-17'),
    (5398, 'Muratura', '2023-02-01', '2023-05-01'),
    (1385, 'Imbiancatura', '2023-04-13', '2023-04-20');
    
INSERT INTO InEsecuzione(Stadio,Lavoro,DataInizio) VALUES
	(1385, 'Impianto elettrico', '2023-04-29'),
    (4723, 'Pavimentazione', '2023-05-10'),
    (7593, 'Imbiancatura', '2023-05-19'),
    (5398, 'Impianto elettrico', '2023-04-13'),
    (3920, 'Impianto idraulico', '2023-05-01'),
    (1385, 'Imbiancatura', '2023-05-15'),
    (5398, 'Muratura', '2023-03-15');

INSERT INTO Turno (Orario, Durata, NumeroMaxOperai, Stadio) VALUES 
  ('08:00:00', 8, 20, 2947),
  ('14:00:00', 6, 30, 5398),
  ('10:00:00', 10, 35, 4729),
  ('08:00:00', 5, 25, 7593),
  ('08:00:00', 7, 28, 1385),
  ('09:00:00', 9, 32, 4723),
  ('12:00:00', 4, 15, 3920),
  ('08:00:00', 9, 38, 4723),
  ('10:30:00', 6, 24, 2947);

INSERT INTO Operaio (Nome) VALUES
	('Mario Rossi'),
	('Luigi Bianchi'),
	('Paolo Ferrari'),
	('Roberto Martini'),
	('Alberto Sartori'),
	('Marco Gargelli');

INSERT INTO Partecipazione(Turno,Operaio) VALUES
	(1, 5),
    (2, 1),
    (3, 5),
    (4, 4),
    (5, 2),
    (6, 6),
    (7, 1),
    (8, 3),
    (9, 3),
    (3, 6),
    (7, 3),
    (9, 2);

INSERT INTO Capocantiere (Nome, NumOperai) VALUES 
	('Paolo Banchi', 10),
	('Sandro Martini', 8),
	('Giovanni Leopardi', 12),
	('Sirio Bellomini', 6),
	('Sveva Maltinti', 9);
    
INSERT INTO Direzione (Turno, CapoCantiere) VALUES 
	(8, 3),
	(1, 1),
	(5, 4),
	(5, 5),
	(3, 3),
	(6, 1),
	(9, 4),
	(1, 2),
	(3, 1),
	(2, 2),
	(6, 2),
	(4, 4),
	(7, 5),
	(3, 5),
	(7, 2);
    
####INTERROGAZIONI####

# Trovare i lavori ancora in corso con costo maggiore di 2000 #
SELECT IE.Lavoro, IE.Stadio
FROM InEsecuzione IE INNER JOIN Lavoro L ON IE.Lavoro=L.Tipologia
WHERE L.Costo>2000;

# Trovare il numero di capi cantiere che supervisionano ciascun turno #
SELECT T.Codice, COUNT(*) AS NumeroCapoCantiere
FROM Turno T INNER JOIN Direzione D ON T.Codice=D.Turno
GROUP BY T.Codice;

# Trovare il numero di finestre per ciascun piano #
SELECT S.Piano, COUNT(*) AS Finestre
FROM Stanza S INNER JOIN Collegamento C ON S.Codice=C.Stanza INNER JOIN Apertura A ON C.Apertura=A.Codice
WHERE A.Tipo='Finestra'
GROUP BY S.Piano;

# Trovare i nomi degli operai supervisionati da un capo cantiere (in questo caso, Sirio Bellomini) #
SELECT DISTINCT O.Nome
FROM Operaio O INNER JOIN Partecipazione P ON O.Codice=P.Operaio
WHERE P.Turno IN(
	SELECT D.Turno
	FROM  CapoCantiere CC INNER JOIN Direzione D ON CC.Codice=D.CapoCantiere
	WHERE CC.Nome='Sirio Bellomini'
);

# Trovare gli operai che lavorano in turni di 6 ore #
SELECT O.Nome
FROM Operaio O
WHERE O.Codice IN(
	SELECT P.Operaio
	FROM Partecipazione P INNER JOIN Turno T ON P.Turno=T.Codice
	WHERE T.Durata=6
);

# Trovare le stanze di un piano con volume minore della media di tutti i volumi #
WITH VolumiStanze AS(
	SELECT S.Codice AS CodiceStanza, S.Altezza*S.Larghezza*S.Lunghezza AS Volume, S.Funzione
	FROM Stanza S
)
SELECT *
FROM  VolumiStanze VS
WHERE VS.Volume<(
	SELECT AVG(VS.Volume) AS Media
	FROM VolumiStanze VS 
);


#### PROCEDURE E FUNZIONI ####

#Procedura per controllare che le dimensioni di una Aperura rientrino nei parametri della stanza#
DELIMITER $$
CREATE PROCEDURE ControlloDimensioni(Larghezza DECIMAL, Altezza DECIMAL, Ubicazione VARCHAR(20), Tipo VARCHAR(8), idStanza INT)
BEGIN
	DECLARE hStanza INT;
	DECLARE bStanza INT;
    DECLARE Messaggio VARCHAR(100);
    
	SELECT Altezza INTO hStanza FROM Stanza S WHERE S.Codice=idStanza;
	IF (Ubicazione='Nord' OR Ubicazione = 'Sud') THEN
		SELECT Larghezza INTO bStanza FROM Stanza S WHERE S.Codice=idStanza;
	ELSEIF (Ubicazione='Ovest' OR Ubicazione = 'Est') THEN
		SELECT Lunghezza INTO bStanza FROM Stanza S WHERE S.Codice=idStanza;
	END IF;
	IF (Tipo='Porta' AND Altezza<hStanza AND Altezza>2.10 AND Larghezza>0.80 AND Larghezza<bStanza) THEN
		SET Messaggio='La porta rispetta le limitazioni';
	 END IF;
	IF (Tipo='Finestra' AND Altezza<hStanza AND Altezza>1.20 AND Larghezza<bStanza AND Larghezza>0.60) THEN
		SET Messaggio='La finestra rispetta le limitazioni';
	END IF;
	IF (Tipo='Finestra' AND Altezza<hStanza AND Altezza>1.80 AND Larghezza<bStanza AND Larghezza>50) THEN
		SET Messaggio= 'La terrazza rispetta le limitazioni';
	ELSE
		SET Messaggio= 'Dimensioni non valide';
	 END IF;

END $$
DELIMITER ;

CALL ControlloDimensioni (1.70,2.15,'Nord','Finestra','10');

#Funzione per il calcolo del costo totale di un Progetto Edilizio#
DROP FUNCTION IF EXISTS CalcoloCostoProgetto;
DELIMITER $$
CREATE FUNCTION CalcoloCostoProgetto(idProgetto INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE TOT INT;
    
    SET TOT=(SELECT SUM(L.Costo)
    FROM ProgettoEdilizio PE INNER JOIN Stadio S ON PE.Codice=S.ProgettoEdilizio INNER JOIN Eseguito E ON S.Codice=E.Stadio INNER JOIN Lavoro L ON E.Lavoro=L.Tipologia);
    
    RETURN TOT;
    
END $$
DELIMITER ;

SELECT CalcoloCostoProgetto (218);

#### VISTE ####

# Vista che mostra tutti i turni che hanno durata pari o superiore a 8 ore #

DROP VIEW IF EXISTS TurnoIntegrale;
CREATE VIEW TurnoIntegrale AS
	SELECT * 
	FROM Turno T
	WHERE T.Durata>=8
	WITH LOCAL CHECK OPTION;
SELECT *  FROM TurnoIntegrale;

# Vista che mostra tutte le finestre che sono rivolte a nord nelle stanze di tipo soggiorno #

DROP VIEW IF EXISTS FinestreNordSoggiorno;
CREATE VIEW FinestreNordSoggiorno AS
	SELECT A.Codice AS CodiceNord, A.Altezza AS AltezzaNord, A.Larghezza AS LarghezzaNord
	FROM Apertura A INNER JOIN Collegamento C ON A.Codice=C.Apertura INNER JOIN Stanza S ON C.Stanza=S.Codice
	WHERE S.Funzione='soggiorno' AND A.Ubicazione='Nord' AND A.Tipo='Finestra'
	WITH LOCAL CHECK OPTION;
SELECT * FROM FinestreNordSoggiorno;


#### TRIGGER ####

# Trigger che controlla se la data del Progetto Edilizio inserito è coerente #

DROP TRIGGER IF EXISTS ControlloProgettoEdilizio;
DELIMITER $$
CREATE TRIGGER ControlloProgettoEdilizio
BEFORE INSERT ON ProgettoEdilizio
FOR EACH ROW
BEGIN 

	IF (NEW.DataInizio > NEW.DataFine) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'date di inizio stadio inserite incoerenti con il progetto';
	

		INSERT INTO ProgettoEdilizio (Codice, Tipo, DataInizio, DataFine, Edificio)
		VALUES (NEW.Codice, NEW.Tipo, NEW.DataInizio, DATE_ADD(NEW.DataFine, INTERVAL 1 YEAR), NEW.Edificio);
	END IF;
END $$
DELIMITER ;








