/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO     : OTROS
SUBMODULO..: CAFETERIA

**************************************************************************
* TITULO..: MENU DE CAFETERIA                                            *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: JUN 30/2005 JUE A
       Bucaramanga, Colombia        INICIO: 04:00 PM   JUN 30/2005 JUE

OBJETIVOS:

1- Visualiza un men� para la cafeteria

2- Ejecuta las diferentes funciones.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_603(aParam1,aParam2,aParam3)

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

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men�
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men�

       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi�n.
       LOCAL nCodPrn := 0                   // C�digo de Impresi�n
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql

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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO LOS ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       lPrnArc := SCA->lPrnArcCar
       nCodPrn := SCA->nCodigoPrn
       cOpcPrn := SCA->cOpcPrnCar
       CloseAll()
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DECLARACION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

       AADD(aMenus,"1<ASIGNAR CONCEPTOS    >")
       AADD(aMenus,"2<CONCEPTOS RESTAURANTE>")
       AADD(aMenus,"3<RESTAURANTE PERSONAL >")
       AADD(aMenus,"4<CONSULTA DE NOVEDEDAS>")

       AADD(aAyuda,'Permite asignar conceptos de Cafeteria a los Estudiantes')
       AADD(aAyuda,'Permite Consultar los Conceptos del Restaurante')
       AADD(aAyuda,'Permite Habilitar el Servicio de Restaurante al Personal del Colegio')
       AADD(aAyuda,'Permite Consultar las Novedades de Cafeteria')
*>>>>FIN DECLARACION Y EJECUCION DEL MENU

*>>>>VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA
       nLenOpc := LEN(aMenus[1])
      *Calculo de la Longitud mayor

       IF nColInf + nLenOpc + 2 > 78
	  nColInf := 78-nLenOpc-3
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf-1,nColInf+3,NIL,NIL,nNroOpc,.F.)

	  RESTSCREEN(0,0,24,79,cSavPan)
	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       Carte_621(aParam1,aParam2,aParam3,;
			 2)
	      *Asignar Conceptos de Cafeteria


	  CASE nNroOpc == 2
	       Carte_632(aParam1,aParam2,aParam3,;
			 2)
	      *Conceptos Cafeteria

	  CASE nNroOpc == 3
	       Carte_633(aParam1,aParam2,aParam3)
	      *Restaurante Personal

	  CASE nNroOpc == 4
	       Carte_634(aParam1,aParam2,aParam3)
	      *Novedades de Cafeteria


	  ENDCASE
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA