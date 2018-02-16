CREATE DATABASE mydb;


CREATE TABLE ekas (
  id SERIAL PRIMARY KEY,
  nosaukums VARCHAR(45) NOT NULL,
  adrese VARCHAR(45) NOT NULL,
  kontakpersona VARCHAR(45) NULL,
  kontakttelefons VARCHAR(13) NULL);

CREATE TABLE telpas (
  id SERIAL PRIMARY KEY,
  nosaukums VARCHAR(20) NOT NULL,
  stavs INT NULL,
  ekas_id INT NOT NULL REFERENCES ekas (id) ON DELETE NO ACTION ON UPDATE CASCADE);

CREATE TABLE dalibnieki (
  id SERIAL PRIMARY KEY,
  vards VARCHAR(20) NOT NULL,
  uzvards VARCHAR(25) NOT NULL,
  pers_kods VARCHAR(12) NOT NULL Unique,
  epasts VARCHAR(30) NULL,
  nodarbosanas VARCHAR(45) NULL);

CREATE TABLE konferences (
  id SERIAL PRIMARY KEY,
  nosaukums TEXT NOT NULL,
  laiks TIMESTAMP,
  tema VARCHAR(45) NULL,
  organizators VARCHAR(45) NULL,
  telpas_id INT NOT NULL REFERENCES telpas (id) ON DELETE SET NULL ON UPDATE CASCADE,
  registr_dalibn_sk INT NULL,
  lekciju_sk INT NULL);

CREATE TABLE registr_konferencei (
  id SERIAL PRIMARY KEY,
  reg_laiks TIMESTAMP NOT NULL default CURRENT_DATE,
  dalibnieka_id INT NOT NULL REFERENCES dalibnieki (id) ON DELETE NO ACTION ON UPDATE CASCADE,
  konferences_id INT NOT NULL REFERENCES konferences (id) ON DELETE CASCADE ON UPDATE CASCADE,
 CONSTRAINT registr_uniq UNIQUE (dalibnieka_id, konferences_id));

CREATE TABLE lektori (
  id SERIAL PRIMARY KEY,
  vards VARCHAR(20) NOT NULL,
  uzvards VARCHAR(25) NOT NULL,
  tituls VARCHAR(10) NULL,
  darbibas_joma VARCHAR(45) NULL);

CREATE TABLE lekcijas (
  id SERIAL PRIMARY KEY,
  nosaukums VARCHAR(45) NOT NULL,
  atslegvardi TEXT NULL,
  anotacija TEXT NULL,
  lektora_id INT NOT NULL REFERENCES lektori (id) ON DELETE SET NULL ON UPDATE CASCADE,
  konferences_id INT NOT NULL REFERENCES konferences (id) ON DELETE SET NULL ON UPDATE CASCADE);

CREATE TABLE lektoru_kontaktinfo (
  id SERIAL PRIMARY KEY,
  lektora_id INT NOT NULL Unique REFERENCES lektori (id) ON DELETE CASCADE ON UPDATE CASCADE,
  epasts VARCHAR(25) NULL,
  telefons VARCHAR(13) NOT NULL);

INSERT INTO dalibnieki (vards, uzvards, pers_kods, epasts, nodarbosanas) VALUES ('Juris','Kļaviņš','111176-35345', 'jklavins@inbox.lv', 'students');
INSERT INTO dalibnieki (vards, uzvards, pers_kods, epasts, nodarbosanas) VALUES ('Ilze','Rozīte','121280-87654', 'irozite@gmail.com.lv', 'arhitekts');
INSERT INTO dalibnieki (vards, uzvards, pers_kods) VALUES ('Roberts','Bērziņš','020291-11654');
INSERT INTO ekas (nosaukums, adrese, kontakpersona, kontakttelefons) VALUES ('LU galvenā ēka','Rīgas iela 1, Rīga','Maija Skujiņa', '23456789');
INSERT INTO ekas (nosaukums, adrese, kontakpersona, kontakttelefons) VALUES ('LU Dabaszinātņu fakultāte','Ogres iela 15, Rīga','Aija', '+37123996789');
INSERT INTO ekas (nosaukums, adrese) VALUES ('RTU','Ķīpsalas iela 3, Rīga');
INSERT INTO telpas (nosaukums, stavs, ekas_id) VALUES ('201',3, 1);
INSERT INTO telpas (nosaukums, stavs, ekas_id) VALUES ('Lielā aula',2, 1);
INSERT INTO telpas (nosaukums, stavs, ekas_id) VALUES ('T101',1, 3);
INSERT INTO konferences (nosaukums, laiks, tema, organizators, telpas_id) VALUES ('Arhitektūra kā Skandināvijas kultūras resurss','2024-10-19 10:15:00', 'ārzemju arhitektūra', 'Arhitektu savienība', 3);
INSERT INTO konferences (nosaukums, laiks, tema, organizators, telpas_id) VALUES ('Koka arhitektūras konference','2020-12-01 18:00:00', 'materiāli arhitektūrā', 'WoodAbc', 1);
INSERT INTO konferences (nosaukums, tema, telpas_id) VALUES ('Maskavas forštates arhitektūras kultūras mantojums', 'kultūras mantojums', 2);
INSERT INTO registr_konferencei (dalibnieka_id, konferences_id) VALUES (2, 2);
INSERT INTO registr_konferencei (dalibnieka_id, konferences_id) VALUES (2, 1);
INSERT INTO registr_konferencei (dalibnieka_id, konferences_id) VALUES (3, 1);
INSERT INTO lektori (vards, uzvards, tituls, darbibas_joma) VALUES ('Imants','Arājs', 'asoc.prof.', 'vēsturnieks');
INSERT INTO lektori (vards, uzvards, darbibas_joma) VALUES ('Daiga','Zemniece', 'arhitekte');
INSERT INTO lektori (vards, uzvards) VALUES ('Jānis','Bērziņš');
INSERT INTO lektoru_kontaktinfo (lektora_id, epasts, telefons) VALUES (2, 'daigaz@gmail.com','0037122665544');
INSERT INTO lektoru_kontaktinfo (lektora_id, telefons) VALUES (1, '26754389');
INSERT INTO lekcijas (nosaukums, atslegvardi, anotacija, lektora_id, konferences_id) VALUES ('Maskavas forštates vēsture', 'maskavas forštate, kultūras mantojums', 'Īss ieskats galvenajos Maskavas forštates vēsturiskajos notikumos', 2, 3);
INSERT INTO lekcijas (nosaukums, atslegvardi, lektora_id, konferences_id) VALUES ('Koks kā fasādes materiāls', 'koks, fasādes materiāli', 3, 2);
INSERT INTO lekcijas (nosaukums, atslegvardi, lektora_id, konferences_id) VALUES ('Koks vēsturiskajās ēkās', 'koks, vēsturiskās ēkas', 1, 2);

CREATE USER lietotajs PASSWORD 'konferences';
CREATE USER registrators PASSWORD 'registrkonf12';
CREATE USER admin PASSWORD 'konf12*adm';
GRANT SELECT ON TABLE konferences, lekcijas, lektori, telpas, ekas TO lietotajs;
GRANT SELECT ON TABLE dalibnieki, ekas, konferences, lekcijas, lektori, lektoru_kontaktinfo, registr_konferencei, telpas TO registrators;
GRANT INSERT, DELETE ON TABLE registr_konferencei TO registrators;
GRANT INSERT ON TABLE dalibnieki TO registrators;
GRANT ALL ON TABLE dalibnieki, ekas, konferences, lekcijas, lektori, lektoru_kontaktinfo, registr_konferencei, telpas TO admin;

CREATE INDEX name_surname ON dalibnieki (vards,uzvards);
CREATE INDEX konf_nos ON konferences (nosaukums);
CREATE INDEX lekc_nos ON lekcijas (nosaukums);
CREATE INDEX atslegv ON lekcijas (atslegvardi);
CREATE INDEX lekt_uzv ON lektori (uzvards);
CREATE INDEX ekas_adr ON ekas (adrese);

CREATE or replace FUNCTION "registr_insert"() RETURNS "opaque" AS '
DECLARE
v_laiks timestamp;
v_liet varchar;
BEGIN
v_laiks := now();
v_liet := current_user;
RAISE NOTICE ''Laiks - %'', v_laiks;
RAISE NOTICE ''Lietotajs - %'', v_liet;
RAISE NOTICE ''Operacija -%'', TG_OP;
RAISE NOTICE '' Dalibnieka_id - %'', new.dalibnieka_id;
RAISE NOTICE '' Konferences_id - %'', new.konferences_id;
RETURN NEW;
END;
' LANGUAGE 'plpgsql';

CREATE TRIGGER "tr_registr_insert"
AFTER INSERT ON "registr_konferencei"
FOR EACH ROW EXECUTE PROCEDURE registr_insert();


CREATE or replace FUNCTION "lekciju_sk"() RETURNS "opaque" AS '
DECLARE
x RECORD;
lekciju_skaits int;
konf_id int;
BEGIN
FOR x IN SELECT * FROM konferences LOOP
konf_id:=x.id;
lekciju_skaits:= count(*) FROM lekcijas WHERE lekcijas.konferences_id=konf_id;
UPDATE konferences SET lekciju_sk=lekciju_skaits WHERE konferences.id=konf_id;
END LOOP;
RETURN NEW;
END;
' LANGUAGE 'plpgsql';

CREATE TRIGGER "tr_lekciju_sk"
AFTER INSERT OR UPDATE OR DELETE ON "lekcijas"
FOR EACH ROW EXECUTE PROCEDURE lekciju_sk();


CREATE or replace FUNCTION "dalibnieku_sk"() RETURNS "opaque" AS '
DECLARE
x RECORD;
dalibnieku_skaits int;
konf_id int;
BEGIN
FOR x IN SELECT * FROM konferences LOOP
konf_id:=x.id;
dalibnieku_skaits:= count(*) FROM registr_konferencei WHERE registr_konferencei.konferences_id=konf_id;
UPDATE konferences SET registr_dalibn_sk=dalibnieku_skaits WHERE konferences.id=konf_id;
END LOOP;
RETURN NEW;
END;
' LANGUAGE 'plpgsql';

CREATE TRIGGER "tr_dalibnieku_sk"
AFTER INSERT OR UPDATE OR DELETE ON "registr_konferencei"
FOR EACH ROW EXECUTE PROCEDURE dalibnieku_sk();
