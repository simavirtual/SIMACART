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

FUNCTION OtMor0771(aParam1,aParam2,aParam3,;
		   cEmpCob,oBrowse,cMesIni)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cEmpCob                              // Empresa de Cobro
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

       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL lHayEst := .F.                 // .T. Existe el Estudiante
       LOCAL lHayCli := .F.                 // .T. Existe el Cliente
       LOCAL lHayPag := .F.                 // .T. Hay Pago
       LOCAL lGrabar := .T.                 // Grabar el Archivo ASCII
       LOCAL cTxtObs := ''                  // Texto de Observaci�n
       LOCAL nNroFil := 0                   // N�mero de la Fila
       LOCAL nNroCol := 0                   // N�mero de la Columna
       LOCAL cTipMor := ''                  // Tipo de Moroso
       LOCAL cNotMor := ''                  // Nota del Moroso
       LOCAL cPasWor := ''                  // Clave de Reporte

       LOCAL nNroArc := 0                   // N�mero del Archivo
       LOCAL cRegTxt := ''                  // Texto del registro
       LOCAL nByeWri := 0                   // Bytes Escritos
       LOCAL lGraReg := .F.                 // Grabar el Registro
       LOCAL lSiPaso := .F.                 // Control de Flujo
       LOCAL Getlist := {}                  // Variable del sistema
     *�Variables espec�ficas 

       LOCAL nMesIniTpa := 0                // Mes Inicial de pago
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

*>>>>VALIDACION DE CONTENIDOS
       lHayErr := .T.
       DO CASE
       CASE EMPTY(CAR->cCodCobCar)
	    cError('DEBE DEFINIR EL CODIGO INTERNO DE COBRO')

       CASE EMPTY(CAR->cPswCobCar)
	    cError('DEBE DEFINIR LA CLAVE PARA REPORTAR')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS

*>>>>VALIDACION DE LA CREACION DEL ARCHIVO
       cSavPan := SAVESCREEN(0,0,24,79)
       cCodEmp := CAR->cCodCobCar

       FileTem := cPatSis+'\COBROS\'+;
		  cCodEmp+cMesIni+'.'+SUBS(cJorTxt,1,1)+cAnoSis
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
       IF .NOT. lInfActMor(lShared,cNomSis,cMaeAlu,CAA->nNomRepCaA)
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN VALIDACION DE LA INFORMACION ACTUALIZADA

*>>>>LECTURA DE LA CLAVE DE REPORTE
       SET COLOR TO W/N,N/N
       cPasWor := SPACE(12)
       TitBuscar(16,@nNroFil,@nNroCol,'CLAVE DE REPORTE','�')
       @ nNroFil,nNroCol GET cPasWor PICT '@X'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)
       SetClrTo()
       IF ALLTRIM(cPasWor) # ALLTRIM(CAR->cPswCobCar)
	  cError('CLAVE DE REPORTE INCORRECTA')
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE LA CLAVE DE REPORTE

*>>>>SELECCION DE TIPO DE MOROSO
       TitBuscar(10,@nNroFil,@nNroCol,,'EVALUACION')
       cTipMor := cLeeTipMor(nNroFil,nNroCol,nNroFil+2,nNroCol-2)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF EMPTY(cTipMor)
	  cError('No Seleciono Ning�n Estudiante SE ABROTA EL PROCESO')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE TIPO DE MOROSO

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  cError('SE ABANDONA EL PROCESO')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>CREACION DEL ARCHIVO
       nNroArc := FCREATE(FileTem,0)
       IF nNroArc == -1
	  cError('NO SE PUEDE CREAR EL ARCHIVO '+FileTem)
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>IMPRESION DEL INFORME PARA CADA GRUPO
       Termometro(0,'GRABANDO LOS REGISTROS')
       Termometro(10)
       SELECT MOR
       GO TOP
       DO WHILE .NOT. MOR->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( MOR->(RECNO()) / MOR->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       Termometro(nAvance)
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('REGISTRO: '+STR(MOR->(RECNO()),5)+'/'+;
				     STR(MOR->(RECCOUNT()),5),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********BUSQUEDA DEL ESTUDIANTE
	    lHayEst := lSekCodMae(MOR->cCodigoEst,cMaeAlu,@cMaeAct)
**********FIN BUSQUEDA DEL ESTUDIANTE

**********ANALISIS DEL TIPO DE MOROSO
	    cNotMor := ''
	    IF lHayEst
	       cNotMor := cNotaCli(MOR->cCodigoEst,;
				   &cMaeAct->cCodigoGru,;
				   ALLTRIM(CAA->cConPenCaA)+;
				   ALLTRIM(&cMaeAct->cConcepEst),;
				   MOR->nSdoActCli+MOR->nSdoMorCli,;
				   TipoMora(MOR->cMesPagCli),;
				   MOR->cMesPagCli)
	    ENDIF
**********FIN ANALISIS DEL TIPO DE MOROSO

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
				&cMaeAct->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
				&cMaeAct->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO DE CLIENTES')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL CODIGO
	    lHayCli := lLocCodigo('cCodigoEst','CLI',MOR->cCodigoEst)
	    IF !lHayCli
	       cTxtObs := 'EL CODIGO '+MOR->cCodigoEst+;
			  ' NO EXISTE EN LOS CLIENTES '+;
			  'DEL GRUPO: '+&cMaeAct->cCodigoGru
	       cError(cTxtObs)
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********ANALISIS SI ES EL MES ACTUAL
	    IF nMesIniTpa < LEN(RTRIM(CLI->cMesPagCli))
	       nMesIniTpa := VAL(cMesIni)
	    ELSE
	       nMesIniTpa := LEN(RTRIM(CLI->cMesPagCli))
	    ENDIF
**********FIN ANALISIS SI ES EL MES ACTUAL

**********LOCALIZACION DEL PAGO
	    lHayPag := lLocCodPag(MOR->cCodigoEst,nMesIniTpa,.F.)
	    IF !lHayPag
	       cTxtObs := 'NO EXISTE RECIBO DE PAGO DEL MES DE '+;
			  cMes(nMesIniTpa)
	       cError(cTxtObs)
	    ENDIF
**********FIN LOCALIZACION DEL PAGO

**********ANALISIS SI EL CLIENTE PERTENCE AL GRUPO
	    IF lHayCli .AND. CLI->lRetGruCli
	       cTxtObs := 'EL CODIGO '+MOR->cCodigoGru+;
			  ' NO PERTENCE AL GRUPO: '+&cMaeAct->cCodigoGru
	       cError(cTxtObs)
	    ENDIF
**********FIN ANALISIS SI EL CLIENTE PERTENCE AL GRUPO

**********ANALISIS PARA REPORTAR A LA CENTRAL DE RIESGO
	    lGraReg := .F.
	    IF (lHayEst .AND. lHayCli .AND. lHayPag .AND.;
		MOR->lInfActMor .AND.;
		(CLI->nSdoActCli+CLI->nSdoMorCli # 0) .AND.;
		MOR->lSiRepoMor .AND. cNotMor $ cTipMor) .OR.;
		!EMPTY(MOR->cHayRepCli)

*--------------GRABACION DE LA CABECERA DEL ARCHIVO
		 IF .NOT. lSiPaso
		    SET DATE FORMAT "DD/MM/YYYY"
		    cRegTxt := cComillas(ALLTRIM(CAR->cPswCobCar))+','+;
			       cComillas(DTOC(DATE()))+;
			       CHR(13)+CHR(10)
		    SET DATE FORMAT "MM/DD/YYYY"

		    nByeWri := FWRITE(nNroArc,cRegTxt,LEN(cRegTxt))
		    IF nByeWri # LEN(cRegTxt)
			cError('GRABACION DE LA CABECERA')
			EXIT
		    ENDIF
		 ENDIF
*--------------FIN GRABACION DE LA CABECERA DEL ARCHIVO

*--------------GRABACION DE LAS PERSONAS A REPORTAR
		 FOR i := 1 TO CAA->nNomRepCaA

*...................GRABACION DEL REGISTRO ASCII
		      cRegTxt := cRegLexcom(i,cMaeAct)+;
				 CHR(13)+CHR(10)
		      nByeWri := FWRITE(nNroArc,cRegTxt,LEN(cRegTxt))
		      IF nByeWri # LEN(cRegTxt)
			 cError('GRABACION DEL REGISTRO')
			 EXIT
		      ENDIF
		      lSiPaso := .T.
		      lGraReg := .T.
*...................FIN GRABACION DEL REGISTRO ASCII

		 ENDFOR
*--------------FIN GRABACION DE LAS PERSONAS A REPORTAR

	    ENDIF
**********FIN ANALISIS PARA REPORTAR A LA CENTRAL DE RIESGO

**********GRABACION DEL CONTROL DEL REPORTE
	    IF lGraReg
	       IF PAG->(lRegLock(lShared,.F.))
		  REPL PAG->nNomFacEst WITH &cMaeAct->nNomFacEst
		  REPL PAG->nNomRepCaA WITH CAA->nNomRepCaA
		  REPL PAG->dFecRepMor WITH DATE()
		  PAG->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABA EL REGISTRO')
	       ENDIF
	       IF lShared
		  PAG->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DEL CONTROL DEL REPORTE

**********OBSERVACION DEL REPORTADO
	    IF lGraReg
	       IF EMPTY(MOR->cHayRepCli)
		  cTxtObs := 'REPORTADO '+cTipNomRep(&cMaeAct->nNomFacEst)+;
			     IF(!EMPTY(cEmpCob),' A '+ALLTRIM(cEmpCob),'')
	       ELSE
		  cTxtObs := 'ACTUALIZADO '+;
			     cTipNomRep(&cMaeAct->nNomFacEst)+;
			     IF(!EMPTY(cEmpCob),' A '+ALLTRIM(cEmpCob),'')
	       ENDIF
	    ENDIF
**********FIN OBSERVACION DEL REPORTADO

**********GRABACION DEL CHEQUEO DEL REGISTRO
	    IF MOR->(lRegLock(lShared,.F.))
	       IF lGraReg
		  REPL MOR->dFecRepMor WITH DATE()
		  REPL MOR->cObservMor WITH cTxtObs
		  IF CLI->nSdoActCli+CLI->nSdoMorCli == 0
		     REPL MOR->lPagRecMor WITH .T.
		     REPL MOR->lHayRepMor WITH .F.
		  ELSE
		     REPL MOR->lHayRepMor WITH .T.
		  ENDIF
	       ELSE
		  REPL MOR->lHayRepMor WITH .F.
		  REPL MOR->cObservMor WITH 'no reportado'
	       ENDIF
	       MOR->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       MOR->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL CHEQUEO DEL REGISTRO

**********GRABACION DEL CONTROL DEL REPORTE
	    IF lGraReg
	       IF CLI->(lRegLock(lShared,.F.))
		  REPL CLI->cHayRepCli WITH STR(nMesIniTpa,2)+;
					    STR(&cMaeAct->nNomFacEst,1,0)+;
					    STR(CAA->nNomRepCaA,1,0)+;
					    SPACE(01)
		  CLI->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABA EL REGISTRO')
	       ENDIF
	       IF lShared
		  CLI->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DEL CONTROL DEL REPORTE

	  CloseDbf('CLI',FileCli,nModCry)
	  CloseDbf('PAG',FilePag,nModCry)
	  MOR->(DBSKIP())

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       SELECT MOR
       IF !EMPTY(oBrowse)
	  MOR->(DBGOTOP())
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO


FUNCTION cRegLexcom(nNomRep,cMaeAct,cNroNit)

*>>>>DESCRIPICON DE PARAMETROS
/*     nNomRep				    // Nombre a Reportar
       cMaeAct                              // Maestro Actual
       cNroNit                              // @Numero del Documento */
*>>>>FIN DESCRIPICON DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cTxtChr := ''                  // Texto Ascii
       LOCAL cApelli := ''                  // Apellidos
       LOCAL cNombre := ''                  // Nombres
       LOCAL nNomFac := 0                   // Nombre de la Factura
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DEL REGISTRO
       cNroNit := ''
       DO CASE
       CASE nNomRep == 1                    // Padre,Madre,Acudiente

	    nNomFac := &cMaeAct->nNomFacEst
	    DO CASE
	    CASE nNomFac == 0 .OR. nNomFac == 1  // Padre

		 cNroNit := &cMaeAct->cPadTntEst+' '+&cMaeAct->cPadNitEst

		 cTxtChr:=cCamLexcom(&cMaeAct->cApePadEst,30)+','+;
			  cCamLexcom(&cMaeAct->cNomPadEst,30)+','+;
			  cCamLexcom(&cMaeAct->cPadTntEst,3)+','+;
			  cCamLexcom(&cMaeAct->cPadNitEst,11)+','+;
			  cCamLexcom(&cMaeAct->cCiudadEst,27)+','+;
			  cCamLexcom(RTRIM(&cMaeAct->cDireccEst)+' '+;
				     RTRIM(&cMaeAct->cBarrioEst),40)+','+;
			  cCamLexcom(&cMaeAct->cTelefnEst,17)+','+;
			  cCamLexcom(RTRIM(&cMaeAct->cDirPadEst)+' '+;
				     RTRIM(&cMaeAct->cBarPadEst),40)+','+;
			  cCamLexcom(&cMaeAct->cTelPadEst,17)+','+;
			  cCamLexcom(STR(MOR->nSdoActCli+;
					 MOR->nSdoMorCli,8,0))+','+;
			  cCamLexcom(TipoMora(MOR->cMesPagCli))+','+;
			  cCamLexcom('1')+','+;
			  cCamLexcom(RTRIM(&cMaeAct->cApelliEst)+' '+;
				     RTRIM(&cMaeAct->cNombreEst),40)+','+;
			  cCamLexcom(&cMaeAct->cCodigoGru)+','+;
			  IF(MOR->lNtfCobCar,cComillas("SI"),;
					     cComillas("NO"))+','+;
			  IF(MOR->lNtfCobCar,cCamLexcom(MOR->cTipNtfCar),;
					     cComillas("NINGUNO"))

	    CASE nNomFac == 2  // Madre

		 cNroNit := &cMaeAct->cMadTntEst+' '+&cMaeAct->cMadNitEst

		 cTxtChr:=cCamLexcom(&cMaeAct->cApeMadEst,30)+','+;
			  cCamLexcom(&cMaeAct->cNomMadEst,30)+','+;
			  cCamLexcom(&cMaeAct->cMadTntEst,3)+','+;
			  cCamLexcom(&cMaeAct->cMadNitEst,11)+','+;
			  cCamLexcom(&cMaeAct->cCiudadEst,27)+','+;
			  cCamLexcom(RTRIM(&cMaeAct->cDireccEst)+' '+;
				     RTRIM(&cMaeAct->cBarrioEst),40)+','+;
			  cCamLexcom(&cMaeAct->cTelefnEst,17)+','+;
			  cCamLexcom(RTRIM(&cMaeAct->cDirMadEst)+' '+;
				     RTRIM(&cMaeAct->cBarMadEst),40)+','+;
			  cCamLexcom(&cMaeAct->cTelMadEst,17)+','+;
			  cCamLexcom(STR(MOR->nSdoActCli+;
					 MOR->nSdoMorCli,8,0))+','+;
			  cCamLexcom(TipoMora(MOR->cMesPagCli))+','+;
			  cCamLexcom('1')+','+;
			  cCamLexcom(RTRIM(&cMaeAct->cApelliEst)+' '+;
				     RTRIM(&cMaeAct->cNombreEst),40)+','+;
			  cCamLexcom(&cMaeAct->cCodigoGru)+','+;
			  IF(MOR->lNtfCobCar,cComillas("SI"),;
					     cComillas("NO"))+','+;
			  IF(MOR->lNtfCobCar,cCamLexcom(MOR->cTipNtfCar),;
					     cComillas("NINGUNO"))

	    CASE nNomFac == 3  // Acudiente

		 cNroNit := &cMaeAct->cAcuTntEst+' '+&cMaeAct->cAcuNitEst

		 cTxtChr:=cCamLexcom(&cMaeAct->cApeAcuEst,30)+','+;
			  cCamLexcom(&cMaeAct->cNomAcuEst,30)+','+;
			  cCamLexcom(&cMaeAct->cAcuTntEst,3)+','+;
			  cCamLexcom(&cMaeAct->cAcuNitEst,11)+','+;
			  cCamLexcom(&cMaeAct->cCiudadEst,27)+','+;
			  cCamLexcom(RTRIM(&cMaeAct->cDireccEst)+' '+;
				     RTRIM(&cMaeAct->cBarrioEst),40)+','+;
			  cCamLexcom(&cMaeAct->cTelefnEst,17)+','+;
			  cCamLexcom(RTRIM(&cMaeAct->cDirAcuEst)+' '+;
				     RTRIM(&cMaeAct->cBarAcuEst),40)+','+;
			  cCamLexcom(&cMaeAct->cTe1AcuEst,17)+','+;
			  cCamLexcom(STR(MOR->nSdoActCli+;
					 MOR->nSdoMorCli,8,0))+','+;
			  cCamLexcom(TipoMora(MOR->cMesPagCli))+','+;
			  cCamLexcom('1')+','+;
			  cCamLexcom(RTRIM(&cMaeAct->cApelliEst)+' '+;
				     RTRIM(&cMaeAct->cNombreEst),40)+','+;
			  cCamLexcom(&cMaeAct->cCodigoGru)+','+;
			  IF(MOR->lNtfCobCar,cComillas("SI"),;
					     cComillas("NO"))+','+;
			  IF(MOR->lNtfCobCar,cCamLexcom(MOR->cTipNtfCar),;
					     cComillas("NINGUNO"))

	    ENDCASE

       CASE nNomRep == 2                    // Primer Fiador
       CASE nNomRep == 3                    // Segundo Fiador
       ENDCASE
       RETURN cTxtChr
*>>>>FIN CREACION DEL REGISTRO


FUNCTION cCamLexcom(cTxtTem,nLenTxt)

*>>>>DESCRIPCION DE PARAMETROS
/*     cTxtTem                              // Texto a ASCII
       nLenTxt                              // Longitud del Texto */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>VALIDACION DE CONTENIDO
       IF EMPTY(cTxtTem)
	  cTxtTem := 'NO ESPECIFICADO'
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDO

*>>>>VALIDACION DE LONGITUD
       IF .NOT. EMPTY(nLenTxt)
	  cTxtTem := SUBS(cTxtTem+SPACE(nLenTxt),1,nLenTxt)
       ENDIF
       RETURN cComillas(ALLTRIM(cTxtTem))

       FUNCTION cComillas(cTxtTem)
       RETURN '"'+cTxtTem+'"'
*>>>>FIN VALIDACION DE LONGITUD

