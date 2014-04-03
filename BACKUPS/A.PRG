IF cCodEst == '210089' .AND. EXT->dFechaTra == CTOD('11/02/2012')

   wait cAnoUsr
   wait CMV->cAnoCmvCmv

   wait FileMoB
   wait PathTem+'\'+FileCmv
   wait nCodCmv
   wait cAnoUsr


   wait aVlrDif[k,1]  // cCodBan+cAnoPag+cMesPag
   wait aVlrDif[k,2]  // 2.  Archivo del Extracto
   wait aVlrDif[k,3]  // 3.  C¢digo de la Referencia
   wait aVlrDif[k,4]  // 4.  C¢digo del Grupo
   wait aVlrDif[k,5]  // 5.  Mes Inicial
   wait aVlrDif[k,6]  // 6.  Mes Final
   wait aVlrDif[k,7]  // 7.  Valor Pago
   wait aVlrDif[k,8]  // 8.  Fecha de Pago
   wait aVlrDif[k,9]  // 9.  Referencia
   wait aVlrDif[k,10] // 10. Valor de la Transaci¢n
   wait aVlrDif[k,11] // 11. Fecha de la Transaci¢n

ENDIF