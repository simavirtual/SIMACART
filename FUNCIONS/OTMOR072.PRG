/*************************************************************************
* TITULO ..: COPIA EL ARCHIVO A DRIVE                                    *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: AGO 18/99 MIE A
       Colombia, Bucaramanga        INICIO: 10:00 PM   AGO 18/99 MIE

OBJETIVOS:

1- Copia el Archivo ASCII a un Drive

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtMor0772(aParam1,aParam2,aParam3,;
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

       LOCAL cPasWor := ''                  // Clave de Reporte
       LOCAL nNroFil := 0                   // N�mero de Fila
       LOCAL nNroCol := 0                   // N�mero de Columna

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

*>>>>LECTURA DE LA CLAVE DE REPORTE
       cSavPan := SAVESCREEN(0,0,24,79)
       SET COLOR TO W/N,N/N,N
       cPasWor := SPACE(12)
       TitBuscar(16,@nNroFil,@nNroCol,'CLAVE DE REPORTE','�')
       @ nNroFil,nNroCol GET cPasWor PICT '@X'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)
       SET COLOR TO
       IF ALLTRIM(cPasWor) # ALLTRIM(CAR->cPswCobCar)
	  cError('CLAVE DE REPORTE INCORRECTA')
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE LA CLAVE DE REPORTE

*>>>>VALIDACION DE LA UNIDAD
       cSavPan := SAVESCREEN(0,0,24,79)
       cPatSis := cPatSis+'\COBROS\'

       FileTem := CAR->cCodCobCar+cMesIni+'.'+SUBS(cJorTxt,1,1)+cAnoSis

       lHayErr := .T.
       DO WHILE lHayErr

	  DO CASE
	  CASE .NOT. FILE(cPatSis+FileTem)
	       cError('No se ha creado el Archivo ASCII respectivo')

	  CASE .NOT. DISKREADY("A")
	       cError('Inserte un Diskette en la Unidad A')

	  CASE .NOT. DISKREADYW("A")
	       cError('El Diskette est� protegido contra escritura')

/*
	  CASE DISKFREE("A") # DISKTOTAL("A")
	       cError('El Diskette debe estar vacio para poder copiar el archivo')
*/

	  CASE FILESIZE(cPatSis+FileTem) >= DISKTOTAL("A")
	       cError('El tama�o del Archivo es mayor que la capacidad del Diskette')

	  OTHERWISE
	       lHayErr := .F.
	  ENDCASE

	  IF lHayErr
	     IF !lPregunta('DESEA CONTINUAR? Si No')
		cError('SE CANCELE LA COPIA DEL ARCHIVO')
		RETURN NIL
	     ENDIF
	     LOOP
	  ENDIF

       ENDDO
*>>>>FIN VALIDACION DE LA UNIDAD

*>>>>COPIA DEL ARCHIVO
       IF FILECOPY(cPatSis+FileTem,;
		   'A:\'+FileTem) == FILESIZE(cPatSis+FileTem)
	  cError('Copia exitosa')
       ELSE
	  cError('No se copio con Exito el Archivo')
       ENDIF

       RESTSCREEN(0,0,24,79,cSavPan)
       IF !EMPTY(oBrowse)
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
       RETURN NIL
*>>>>FIN COPIA DEL ARCHIVO
