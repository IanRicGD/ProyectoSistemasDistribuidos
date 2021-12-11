create database ProyectoDistribuidos
go
use ProyectoDistribuidos
go

CREATE TABLE AEROPUERTO
( 
	codigoAeropuerto     int  identity (1,1) NOT NULL ,
	nombre               varchar(50)  NOT NULL ,
	localidad            varchar(50)  NOT NULL ,
	pais                 varchar(50)  NOT NULL 
)
go



ALTER TABLE AEROPUERTO
	ADD CONSTRAINT XPKAEROPUERTO PRIMARY KEY  CLUSTERED (codigoAeropuerto ASC)
go



CREATE TABLE ASIENTO
( 
	numero_D             int  identity (1,1) NOT NULL ,
	fila                 int  NOT NULL ,
	columna              char  NOT NULL ,
	codigoAvion          int  NOT NULL ,
	ocupado				 bit NOT NULL
)
go


ALTER TABLE ASIENTO
	ADD CONSTRAINT XPKASIENTO PRIMARY KEY  CLUSTERED (numero_D ASC,codigoAvion ASC)
go



CREATE TABLE AVION
( 
	modelo               varchar(20)  NOT NULL ,
	numPlazas            int  NOT NULL ,
	codigoAvion          int  identity (1,1) NOT NULL ,
)
go



ALTER TABLE AVION
	ADD CONSTRAINT XPKAVION PRIMARY KEY  CLUSTERED (codigoAvion ASC)
go




CREATE TABLE CLIENTE
( 
	nombreUsuario		 varchar (20) NOT NULL,
	contraseña			 nvarchar(100) NOT NULL,
	curp                 char(18)  NOT NULL ,
	nom                  varchar(50)  NOT NULL ,
	apPaterno            varchar(50)  NOT NULL ,
	apMaterno            varchar(50)  NULL ,
	telefono             varchar(50)  NULL 
)
go



ALTER TABLE CLIENTE
	ADD CONSTRAINT XPKCLIENTE PRIMARY KEY  CLUSTERED (nombreUsuario ASC),
	CONSTRAINT uq_curpCliente UNIQUE (curp),
	CONSTRAINT ch_curp CHECK (len(curp)=18),
	CONSTRAINT uq_nombreUduario UNIQUE (nombreUsuario),
	CONSTRAINT ch_nombreUsuario  CHECK ((len(nombreUsuario)) between 6 and 20),
	CONSTRAINT ch_contraseña  CHECK ((len(contraseña)) between 8 and 20)
go




CREATE TABLE PASE
( 
	ID                   int  identity (1,1) NOT NULL ,
	hora				 time  NOT NULL ,
	fecha                date  NOT NULL ,
	origen				 varchar(20) NOT NULL,
    destino				 varchar(20) NOT NULL,
	numero_D             int  NOT NULL ,
	codigoAvion          int  NOT NULL ,
	numReserva_D         int  NOT NULL ,
	nombreUsuario        varchar(20)  NOT NULL,
	numPase_D			 int NULL,
	codigoUnico_D		 int NOT NULL  
)
go



ALTER TABLE PASE
	ADD CONSTRAINT XPKPASE PRIMARY KEY  CLUSTERED (ID ASC)
go



ALTER TABLE PASE
	ADD CONSTRAINT XAK1PASE UNIQUE (numReserva_D  ASC,numero_D  ASC,codigoAvion  ASC,nombreUsuario  ASC,numPase_D  ASC)
go



CREATE TABLE RESERVACION
( 
	numReserva_D        int  identity (1,1) NOT NULL ,
	fecha                date  NOT NULL ,
	hora                 time  NOT NULL ,
	tarjeta              varchar(20)  NOT NULL ,
	nombreUsuario        varchar(20)  NOT NULL
)
go



ALTER TABLE RESERVACION
	ADD CONSTRAINT XPKRESERVACION PRIMARY KEY  CLUSTERED (numReserva_D ASC,nombreUsuario ASC)
go



CREATE TABLE VUELO
( 
	codigoUnico_D      int  identity (1,1) NOT NULL ,
	horaLlegada          time  NOT NULL ,
	horaSalida           time  NOT NULL ,
	fechaLlegada		 date NOT NULL,
	fechaSalida			 date NOT NULL,
	codigoAeropuertoLlegada     int  NOT NULL ,
	codigoAeropuertoSalida     int  NOT NULL ,
	codigoAvion          int  NOT NULL, 
	finalizado			 bit NOT NULL
)
go



ALTER TABLE VUELO
	ADD CONSTRAINT XPKVUELO PRIMARY KEY  CLUSTERED (codigoUnico_D ASC,codigoAvion ASC)
go




ALTER TABLE ASIENTO
	ADD CONSTRAINT R_11 FOREIGN KEY (codigoAvion) REFERENCES AVION(codigoAvion)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE PASE
	ADD CONSTRAINT R_13 FOREIGN KEY (numero_D,codigoAvion) REFERENCES ASIENTO(numero_D,codigoAvion)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE PASE
	ADD CONSTRAINT R_15 FOREIGN KEY (numReserva_D,nombreUsuario) REFERENCES RESERVACION(numReserva_D,nombreUsuario)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE PASE
	ADD CONSTRAINT R_17 FOREIGN KEY (codigoUnico_D,codigoAvion) REFERENCES VUELO(codigoUnico_D,codigoAvion)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE RESERVACION
	ADD CONSTRAINT R_9 FOREIGN KEY (nombreUsuario) REFERENCES CLIENTE(nombreUsuario)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE VUELO
	ADD CONSTRAINT R_6 FOREIGN KEY (codigoAeropuertoLlegada) REFERENCES AEROPUERTO(codigoAeropuerto)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT R_7 FOREIGN KEY (codigoAeropuertoSalida) REFERENCES AEROPUERTO(codigoAeropuerto)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE VUELO
	ADD CONSTRAINT R_8 FOREIGN KEY (codigoAvion) REFERENCES AVION(codigoAvion)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




CREATE TRIGGER tD_AEROPUERTO ON AEROPUERTO FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on AEROPUERTO */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* AEROPUERTO  VUELO on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0001d0af", PARENT_OWNER="", PARENT_TABLE="AEROPUERTO"
    CHILD_OWNER="", CHILD_TABLE="VUELO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="codigoAeropuerto" */
    IF EXISTS (
      SELECT * FROM deleted,VUELO
      WHERE
        /*  %JoinFKPK(VUELO,deleted," = "," AND") */
        VUELO.codigoAeropuertoLlegada = deleted.codigoAeropuerto
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete AEROPUERTO because VUELO exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* AEROPUERTO  VUELO on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="AEROPUERTO"
    CHILD_OWNER="", CHILD_TABLE="VUELO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="codigoAeropuerto" */
    IF EXISTS (
      SELECT * FROM deleted,VUELO
      WHERE
        /*  %JoinFKPK(VUELO,deleted," = "," AND") */
        VUELO.codigoAeropuertoSalida = deleted.codigoAeropuerto
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete AEROPUERTO because VUELO exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror (@errno, @errmsg,1)
    rollback transaction
END

go


CREATE TRIGGER tU_AEROPUERTO ON AEROPUERTO FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on AEROPUERTO */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @inscodigoAeropuerto char(18),
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* AEROPUERTO  VUELO on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00020cef", PARENT_OWNER="", PARENT_TABLE="AEROPUERTO"
    CHILD_OWNER="", CHILD_TABLE="VUELO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="codigoAeropuerto" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(codigoAeropuerto)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,VUELO
      WHERE
        /*  %JoinFKPK(VUELO,deleted," = "," AND") */
        VUELO.codigoAeropuertoLlegada = deleted.codigoAeropuerto
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update AEROPUERTO because VUELO exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* AEROPUERTO  VUELO on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="AEROPUERTO"
    CHILD_OWNER="", CHILD_TABLE="VUELO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="codigoAeropuerto" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(codigoAeropuerto)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,VUELO
      WHERE
        /*  %JoinFKPK(VUELO,deleted," = "," AND") */
        VUELO.codigoAeropuertoSalida = deleted.codigoAeropuerto
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update AEROPUERTO because VUELO exists.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror (@errno, @errmsg,1)
    rollback transaction
END

go




CREATE TRIGGER tD_ASIENTO ON ASIENTO FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on ASIENTO */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* ASIENTO  PASE on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00021868", PARENT_OWNER="", PARENT_TABLE="ASIENTO"
    CHILD_OWNER="", CHILD_TABLE="PASE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="numero_D""codigoAvion" */
    IF EXISTS (
      SELECT * FROM deleted,PASE
      WHERE
        /*  %JoinFKPK(PASE,deleted," = "," AND") */
        PASE.numero_D = deleted.numero_D AND
        PASE.codigoAvion = deleted.codigoAvion
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete ASIENTO because PASE exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* AVION  ASIENTO on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="AVION"
    CHILD_OWNER="", CHILD_TABLE="ASIENTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="codigoAvion" */
    IF EXISTS (SELECT * FROM deleted,AVION
      WHERE
        /* %JoinFKPK(deleted,AVION," = "," AND") */
        deleted.codigoAvion = AVION.codigoAvion AND
        NOT EXISTS (
          SELECT * FROM ASIENTO
          WHERE
            /* %JoinFKPK(ASIENTO,AVION," = "," AND") */
            ASIENTO.codigoAvion = AVION.codigoAvion
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ASIENTO because AVION exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror (@errno, @errmsg,1)
    rollback transaction
END

go


CREATE TRIGGER tU_ASIENTO ON ASIENTO FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on ASIENTO */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insnumero_D char(18), 
           @inscodigoAvion char(18),
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* ASIENTO  PASE on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="000259ab", PARENT_OWNER="", PARENT_TABLE="ASIENTO"
    CHILD_OWNER="", CHILD_TABLE="PASE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="numero_D""codigoAvion" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(numero_D) OR
    UPDATE(codigoAvion)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,PASE
      WHERE
        /*  %JoinFKPK(PASE,deleted," = "," AND") */
        PASE.numero_D = deleted.numero_D AND
        PASE.codigoAvion = deleted.codigoAvion
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update ASIENTO because PASE exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* AVION  ASIENTO on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="AVION"
    CHILD_OWNER="", CHILD_TABLE="ASIENTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="codigoAvion" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(codigoAvion)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,AVION
        WHERE
          /* %JoinFKPK(inserted,AVION) */
          inserted.codigoAvion = AVION.codigoAvion
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ASIENTO because AVION does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror (@errno, @errmsg,1)
    rollback transaction
END

go




CREATE TRIGGER tD_AVION ON AVION FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on AVION */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* AVION  VUELO on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0001d6c5", PARENT_OWNER="", PARENT_TABLE="AVION"
    CHILD_OWNER="", CHILD_TABLE="VUELO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="codigoAvion" */
    IF EXISTS (
      SELECT * FROM deleted,VUELO
      WHERE
        /*  %JoinFKPK(VUELO,deleted," = "," AND") */
        VUELO.codigoAvion = deleted.codigoAvion
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete AVION because VUELO exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* AVION  ASIENTO on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="AVION"
    CHILD_OWNER="", CHILD_TABLE="ASIENTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="codigoAvion" */
    IF EXISTS (
      SELECT * FROM deleted,ASIENTO
      WHERE
        /*  %JoinFKPK(ASIENTO,deleted," = "," AND") */
        ASIENTO.codigoAvion = deleted.codigoAvion
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete AVION because ASIENTO exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror (@errno, @errmsg,1)
    rollback transaction
END

go


CREATE TRIGGER tU_AVION ON AVION FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on AVION */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @inscodigoAvion char(18),
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* AVION  VUELO on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0001f20a", PARENT_OWNER="", PARENT_TABLE="AVION"
    CHILD_OWNER="", CHILD_TABLE="VUELO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="codigoAvion" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(codigoAvion)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,VUELO
      WHERE
        /*  %JoinFKPK(VUELO,deleted," = "," AND") */
        VUELO.codigoAvion = deleted.codigoAvion
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update AVION because VUELO exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* AVION  ASIENTO on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="AVION"
    CHILD_OWNER="", CHILD_TABLE="ASIENTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="codigoAvion" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(codigoAvion)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ASIENTO
      WHERE
        /*  %JoinFKPK(ASIENTO,deleted," = "," AND") */
        ASIENTO.codigoAvion = deleted.codigoAvion
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update AVION because ASIENTO exists.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror (@errno, @errmsg,1)
    rollback transaction
END

go




CREATE TRIGGER tD_CLIENTE ON CLIENTE FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on CLIENTE */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* CLIENTE  RESERVACION on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0000f152", PARENT_OWNER="", PARENT_TABLE="CLIENTE"
    CHILD_OWNER="", CHILD_TABLE="RESERVACION"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="nombreUsuario" */
    IF EXISTS (
      SELECT * FROM deleted,RESERVACION
      WHERE
        /*  %JoinFKPK(RESERVACION,deleted," = "," AND") */
        RESERVACION.nombreUsuario = deleted.nombreUsuario
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete CLIENTE because RESERVACION exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror (@errno, @errmsg,1)
    rollback transaction
END

go


CREATE TRIGGER tU_CLIENTE ON CLIENTE FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on CLIENTE */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insnombreUsuario char(18),
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* CLIENTE  RESERVACION on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00010d69", PARENT_OWNER="", PARENT_TABLE="CLIENTE"
    CHILD_OWNER="", CHILD_TABLE="RESERVACION"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="nombreUsuario" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(nombreUsuario)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,RESERVACION
      WHERE
        /*  %JoinFKPK(RESERVACION,deleted," = "," AND") */
        RESERVACION.nombreUsuario = deleted.nombreUsuario
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update CLIENTE because RESERVACION exists.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror (@errno, @errmsg,1)
    rollback transaction
END

go




CREATE TRIGGER tD_PASE ON PASE FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on PASE */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* ASIENTO  PASE on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0003e5b2", PARENT_OWNER="", PARENT_TABLE="ASIENTO"
    CHILD_OWNER="", CHILD_TABLE="PASE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="numero_D""codigoAvion" */
    IF EXISTS (SELECT * FROM deleted,ASIENTO
      WHERE
        /* %JoinFKPK(deleted,ASIENTO," = "," AND") */
        deleted.numero_D = ASIENTO.numero_D AND
        deleted.codigoAvion = ASIENTO.codigoAvion AND
        NOT EXISTS (
          SELECT * FROM PASE
          WHERE
            /* %JoinFKPK(PASE,ASIENTO," = "," AND") */
            PASE.numero_D = ASIENTO.numero_D AND
            PASE.codigoAvion = ASIENTO.codigoAvion
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last PASE because ASIENTO exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* RESERVACION  PASE on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RESERVACION"
    CHILD_OWNER="", CHILD_TABLE="PASE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="numReserva_D""nombreUsuario" */
    IF EXISTS (SELECT * FROM deleted,RESERVACION
      WHERE
        /* %JoinFKPK(deleted,RESERVACION," = "," AND") */
        deleted.numReserva_D = RESERVACION.numReserva_D AND
        deleted.nombreUsuario = RESERVACION.nombreUsuario AND
        NOT EXISTS (
          SELECT * FROM PASE
          WHERE
            /* %JoinFKPK(PASE,RESERVACION," = "," AND") */
            PASE.numReserva_D = RESERVACION.numReserva_D AND
            PASE.nombreUsuario = RESERVACION.nombreUsuario
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last PASE because RESERVACION exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* VUELO  PASE on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="VUELO"
    CHILD_OWNER="", CHILD_TABLE="PASE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="codigoUnico_D""codigoAvion" */
    IF EXISTS (SELECT * FROM deleted,VUELO
      WHERE
        /* %JoinFKPK(deleted,VUELO," = "," AND") */
        deleted.codigoUnico_D = VUELO.codigoUnico_D AND
        deleted.codigoAvion = VUELO.codigoAvion AND
        NOT EXISTS (
          SELECT * FROM PASE
          WHERE
            /* %JoinFKPK(PASE,VUELO," = "," AND") */
            PASE.codigoUnico_D = VUELO.codigoUnico_D AND
            PASE.codigoAvion = VUELO.codigoAvion
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last PASE because VUELO exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror (@errno, @errmsg,1)
    rollback transaction
END

go

CREATE TRIGGER tU_PASE ON PASE FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on PASE */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insID char(18),
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* ASIENTO  PASE on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0004bf90", PARENT_OWNER="", PARENT_TABLE="ASIENTO"
    CHILD_OWNER="", CHILD_TABLE="PASE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="numero_D""codigoAvion" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(numero_D) OR
    UPDATE(codigoAvion)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,ASIENTO
        WHERE
          /* %JoinFKPK(inserted,ASIENTO) */
          inserted.numero_D = ASIENTO.numero_D and
          inserted.codigoAvion = ASIENTO.codigoAvion
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.numero_D IS NULL AND
      inserted.codigoAvion IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update PASE because ASIENTO does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* RESERVACION  PASE on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RESERVACION"
    CHILD_OWNER="", CHILD_TABLE="PASE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="numReserva_D""nombreUsuario" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(numReserva_D) OR
    UPDATE(nombreUsuario)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,RESERVACION
        WHERE
          /* %JoinFKPK(inserted,RESERVACION) */
          inserted.numReserva_D = RESERVACION.numReserva_D and
          inserted.nombreUsuario = RESERVACION.nombreUsuario
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.numReserva_D IS NULL AND
      inserted.nombreUsuario IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update PASE because RESERVACION does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* VUELO  PASE on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="VUELO"
    CHILD_OWNER="", CHILD_TABLE="PASE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="codigoUnico_D""codigoAvion" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(codigoUnico_D) OR
    UPDATE(codigoAvion)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,VUELO
        WHERE
          /* %JoinFKPK(inserted,VUELO) */
          inserted.codigoUnico_D = VUELO.codigoUnico_D and
          inserted.codigoAvion = VUELO.codigoAvion
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.codigoUnico_D IS NULL AND
      inserted.codigoAvion IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update PASE because VUELO does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror (@errno, @errmsg,1)
    rollback transaction
END

go



CREATE TRIGGER tD_RESERVACION ON RESERVACION FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on RESERVACION */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* RESERVACION  PASE on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002171e", PARENT_OWNER="", PARENT_TABLE="RESERVACION"
    CHILD_OWNER="", CHILD_TABLE="PASE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="numReserva_D""nombreUsuario" */
    IF EXISTS (
      SELECT * FROM deleted,PASE
      WHERE
        /*  %JoinFKPK(PASE,deleted," = "," AND") */
        PASE.numReserva_D = deleted.numReserva_D AND
        PASE.nombreUsuario = deleted.nombreUsuario
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete RESERVACION because PASE exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* CLIENTE  RESERVACION on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CLIENTE"
    CHILD_OWNER="", CHILD_TABLE="RESERVACION"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="nombreUsuario" */
    IF EXISTS (SELECT * FROM deleted,CLIENTE
      WHERE
        /* %JoinFKPK(deleted,CLIENTE," = "," AND") */
        deleted.nombreUsuario = CLIENTE.nombreUsuario AND
        NOT EXISTS (
          SELECT * FROM RESERVACION
          WHERE
            /* %JoinFKPK(RESERVACION,CLIENTE," = "," AND") */
            RESERVACION.nombreUsuario = CLIENTE.nombreUsuario
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last RESERVACION because CLIENTE exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror (@errno, @errmsg,1)
    rollback transaction
END

go


CREATE TRIGGER tU_RESERVACION ON RESERVACION FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on RESERVACION */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insnumReserva_D char(18), 
           @insnombreUsuario char(18),
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* RESERVACION  PASE on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00024848", PARENT_OWNER="", PARENT_TABLE="RESERVACION"
    CHILD_OWNER="", CHILD_TABLE="PASE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="numReserva_D""nombreUsuario" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(numReserva_D) OR
    UPDATE(nombreUsuario)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,PASE
      WHERE
        /*  %JoinFKPK(PASE,deleted," = "," AND") */
        PASE.numReserva_D = deleted.numReserva_D AND
        PASE.nombreUsuario = deleted.nombreUsuario
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update RESERVACION because PASE exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* CLIENTE  RESERVACION on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CLIENTE"
    CHILD_OWNER="", CHILD_TABLE="RESERVACION"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="nombreUsuario" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(nombreUsuario)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,CLIENTE
        WHERE
          /* %JoinFKPK(inserted,CLIENTE) */
          inserted.nombreUsuario = CLIENTE.nombreUsuario
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update RESERVACION because CLIENTE does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror (@errno, @errmsg,1)
    rollback transaction
END

go





CREATE TRIGGER tD_VUELO ON VUELO FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on VUELO */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* VUELO  PASE on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00048a66", PARENT_OWNER="", PARENT_TABLE="VUELO"
    CHILD_OWNER="", CHILD_TABLE="PASE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="codigoUnico_D""codigoAvion" */
    IF EXISTS (
      SELECT * FROM deleted,PASE
      WHERE
        /*  %JoinFKPK(PASE,deleted," = "," AND") */
        PASE.codigoUnico_D = deleted.codigoUnico_D AND
        PASE.codigoAvion = deleted.codigoAvion
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete VUELO because PASE exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* AEROPUERTO  VUELO on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="AEROPUERTO"
    CHILD_OWNER="", CHILD_TABLE="VUELO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="codigoAeropuerto" */
    IF EXISTS (SELECT * FROM deleted,AEROPUERTO
      WHERE
        /* %JoinFKPK(deleted,AEROPUERTO," = "," AND") */
        deleted.codigoAeropuertoLlegada = AEROPUERTO.codigoAeropuerto AND
        NOT EXISTS (
          SELECT * FROM VUELO
          WHERE
            /* %JoinFKPK(VUELO,AEROPUERTO," = "," AND") */
            VUELO.codigoAeropuertoLlegada = AEROPUERTO.codigoAeropuerto
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last VUELO because AEROPUERTO exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* AEROPUERTO  VUELO on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="AEROPUERTO"
    CHILD_OWNER="", CHILD_TABLE="VUELO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="codigoAeropuerto" */
    IF EXISTS (SELECT * FROM deleted,AEROPUERTO
      WHERE
        /* %JoinFKPK(deleted,AEROPUERTO," = "," AND") */
        deleted.codigoAeropuertoSalida = AEROPUERTO.codigoAeropuerto AND
        NOT EXISTS (
          SELECT * FROM VUELO
          WHERE
            /* %JoinFKPK(VUELO,AEROPUERTO," = "," AND") */
            VUELO.codigoAeropuertoSalida = AEROPUERTO.codigoAeropuerto
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last VUELO because AEROPUERTO exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* AVION  VUELO on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="AVION"
    CHILD_OWNER="", CHILD_TABLE="VUELO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="codigoAvion" */
    IF EXISTS (SELECT * FROM deleted,AVION
      WHERE
        /* %JoinFKPK(deleted,AVION," = "," AND") */
        deleted.codigoAvion = AVION.codigoAvion AND
        NOT EXISTS (
          SELECT * FROM VUELO
          WHERE
            /* %JoinFKPK(VUELO,AVION," = "," AND") */
            VUELO.codigoAvion = AVION.codigoAvion
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last VUELO because AVION exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror (@errno, @errmsg,1)
    rollback transaction
END

go


CREATE TRIGGER tU_VUELO ON VUELO FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on VUELO */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @inscodigoUnico_D char(18), 
           @inscodigoAvion char(18),
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* VUELO  PASE on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0005609b", PARENT_OWNER="", PARENT_TABLE="VUELO"
    CHILD_OWNER="", CHILD_TABLE="PASE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="codigoUnico_D""codigoAvion" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(codigoUnico_D) OR
    UPDATE(codigoAvion)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,PASE
      WHERE
        /*  %JoinFKPK(PASE,deleted," = "," AND") */
        PASE.codigoUnico_D = deleted.codigoUnico_D AND
        PASE.codigoAvion = deleted.codigoAvion
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update VUELO because PASE exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* AEROPUERTO  VUELO on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="AEROPUERTO"
    CHILD_OWNER="", CHILD_TABLE="VUELO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="codigoAeropuerto" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(codigoAeropuertoLlegada)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,AEROPUERTO
        WHERE
          /* %JoinFKPK(inserted,AEROPUERTO) */
          inserted.codigoAeropuertoLlegada = AEROPUERTO.codigoAeropuerto
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.codigoAeropuertoLlegada IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update VUELO because AEROPUERTO does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* AEROPUERTO  VUELO on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="AEROPUERTO"
    CHILD_OWNER="", CHILD_TABLE="VUELO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="codigoAeropuerto" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(codigoAeropuertoSalida)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,AEROPUERTO
        WHERE
          /* %JoinFKPK(inserted,AEROPUERTO) */
          inserted.codigoAeropuertoSalida = AEROPUERTO.codigoAeropuerto
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.codigoAeropuertoSalida IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update VUELO because AEROPUERTO does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* AVION  VUELO on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="AVION"
    CHILD_OWNER="", CHILD_TABLE="VUELO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="codigoAvion" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(codigoAvion)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,AVION
        WHERE
          /* %JoinFKPK(inserted,AVION) */
          inserted.codigoAvion = AVION.codigoAvion
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update VUELO because AVION does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror (@errno, @errmsg,1)
    rollback transaction
END

go


