/*************************************************************************
* TITULO ..: GRABACION DEL ARCHIVO ASCII                                 *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: AGO 18/99 MIE A
       Colombia, Bucaramanga        INICIO: 10:00 PM   AGO 18/99 MIE

OBJETIVOS:

1- Crea el archivo ASCII con los registros de los estudiantes que van
   para cobro.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrCob022(aParam1,aParam2,aParam3,;
		   oBrowse,cMesIni)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo
       cMesIni                              // Mes Inical del pago */
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

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL lGrabar := .T.                 // Grabar el Archivo ASCII
       LOCAL nNroArc := 0                   // N�mero del Archivo
       LOCAL cRegTxt := ''                  // Texto del registro
       LOCAL nByeWri := 0                   // Bytes Escritos

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

*>>>>VALIDACION DE LA CREACION DEL ARCHIVO
       cSavPan := SAVESCREEN(0,0,24,79)
       cCodEmp := SCO->cCodEmpCon
       lCorrecion(@cCodEmp)

       FileTem := cPatSis+'\COBROS\'+;
		  cCodEmp+cAnoUsr+cMesIni+'.'+SUBS(cJorTxt,1,3)
       lGrabar := .T.
       IF File(FileTem)
	  lGrabar := .F.
	  cError('EL ARCHIVO YA ESTA CREADO')
	  IF lPregunta('DESEA VOLVER A GRABARLO? Si No')
	     lGrabar := .T.
	  ENDIF
       ENDIF
       IF .NOT. lGrabar
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LA CREACION DEL ARCHIVO

*>>>>VALIDACION DE LA INFORMACION ACTUALIZADA
       IF .NOT. lInfActCob(lShared)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LA INFORMACION ACTUALIZADA

*>>>>CREACION DEL ARCHIVO
       nNroArc := FCREATE(FileTem,0)
       IF nNroArc == -1
	  cError('NO SE PUEDE CREAR EL ARCHIVO '+FileTem)
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>IMPRESION DEL INFORME PARA CADA GRUPO
       Termometro(0,'GRABANDO LOS REGISTROS')
       SELECT COB
       GO TOP
       DO WHILE .NOT. COB->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( COB->(RECNO()) / COB->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       Termometro(nAvance)
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('REGISTRO: '+STR(COB->(RECNO()),5)+'/'+;
				     STR(COB->(RECCOUNT()),5),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********GRABACION DEL REGISTRO ASCII
	    cRegTxt := COB->cRegTxtCob+CHR(13)+CHR(10)
	    nByeWri := FWRITE(nNroArc,cRegTxt,LEN(cRegTxt))
	    IF nByeWri # LEN(cRegTxt)
	       cError('GRABACION INCORRECTA')
	       EXIT
	    ENDIF
**********FIN GRABACION DEL REGISTRO ASCII

**********GRABACION DEL CHEQUEO DEL REGISTRO
	    IF COB->(lRegLock(lShared,.F.))
	       REPL COB->lRegGraCob WITH .T.
	       COB->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       COB->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL CHEQUEO DEL REGISTRO

	  COB->(DBSKIP())

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       IF !EMPTY(oBrowse)
	  COB->(DBGOTOP())
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO

