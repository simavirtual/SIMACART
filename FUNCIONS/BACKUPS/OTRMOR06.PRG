/*************************************************************************
* TITULO ..: LECTURA DEL ARCHIVO                                         *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: AGO 06/99 VIE A
       Colombia, Bucaramanga        INICIO: 10:00 PM   AGO 06/99 VIE

OBJETIVOS:

1- Crea el archivo con los estudiantes morosos de acuerdo al criterio
   del Colegio.

2- Retorna Nil

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrMor066(aParam1,aParam2,aParam3,;
		   oBrowse,lPazSav,cMesIni,;
		   lMorAct,dFecDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo
       lPazSav                              // Paz y Salvo
       cMesIni                              // Mes Inical del pago
       lMorAct                              // .T. Moroso Actual
       dFecDia                              // Fecha del Proceso Diario */
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

       LOCAL       i := 0                   // Contador
       LOCAL PathAct := ''                  // Paht Actual
       LOCAL nNroFil := 0                   // N�mero de la fila
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL lIniFin := .F.                 // Todos los Registros
       LOCAL cGruFin := ''                  // Grupo final de impresi�n
       LOCAL lSwPaso := .F.                 // Control de Flujo
       LOCAL cHorSys := TIME()              // Hora del Sistema
       LOCAL dFecUsr := CTOD("00/00/00")    // Fecha del Usuario

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
	  RETURN NIL
       ENDIF
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
	  CloseDbf('FUE')
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN lIniFin
       ENDIF

       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	   CloseDbf('GRU')

	   IF !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis)
	      cError('ABRIENDO ARCHIVOS')
	      CloseDbf('FUE')
	      CloseDbf('GRU')
	      IF !lFileDelete(FileTem)
		 cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	      ENDIF
	      RETURN lIniFin
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('GRU')
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN lIniFin
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('GRU')
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN lIniFin
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !EMPTY(dFecDia)
	  SELECT GRU
	  GO TOP
	  nRegIni := GRU->(RECNO())
	  GO BOTTOM
	  nRegFin := GRU->(RECNO())
	  GO TOP
       ELSE
	  IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin,@lIniFin)
	     CloseDbf('GRU')
	     IF !lFileDelete(FileTem)
		cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	     ENDIF
	     RETURN lIniFin
	  ENDIF
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>VERIFICACION O CREACION DEL DIRECTORIO COBROS
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (cPatSis+"\COBROS") == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+"\COBROS") == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO COBROS")
	    QUIT

       CASE DIRCHANGE(cPatSis+"\COBROS") == -3
	    DIRMAKE(cPatSis+"\COBROS")
       ENDCASE
       DIRCHANGE(PathAct)
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO COBROS

*>>>>ANALISIS DE LA FECHA DE PROCESO
       IF !lPazSav
	  IF EMPTY(dFecDia)
	     dFecUsr := DATE()
	  ELSE
	     dFecUsr := dFecDia
	  ENDIF
       ELSE
	  dFecUsr := DATE()
       ENDIF
*>>>>FIN ANALISIS DE LA FECHA DE PROCESO

*>>>>IMPRESION DE LOS ENCABEZADOS
       IF lPazSav
	  FileMor := 'RETIMORA'+ExtFile
       ELSE
	  FileMor := FileMor+cMesIni+ExtFile
       ENDIF
       IF lPazSav
	  nNroFil := nMarco(3,'REPORTADOS A PAZ Y SALVO. A�O: '+cAnoUsr)
       ELSE
	  IF lMorAct
	     nNroFil := nMarco(3,'ESTUDIANTES MOROSOS A '+cFecha(dFecUsr)+;
				 ' A�O: '+cAnoUsr)
	  ELSE
	     nNroFil := nMarco(3,'ESTUDIANTES MOROSOS DE LOS RECIBOS DEL MES DE '+;
				 cMes(VAL(cMesIni))+' A�O: '+cAnoUsr)
	  ENDIF
       ENDIF
       cRegPrint({'CODIGO','GRUPO','SALDO ACTUAL','REGISTRO'},{06,04,12,04},@aNroCol)
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>IMPRESION DEL INFORME PARA CADA GRUPO
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE RECNO() <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
				GRU->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

	       cError('ABRIENDO DE CLIENTES')
	       CloseDbf('GRU')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       IF !lFileDelete(FileTem)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN lIniFin
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS')

	    CASE PAG->(RECCOUNT()) == 0
		 cError('NO EXISTEN RECIBOS GRABADOS')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('GRU')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       IF !lFileDelete(FileTem)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN lIniFin
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'�'+;
			'HASTA EL GRUPO: '+cGruFin+'�ESPERE',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL INFORME
	    IF lPazSav
	       GraRetMor(lShared,nModCry,cNomUsr,cAnoUsr,dFecUsr,;
			 cHorSys,@nNroFil,aNroCol,cMaeAlu,;
			 @lSwPaso,cPatSis+'\COBROS',FileMor)
	    ELSE
	       GraMoroso(lShared,nModCry,cNomUsr,cAnoUsr,dFecUsr,;
			 cHorSys,@nNroFil,aNroCol,cMaeAlu,VAL(cMesIni),;
			 @lSwPaso,cPatSis+'\COBROS',FileMor,lMorAct)
	    ENDIF

	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
**********FIN IMPRESION DEL INFORME

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
       CloseDbf('GRU')
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO

*>>>>VALIDACION DE LA INFORMACION
       IF !lPazSav
	  IF lSwPaso
	     lInfActMor(lShared,cNomSis,cMaeAlu,CAA->nNomRepCaA)

	     SELECT MOR
	  ELSE
	     cError('NO EXISTEN ESTUDIANTES MOROSOS PARA EL MES DE '+;
		    cMes(VAL(cMesIni)))
	  ENDIF
       ENDIF

       IF !EMPTY(oBrowse)
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
       IF !lFileDelete(FileTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       RETURN lIniFin
*>>>>VALIDACION DE LA INFORMACION

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************

/*************************************************************************
* TITULO..: GRABACION DE LOS MOROSOS                                     *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: AGO 05/99 MIE A
       Bucaramanga, Colombia	    INICIO: 11:50 PM   AGO 05/99 MIE

OBJETIVOS:

1- Graba los Estudiantes que se encuentran en Mora

2- Return el total de la deuda del grupo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION GraMoroso(lShared,nModCry,cNomUsr,cAnoUsr,dFecUsr,cHorSys,;
		   nNroFil,aNroCol,cMaeAlu,nMesIni,lSwPaso,cPatSis,;
		   FileMor,lMorAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci�n
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A�o del Usuario
       dFecUsr                              // Fecha del Usuario
       cHorSys                              // Hora del Sistema
       nNroFil                              // @N�mero de la fila
       aNroCol                              // N�mero de Columnas
       cMaeAlu                              // Maestro Habilitados
       nMesIni				    // Mes Inicial del pago
       lSwPaso                              // Control de Flujo
       cPatSis                              // Path del Sistema
       FileMor                              // Archivo de Moroso
       lMorAct                              // .T. Morosos a la Fecha */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL nTotMes := 0                   // Total de meses atrasados
       LOCAL lMoroso := .F.                 // .T. Estudiante moroso
       LOCAL lDebe   := .T.                 // .T. Debe .F. Pago
       LOCAL aUseDbf := {}                  // Vector para Apertura de Varias Dbfs
       LOCAL lDeudor := .F.                 // .T. Deudor
       LOCAL lHayPag := .F.                 // .T. Hay Pago
       LOCAL nVlrPag := 0                   // Valor del Pago
       LOCAL nVlrInt := 0                   // Valor de los Intereses
       LOCAL lMesAct := .F.                 // .T. Mes Actual
       LOCAL nCodPaz := 0                   // C�digo del Paz y Salvo
       LOCAL cCampos := ''                  // Nombre de Campo
       LOCAL aConAlu := {}                  // Conceptos por Estudiante
       LOCAL cConcep := ''                  // Conceptos
       LOCAL nDiaMor := 0                   // Dias en Mora
       LOCAL nMesSdo := 0                   // Mes del saldo

       LOCAL nMesIniTpa := 0                // Mes Inicial del Pago
       LOCAL nSdoActTcl := 0                // Saldo Actual
       LOCAL nSdoMorTcl := 0                // Mora Actual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION ITEM DEL PAZ Y SALVO
       nCodPaz := 0
       IF lLocCodigo('nNroTipPaz','PAZ',1)
	  nCodPaz := PAZ->nCodigoPaz
       ENDIF
       IF EMPTY(nCodPaz)
	  cError('NO ESTA HABILITADO EL ITEM DE LOS PAZ Y SALVOS')
       ENDIF
*>>>>FIN LOCALIZACION ITEM DEL PAZ Y SALVO

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT CLI
       GO TOP
       DO WHILE .NOT. CLI->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('GRUPO: '+GRU->cCodigoGru+'�'+;
			'CODIGO:'+CLI->cCodigoEst,'')
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS DE ES DEUDOR ACTUAL
	    nDiaMor := 0
	    nMesSdo := 0
	    aConAlu := {}
	    lDebe := .T.
	    IF CLI->nSdoActCli+CLI->nSdoMorCli == 0
	       lDebe := .F.
	    ELSE
	       IF lLocCodPag(CLI->cCodigoEst,;
			     nMesUltPag(CLI->cCodigoEst),.F.)

*		  IF !EMPTY(PAG->cConcepPag)  // Pendiente verificar retirados con PAG->cConcepPag vacio.
		     lVlrConSdo(CLI->nSdoActCli,0,aConAlu,@nDiaMor,@nMesSdo)
*		  ENDIF

	       ENDIF

	    ENDIF
**********ANALISIS DE ES DEUDOR ACTUAL

**********ANALISIS SI ES EL MES ACTUAL
	    lMesAct := .T.
	    nMesIniTpa := nMesIni
	    IF nMesIniTpa < LEN(RTRIM(CLI->cMesPagCli))
	       lMesAct := .F.
	    ELSE
	       nMesIniTpa := LEN(RTRIM(CLI->cMesPagCli))
	    ENDIF
	    IF lMorAct
	       lMesAct := .T.
	    ENDIF
**********FIN ANALISIS SI ES EL MES ACTUAL

**********ANALISIS SI EL ESTUDIANTE ES MOROSO
	    lDeudor := .F.
	    IF lMesAct
	       IF CLI->nSdoActCli+CLI->nSdoMorCli # 0
		  lDeudor := .T.
		  nSdoActTcl := CLI->nSdoActCli
		  nSdoMorTcl := CLI->nSdoMorCli
	       ENDIF
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ES MOROSO

**********ANALISIS SI EXISTE PAGO
	    IF !lMorAct
	       lHayPag := lLocCodPag(CLI->cCodigoEst,nMesIniTpa,.F.)
	       IF !lHayPag
		  lDeudor := .F.
	       ENDIF
	    ELSE
	       lHayPag := .F.
	    ENDIF
**********FIN ANALISIS SI EXISTE PAGO

**********ANALISIS DEL PAGO
	    IF !lMesAct .AND. lHayPag

*--------------CALCULO DE LOS INTERESES
		 nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
				       PAG->nMesIniPag,;
				       CAA->nMesAmnCaA)
*--------------FIN CALCULO DE LOS INTERESES

*--------------ANALISIS DE LA FORMA DE PAGO
		 lDeudor := .F.
		 IF PAG->cEstadoPag = 'D'

*...................ANALISIS DEL RECIBO POR ADELANTADO
		      lDeudor := .T.
		      IF PAG->nMesIniPag == PAG->nMesFinPag
			 nVlrPag := PAG->nVlrPagPag
		      ELSE
			 IF CAA->nMesAmnCaA == nMesIniTpa
			    nVlrPag := PAG->nVlrMesPag
			 ELSE
			    nVlrPag := PAG->nSdoAntPag+PAG->nMorAntPag+;
				       PAG->nVlrMesPag
			 ENDIF
		      ENDIF
*...................FIN ANALISIS DEL RECIBO POR ADELANTADO

*...................ANALISIS DE LA AMNISTIA
		      IF CAA->nMesAmnCaA # nMesIniTpa
			 nSdoActTcl := nVlrPag
			 nSdoMorTcl := nVlrInt
		      ELSE
			 nSdoActTcl := PAG->nSdoAntPag+nVlrPag
			 nSdoMorTcl := PAG->nMorAntPag+nVlrInt
		      ENDIF
		      IF nSdoMorTcl+nSdoMorTcl == 0
			 lDeudor := .F.
		      ENDIF
*...................FIN ANALISIS DE LA AMNISTIA

		 ENDIF
*--------------FIN ANALISIS DE LA FORMA DE PAGO

	    ENDIF
**********FIN ANALISIS DEL PAGO

**********CREACION DEL ARCHIVO DE TRANSACIONES
	    IF .NOT. lSwPaso .AND. lDeudor
	       CloseDbf('MOR',cPatSis+'\'+FileMor,nModCry)
	       CreaDbfMor(lShared,nModCry,cPatSis,FileMor)
	    ENDIF
**********FIN CREACION DEL ARCHIVO DE TRANSACIONES

**********AREAS DE TRABAJO
	    IF .NOT. lSwPaso .AND. lDeudor
	       aUseDbf := {}
	       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			     FileMor,'MOR',NIL,lShared,nModCry})
	    ENDIF
**********FIN AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF .NOT. lSwPaso .AND. lDeudor
	       lSwPaso := .T.
	       IF !lUseDbfs(aUseDbf)
		  cError('ABRIENDO EL ARCHIVO DE MOROSOSO')
		  RETURN NIL
	       ENDIF
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********BUSQUEDA DEL DEL ESTUDIANTE
	    IF lDeudor .AND. (lHayPag .OR. lMorAct)
	       lSekCodMae(CLI->cCodigoEst,cMaeAlu,@cMaeAct)
	    ENDIF
**********FIN BUSQUEDA DEL DEL ESTUDIANTE

**********IMPRESION DE LOS DETALLES DEL PAGO
	    IF lDeudor .AND. (lHayPag .OR. lMorAct)
	       @ nNroFil,aNroCol[1] SAY CLI->cCodigoEst
	       @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
	       @ nNroFil,aNroCol[3] SAY CLI->nSdoactCli PICT "9999,999.99"
	       nNroFil++
	    ENDIF
**********FIN IMPRESION DE LOS DETALLES DEL PAGO

**********GRABACION DEL REGISTRO
	    IF lDeudor
	       IF MOR->(lRegLock(lShared,.T.))
		  REPL MOR->cCodigoEst WITH CLI->cCodigoEst
		  IF !lMorAct
		     REPL MOR->nMesIniPag WITH PAG->nMesIniPag
		     REPL MOR->nMesFinPag WITH PAG->nMesFinPag
		     REPL MOR->nSdoAntPag WITH PAG->nSdoAntPag
		     REPL MOR->nMorAntPag WITH PAG->nMorAntPag
		     REPL MOR->nVlrMesPag WITH PAG->nVlrMesPag
		     REPL MOR->nVlrPagPag WITH PAG->nVlrPagPag
		  ENDIF
		  REPL MOR->nDiaMorMor WITH nDiaMor
		  REPL MOR->nMesMorMor WITH nMesSdo
		  REPL MOR->nSdoActCli WITH nSdoActTcl
		  REPL MOR->nSdoMorCli WITH nSdoMorTcl
		  REPL MOR->lPagRecMor WITH .NOT. lDebe
		  REPL MOR->lSiRepoMor WITH .T.
		  REPL MOR->lHayRepMor WITH .F.
		  REPL MOR->lInfActMor WITH .F.
		  REPL MOR->lCartasMor WITH .T.
		  REPL MOR->cHayRepCli WITH CLI->cHayRepCli
		  REPL MOR->cMesPagCli WITH CLI->cMesPagCli
		  REPL MOR->lNtfCobCar WITH SCA->lNtfCobCar
		  REPL MOR->cTipNtfCar WITH IF(SCA->lNtfCobCar,;
					       SCA->cTipNtfCar,;
					       "NINGUNO")

		  IF !EMPTY(aConAlu) .AND.;
		     nSuma(aConAlu,3) == CLI->nSdoActCli

		     cConcep := ''
		     FOR i := 1 TO LEN(aConAlu)
			 cConcep += aConAlu[i,1]
			 REPL &('MOR->nVlrCo'+STR(i,1)+'Mor') WITH aConAlu[i,3]
		     ENDFOR
		     REPL MOR->cConcepMor WITH cConcep
		  ENDIF

		  REPL MOR->cNomUsrMor WITH cNomUsr
		  REPL MOR->dFecUsrMor WITH dFecUsr
		  REPL MOR->cHorUsrMor WITH cHorSys
		  MOR->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABA EL REGISTRO')
	       ENDIF
	       IF lShared
		  MOR->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DEL REGISTRO

**********GRABACION DEL PAZ Y SALVO
	    IF lDeudor .AND. nCodPaz # 0

	       SELECT &cMaeAct
	       IF lRegLock(lShared,.F.)
		  cCampos := cMaeAct+'->cPazSdoEst'
		  REPL &cCampos WITH STUFF(&cCampos,nCodPaz,1,'N')
		  DBCOMMIT()
	       ELSE
		  cError('NO SE GRABAN EL REGISTRO EN PAZ Y SALVO')
	       ENDIF
	       IF lShared
		  DBUNLOCK()
	       ENDIF
	    ENDIF
**********FIN GRABACION DEL PAZ Y SALVO

**********CONTROL DE LA FILA DE VISUALIZACION
	    IF nNroFil > 20

*--------------VISUALIZACION DEL ULTIMO CLIENTE
		 IF lMorAct
		    nNroFil := nMarco(3,'ESTUDIANTES MOROSOS A '+;
					cFecha(dFecUsr)+' A�O: '+cAnoUsr)
		 ELSE
		    nNroFil := nMarco(3,'ESTUDIANTES MOROSOS DE LOS '+;
					'RECIBOS DEL MES DE '+cMes(nMesIniTpa)+;
					' A�O: '+cAnoUsr)
		 ENDIF
*--------------FIN VISUALIZACION DEL ULTIMO CLIENTE

	    ENDIF
**********FIN CONTROL DE LA FILA DE VISUALIZACION

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT CLI
	    CLI->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RETURN NIL
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

/*************************************************************************
* TITULO..: GRABACION DE LOS RETIROS DE LOS REPORTADOS                   *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: JUN 11/2001 LUN A
       Colombia, Bucaramanga        INICIO: 04:45 PM   JUN 11/2001 LUN

OBJETIVOS:

1- Graba los Estudiantes Reportados que se encuentra a Paz y Salvo

2- Returna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION GraRetMor(lShared,nModCry,cNomUsr,cAnoUsr,dFecUsr,cHorSys,;
		   nNroFil,aNroCol,cMaeAlu,lSwPaso,cPatSis,FileMor)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci�n
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A�o del Usuario
       dFecUsr                              // Fecha del Usuario
       cHorSys                              // Hora del Sistema
       nNroFil                              // @N�mero de la fila
       aNroCol                              // N�mero de Columnas
       cMaeAlu                              // Maestro Habilitados
       nMesIni				    // Mes Inicial del pago
       lSwPaso                              // Control de Flujo
       cPatSis                              // Path del Sistema
       FileMor                              // Archivo de Moroso */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL lPazSav := .F.                 // .T. Paz y Salvo
       LOCAL nMesIni := 0                   // Mes Inicial del Pago
       LOCAL aUseDbf := {}                  // Vector para Apertura de Varias Dbfs
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT CLI
       GO TOP
       DO WHILE .NOT. CLI->(EOF())

**********ANALISIS DE ES DEUDOR ACTUAL
	    lPazSav := .F.
	    nMesIni := 0
	    IF CLI->nSdoActCli+CLI->nSdoMorCli == 0 .AND.;
	       !EMPTY(CLI->cHayRepCli)
	       lPazSav := .T.
	       nMesIni := VAL(SUBS(CLI->cHayRepCli,1,2))
	    ENDIF
**********ANALISIS DE ES DEUDOR ACTUAL

**********CREACION DEL ARCHIVO DE TRANSACIONES
	    IF .NOT. lSwPaso .AND. lPazSav
	       CloseDbf('MOR',cPatSis+'\'+FileMor,nModCry)
	       CreaDbfMor(lShared,nModCry,cPatSis,FileMor)
	    ENDIF
**********FIN CREACION DEL ARCHIVO DE TRANSACIONES

**********AREAS DE TRABAJO
	    IF .NOT. lSwPaso .AND. lPazSav
	       aUseDbf := {}
	       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			     FileMor,'MOR',NIL,lShared,nModCry})
	    ENDIF
**********FIN AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF .NOT. lSwPaso .AND. lPazSav
	       lSwPaso := .T.
	       IF !lUseDbfs(aUseDbf)
		  cError('ABRIENDO EL ARCHIVO DE MOROSOSO')
		  RETURN NIL
	       ENDIF
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********BUSQUEDA DEL DEL ESTUDIANTE
	    IF lPazSav
	       lSekCodMae(CLI->cCodigoEst,cMaeAlu,@cMaeAct)
	    ENDIF
**********FIN BUSQUEDA DEL DEL ESTUDIANTE

**********IMPRESION DE LOS DETALLES DEL PAGO
	    IF lPazSav
	       @ nNroFil,aNroCol[1] SAY CLI->cCodigoEst
	       @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
	       @ nNroFil,aNroCol[3] SAY CLI->nSdoactCli PICT "9999,999.99"
	       nNroFil++
	    ENDIF
**********FIN IMPRESION DE LOS DETALLES DEL PAGO

**********GRABACION DEL REGISTRO
	    IF lPazSav
	       IF MOR->(lRegLock(lShared,.T.))
		  REPL MOR->cCodigoEst WITH CLI->cCodigoEst
		  REPL MOR->nMesIniPag WITH nMesIni
		  REPL MOR->lPagRecMor WITH .T.
		  REPL MOR->lSiRepoMor WITH IF(EMPTY(SUBS(CLI->cHayRepCli,5,1)),.T.,.F.)
		  REPL MOR->lHayRepMor WITH IF(EMPTY(SUBS(CLI->cHayRepCli,5,1)),.F.,.T.)
		  REPL MOR->lCartasMor WITH .T.
		  REPL MOR->cMesPagCli WITH CLI->cMesPagCli
		  REPL MOR->cHayRepCli WITH CLI->cHayRepCli
		  REPL MOR->cNomUsrMor WITH cNomUsr
		  REPL MOR->dFecUsrMor WITH dFecUsr
		  REPL MOR->cHorUsrMor WITH cHorSys
		  MOR->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABA EL REGISTRO')
	       ENDIF
	       IF lShared
		  MOR->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DEL REGISTRO

**********CONTROL DE LA FILA DE VISUALIZACION
	    IF nNroFil > 20

*--------------VISUALIZACION DEL ULTIMO CLIENTE
		 nNroFil := nMarco(3,'REPORTADOS A PAZ Y SALVO. A�O: '+;
				   cAnoUsr)
*--------------FIN VISUALIZACION DEL ULTIMO CLIENTE

	    ENDIF
**********FIN CONTROL DE LA FILA DE VISUALIZACION

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT CLI
	    CLI->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RETURN NIL
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME