CREATE TABLE Acquirente (
	CF VARCHAR(16) PRIMARY KEY,
	Nome VARCHAR(30) NOT NULL,
	Nazione VARCHAR(30) NOT NULL,
	Città VARCHAR(50) NOT NULL,
	Via VARCHAR(50) NOT NULL,
	Civico VARCHAR(8) NOT NULL
);
CREATE TABLE Persona (
	CF VARCHAR(16) PRIMARY KEY,
	Cognome VARCHAR(30) NOT NULL,
	FOREIGN KEY (CF) REFERENCES Acquirente (CF)
);
CREATE TABLE Azienda (
    CF VARCHAR(16) PRIMARY KEY, 
	PIVA VARCHAR(11) NOT NULL,
	FOREIGN KEY (CF) REFERENCES Acquirente(CF)
);
CREATE TYPE MANSIONE AS ENUM ('Impiegato', 'Meccanico', 'Dirigente');
CREATE TABLE Dipendente (
	CF VARCHAR(16) PRIMARY KEY,
	Nome VARCHAR(30) NOT NULL,
	Cognome VARCHAR(30) NOT NULL,
	Mansione MANSIONE NOT NULL,
	Nazione VARCHAR(30) NOT NULL,
	Città VARCHAR(50) NOT NULL,
	Via VARCHAR(50) NOT NULL,
	Civico VARCHAR(8) NOT NULL
);
CREATE TYPE TIPO_SEDE AS ENUM ('Officina', 'Concessionario');
CREATE TABLE Sede (
	ID VARCHAR PRIMARY KEY,
	Tipo TIPO_SEDE,
	Nazione VARCHAR(30) NOT NULL,
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
	FOREIGN KEY (Dipendente) REFERENCES Dipendente(CF),
	FOREIGN KEY (Contratto) REFERENCES Contratto(ID)
);
CREATE TABLE Impiego_Passato (
	Dipendente VARCHAR(16),
	Inizio DATE,
	Fine DATE NOT NULL,
	Contratto VARCHAR NOT NULL,
	Sede VARCHAR NOT NULL,
	PRIMARY KEY(Dipendente, Inizio),
	FOREIGN KEY (Contratto) REFERENCES Contratto(ID),
	FOREIGN KEY (Sede) REFERENCES Sede(ID)
);
CREATE TABLE Modello (
	Nome VARCHAR(30) PRIMARY KEY,
	Costruttore VARCHAR(20) NOT NULL,
	Descrizione VARCHAR(50)
);
CREATE TABLE Veicolo  (
	Telaio VARCHAR(17) PRIMARY KEY,
	Prezzo DOUBLE PRECISION NOT NULL,
	Anno DATE NOT NULL,
    Modello VARCHAR(30) NOT NULL,
    FOREIGN KEY (Modello) REFERENCES Modello(Nome)
);
CREATE TABLE Veicolo_immatricolato (
	Telaio VARCHAR(17) PRIMARY KEY,
	Targa VARCHAR(10) NOT NULL,
	KM INT DEFAULT 0 NOT NULL,
	FOREIGN KEY (Telaio) REFERENCES Veicolo (Telaio)
);
CREATE TABLE Optional (
	Nome VARCHAR(30) PRIMARY KEY,
	Prezzo INT NOT NULL,
	Categoria VARCHAR(20),
	Fornitore VARCHAR(20) NOT NULL
);
CREATE TABLE Optional_base (
	Modello VARCHAR(30),
	Optional VARCHAR(30),
	PRIMARY KEY(Modello, Optional),
	FOREIGN KEY (Modello) REFERENCES Modello(Nome),
	FOREIGN KEY (Optional) REFERENCES Optional(Nome)
);
CREATE TABLE Optional_Aggiuntivi (
	Veicolo VARCHAR (17),
	Optional VARCHAR (30),
	Prezzo DOUBLE PRECISION NOT NULL,
	PRIMARY KEY (Veicolo, Optional),
	FOREIGN KEY (Veicolo) REFERENCES Veicolo(Telaio),
	FOREIGN KEY (Optional) REFERENCES Optional(Nome)
);
CREATE TABLE Intervento (
	ID VARCHAR PRIMARY KEY,
	Veicolo VARCHAR (17) NOT NULL,
	Officina VARCHAR NOT NULL,
	FOREIGN KEY (Veicolo) REFERENCES Veicolo(Telaio),
	FOREIGN KEY (Officina) REFERENCES Sede(ID)
);
CREATE TABLE Fattura (
	Numero VARCHAR PRIMARY KEY,
	Intervento VARCHAR NOT NULL,
	Netto FLOAT NOT NULL,
	Iva INT NOT NULL,
	Data DATE NOT NULL,
	FOREIGN KEY (Intervento) REFERENCES Intervento (ID)
);
CREATE TABLE Intervento_Dipendente (
    ID VARCHAR,
    CF VARCHAR(16),
    Ore_Impiegate DOUBLE PRECISION NOT NULL,
    PRIMARY KEY (ID, CF),
    FOREIGN KEY (ID) REFERENCES Intervento (ID),
    FOREIGN KEY (CF) REFERENCES DIPENDENTE (CF)
);
CREATE TABLE Vendita (
	Veicolo VARCHAR (17),
	Concessionario VARCHAR,
	Acquirente VARCHAR (16),
	Data DATE,
	PRIMARY KEY (Veicolo, Concessionario, Acquirente, Data),
    FOREIGN KEY (Veicolo) REFERENCES Veicolo(Telaio),
    FOREIGN KEY (Acquirente) REFERENCES Acquirente(CF),
    FOREIGN KEY (Concessionario) REFERENCES Sede(ID)
);
