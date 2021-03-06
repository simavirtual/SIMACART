/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS
SUBMODULO...: COBROS                                   MODULO No. 208

**************************************************************************
* TITULO..: REPORTE DE MOROSOS                                           *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: ABR 03/2001 MAR A
       Colombia, Bucaramanga        INICIO: 10:25 AM   ABR 03/2001 MAR

REQUERIMIENTOS:

1- Para ejecutar la funci�n tener presente la sintaxis

OBJETIVOS:

1- Visualiza el men� el reporte de los Morosos

2- Ejecuta las diferentes opciones del menu.

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_409(aParam1,aParam2,aParam3,;
		   cEmpCob)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cEmpCob                              // Empresa de Cobro de la Cartera */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci�n uno
       LOCAL cIntDos := ''                  // Path de integraci�n dos
       LOCAL cIntTre := ''                  // Path de integraci�n tres
       LOCAL cIntCua := ''                  // Path de integraci�n cuatro

       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men�
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men�

       LOCAL GetList := {}                  // Variable del Sistema
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

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)
       aMenus := {'1<RELACION DE MOROSOS >',;
		  '2<RETIRO DE REPORTADOS>'}

       aAyuda := {'Permite Relacionar los Morosos a Reportar',;
		  'Permite Retirar los Reportados a la Central de Riesgo'}
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,nNroOpc,.F.)

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       RESTSCREEN(0,0,24,79,cSavPan)
	       MantenMor(aParam1,aParam2,aParam3,;
			 cEmpCob)
	      *Mantenimiento de Morosos

	  CASE nNroOpc == 2
	       RESTSCREEN(0,0,24,79,cSavPan)
	       ManRetMor(aParam1,aParam2,aParam3,;
			 cEmpCob)
	      *Mantenimiento de Retiro de Reportados

	  ENDCASE

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA