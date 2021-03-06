/****************************************************************************
Srev StrayRev Stray [,isepA [, isepB [, isepOut]]]
Reverses the elements of an array-string

Reverses the elements in Stray and returns the result. Elements are defined by two seperators as ASCII coded characters: isep1 defaults to 32 (= space), isep2 defaults to 9 (= tab). If just one seperator is used, isep2 equals isep1. The elements in the resulting string Sres are seperated by isepOut (default=isep1)
Requires Csound 5.16 or higher (new parser)
written by joachim heintz

Stray - a string as array
isepA - the first seperator for the elements in Stray (default=32: space)
isepB - the second seperator for the elements in Stray (default=9: tab) 
isepOut - the seperator for the output string (default=isep1)
Srev - Stray with elements in reverse order
****************************************************************************/


<CsoundSynthesizer>
<CsOptions>
-n -m0
</CsOptions>
<CsInstruments>

  opcode StrayRev, S, Sjjj
;reverses the elements in Stray and returns the result. elements are defined by two seperators as ASCII coded characters: isep1 defaults to 32 (= space), isep2 defaults to 9 (= tab). if just one seperator is used, isep2 equals isep1. the elements in the resulting string Sres are seperated by isepOut (default=isep1)
Stray, isepA, isepB, isepOut xin
;;DEFINE THE SEPERATORS
isep1     =         (isepA == -1 ? 32 : isepA)
isep2     =         (isepA == -1 && isepB == -1 ? 9 : (isepB == -1 ? isep1 : isepB))
isepOut   =         (isepOut == -1 ? isep1 : isepOut)
Sep1      sprintf   "%c", isep1
Sep2      sprintf   "%c", isep2
;;INITIALIZE SOME PARAMETERS
Sres      =         ""
ilen      strlen    Stray
istartsel =         -1; startindex for searched element
iwarleer  =         1; is this the start of a new element
indx      =         0 ;character index
inewel    =         0 ;new element to find
;;LOOP
 if ilen == 0 igoto end ;don't go into the loop if Stray is empty
loop:
Schar     strsub    Stray, indx, indx+1; this character
isep1p    strcmp    Schar, Sep1; returns 0 if Schar is sep1
isep2p    strcmp    Schar, Sep2; 0 if Schar is sep2
is_sep    =         (isep1p == 0 || isep2p == 0 ? 1 : 0) ;1 if Schar is a seperator
 ;END OF STRING AND NO SEPARATORS BEFORE?
 if indx == ilen && iwarleer == 0 then
Sel       strsub    Stray, istartsel, -1
inewel    =         1
 ;FIRST CHARACTER OF AN ELEMENT?
 elseif is_sep == 0 && iwarleer == 1 then
istartsel =         indx ;if so, set startindex
iwarleer  =         0 ;reset info about previous separator 
 ;FIRST SEPERATOR AFTER AN ELEMENT?
 elseif iwarleer == 0 && is_sep == 1 then
Sel       strsub    Stray, istartsel, indx ;get elment
inewel    =         1 ;tell about
iwarleer  =         1 ;reset info about previous separator
 endif
 ;PREPEND THE ELEMENT TO THE RESULT
 if inewel == 1 then ;for each new element
Selsep    sprintf   "%c%s", isepOut, Sel ;prepend seperator
Sres      strcat    Selsep, Sres ;prepend to result
 endif
inewel    =         0
          loop_le   indx, 1, ilen, loop 
end:
Sout      strsub    Sres, 1; remove starting seperator
          xout      Sout
  endop 

  
instr 1
Stray     strget    p4
ipcnt     pcount
if ipcnt == 4 then
Srev      StrayRev  Stray
elseif ipcnt == 5 then
Srev      StrayRev  Stray, p5
elseif ipcnt == 6 then
Srev      StrayRev  Stray, p5, p6
elseif ipcnt == 7 then
Srev      StrayRev  Stray, p5, p6, p7
endif
		printf_i	"'%s'\n", 1, Srev
endin 

</CsInstruments>
<CsScore>
i 1 0 0.01 "" 
i . + . "sdhgf a elh 4 876 x" 
i . + . "sdhgf,a,elh,4,876"  44
i . + . "	sdhgf, a, elh,  4,  876" 44 
i . + . "    sdhgf, a, elh,  4,  876" 44 32
i . + . " sdhgf, a, elh,  4,  876" 44 32 44
i . + . "sdhgf,a,elh,4,876"  44 44 124
e
</CsScore>
</CsoundSynthesizer>

returns:
''
'x 876 4 elh a sdhgf'
'876,4,elh,a,sdhgf'
'  876,  4, elh, a,	sdhgf'
'876,4,elh,a,sdhgf'
'876,4,elh,a,sdhgf'
'876|4|elh|a|sdhgf'

