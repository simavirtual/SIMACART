		    DO CASE
		    CASE CMV->nCodCmvCmv == 1 .OR. CMV->nCodCmvCmv == 2 // Pensiones

		    CASE CMV->nCodCmvCmv == 3  // Abonos

		    CASE CMV->nCodCmvCmv == 4  // Matriculas

		    OTHERWISE

		    ENDCASE

IF CMV->nCodigoCmv == 546 .AND. ALLTRIM(TRA->cCodRefTra) == '2130340211'
   wait 'OK'
   wait CMV->nCodCmvCmv
ENDIF