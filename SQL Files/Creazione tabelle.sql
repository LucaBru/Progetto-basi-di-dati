CREATE TABLE Acquirente (
	CF VARCHAR(16) PRIMARY KEY,
	Nome VARCHAR(50) NOT NULL,
	Nazione VARCHAR(50) NOT NULL,
	Città VARCHAR(50) NOT NULL,
	Via VARCHAR(50) NOT NULL,
	Civico VARCHAR(8) NOT NULL
);

CREATE INDEX idx_Acquirente ON Acquirente USING hash (CF);

CREATE TABLE Persona (
	CF VARCHAR(16) PRIMARY KEY,
	Cognome VARCHAR(50) NOT NULL,
	FOREIGN KEY (CF) REFERENCES Acquirente (CF) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Azienda (
    CF VARCHAR(16) PRIMARY KEY, 
	PIVA VARCHAR(17) NOT NULL,
	FOREIGN KEY (CF) REFERENCES Acquirente(CF)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TYPE MANSIONE AS ENUM ('Impiegato', 'Meccanico', 'Dirigente');
CREATE TABLE Dipendente (
	CF VARCHAR(16) PRIMARY KEY,
	Nome VARCHAR(50) NOT NULL,
	Cognome VARCHAR(50) NOT NULL,
	Mansione MANSIONE NOT NULL,
	Nazione VARCHAR(50) NOT NULL,
	Città VARCHAR(50) NOT NULL,
	Via VARCHAR(50) NOT NULL,
	Civico VARCHAR(8) NOT NULL
);

CREATE TYPE TIPO_SEDE AS ENUM ('Officina', 'Concessionario');
CREATE TABLE Sede (
	ID VARCHAR PRIMARY KEY,
	Tipo TIPO_SEDE,
	Nazione VARCHAR(50) NOT NULL,
	Città VARCHAR(50) NOT NULL,
	Via VARCHAR(50) NOT NULL,
    Civico VARCHAR(8) NOT NULL,
    UNIQUE (Tipo, Città, Via, Civico)	
);

CREATE TYPE TIPO_CONTRATTO AS ENUM ('Stagista', 'Apprendista', 'Determinato', 'Indeterminato');
CREATE TABLE Contratto (
	ID VARCHAR PRIMARY KEY,
    Tipo TIPO_CONTRATTO,
    Retribuzione_oraria DOUBLE PRECISION NOT NULL,
    Livello INT NOT NULL
);

CREATE TABLE Impiego_corrente (
	Dipendente VARCHAR (16) PRIMARY KEY,
	Contratto VARCHAR NOT NULL,
	Sede VARCHAR NOT NULL,
	Inizio DATE NOT NULL,
	FOREIGN KEY (Dipendente) REFERENCES Dipendente(CF) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Contratto) REFERENCES Contratto(ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Sede) REFERENCES Sede(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Impiego_Passato (
	Dipendente VARCHAR(16),
	Inizio DATE,
	Fine DATE NOT NULL,
	Contratto VARCHAR NOT NULL,
	Sede VARCHAR NOT NULL,
	PRIMARY KEY(Dipendente, Inizio),
	FOREIGN KEY (Dipendente) REFERENCES Dipendente(CF) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Contratto) REFERENCES Contratto(ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Sede) REFERENCES Sede(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Modello (
	Nome VARCHAR(50) PRIMARY KEY,
	Costruttore VARCHAR(20) NOT NULL,
	Inizio_Produzione INT4 CHECK (Inizio_Produzione > 1959 AND Inizio_Produzione <= EXTRACT (YEAR FROM CURRENT_DATE))
);

CREATE TABLE Veicolo  (
	Telaio VARCHAR(17) PRIMARY KEY,
	Prezzo DOUBLE PRECISION NOT NULL,
	Anno DATE NOT NULL,
    Modello VARCHAR(30) NOT NULL,
    FOREIGN KEY (Modello) REFERENCES Modello(Nome) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX idx_VTelaio ON Veicolo USING hash (Telaio);
CREATE INDEX idx_VPrezzo ON Veicolo (Prezzo);

CREATE TABLE Veicolo_immatricolato (
	Telaio VARCHAR(17) PRIMARY KEY,
	Targa VARCHAR(10) NOT NULL,
	KM INT DEFAULT 0 NOT NULL,
	FOREIGN KEY (Telaio) REFERENCES Veicolo (Telaio) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Optional (
	Codice VARCHAR(15) PRIMARY KEY,
	Categoria VARCHAR(50) NOT NULL,
	Fornitore VARCHAR(50) NOT NULL
);

CREATE TABLE Optional_base (
	Modello VARCHAR(30),
	Optional VARCHAR(15),
	PRIMARY KEY(Modello, Optional),
	FOREIGN KEY (Modello) REFERENCES Modello(Nome) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Optional) REFERENCES Optional(Codice) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Optional_Aggiuntivi (
	Veicolo VARCHAR (17),
	Optional VARCHAR (15),
	Prezzo DOUBLE PRECISION NOT NULL,
	PRIMARY KEY (Veicolo, Optional),
	FOREIGN KEY (Veicolo) REFERENCES Veicolo(Telaio) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Optional) REFERENCES Optional(Codice) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Intervento (
	ID VARCHAR PRIMARY KEY,
	Veicolo VARCHAR (17) NOT NULL,
	Officina VARCHAR NOT NULL,
	FOREIGN KEY (Veicolo) REFERENCES Veicolo(Telaio) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Officina) REFERENCES Sede(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Fattura (
	Numero VARCHAR PRIMARY KEY,
	Intervento VARCHAR NOT NULL,
	Netto FLOAT NOT NULL,
	Iva INT NOT NULL,
	Data DATE NOT NULL,
	FOREIGN KEY (Intervento) REFERENCES Intervento (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Intervento_Dipendente (
    ID VARCHAR,
    CF VARCHAR(16),
    Ore_Impiegate DOUBLE PRECISION NOT NULL,
    PRIMARY KEY (ID, CF),
    FOREIGN KEY (ID) REFERENCES Intervento (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (CF) REFERENCES DIPENDENTE (CF) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Vendita (
	Veicolo VARCHAR (17),
	Concessionario VARCHAR,
	Acquirente VARCHAR (16),
	Data DATE,
	PRIMARY KEY (Veicolo, Concessionario, Acquirente, Data),
    FOREIGN KEY (Veicolo) REFERENCES Veicolo(Telaio) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Acquirente) REFERENCES Acquirente(CF) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Concessionario) REFERENCES Sede(ID) ON DELETE CASCADE ON UPDATE CASCADE
);