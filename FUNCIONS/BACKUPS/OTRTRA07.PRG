/*************************************************************************
* TITULO ..: LECTURA DEL ARCHIVO DE PAGOS MENSUAL.                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 15/99 MAR A
       Colombia, Bucaramanga        INICIO: 03:20 PM   JUN 15/99 MAR

OBJETIVOS:

1- Lee el archivo ascii generado por el Banco o Coorporaci¢n
   correspondiente al mes de pago.

2- Retorna Nil

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrTra077(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse,cModem,cNroDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo
       cModem                               // Banco de la Gerencia
       cNroDia                              // N£mero del D¡a */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL cNomArc := ''                  // Nombre del archivo
       LOCAL PathAct := ''                  // Paht Actual
       LOCAL nVlrDec := 0                   // Valor Decimal

       LOCAL nMesIni := 0                   // Mes del pago
       LOCAL cCodRef := ''                  // C¢digo de la Referencia
       LOCAL cCodTra := ''                  // C¢digo de la transaci¢n
       LOCAL nValor  := 0                   // Valor de la Transaci¢n
       LOCAL dFecha  := CTOD('00/00/00')    // Fecha de Pago
       LOCAL lSumar := .F.                  // .T. Credito .F. Debito
       LOCAL cSigTra := ''                  // Signo de la transaci¢n
       LOCAL nSumar  := 0                   // 0 = Indefinido 1 => Credito 2=> Debito
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTtr := ''               // C¢digo de la Transaci¢n
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL nValorTtr  := 0                // Valor de la Transaci¢n
       LOCAL dFechaTtr  := CTOD('00/00/00') // Fecha de la Transaci¢n
       LOCAL nMesIniTtr := 0                // Mes Inicial
       LOCAL nMesFinTtr := 0                // Mes Final
       LOCAL cNroCtaTtr := ''               // N£mero de la Cuenta
       LOCAL cValCtaTba := ''               // N£mero de la Cuenta a validar
       LOCAL cOficinTtr := ''               // Oficina de la Trnasacci¢n
       LOCAL cTerOfiTtr := ''               // Terminal de la Oficina
       LOCAL cTalonTtr  := ''               // Talon de la Transaci¢n
       LOCAL cJornadTtr := ''               // Jornada de pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

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

*>>>>PREPARACION DE VARIABLES DE ARCHIVO
       IF !EMPTY(cNroDia)
	  FileTra := cAnoUsr+cNroMes+cNroDia+ExtFile
	  fNtxTra := cAnoUsr+cNroMes+cNroDia+cExtNtx
       ELSE
	  cNroDia := ''
	  FileTra := 'PA'+cAnoUsr+cNroMes+ExtFile
	  fNtxTra := 'PA'+cAnoUsr+cNroMes+cExtNtx
       ENDIF
*>>>>FIN PREPARACION DE VARIABLES DE ARCHIVO

*>>>>ACTIVACION DEL CURSOR
       IF !EMPTY(oBrowse)
	  SETCURSOR(1)
       ENDIF
*>>>>FIN ACTIVACION DEL CURSOR

*>>>>LECTURA DEL DIRECTORIO DEL ARCHIVO DE PAGOS
       cNomArc := SPACE(99)
       cSavLin := SAVESCREEN(nFilInf+1,00,nFilInf+2,79)
       @ nFilInf+1,nColInf SAY "POR FAVOR ENTRE EL NOMBRE DEL ARCHIVO "+;
			       "DE PAGOS DE "+;
			       cMes(VAL(cNroMes),10)+;
			       IF(EMPTY(cNroDia),'',' '+cNroDia)+':'
       DO WHILE .T.

**********LECTURA DEL ARCHIVO
	    @ nFilInf+2,nColInf GET cNomArc PICT "@!S50"
	    READ
**********FIN LECTURA DEL ARCHIVO

**********VALIDACION DEL ARCHIVO
	    DO CASE
	    CASE EMPTY(cNomArc)
		 RESTSCREEN(nFilInf+1,00,nFilInf+2,79,cSavLin)
		 RETURN NIL

	    CASE !FILE(ALLTRIM(cNomArc))
		 cError('NO EXISTE EL ARCHIVO '+ALLTRIM(cNomArc))
		 LOOP

	    OTHERWISE
		 IF !lPregunta('DESEA CORREGIR? No Si')
		    EXIT
		 ENDIF
	    ENDCASE
**********FIN VALIDACION DEL ARCHIVO

       ENDDO
       RESTSCREEN(nFilInf+1,00,nFilInf+2,79,cSavLin)
*>>>>FIN LECTURA DEL DIRECTORIO DEL ARCHIVO DE PAGOS

*>>>>VERIFICACION O CREACION DEL DIRECTORIO MODEM
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (cPatSis+"\MODEM\"+BAN->cCodigoBan) == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+"\MODEM\"+BAN->cCodigoBan) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO MODEM")
	    QUIT

       CASE DIRCHANGE(cPatSis+"\MODEM\"+BAN->cCodigoBan) == -3
	    DIRMAKE(cPatSis+"\MODEM\"+BAN->cCodigoBan)
       ENDCASE
       DIRCHANGE(PathAct)
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO MODEM

*>>>>CREACION DEL ARCHIVO DE TRANSACIONES
       CloseDbf('TRA',cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
		FileTra,nModCry)
       cNomArc := ALLTRIM(cNomArc)

       CreaDbfTra(lShared,nModCry,;
		  cPatSis+'\MODEM\'+BAN->cCodigoBan,FileTra)
      *Creaci¢n de archivo de trasaciones
*>>>>FIN CREACION DEL ARCHIVO DE TRANSACIONES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
		   FileTra,'TRA',NIL,lShared,nModCry)

	  cError('ERROR ABRIENDO ARCHIVOS')
	  CloseDbf('TRA',cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
		   FileTra,nModCry)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>CONVERSION DEL ARCHIVO ASCII
       Termometro(0,'LEYENDO EL ARCHIVO')
       Termometro(20)
       SELECT TRA
       APPEND FROM &cNomArc SDF
       Termometro(50)
*>>>>FIN CONVERSION DEL ARCHIVO ASCII

*>>>>VALIDACION DE LA CUENTA
       cNroCtaTtr := ''
       IF !EMPTY(BAN->cValCtaBan)

	  TRA->(DBGOTOP())
	  TRA->(DBGOTO(2)) // Salta el Registro de Control si existe

	  cNroCtaTtr := ALLTRIM(SUBS(TRA->Registro,BAN->nNroCtaBan,BAN->nLenCtaBan))
	  cValCtaTba := ALLTRIM(SUBS(BAN->cValCtaBan,1,BAN->nLenCtaBan))

	  IF cNroCtaTtr # cValCtaTba
	     cError(cNroCtaTtr+' NUMERO DE CUENTA ERRONEA')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DE LA CUENTA

*>>>>CONVERSION DEL ARCHIVO A LOS RESPECTIVOS CAMPOS
       SELECT TRA
       GO TOP
       DO WHILE .NOT. TRA->(EOF())


**********LECTURA DE LOS RESPECTIVO CAMPOS
	    cCodRef := cCodRef(TRA->Registro)

	    cCodigoTes := SUBS(cCodRef,1,06)
	    nMesIniTtr := VAL(SUBS(cCodRef,7,2))
	    nMesFinTtr := VAL(SUBS(cCodRef,9,2))

	    nVlrDec := 0
	    IF !EMPTY(BAN->nPagDecBan)
	       nVlrDec := VAL(SUBS(TRA->Registro,BAN->nPagDecBan,;
						 BAN->nLenDecBan))/100
	    ENDIF
	    nValorTtr  := VAL(SUBS(TRA->Registro,;
				   BAN->nPagIntBan,;
				   BAN->nLenIntBan))+nVlrDec

	    dFechaTtr  := CTOD(SUBS(TRA->Registro,BAN->nMesPagBan,02)+'/'+;
			       SUBS(TRA->Registro,BAN->nDiaPagBan,02)+'/'+;
			       SUBS(TRA->Registro,;
				    BAN->nAnoPagBan,BAN->nLenAnoBan))

	    cCodigoTtr := SUBS(TRA->Registro,BAN->nTipMovBan,BAN->nLenTipBan)
	    IF BAN->nSigMovBan # 0 .AND.;
	       BAN->nLenSigBan # 0 .AND.;
	       BAN->nLugSigBan # 0

	       cSigTra := SUBS(TRA->Registro,BAN->nSigMovBan,BAN->nLenSigBan)
	       IF BAN->nLugSigBan == 1
		  cCodigoTtr := cSigTra+cCodigoTtr
	       ELSE
		  cCodigoTtr := cCodigoTtr+cSigTra
	       ENDIF
	    ENDIF

	    cOficinTtr := ''
	    IF !EMPTY(BAN->nPosOfiBan)
	       cOficinTtr := SUBS(TRA->Registro,BAN->nPosOfiBan,BAN->nLenOfiBan)
	    ENDIF

	    cTerOfiTtr := ''
	    IF !EMPTY(BAN->nPosTerBan)
	       cTerOfiTtr := SUBS(TRA->Registro,BAN->nPosTerBan,BAN->nLenTerBan)
	    ENDIF

	    cTalonTtr  := ''
	    IF !EMPTY(BAN->nPosTalBan)
	       cTalonTtr := SUBS(TRA->Registro,BAN->nPosTalBan,BAN->nLenTalBan)
	    ENDIF

	    cJornadTtr := ''
	    IF !EMPTY(BAN->nPosJorBan)
	       cJornadTtr := SUBS(TRA->Registro,BAN->nPosJorBan,BAN->nLenJorBan)
	    ENDIF
**********FIN LECTURA DE LOS RESPECTIVO CAMPOS

**********LOCALIZACION DEL CODIGO DE LA TRANSACION
	    nSumar  := 0
	    IF lLocCodigo('ALLTRIM(cCodigoTra)','TMV',;
			   ALLTRIM(cCodigoTtr))

	       IF TMV->lSumarTra
		  nSumar := 1   // Credito
	       ELSE
		  nSumar := 2   // Debito
	       ENDIF

	    ENDIF
**********FIN LOCALIZACION DEL CODIGO DE LA TRANSACION

**********GRABACION DE LOS CAMPOS
	    IF TRA->(lRegLock(lShared,.F.))
	       REPL TRA->cCodRefTra WITH cCodRef
	       REPL TRA->cCodigoEst WITH cCodigoTes
	       REPL TRA->nMesIniTra WITH nMesIniTtr
	       REPL TRA->nMesFinTra WITH nMesFinTtr
	       REPL TRA->cCodigoTra WITH cCodigoTtr
	       REPL TRA->nValorTra  WITH nValorTtr
	       REPL TRA->nSumarTra  WITH nSumar
	       REPL TRA->dFechaTra  WITH dFechaTtr
	       REPL TRA->nCodigoCmv WITH nCodigoCmv(MONTH(dFechaTtr),;
						    cCodRef,;
						    BAN->nLenRefBan)
	       REPL TRA->cNroCtaTra WITH cNroCtaTtr
	       REPL TRA->cOficinTra WITH cOficinTtr
	       REPL TRA->cTerOfiTra WITH cTerOfiTtr
	       REPL TRA->cTalonTra  WITH cTalonTtr
	       REPL TRA->cJornadTra WITH cJornadTtr
	       TRA->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       TRA->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LOS CAMPOS

	  TRA->(DBSKIP())

       ENDDO
       Termometro(100)
*>>>>CONVERSION DEL ARCHIVO A LOS RESPECTIVOS CAMPOS

*>>>>CREACION DE INDICES
       SELECT TRA
       INDEX ON TRA->cCodigoEst;
	     TO &(cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+fNtxTra)
*>>>>FIN CREACION DE INDICES

*>>>>CIERRE DE ARCHIVOS
       IF EMPTY(oBrowse)
	  OrdenaTra(lShared,nModCry,;
		    cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileTra)
       ELSE
	  OrdenaTra(lShared,nModCry,;
		    cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileTra,;
		    oBrowse)
       ENDIF
       RETURN NIL
*>>>>FIN CIERRE DE ARCHIVOS

