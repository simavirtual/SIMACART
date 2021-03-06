/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : DESCUENTOS/RECARGOS
SUBMODULO...: IMPRIMIR NO ACTIVADOS     MODULO No. 544

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE402.PRG                                    *
* TITULO DEL PROGRAMA..: ESTUDIANTES NO ACTIVADOS                        *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: FEB 19/98 JUE A
       Bucaramanga, Colombia        INICIO: 09:00 PM   FEB 19/98 JUE

REQUERIMIENTOS:

1- Para ejecutar la funci�n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir que no estan activados para aplicarles descuentos o
   recargos generales para un mes espec�fico.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_544(aParam1,aParam2,aParam3)

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
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL lAnoAct := .T.                 // A�o Actual
       LOCAL nNroAct := 0                   // N�mero de No Activos
       LOCAL nNroMes := 0                   // N�mero del Mes

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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
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


*>>>>CAPTURA DEL MES A PAGAR
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroMes := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			  'Mes del Descuento o Recargo General',.T.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroMes == 0
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>CONTEO DE LOS ESTUDIANTES MOROSOS
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'CONTANDO ESTUDIANTES')
       nTotReg := nCountActi(lShared,nModCry,cPatSis,cAnoUsr,cIntUno,cMaeAlu,nNroMes)
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nTotReg == 0
	  cError('NO APARECEN ESTUDIANTES DESACTIVADOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       nTotReg := nTotReg+((nRegFin-nRegIni+1)*nLinTot)+nLinTot
*>>>>FIN CONTEO DE LOS ESTUDIANTES MOROSOS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := nTotReg+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'RELACION DE NO ACTIVADOS PARA EL MES '+cMes(nNroMes,10)+;
		   ' JORNADA: '+cJorTxt,;
		   '',;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,02,06,06,20,20}
       aTitulo := {'##',;
		   'No',;
		   'CODIGO',;
		   'GRUPO ',;
		   'APELLIDOS Y NOMBRES ',;
		   SPACE(20)}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .T.
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

*>>>>PREGUNTA DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll(aUseDbf)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
*>>>>FIN PREGUNTA DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       ActivaPrn(lSiRed,cNomSis,PathSis,fSimCar,'cColaAcCar','Car',,nModCry)
       IF !Printer_on()
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi�n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

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
*---------------FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

*---------------SELECION DE LAS AREAS DE TRABAJO
		  IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
		     cError('ABRIENDO DE CLIENTES')
		     CloseDbf('CLI',FileCli,nModCry)
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

*---------------IMPRESION DEL INFORME
		  ActivosPrn(cNomEmp,cNomSis,cAnoUsr,lAnoAct,cJorTxt,;
			     GRU->cCodigoGru,cNalias,nColCab,aTitulo,;
			     aNroCol,bPagina,bDerAut,bCabeza,@nNroAct,;
			     nNroMes)
		  CloseDbf('CLI',FileCli,nModCry)
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

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       cSavPan := SAVESCREEN(0,0,24,79)
       CloseDbf('CLI',FileCli,nModCry)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

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

FUNCTION ActivosPrn(cNomEmp,cNomSis,cAnoUsr,lAnoAct,cJorTxt,;
		    cCodGru,cMaeAlu,nColCab,aTitulo,aNroCol,;
		    bPagina,bDerAut,bCabeza,nNroAct,nNroMes)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A�o del sistema
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
       nNroAct				    // N�mero de Becados
       nNroMes                              // N�mero del mes */
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

       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL lHayAlu := .T.                 // .T. Existe alumno
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nLinTot := 2                   // L�neas totales de control
       LOCAL cTxtPrn := ''                  // Texto de impresi�n
       LOCAL nVlrMes := 0                   // Valor del Mes
       LOCAL nVlrBec := 0                   // Valor de la Beca
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

**********ANALISIS SI EL STUDIANTE ESTA ACTIVADO
	    IF SUBS(CLI->cHayNovCli,nNroMes,1) = '1'
	       CLI->(DBSKIP())
	       IF CLI->(EOF())
		  SET DEVICE TO SCREEN
		  Termometro(100)
		  SET DEVICE TO PRINT
	       ENDIF
	       LOOP
	    ENDIF
	    nNroAct++
**********FIN ANALISIS SI EL STUDIANTE ESTA ACTIVADO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    lHayAlu := lSekCodMae(CLI->cCodigoEst,cMaeAlu,@cNalias,.F.)
	    IF lHayAlu
	       cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			     RTRIM(&cNalias->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(20),1,20)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS SI ESTUDIANTE ESTA RETIRADO
	    lRetadoTes := .F.
	    IF lHayAlu
	       IF &cNalias->lRetiroEst
		  lRetadoTes := .T.
	       ENDIF
	    ENDIF
**********FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aTitulo := {STR(nNroAct,4),;
			STR(CLI->(RECNO()),2),;
			CLI->cCodigoEst,;
			&cNalias->cCodigoGru,;
			SPACE(01)+SUBS(cNombreTes,1,19),;
			IF(&cNalias->lRetiroEst,'RETIRADO',SPACE(20))}
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
       RETURN NIL
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*******

FUNCTION nCountActi(lShared,nModCry,cPatSis,cAnoUsr,cIntUno,cMaeAlu,nNroMes)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci�n
       cPatSis                              // Path del sistema
       cAnoUsr                              // A�o del Usuario
       cIntUno                              // Path de integraci�n uno
       cMaeAlu                              // Maestros habilitados
       nNroMes                              // N�mero del Mes */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL lAnoAct := .F.                 // .T. A�o Actual
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A�o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nNroAct := 0                   // N�mero de Becados
       LOCAL       i := 0                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS PARA CADA NIVEL
       FOR i := 1 TO LEN(cMaeAlu)/3

***********SELECION DE LAS AREAS DE TRABAJO
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	     IF !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis,lAnoAct)
		cError('ABRIENDO EL ARCHIVO DE GRUPOS')
		CloseAll()
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
		     CloseAll()
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
		       IF SUBS(CLI->cHayNovCli,nNroMes,1) = '0'
			  nNroAct++
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
       CloseDbf('CLI',FileCli,nModCry)
       CloseAll()
       RETURN nNroAct
*>>>>FIN ANALISIS PARA CADA NIVEL

