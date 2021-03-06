/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: ESTUDIANTES MOROSOS    MODULO No. 401

**************************************************************************
* TITULO..: ESTUDIANTES MOROSOS A�OS ANTERIORES                          *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: JUL 10/96 MIE A
       Bucaramanga, Colombia	    INICIO: 11:45 PM   JUL 10/96 MIE

REQUERIMIENTOS:

1- Para ejecutar la funci�n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir los estudiantes morosos

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_416(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci�n uno
       LOCAL cIntDos := ''                  // Path de integraci�n dos
       LOCAL cIntTre := ''                  // Path de integraci�n tres
       LOCAL cIntCua := ''                  // Path de integraci�n cuatro
     *�Variables generales

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
     *�Variables de informe

       LOCAL       i := 0                   // Contador
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi�n
       LOCAL nAnoIni := 0                   // A�o Inicial
       LOCAL nAnoFin := 0                   // A�o Final
       LOCAL lTodos  := .F.                 // .T. Todos los Registros
       LOCAL nTotAno := 0                   // Total del A�o
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

*>>>>CREACION DE TODOS LOS GRUPOS
       FileTem := cFileTempo('',SUBS(cNomUsr,1,4),ExtFile)
       CreaDbfGru(lShared,DIRNAME(),FileTem)

       IF !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'FUE',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF

       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	   CloseDbf('GRU')

	   IF !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis)
	      cError('ABRIENDO ARCHIVOS')
	      CloseAll()
	      IF !lFileDelete(FileTem)
		 cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	      ENDIF
	      RETURN NIL
	   ENDIF

	   SELECT GRU
	   GO TOP
	   DO WHILE .NOT. (GRU->(EOF()))

	      IF FUE->(lRegLock(lShared,.T.))
		 REPL FUE->cCodigoGru WITH GRU->cCodigoGru
		 FUE->(DBCOMMIT())
	      ELSE
		 cError('NO SE GRABA LA FORMA DE PAGO')
	      ENDIF
	      IF lShared
		 FUE->(DBUNLOCK())
	      ENDIF

	      SELECT GRU
	      SKIP

	   ENDDO

       ENDFOR
       CloseDbf('FUE')
       CloseDbf('GRU')
*>>>>FIN CREACION DE TODOS LOS GRUPOS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis)             .OR.;
	  !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lShared).OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
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

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
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

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ANALISIS DE DECISION
       lTodos := !lPregunta('CLASIFICAR LAS DEUDAS POR A�OS? No Si')
       ActivaPrn(lSiRed,cNomSis,PathSis,fSimCar,'cColaAcCar','Car',,nModCry)
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := nTotReg+nLinTot
       nTotReg := 0

       aCabeza := {cNomEmp,cNomSis,;
		   'ESTUDIANTES MATRICULADOS CON MORA A�OS ANTERIORES',;
		   IF(lTodos,'RELACION DE TODOS LOS MOROSOS',;
			     'DEUDAS CLASIFICADAS POR A�OS'),;
		   'JORNADA: '+cJorTxt+'. A�O: '+cAnoUsr,;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})


*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,04,42,12,50}
       aTitulo := {'CODIGO',;
		   'GRUPO',;
		   'A�O',;
		   'APELLIDOS Y NOMBRES',;
		   'SALDO ACTUAL',;
		   'OBSERVACIONES'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on(SCA->lPrnArcCar)
	   CloseAll(aUseDbf)
	   IF !lFileDelete(FileTem)
	      cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	   ENDIF
	   RETURN NIL
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi�n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LA DEUDA POR A�OS
       nAnoIni := SCA->nAnoIniCar
       nAnoFin := SCA->nAnoFinCar

       IF .NOT. lTodos

	  nTotAno += nMorGruAno(lShared,nModCry,cNomSis,cNomEmp,cAnoUsr,;
				cPatSis,GRU->cCodigoGru,nRegIni,nRegFin,;
				cMaeAlu,nColCab,aTitulo,aNroCol,bPagina,;
				bCabeza,bDerAut,0,lTodos,LEN(cCabCol))

	  FOR i := nAnoIni TO nAnoFin
	      nTotAno += nMorGruAno(lShared,nModCry,cNomSis,cNomEmp,cAnoUsr,;
				    cPatSis,GRU->cCodigoGru,nRegIni,nRegFin,;
				    cMaeAlu,nColCab,aTitulo,aNroCol,bPagina,;
				    bCabeza,bDerAut,i,lTodos,LEN(cCabCol))
	  ENDFOR

       ELSE
	  nTotAno += nMorGruAno(lShared,nModCry,cNomSis,cNomEmp,cAnoUsr,;
				cPatSis,GRU->cCodigoGru,nRegIni,nRegFin,;
				cMaeAlu,nColCab,aTitulo,aNroCol,bPagina,;
				bCabeza,bDerAut,i,lTodos,LEN(cCabCol))
       ENDIF
*>>>>FIN IMPRESION DE LA DEUDA POR A�OS

*>>>>IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL
       IF PROW() > 58 - nLinTot .OR. PROW() = 0
	  IF PROW() <> 0
	     EVAL(bDerAut)
	    *Impresi�n de derechos
	     EJECT
	  ENDIF
	  EVAL(bCabeza)
	 *Impresi�n del Encabezado
       ENDIF
       @ PROW()+1,nColCab SAY 'GRAN TOTAL '+TRANS(nTotAno,"$###,###,###")
*>>>>FIN IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       CloseDbf('CLI',FileCli,nModCry)
       CloseAll(aUseDbf)
       IF !lFileDelete(FileTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************

/*************************************************************************
* TITULO..: MOROSOS A�OS ANTERIORES POR GRUPOS                           *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: ABR 30/2003 MIE A
       Bucaramanga, Colombia	    INICIO: 09:50 PM   ABR 30/2003 MIE

OBJETIVOS:

1- Imprime los estudiantes morosos de a�os anterios por grupos

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nMorGruAno(lShared,nModCry,cNomSis,cNomEmp,cAnoUsr,cPatSis,;
		    cCodGru,nRegIni,nRegFin,cMaeAlu,nColCab,aTitulo,;
		    aNroCol,bPagina,bCabeza,bDerAut,nAnoMor,lTodos,;
		    nLenTxt)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci�n
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A�o del usuario
       cPatSis                              // Path del sistema
       cCodGru                              // C�digo del Grupo
       nRegIni                              // Registro Inicial
       nRegFin                              // Registro Final
       cMaeAlu                              // Maestros Habilitados
       nColCab                              // Columna del encabezado
       aTitulo                              // T�tulos para impresi�n
       aNroCol                              // Columnas de impresi�n
       bPagina                              // Block de P�gina
       bCabeza                              // Block de Encabezado
       bDerAut                              // Block Derechos de Autor
       nMorAno                              // Mora del A�o
       lTodos                               // .T. Todos los Registros
       nLenTxt                              // Longitud del Texto */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A�o del sistema

       LOCAL       i := 0                   // Contador
       LOCAL cGruFin := ''                  // Grupo final de impresi�n
       LOCAL cNivAnt := ''                  // Nivel Anterior
       LOCAL cNivAct := ''                  // Nivel Actual
       LOCAL nTotGru := 0                   // Total del Grupo
       LOCAL nTotNiv := 0                   // Total del Nivel
       LOCAL nTotAno := 0                   // Total del A�o
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       cError('ABRIENDO DE CLIENTES')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseAll(aUseDbf)
	       IF !lFileDelete(FileTem)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS')
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseAll(aUseDbf)
	       IF !lFileDelete(FileTem)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'�'+;
			'HASTA EL GRUPO: '+cGruFin+'�ESPERE',cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL INFORME
	    nTotGru := nMorAnoAnt(cNomEmp,cNomSis,cAnoUsr,GRU->cCodigoGru,;
				  cMaeAlu,nColCab,aTitulo,aNroCol,bPagina,;
				  bDerAut,bCabeza,nAnoMor,lTodos)
	    nTotNiv += nTotGru
	    nTotAno += nTotGru

	    CloseDbf('CLI',FileCli,nModCry)
**********FIN IMPRESION DEL INFORME

**********AVANCE DEL SIGUIENTE GRUPO
	    cNivAnt := SUBS(GRU->cCodigoGru,1,2)
	    SELECT GRU
	    GRU->(DBSKIP())

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

**********CONTROL PARA EL CAMBIO DE NIVEL
	    cNivAct := SUBS(GRU->cCodigoGru,1,2)
	    IF cNivAnt # cNivAct

	       IF nTotNiv # 0
		  @ PROW()+1,00 SAY ''
		  @ PROW(),nColCab+nColTxt(aNroCol,5) SAY REPL('=',aNroCol[5])
		  @ PROW()+1,nColCab SAY 'TOTAL '+cNomNiv(cNivAnt)
		  @ PROW(),nColCab+nColTxt(aNroCol,5) SAY TRANS(nTotNiv,"####,###,###")
	       ENDIF

	       nTotNiv := 0
	       cNivAnt := cNivAct
	    ENDIF
**********FIN CONTROL PARA EL CAMBIO DE NIVEL

       ENDDO
*>>>>FIN RECORRIDO POR GRUPOS

*>>>>IMPRESION DEL TOTAL DEL A�O
       IF nTotAno # 0 .AND. !lTodos
	  @ PROW()+1,00 SAY ''
	  @ PROW(),nColCab SAY 'TOTAL A�O: '+STR(nAnoMor,4)+' '+;
			       TRANS(nTotAno,"$###,###,###")

	  @ PROW()+1,nColCab SAY REPL('-',nLenTxt)
       ENDIF
       RETURN nTotAno
*>>>>FIN IMPRESION DEL TOTAL DEL A�O


/*************************************************************************
* TITULO..: MOROSOS A�OS ANTERIORES                                      *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: JUL 10/96 MIE A
       Bucaramanga, Colombia	    INICIO: 11:50 PM   JUL 10/96 MIE

OBJETIVOS:

1- Imprime los estudiantes morosos

2- Return el total de la deuda del grupo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nMorAnoAnt(cNomEmp,cNomSis,cAnoUsr,cCodGru,cMaeAlu,;
		    nColCab,aTitulo,aNroCol,bPagina,bDerAut,;
		    bCabeza,nAnoMor,lTodos)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A�o del sistema
       cCodGru                              // C�digo del grupo
       cMaeAlu                              // Maestros habilitados
       nColCab                              // Columna del encabezado
       aTitulo                              // T�tulos para impresi�n
       aNroCol                              // Columnas de impresi�n
       bPagina                              // Block de P�gina
       bDerAut                              // Block Derechos de Autor
       bCabeza                              // Block de Encabezado
       nAnoMor                              // A�o de la Mora
       lTodos                               // .T. Todos los Registros */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A�o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci�n uno
       LOCAL cIntDos := ''                  // Path de integraci�n dos
       LOCAL cIntTre := ''                  // Path de integraci�n tres
       LOCAL cIntCua := ''                  // Path de integraci�n cuatro
     *�Variables generales

       LOCAL       i := 0                   // Contador
       LOCAL cMaeAct := ''                  // Alias del maestro
       LOCAL lHayAlu := .T.                 // .T. Existe alumno
       LOCAL nTotSdo := 0                   // Total de los saldos
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nLinTot := 2                   // L�neas totales de control
       LOCAL cTxtPrn := ''                  // Texto de impresi�n
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL nVlrPag := 0                   // Valor del pago de un mes o varios meses.
       LOCAL lDeudor := .T.                 // .T. Deudor
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL lMesAct := .T.                 // .T. Mes Actual
       LOCAL nTotGru := 0                   // Total del Grupo
     *�Variables espec�ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL nSdoActTcl := 0                // Deuda Actual
       LOCAL nSdoMorTcl := 0                // Mora Actual
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

**********ANALISIS SI EL ESTUDIANTE ES MOROSO
	    IF CLI->nSdoAnoCli+CLI->nMorAnoCli == 0
	       CLI->(DBSKIP())
	       LOOP
	    ELSE

	    ENDIF

	    IF .NOT. lTodos
	       IF CLI->nAnoSdoCli # nAnoMor
		  CLI->(DBSKIP())
		  LOOP
	       ENDIF
	    ENDIF
	    nTotGru += CLI->nSdoAnoCli+CLI->nMorAnoCli
**********FIN ANALISIS SI EL ESTUDIANTE ES MOROSO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodMae(CLI->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(20),1,42)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aTitulo := {CLI->cCodigoEst,;
			cCodGru,;
			STR(CLI->nAnoSdoCli,4),;
			SPACE(01)+SUBS(cNombreTes,1,41),;
			TRANS(CLI->nSdoAnoCli+;
			      CLI->nMorAnoCli,'####,###,###'),;
			''}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
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
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL
       IF PROW() > 58 - nLinTot .OR. PROW() = 0
	  IF PROW() <> 0
	     EVAL(bDerAut)
	    *Impresi�n de derechos
	     EJECT
	  ENDIF
	  EVAL(bCabeza)
	 *Impresi�n del Encabezado
       ENDIF
       RETURN nTotGru
*>>>>FIN IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL