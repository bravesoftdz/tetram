CREATE TABLE EDITEURS (
    ID_EDITEUR          char(38) not null,
    INITIALENOMEDITEUR  char(1) character set utf8 NOT NULL,
    DC_EDITEURS         timestamp not null,
    DM_EDITEURS         timestamp not null,
    NOMEDITEUR          varchar(50) character set utf8,
    SITEWEB             VARCHAR(255)
);
