/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: MOROSOS POR MESES                        MODULO No. 413

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE411.PRG                                    *
* TITULO DEL PROGRAMA..: MOROSOS POR MESES                               *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: JUL 28/99 MIE A
       Bucaramanga, Colombia	    INICIO: 05:05 PM   JUL 28/99 MIE

REQUERIMIENTOS:

1- Para ejecutar la funci�n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir los morosos de acuerdo a los meses que a deuda
   o de acuerdo a un intervalo seleccionado.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_413(aParam1,aParam2,aParam3)

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

       LOCAL       i := 0                   // Contador
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL cMesIni := ''                  // Mes Inicial
       LOCAL PathAct := ''                  // Paht Actual
       LOCAL nNroFil := 0                   // N�mero de la fila
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL nNroMes := 0                   // N�mero de meses de atraso
       LOCAL nVlrInf := 0                   // Valor Inferior para la deuda
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
			     'Por Favor Seleccione el Mes',.T.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nMesIni == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
       cMesIni := STR(nMesIni,2)
       lCorrecion(@cMesIni)
*>>>>FIN CAPTURA DEL MES A PAGAR

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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis)  .OR.;
	  !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
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
	  CloseAll()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>LECTURA DE LOS INTERVALOS DE LA DEUDA
       cSavPan := SAVESCREEN(0,0,24,79)
       nVlrInf := 0
       @nFilInf+3,nColInf SAY 'MESES DE ATRASO    : ' GET nNroMes PICT "99"
       @nFilInf+4,nColInf SAY 'DEUDAS SUPERIORES A: ' GET nVlrInf PICT "9999999999"
       READ

       IF EMPTY(nVlrInf) .AND. EMPTY(nNroMes)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  CloseAll()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  CloseAll()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE LOS INTERVALOS DE LA DEUDA

*>>>>VERIFICACION O CREACION DEL DIRECTORIO MODEM
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (cPatSis+"\COBROS") == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+"\COBROS") == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO MODEM")
	    QUIT

       CASE DIRCHANGE(cPatSis+"\COBROS") == -3
	    DIRMAKE(cPatSis+"\COBROS")
       ENDCASE
       DIRCHANGE(PathAct)
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO MODEM

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(3,'ESTUDIANTES CON MESES DE ATRASO = '+;
			   ALLTRIM(STR(nNroMes,2))+' '+;
			   'Y DEUDAS MAYORES O IGUALES A '+;
			   ALLTRIM(TRANS(nVlrInf,"####,###,###")))
       cRegPrint({'CODIGO','GRUPO','SALDO ACTUAL'},{06,04,12,},@aNroCol)
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
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       cError('ABRIENDO DE CLIENTES')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseAll()
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
	       CloseAll()
	       IF !lFileDelete(FileTem)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'�'+;
			'HASTA EL GRUPO: '+cGruFin+'�ESPERE',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL INFORME
	    cMaeAct := cAliasNiv(VAL(SUBS(GRU->cCodigoGru,1,2)))
	    DeudaxMes(lShared,@nNroFil,aNroCol,cMaeAlu,nNroMes,nVlrInf,99999999)
	    CloseDbf('CLI',FileCli,nModCry)
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
       CloseDbf('CLI',FileCli,nModCry)
       CloseAll()
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO

/*************************************************************************
* TITULO..: MOROSOS POR NUMERO DE MESES                                  *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: AGO 05/99 MIE A
       Bucaramanga, Colombia	    INICIO: 11:50 PM   AGO 05/99 MIE

OBJETIVOS:

1- Imprime los mororos por n�mero de meses e intervalo de la deuda.

2- Return el total de la deuda del grupo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MorosoxMes(lShared,nNroFil,aNroCol,cMaeAlu,cMesIni,nMesDeu,nVlrInf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nNroFil                              // @N�mero de la fila
       aNroCol                              // N�mero de Columnas
       cMaeAlu                              // Maestro Habilitados
       cMesIni				    // Mes Inicial del pago
       nMesDeu                              // Meses de Atraso
       nVlrInf                              // Valor de la Deuda */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL nTotMes := 0                   // Total de meses atrasados
       LOCAL lMoroso := .F.                 // .T. Estudiante moroso
       LOCAL cRegTxt := ''                  // Registro Texto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT CLI
       GO TOP
       DO WHILE .NOT. EOF()

**********ANALISIS DE LA DEUDA
	    nTotMes := 0
	    lMoroso := lMoroso(VAL(cMesIni),nMesDeu,@nTotMes,nVlrInf)
**********FIN ANALISIS DE LA DEUDA

**********BUSQUEDA DEL DEL ESTUDIANTE
	    IF lMoroso
	       lSekCodMae(CLI->cCodigoEst,cMaeAlu,@cMaeAct)
	    ENDIF
**********FIN BUSQUEDA DEL DEL ESTUDIANTE

**********PREPARACION DEL REGISTRO ASCII
	    IF lMoroso
	       cRegTxt := SCO->cCodEmpCon+;
			  CLI->cCodigoEst+;
			  cMesIni+;
			  STR(CLI->nSdoActCli,10,2)+;
			  STR(CLI->nSdoMorCli,10,2)+;
			  STR(nTotMes,2)+;
			  &cMaeAct->cNombreEst+;
			  &cMaeAct->cApelliEst+;
			  &cMaeAct->cDireccEst+;
			  &cMaeAct->cBarrioEst+;
			  &cMaeAct->cTelefnEst+;
			  &cMaeAct->cNomPadEst+;
			  &cMaeAct->cPadNitEst+;
			  &cMaeAct->cPadLugEst+;
			  &cMaeAct->cTelPadEst+;
			  &cMaeAct->cNomMadEst+;
			  &cMaeAct->cMadNitEst+;
			  &cMaeAct->cMadLugEst+;
			  &cMaeAct->cTelMadEst+;
			  &cMaeAct->cNomAcuEst+;
			  &cMaeAct->cAcuNitEst+;
			  &cMaeAct->cAcuLugEst+;
			  &cMaeAct->cTe1AcuEst+;
			  &cMaeAct->cTe2AcuEst
	    ENDIF
**********FIN PREPARACION DEL REGISTRO ASCII

**********IMPRESION DE LOS DETALLES DEL PAGO
	    IF lMoroso
	       @ nNroFil,aNroCol[1] SAY CLI->cCodigoEst
	       @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
	       @ nNroFil,aNroCol[3] SAY CLI->nSdoactCli PICT "9999,999.99"
	       @ nNroFil,aNroCol[4] SAY LEN(cRegTxt)
	       nNroFil++
	    ENDIF
**********FIN IMPRESION DE LOS DETALLES DEL PAGO

**********GRABACION DEL REGISTRO
	    IF lMoroso
	       IF COB->(lRegLock(lShared,.T.))
		  REPL COB->cCodigoEst WITH CLI->cCodigoEst
		  REPL COB->nMesIniPag WITH VAL(cMesIni)
		  REPL COB->nMesFinPag WITH VAL(cMesIni)
		  REPL COB->nSdoAntPag WITH CLI->nSdoActCli
		  REPL COB->nMorAntPag WITH CLI->nSdoMorCli
		  REPL COB->lRegGraCob WITH .F.
		  REPL COB->cRegTxtCob WITH cRegTxt
		  COB->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABA EL REGISTRO')
	       ENDIF
	       IF lShared
		  COB->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DEL REGISTRO

**********CONTROL DE LA FILA DE VISUALIZACION
	    IF nNroFil > 20

*--------------VISUALIZACION DEL ULTIMO CLIENTE
		 nNroFil := nMarco(3,'ESTUDIANTES CON MESES DE ATRASO = '+;
				     ALLTRIM(STR(nMesDeu,2))+' '+;
				     'Y DEUDAS MAYORES O IGUALES A '+;
				     ALLTRIM(TRANS(nVlrInf,"####,###,###")))
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
* TITULO DE LA FUNCION..: MOROSO POR NUMERO DE DEUDAS                    *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: MAY 07/96 MAR A
       Colombia, Bucaramanga        INICIO: 12:00 AM   AMY 07/96 MAR

OBJETIVOS:

1)- Analiza si un estudiante es moroso de acuerdo a intervalo de decisi�n
    y el n�mero de meses de atraso.

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lMorMes(nMesDeu,nTotMes,nVlrInf,nVlrSup)

*>>>>DESCRIPCION DE PARAMETROS
/*     nMesDeu			            // N�mero de Meses de atraso
       nTotMes                              // Total del Meses de atraso
       nVlrInf                              // Valor Inferior
       nVlrSup                              // Valor Superior */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nTotDeu := 0                   // Saldo Actual
       LOCAL lMoroso := .F.                 // .T. Estudiante moroso
       LOCAL cForPag := ''                  // Forma de pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA DEUDA
       nTotDeu := CLI->nSdoActCli+CLI->nSdoMorCli
       IF EMPTY(nVlrSup)
	  lMoroso := nTotDeu >= nVlrInf
       ELSE
	  lMoroso := nTotDeu >= nVlrInf .AND. nTotDeu <= nVlrSup
       ENDIF

       cForPag := RTRIM(CLI->cMesPagCli)
       IF lMoroso
	  FOR i := LEN(cForPag) TO 0 STEP -1
	      IF SUBS(cForPag,i,1) == '*' .OR. SUBS(cForPag,i,1) == 'D'
		 IF SUBS(cForPag,i,1) == 'D'
		    nTotMes++
		 ENDIF
	      ELSE
		 EXIT
	      ENDIF
	  ENDFOR

	  IF nTotMes < nMesDeu
	     lMoroso := .F.
	  ENDIF
       ENDIF
       RETURN lMoroso
*>>>>FIN ANALISIS DE LA DEUDA