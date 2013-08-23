**********LOCALIZACION DEL ANTERIOR RECIBO FACTURADO
	    nRegAnt := 0
	    SELECT PAG
	    LOCATE FOR PAG->cCodigoEst == cCodigoTes .AND.;
		       PAG->nMesIniPag == nMesAnt

	    IF !FOUND()
	       cError('NO EXISTE EL RECIBO DE '+cMes(nMesAnt,10)+;
		      ' DE '+cNombreTes)
	       LOOP
	    ENDIF
	    nRegAnt    := PAG->(RECNO())
	    dExtAnt    := PAG->dPagExtPag
	    nSdoAnt    := PAG->nSdoAntPag+PAG->nMorAntPag
	    nIntAnt    := ROUND((PAG->nMorAntPag*100)/PAG->nSdoAntPag,0)
	    nMorAntTpa := PAG->nMorAntPag
**********FIN LOCALIZACION DEL ANTERIOR RECIBO FACTURADO

**********LECTURA Y VALIDACION DEL SALDO PARA ABONAR
	    nSdoActTcl := 0
	    nSdoMorTcl := 0
	    IF !lMesAct .AND. dFecAbo <= PAG->dPagExtPag

	       nSdoActTcl := PAG->nSdoAntPag
	       nSdoMorTcl := PAG->nMorAntPag
	      *Saldos para abono por fecha oportuna

	       IF nSdoActTcl+nSdoMorTcl == 0
		  cError(cNombreTes+' EN '+cMes(nMesAnt,10)+;
			 ' NO QUEDO CON DEUDAS ATRASADAS')
		  LOOP
	       ENDIF
	     *ÀValidaci¢n del saldo

	    ENDIF
**********FIN LECTURA DEL SALDO PARA ABONAR

**********LOCALIZACION DEL ULTIMO RECIBO FACTURADO
	    nRegAct := 0
	    SELECT PAG
	    LOCATE FOR PAG->cCodigoEst == cCodigoTes .AND.;
		       PAG->nMesIniPag == nMesAct

	    IF !FOUND()
	       cError('NO EXISTE EL RECIBO DE '+cMes(nMesAct,10)+;
		      ' DE '+cNombreTes)
	       LOOP
	    ENDIF
	    nRegAct := PAG->(RECNO())
	    dExtAct := PAG->dPagExtPag
	    nIntAct := ROUND((PAG->nMorAntPag*100)/PAG->nSdoAntPag,0)
	    nIntInt := (CLI->nSdoMorCli*100)/PAG->nMorAntPag
	    nPorAnt := (PAG->nMorAntPag*100)/nMorAntTpa
**********FIN LOCALIZACION DEL ULTIMO RECIBO FACTURADO

**********LECTURA DEL SALDO PARA EL ABONO
	    IF lMesAct
	       IF dFecAbo <= PAG->dPagExtPag
		  nSdoActTcl := PAG->nSdoAntPag
		  nSdoMorTcl := PAG->nMorAntPag
		 *Saldos para abono por fecha oportuna
	       ELSE
		  nSdoActTcl := CLI->nSdoActCli
		  nSdoMorTcl := CLI->nSdoMorCli
		 *Saldos para abono por fecha extemporanea
	       ENDIF
	    ELSE
	       IF dFecAbo > dExtAnt
		     lMesAct := .T.
		  nSdoActTcl := PAG->nSdoAntPag
		  nSdoMorTcl := PAG->nMorAntPag
		 *Saldos para abono por fecha extemporanea
	       ENDIF
	    ENDIF
**********FIN LECTURA DEL SALDO PARA EL ABONO

**********ACTUALIZACION DEL MES ACTUAL
	    SELECT PAG
	    IF lMesAct

*--------------ACTUALIZACION PARA EL RECIBO ACTUAL
		 GO nRegAct
		 IF PAG->cEstadoPag == '*' .OR. PAG->cEstadoPag == 'D'

		    IF dFecAbo <= PAG->dPagExtPag
		       nSaldo  := nSdoActTcl+nSdoMorTcl-nVlrAbo

		       nSdoAnt := ROUND((nSaldo*100)/(100+nIntAct),0)
		       nMorAnt := ROUND((nSdoAnt*nIntAct)/100,0)
		       nVlrMes := PAG->nVlrMesPag

		       DO CASE
		       CASE nSaldo > nSdoAnt+nMorAnt
			    IF ABS(nSaldo-nSdoAnt-nMorAnt) == 1
			       nMorAnt += nSaldo-nSdoAnt-nMorAnt
			    ENDIF
		       CASE nSaldo < nSdoAnt+nMorAnt
			    IF ABS(nSdoAnt+nMorAnt-nSaldo) == 1
			       nMorAnt -= nSdoAnt+nMorAnt-nSaldo
			    ENDIF
		       ENDCASE

		       GO nRegAnt   // Modificado Bethelemitas
		       nIntMes := ROUND((nSdoAnt*PAG->nIntMorPag)/100,0)
		       GO nRegAct   // Modificado Bethelemitas

		    ELSE
		       IF PAG->nMesIniPag == CAA->nMesAmnCaA
			  nSaldo  := nSdoActTcl+nSdoMorTcl-nVlrAbo
			  nSdoCli := ROUND((nSaldo*100)/(100+nIntCli),0)
			  nMorCli := nSaldo-nSdoCli
			  nMorAnt := ROUND((nMorCli*100)/nIntInt,0)
			  nIntMes := nMorCli - nMorAnt
			  nVlrMes := ROUND((nIntMes*100)/PAG->nIntMorPag,0)
			  nSdoAnt := nSdoCli-nVlrMes

			  nIntMes := ROUND((nSdoAnt*PAG->nIntMorPag)/100,0)

		       ELSE
			  nSaldo  := nSdoActTcl+nSdoMorTcl-nVlrAbo

			  GO nRegAnt   // Modificado Bethelemitas
			  IF PAG->cEstadoPag == '*' .OR.;
			     PAG->cEstadoPag == 'D'

			     GO nRegAct   // Modificado Bethelemitas

			     nSdoCli := ROUND((nSaldo*100)/(100+nIntCli),0)
			     nMorCli := nSaldo-nSdoCli

			     nIntMes := ROUND((nSdoCli*PAG->nIntMorPag)/100,0)

			     nMorAnt := nMorCli-nIntMes
			     nSdoAnt := ROUND((nMorAnt*100)/nIntAct,0)
			     nVlrMes := nSdoCli-nSdoAnt

			     nIntMes := ROUND((nSdoAnt*PAG->nIntMorPag)/100,0)

			  ELSE

			     GO nRegAct   // Modificado Bethelemitas
			     nMorAnt := 0
			     nSdoAnt := 0
			     nIntMes := 0
			     nSdoCli := ROUND((nSaldo*100)/(100+PAG->nIntMorPag),0)
			     nMorCli := nSaldo-nSdoCli
			     nVlrMes := nSdoCli
			  ENDIF

		       ENDIF
		    ENDIF
		 ENDIF
*--------------FIN ACTUALIZACION PARA EL RECIBO ACTUAL

	    ENDIF
**********FIN ACTUALIZACION DEL MES ACTUAL

**********ACTUALIZACION DEL MES ANTERIOR
	    IF !lMesAct
	       GO nRegAnt
	       IF dFecAbo <= PAG->dPagExtPag
		  nSaldo  := nSdoActTcl+nSdoMorTcl-nVlrAbo

		  nSdoAnt := ROUND((nSaldo*100)/(100+nIntAnt),0)
		  nMorAnt := ROUND((nSdoAnt*nIntAnt)/100,0)
		  DO CASE
		  CASE nSaldo > nSdoAnt+nMorAnt
		       IF ABS(nSaldo-nSdoAnt-nMorAnt) == 1
			  nMorAnt += nSaldo-nSdoAnt-nMorAnt
		       ENDIF
		  CASE nSaldo < nSdoAnt+nMorAnt
		       IF ABS(nSdoAnt+nMorAnt-nSaldo) == 1
			  nMorAnt -= nSdoAnt+nMorAnt-nSaldo
		       ENDIF
		  ENDCASE
		  nVlrMes := PAG->nVlrMesPag
	       ENDIF
	    ENDIF
**********FIN ACTUALIZACION DEL MES ANTERIOR

**********GRABACION DEL REGISTO DE PAGOS
	    IF PAG->(lRegLock(lShared,.F.)) .AND.;
	       PAG->cEstadoPag # 'P' .AND. PAG->cEstadoPag # 'A'

*--------------GRABACION DEL SALDO ANTERIOR ANTES DE ABONOS FECHA EXT
		 IF DES->dFechaDes > PAG->dPagExtPag
		    IF PAG->nSdoExtPag == 0
		       REPL PAG->nSdoExtPag WITH PAG->nSdoAntPag
		    ENDIF
		 ENDIF
*--------------FIN GRABACION DEL SALDO ANTERIOR ANTES DE ABONOS FECHA EXT

*--------------GRABACION DEL SALDO ANTERIOR ANTES DE ABONOS
		 IF PAG->nSdAbonPag == 0 .AND. PAG->nMoAbonPag == 0
		    REPL PAG->nSdAbonPag WITH PAG->nSdoAntPag
		    REPL PAG->nMoAbonPag WITH PAG->nMorAntPag
		 ENDIF
*--------------FIN GRABACION DEL SALDO ANTERIOR ANTES DE ABANOS

*--------------GRABACION DEL SALDO ANTERIOR DESPUES DE ABONO
		 REPL PAG->nSdoAntPag WITH nSdoAnt
		 REPL PAG->nMorAntPag WITH nMorAnt
		 REPL PAG->nVlrMesPag WITH nVlrMes
*--------------FIN GRABACION DEL SALDO ANTERIOR DESPUES DE ABONO

*--------------GRABACION DEL VALOR A PAGAR
		 IF PAG->nMesIniPag == CAA->nMesAmnCaA
		    REPL PAG->nVlrPagPag WITH nVlrMes
		 ELSE
		    REPL PAG->nVlrPagPag WITH nSdoAnt+nMorAnt+nVlrMes
		 ENDIF
*--------------FIN GRABACION DEL VALOR A PAGAR

	       PAG->(DBCOMMIT())

	    ELSE
	       IF PAG->cEstadoPag # 'P' .AND. PAG->cEstadoPag # 'A'
		  cError('NO SE GRABAN LOS DETALLES DEL PAGO MES ACTUAL')
	       ENDIF
	    ENDIF
	    IF lShared
	       PAG->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTO DE PAGOS

**********ACTUALIZACION DEL MES ACTUAL
	    IF lMesAct

*--------------ACTUALIZACION PARA EL RECIBO ACTUAL
		 nSdoAntTpa := PAG->nSdoAntPag
		 nMorAntTpa := PAG->nMorAntPag
		 GO nRegAnt

		 IF PAG->cEstadoPag == '*' .OR. PAG->cEstadoPag == 'D'
		    IF dFecAbo <= PAG->dPagExtPag
		       nMorAnt := nMorAntTpa-nIntMes
		       nSdoAnt := ROUND((nMorAnt*100)/nIntAnt,0)
		       nVlrMes := nSdoAntTpa-nSdoAnt
		    ELSE
		       IF PAG->nMesIniPag == CAA->nMesAmnCaA
			  nMorAnt := ROUND((nMorAntTpa*100)/nPorAnt,0)
			  nIntMes := nMorAntTpa - nMorAnt
			  nVlrMes := ROUND((nIntMes*100)/PAG->nIntMorPag,0)
			  nSdoAnt := nSdoAntTpa - nVlrMes
		       ELSE
			  nMorAnt := nMorAntTpa-nIntMes
			  nSdoAnt := ROUND((nMorAnt*100)/nIntAnt,0)
			  nVlrMes := nSdoAntTpa-nSdoAnt
		       ENDIF
		    ENDIF
		 ENDIF
*--------------FIN ACTUALIZACION PARA EL RECIBO ACTUAL

	    ENDIF
**********FIN ACTUALIZACION DEL MES ACTUAL

**********ACTUALIZACION DEL MES ANTERIOR
	    IF !lMesAct

	       nSdoAntTpa := PAG->nSdoAntPag
	       nMorAntTpa := PAG->nMorAntPag
	       nVlrMesTpa := PAG->nVlrMesPag

	       GO nRegAct
	       IF PAG->cEstadoPag == '*' .OR. PAG->cEstadoPag == 'D'
		  IF dFecAbo <= PAG->dPagExtPag
		     nSdoAnt := nSdoAntTpa+nVlrMesTpa
		     nMorAnt := nMorAntTpa+;
				ROUND((nSdoAnt*PAG->nIntMorPag)/100,0)
		     nVlrMes := PAG->nVlrMesPag
		  ELSE
		     nMorAnt := nMorAntTpa-nIntMes
		     nSdoAnt := ROUND((nMorAnt*100)/nIntAnt,0)
		     nVlrMes := nSdoAntTpa-nSdoAnt
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN ACTUALIZACION DEL MES ANTERIOR

**********GRABACION DEL REGISTO DE PAGOS
	    IF PAG->(lRegLock(lShared,.F.)) .AND.;
	       PAG->cEstadoPag # 'P' .AND. PAG->cEstadoPag # 'A'

*--------------GRABACION DEL SALDO ANTERIOR ANTES DE ABONOS FECHA EXT
		 IF DES->dFechaDes > PAG->dPagExtPag
		    IF PAG->nSdoExtPag == 0
		       REPL PAG->nSdoExtPag WITH PAG->nSdoAntPag
		    ENDIF
		 ENDIF
*--------------FIN GRABACION DEL SALDO ANTERIOR ANTES DE ABONOS FECHA EXT

*--------------GRABACION DEL SALDO ANTERIOR ANTES DE ABONOS
		 IF PAG->nSdAbonPag == 0 .AND. PAG->nMoAbonPag == 0
		    REPL PAG->nSdAbonPag WITH PAG->nSdoAntPag
		    REPL PAG->nMoAbonPag WITH PAG->nMorAntPag
		 ENDIF
*--------------FIN GRABACION DEL SALDO ANTERIOR ANTES DE ABANOS

*--------------GRABACION DEL SALDO ANTERIOR DESPUES DE ABONO
		 REPL PAG->nSdoAntPag WITH nSdoAnt
		 REPL PAG->nMorAntPag WITH nMorAnt
		 REPL PAG->nVlrMesPag WITH nVlrMes
*--------------FIN GRABACION DEL SALDO ANTERIOR DESPUES DE ABONO

*--------------GRABACION DEL VALOR A PAGAR
		 IF PAG->nMesIniPag == CAA->nMesAmnCaA
		    REPL PAG->nVlrPagPag WITH nVlrMes
		 ELSE
		    REPL PAG->nVlrPagPag WITH nSdoAnt+nMorAnt+nVlrMes
		 ENDIF
*--------------FIN GRABACION DEL VALOR A PAGAR

	       PAG->(DBCOMMIT())

	    ELSE
	       IF PAG->cEstadoPag # 'P' .AND. PAG->cEstadoPag # 'A'
		  cError('NO SE GRABAN LOS DETALLES DEL PAGO MES ACTUAL')
	       ENDIF
	    ENDIF
	    IF lShared
	       PAG->(DBUNLOCK())
	    ENDIF
	    GO nRegAct
**********FIN GRABACION DEL REGISTO DE PAGOS

**********GRABACION DEL SALDO ACTUAL
	    SELECT CLI
	    IF CLI->(lRegLock(lShared,.F.))

	       IF PAG->cEstadoPag == '*'
		  REPL CLI->nSdoActCli WITH PAG->nSdoAntPag
		  REPL CLI->nSdoMorCli WITH PAG->nMorAntPag
	       ELSE
		  REPL CLI->nSdoActCli WITH PAG->nSdoAntPag+PAG->nVlrMesPag

		  IF PAG->nMesIniPag == CAA->nMesAmnCaA
		     REPL CLI->nSdoMorCli WITH PAG->nMorAntPag+;
					       ROUND((ABS(PAG->nVlrPagPag)*;
						      PAG->nIntMorPag)/100,0)
		  ELSE
		     REPL CLI->nSdoMorCli WITH PAG->nMorAntPag+;
					       ROUND((CLI->nSdoActCli*;
						      PAG->nIntMorPag)/100,0)
		  ENDIF
	       ENDIF

	       IF CLI->nSdoActCli == 0
		  REPL CLI->cMesPagCli WITH STUFF(CLI->cMespagCli,;
					    nMesAct,1,'P')
	       ENDIF
	    ELSE
	       cError('NO SE ACTUALIZA EL ABONO EN CLIENTES')
	    ENDIF
	    IF lShared
	       CLI->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL SALDO ACTUAL