/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: ESTUDIANTES BECADOS    MODULO No. 402

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE402.PRG                                    *
* TITULO DEL PROGRAMA..: ESTUDIANTES BECADOS                             *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: JUL 24/96 MIE A
       Bucaramanga, Colombia	    INICIO: 03:25 PM   JUL 24/96 MIE

REQUERIMIENTOS:

1- Para ejecutar la funci�n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir los estudiantes Becados

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_402(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"  // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci�n uno
       LOCAL cIntDos := ''                  // Path de integraci�n dos
       LOCAL cIntTre := ''                  // Path de integraci�n tres
       LOCAL cIntCua := ''                  // Path de integraci�n cuatro
     *�Variables generales

       LOCAL     i,j := 0                   // Contadores
       LOCAL cOpcSys := ''                  // Opci�n del Sistema
       LOCAL nNroIso := ''                  // N�mero Iso del Informe
       LOCAL cCodIso := ''                  // C�digo Iso del Informe
       LOCAL aTitIso := ''                  // T�tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P�gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p�gina
       LOCAL nTotPie := 0                   // Total de Pie de p�ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
       LOCAL oBrowse := NIL                 // Browse del Archivo
     *�Variables Gestion Documental

       LOCAL nNroPag := 1                   // N�mero de p�gina
       LOCAL lTamAnc := .F.                 // .T. Tama�o Ancho
       LOCAL nLinTot := 2                   // L�neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C�digos de impresi�n iniciales
       LOCAL cCodFin := ''                  // C�digos de impresi�n finales
       LOCAL aNroCol := {}                  // Columnas de impresi�n
       LOCAL aTitulo := {}                  // T�tulos para impresi�n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l�nea de impresi�n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P�gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L�neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi�n
       LOCAL nOpcPrn := 0                   // Opci�n de Impresi�n
       LOCAL aRegPrn := {}                  // Registros para impresi�n
       LOCAL aCabXml := {}                  // Encabezado del Xml
       LOCAL aCamXml := {}                  // Campo Xml
     *�Variables de informe

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL lAnoAct := .T.                 // A�o Actual
       LOCAL nNroBec := 0                   // N�mero de Becados
       LOCAL nTotMes := 0                   // Total Valor Mes Sin Beca
       LOCAL nTotBec := 0                   // Valor total en Becas

       LOCAL FileBak := ''                  // Archivo del Backup
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi�n
       LOCAL Getlist := {}                  // Variable del sistema
     *�Variables espec�ficas 
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci�n
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *�Detalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C�digo de la Empresa
     *�Detalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A�o del usuario
       LOCAL cAnoSis := ''                  // A�o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *�Detalles del Usuario

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *�Detalles Acad�micos

       LOCAL nFilPal := 0                   // Fila Inferior Men� principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen�
       LOCAL nColInf := 0                   // Columna Inferior del SubMen�
     *�Detalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *�Sitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *�Lectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>CAPTURA DEL MES A PAGAR
       cSavPan := SAVESCREEN(0,0,24,79)
       nMesIni := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes de Pago',.T.)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>CONTEO DE LOS ESTUDIANTES MOROSOS
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'CONTANDO ESTUDIANTES CON BECADOS')
       nTotReg := nCountBeca(lShared,nModCry,cPatSis,cAnoUsr,cIntUno,cMaeAlu)
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nTotReg == 0
	  cError('NO APARECEN ESTUDIANTES BECADOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
       nTotReg := nTotReg+((nRegFin-nRegIni+1)*nLinTot)+nLinTot
*>>>>FIN CONTEO DE LOS ESTUDIANTES MOROSOS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileTar,'TAR',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       CASE TAR->(RECCOUNT()) == 0
	    cError('NO SE HAN DEFINIDO LAS TARIFAS DE PAGO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 402
     *�N�mero de identificaci�n del informe

       cOpcSys := '<INFORMES><ALUMNOS BECADOS>'
     *�Opci�n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
       AADD(aMezIso,{'<cMesIni>',cMes(nMesIni,10)})
     *�Campos a sustituir

       aTitIso := {}
       AADD(aTitIso,'RELACION DE ESTUDIANTES CON AYUDAS EN PENSION') // T�tulo Uno
       AADD(aTitIso,'CORRESPONDIENTE A RECIBOS DE <cMesIni>')        // T�tulo Dos
       AADD(aTitIso,'A�O: <cAnoUsr>. JORNADA: <cJorTxt>')            // T�tulo Tres
     *�T�tulos del Informe por defecto

       cPiePag := ALLTRIM(SCA->cPiePagCar)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p�gina Uno
       AADD(aPieIso,'')                 // Pie de p�gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p�gina Tres
     *�Pie de p�ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *�Inclusi�n o modificaci�n de la gesti�n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'ayuda'+cMes(nMesIni,3)
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.,.F.,bInsIso,PathDoc)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := nTotReg+nLinTot
       aCabeza := {cNomEmp,cNomSis+cCodIso,;
		   aTitIso[1],;
		   aTitIso[2],;
		   aTitIso[3],;
		   nNroPag++,cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       IF nOpcPrn >= 4 // Archivo
	  aNroCol := {04,02,06,06,40,14,12,12,12,20}
	  aTitulo := {'##',;
		      'No',;
		      'CODIGO',;
		      'GRUPO ',;
		      'APELLIDOS Y NOMBRES ',;
		      'AYUDAS',;
		      'VLR. PENSION',;
		      IF(EMPTY(nMesIni),'VALOR AYUDA','AYUDA EN '+cMes(nMesIni,3)),;
		      '123456789012',;
		      'OBSERVACIONES'}
       ELSE
	  aNroCol := {04,02,06,06,20,14,12,12,12,20}
	  aTitulo := {'##',;
		      'No',;
		      'CODIGO',;
		      'GRUPO ',;
		      'APELLIDOS Y NOMBRES ',;
		      'AYUDAS',;
		      'VLR. PENSION',;
		      IF(EMPTY(nMesIni),'VALOR AYUDA','AYUDA EN '+cMes(nMesIni,3)),;
		      '123456789012',;
		      'OBSERVACIONES'}
       ENDIF

       aCamXml := aTitulo
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       EVAL(bCabeza)
      *Impresi�n del Encabezado
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>ANALISIS PARA CADA NIVEL
       FOR i := 1 TO LEN(cMaeAlu)/3

***********SELECION DE LAS AREAS DE TRABAJO
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	     cNalias := cMaeAct
	     IF !lUseMae(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct) .OR.;
		!lUseGru(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct)
		cError('ABRIENDO ARCHIVOS')
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     lHayErr := .T.
	     SELECT &cNalias
	     DO CASE
	     CASE RECCOUNT() == 0
		  cError('NO EXISTE ESTUDIANTES GRABADOS')

	     CASE GRU->(RECCOUNT()) == 0
		  cError('NO EXISTE GRUPOS GRABADOS')

	     OTHERWISE
		  lHayErr :=.F.
	     ENDCASE
	     IF lHayErr
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

***********IMPRESION DEL INFORME PARA CADA GRUPO
	     SELECT GRU
	     GO TOP
	     DO WHILE .NOT. GRU->(EOF())

*---------------PREPARACION DE LAS VARIABLES DE ARCHIVO
		  FileCli := cPatSis+'\CLIENTES\CL'+;
				      GRU->cCodigoGru+cAnoSis+ExtFile
		  FilePag := cPatSis+'\PAGOS\PA'+;
				      GRU->cCodigoGru+cAnoSis+ExtFile

		  FileBak := cPatSis+'\CLIENTES\BACKUPS\CL'+;
				     GRU->cCodigoGru+cAnoSis+ExtFile
*---------------FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

*---------------SELECION DE LAS AREAS DE TRABAJO
		  IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
		     !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
		     cError('ABRIENDO DE CLIENTES Y PAGOS')
		     CloseDbf('CLI',FileCli,nModCry)
		     CloseDbf('PAG',FilePag,nModCry)
		     CloseAll(aUseDbf)
		     RETURN NIL
		  ENDIF
*---------------FIN SELECION DE LAS AREAS DE TRABAJO

*---------------VALIDACION DE CONTENIDOS DE ARCHIVOS
		  lHayErr := .T.
		  DO CASE
		  CASE CLI->(RECCOUNT()) == 0
		       cError('NO EXISTEN CLIENTES GRABADOS PARA '+;
			      GRU->cCodigoGru)
		  OTHERWISE
		       lHayErr :=.F.
		  ENDCASE
		  IF lHayErr
		     CloseDbf('CLI',FileCli,nModCry)
		     CloseDbf('PAG',FilePag,nModCry)
		     SELECT GRU
		     GRU->(DBSKIP())
		     LOOP
		  ENDIF
*---------------FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*---------------IMPRESION DE LA LINEA DE ESTADO
		  SET DEVICE TO SCREEN
		  LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'�'+;
			      'HASTA EL GRUPO: '+cGruFin+'�ESPERE',cNomSis)
		  SET DEVICE TO PRINT
*---------------FIN IMPRESION DE LA LINEA DE ESTADO

*CopiarCli(lShared,GRU->cCodigoGru)

*---------------IMPRESION DEL INFORME
		  BecadosPrn(lShared,cNomEmp,cNomSis,cAnoUsr,cPatSis,;
			     lAnoAct,cJorTxt,GRU->cCodigoGru,cMaeAlu,;
			     nColCab,aTitulo,aNroCol,bPagina,bDerAut,;
			     bCabeza,@nNroBec,@nTotMes,@nTotBec,nMesIni,;
			     @aRegPrn,nOpcPrn)


		  CloseDbf('CLI',FileCli,nModCry)
		  CloseDbf('PAG',FilePag,nModCry)
*---------------FIN IMPRESION DEL INFORME

*---------------AVANCE DEL SIGUIENTE GRUPO
		  SELECT GRU
		  GRU->(DBSKIP())
*---------------FIN AVANCE DEL SIGUIENTE GRUPO

	     ENDDO
***********FIN IMPRESION DEL INFORME PARA CADA GRUPO

	   CloseDbf('GRU')

       ENDFOR
*>>>>FIN ANALISIS PARA CADA NIVEL

*>>>>IMPRESION DE LOS TOTALES
       aTitulo := {'','','','',REPL('*',40),REPL('*',12)}
       AADD(aTitulo,REPL('=',aNroCol[07]))
       AADD(aTitulo,REPL('=',aNroCol[08]))
       AADD(aTitulo,'')
       AADD(aTitulo,'')
       AADD(aTitulo,'')  // Url
       AADD(aRegPrn,aTitulo)

       @ PROW()+1,nColTxt(aNroCol,07) SAY REPL('-',aNroCol[07])
       @ PROW()  ,nColTxt(aNroCol,08) SAY REPL('-',aNroCol[08])

       @ PROW()+1,nColTxt(aNroCol,07) SAY TRANS(nTotMes,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,08) SAY TRANS(nTotBec,"####,###,###")

       aTitulo := {'','','','','',''}
       AADD(aTitulo,TRANS(nTotMes,"####,###,###"))
       AADD(aTitulo,TRANS(nTotBec,"####,###,###"))
       AADD(aTitulo,'')
       AADD(aTitulo,'')
       AADD(aTitulo,'')  // Url
       AADD(aRegPrn,aTitulo)
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DERECHOS
       cTxtPrn := 'D ->NO PAGO  P->POGO OPORTUNO '+;
		  'A->PAGO EXTEMPORANEO *->DEUDOR'
       lPrnReg(02,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       VerPrn(nOpcPrn,FilePrn)
       SET DEVICE TO SCREEN
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
*>>>>FIN IMPRESION DERECHOS

*>>>>EXPORTACION DEL RETIRADOS CON SALDO A UN ARCHIVO
       AADD(aCabXml,cNomEmp)
      *Nombre de la Empresa

       AADD(aCabXml,cNomSis+':{INFOMES}{ALUMNOS BECADOS}')
      *Nombre del Sistema

       AADD(aCabXml,'RELACION DE ESTUDIANTES CON AYUDAS EN PENSION')
      *Titulo No. 1

       AADD(aCabXml,'CORRESPONDIENTE A RECIBOS DE '+cMes(nMesIni,10))
      *Titulo No. 2

       AADD(aCabXml,'A�O: '+cAnoUsr+' JORNADA: '+cJorTxt)
      *Titulo No. 3

       AADD(aCabXml,cFecha(DATE()))
      *Fecha del Informe

       AADD(aCabXml,TIME())
      *Hora del Informe

/*
       FileXml(PathW01+'\'+'FACT'+cMes(nMesIni,3)+'\'+;
	       'HLP'+cMes(nMesIni,3)+cAnoSis+'.XML',;
	       aRegPrn,aCamXml,aCabXml)
     *�Creaci�n del Archivo
*/

       RETURN NIL
*>>>>FIN EXPORTACION DEL RETIRADOS CON SALDO A UN ARCHIVO

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************


/*************************************************************************
* TITULO DEL PROGRAMA..: INFORME DE PAGOS EFECTUADOS                     *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: JUL 10/96 MIE A
       Bucaramanga, Colombia	    INICIO: 11:50 PM   JUL 10/96 MIE

OBJETIVOS:

1- Imprime los estudiantes morosos

2- Returna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BecadosPrn(lShared,cNomEmp,cNomSis,cAnoUsr,cPatSis,;
		    lAnoAct,cJorTxt,cCodGru,cMaeAlu,nColCab,;
		    aTitulo,aNroCol,bPagina,bDerAut,bCabeza,;
		    nNroBec,nTotMes,nTotBec,nMesIni,aRegPrn,;
		    nOpcPrn)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A�o del sistema
       cPatSis                              // Path del sistema
       lAnoAct                              // .T. A�o Actual
       cJorTxt                              // Jornada escogida
       cCodGru                              // C�digo del grupo
       cMaeAlu                              // Maestros habilitados
       nColCab                              // Columna del encabezado
       aTitulo                              // T�tulos para impresi�n
       aNroCol                              // Columnas de impresi�n
       bPagina                              // Block de P�gina
       bCabeza                              // Block de Encabezado
       bDerAut                              // Block Derechos de Autor
       nNroBec			            // N�mero de Becados
       nTotMes                              // Total Valor Mes Sin Beca
       nTotBec                              // Valor total en Becas
       nMesIni                              // Mes Inicial
       aRegPrn                              // Registro de Impresi�n
       nOpcPrn                              // Opci�n de Impresi�n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A�o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci�n uno
       LOCAL cIntDos := ''                  // Path de integraci�n dos
       LOCAL cIntTre := ''                  // Path de integraci�n tres
       LOCAL cIntCua := ''                  // Path de integraci�n cuatro
     *�Variables generales

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL lHayAlu := .T.                 // .T. Existe alumno
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nLinTot := 2                   // L�neas totales de control
       LOCAL cTxtPrn := ''                  // Texto de impresi�n
       LOCAL nVlrMes := 0                   // Valor del Mes
       LOCAL nVlrBec := 0                   // Valor de la Beca
       LOCAL nBecFac := 0                   // Valor de la Beca Facturada para el mes
       LOCAL cIntBec := ''                  // Interese de la Beca
     *�Variables espec�ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetadoTes := .T.              // .T. Estudiante retirado
     *�Variables temporales de campos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL TERMOMETRO
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO EL GRUPO '+cCodGru)
       Termometro(10)
       SET DEVICE TO PRINT
*>>>>FIN IMPRESION DEL TERMOMETRO

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT CLI
       GO TOP
       DO WHILE .NOT. EOF()

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( CLI->(RECNO()) / CLI->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********ANALISIS SI ESTA BECADO
	    IF CLI->nBecIniCli == 0 .AND. CLI->nBecFinCli == 0
	       CLI->(DBSKIP())
	       IF CLI->(EOF())
		  SET DEVICE TO SCREEN
		  Termometro(100)
		  SET DEVICE TO PRINT
	       ENDIF
	       LOOP
	    ENDIF
	    nNroBec++
**********FIN ANALISIS SI ESTA BECADO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    lHayAlu := lSekCodMae(CLI->cCodigoEst,cMaeAlu,@cNalias,.F.)
	    IF lHayAlu
	       cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			     RTRIM(&cNalias->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    IF nOpcPrn >= 4 // Archivo
	       cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
	       cNombreTes := SPACE(01)+SUBS(cNombreTes,1,39)
	    ELSE
	       cNombreTes := SUBS(cNombreTes+SPACE(20),1,20)
	       cNombreTes := SPACE(01)+SUBS(cNombreTes,1,19)
	    ENDIF
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS SI ESTUDIANTE ESTA RETIRADO
	    lRetadoTes := .F.
	    IF lHayAlu
	       IF &cNalias->lRetiroEst
		  lRetadoTes := .T.
	       ENDIF
	    ENDIF
**********FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

**********CALCULO DE LA BECA
	    nVlrMes := nValorTar(GRU->cCodigoGru,'PE')
	    IF nMesIni == 0
	       IF EMPTY(CLI->nPorBecCli)
		  nVlrBec := CLI->nVlrBecCli
	       ELSE
		  nVlrBec := ROUND((nVlrMes * CLI->nPorBecCli)/100,0)
	       ENDIF
	    ENDIF
**********FIN CALCULO DE LA BECA

**********ANALISIS SI LA BECA FUE FACTURADA
	    cIntBec := ''
	    IF nMesIni # 0
	       nVlrBec := 0
	       IF lLocCodPag(CLI->cCodigoEst,nMesIni,.F.)
		  IF PAG->lHayBecPag
		     nVlrBec := PAG->nVlrBecPag
		     cIntBec := cIntBeca()
		  ENDIF
	       ENDIF
	    ENDIF
	    SELECT CLI
**********FIN ANALISIS SI LA BECA FUE FACTURADA

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aTitulo := {}
	    aTitulo := {STR(nNroBec,4),;
			STR(CLI->(RECNO()),2),;
			CLI->cCodigoEst,;
			&cNalias->cCodigoGru,;
			cNombreTes,;
			cMes(CLI->nBecIniCli,3)+' A '+;
			cMes(CLI->nBecFinCli,3)+;
			     IF(EMPTY(CLI->nPorBecCli),'',;
				+' '+STR(CLI->nPorBecCli,3)+'%'),;
			TRANS(nVlrMes,'####,###,###'),;
			TRANS(nVlrBec,'####,###,###'),;
			AADD(aTitulo,CLI->cMesPagCli),;
			IF(&cNalias->lRetiroEst,cIntBec+' RETIRADO',;
			   SUBS(cIntBec+SPACE(20),1,20))}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	    AADD(aTitulo,'') // Campo Url
	    AADD(aRegPrn,aTitulo)

	    nTotMes += nVlrMes
	    nTotBec += nVlrBec
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT CLI
	    CLI->(DBSKIP())
	    IF CLI->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RETURN NIL
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*******

FUNCTION nCountBeca(lShared,nModCry,cPatSis,cAnoUsr,cIntUno,cMaeAlu,cCondic)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci�n
       cPatSis                              // Path del sistema
       cAnoUsr                              // A�o del Usuario
       cIntUno                              // Path de integraci�n uno
       cMaeAlu                              // Maestros habilitados
       cCondic                              // Condici�n para el conteo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL lAnoAct := .F.                 // .T. A�o Actual
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A�o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nNroBec := 0                   // N�mero de Becados
       LOCAL       i := 0                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS PARA CADA NIVEL
       FOR i := 1 TO LEN(cMaeAlu)/3

***********SELECION DE LAS AREAS DE TRABAJO
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	     IF !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis,lAnoAct)
		cError('ABRIENDO EL ARCHIVO DE GRUPOS')
		CloseDbf('GRU')
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     lHayErr := .T.
	     DO CASE
	     CASE GRU->(RECCOUNT()) == 0
		  cError('NO EXISTE GRUPOS GRABADOS')

	     OTHERWISE
		  lHayErr :=.F.
	     ENDCASE
	     IF lHayErr
		CloseDbf('GRU')
		RETURN 0
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

***********IMPRESION DEL INFORME PARA CADA GRUPO
	     SELECT GRU
	     GO TOP
	     DO WHILE .NOT. GRU->(EOF())

*---------------PREPARACION DE LAS VARIABLES DE ARCHIVO
		  FileCli := cPatSis+'\CLIENTES\CL'+;
			     GRU->cCodigoGru+cAnoSis+ExtFile
*---------------FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

*---------------SELECION DE LAS AREAS DE TRABAJO
		  IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
		     cError('ABRIENDO DE CLIENTES')
		     CloseDbf('CLI',FileCli,nModCry)
		     RETURN 0
		  ENDIF
*---------------FIN SELECION DE LAS AREAS DE TRABAJO

*---------------VALIDACION DE CONTENIDOS DE ARCHIVOS
		  lHayErr := .T.
		  DO CASE
		  CASE CLI->(RECCOUNT()) == 0
		       cError('NO EXISTEN CLIENTES GRABADOS PARA '+;
			      GRU->cCodigoGru)
		  OTHERWISE
		       lHayErr :=.F.
		  ENDCASE
		  IF lHayErr
		     CloseDbf('CLI',FileCli,nModCry)
		     SELECT GRU
		     GRU->(DBSKIP())
		     LOOP
		  ENDIF
*---------------FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*---------------CONTEO DE REGISTROS
		  SELECT CLI
		  GO TOP
		  DO WHILE .NOT. EOF()

*                    ANALISIS DE LA CONDICION DE CONTEO
		       IF CLI->nBecIniCli # 0 .AND. CLI->nBecFinCli # 0
			  nNroBec++
		       ENDIF
*                    FIN ANALISIS DE LA CONDICION DE CONTEO

*                    AVANCE DEL SIGUIENTE REGISTRO
		       SELECT CLI
		       CLI->(DBSKIP())
*                    FIN AVANCE DEL SIGUIENTE REGISTRO

		  ENDDO
		  CloseDbf('CLI',FileCli,nModCry)
*---------------FIN CONTEO DE REGISTROS

*---------------AVANCE DEL SIGUIENTE GRUPO
		  SELECT GRU
		  GRU->(DBSKIP())
*---------------FIN AVANCE DEL SIGUIENTE GRUPO

	    ENDDO
	    CloseDbf('GRU')
***********FIN IMPRESION DEL INFORME PARA CADA GRUPO

       ENDFOR

       RETURN nNroBec
*>>>>FIN ANALISIS PARA CADA NIVEL



FUNCTION CopiarCli(lShared,cCodGru)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cCodGru                              // C�digo del Grupo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nAvance := 0                   // Avance de registros
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL TERMOMETRO
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO EL GRUPO '+cCodGru)
       Termometro(10)
       SET DEVICE TO PRINT
*>>>>FIN IMPRESION DEL TERMOMETRO

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT CLI
       GO TOP
       DO WHILE .NOT. CLI->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( CLI->(RECNO()) / CLI->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********LOCALIZACION DEL CODIGO
	    IF !lLocCodigo('cCodigoEst','BAK',CLI->cCodigoEst)
	       SET DEVICE TO SCREEN
	       cError('NO EXISTE EL CODIGO '+CLI->cCodigoEst)
	       CLI->(DBSKIP())
	       SET DEVICE TO PRINT
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********ACTUALIZACION DEL REGISTRO
	    IF CLI->(lRegLock(lShared,.F.))

	       REPL CLI->cNroCopCli WITH BAK->cNroCopCli
	       REPL CLI->cMesPagCli WITH BAK->cMesPagCli
	       REPL CLI->nPorBecCli WITH BAK->nPorBecCli
	       REPL CLI->nVlrBecCli WITH BAK->nVlrBecCli
	       REPL CLI->nBecIniCli WITH BAK->nBecIniCli
	       REPL CLI->nBecFinCli WITH BAK->nBecFinCli
	       REPL CLI->cNomUsrCli WITH BAK->cNomUsrCli
	       REPL CLI->dFecUsrCli WITH BAK->dFecUsrCli
	       REPL CLI->cHorUsrCli WITH BAK->cHorUsrCli

	       CLI->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
	    ENDIF
	    IF lShared
	       CLI->(DBUNLOCK())
	    ENDIF
**********FIN ACTUALIZACION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT CLI
	    CLI->(DBSKIP())
	    IF CLI->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RETURN NIL
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

