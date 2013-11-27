;####################################################################
;
; Dpmi Stub Loader v1.0b
; 
; Programado por Joao Pinheiro aka Ancestor (c) 2000 
; 
; Biblioteca de Fun‡äes DPMI
;
;
;####################################################################
  
.model large,pascal           
.386p
Locals
  
Include ..\include\Segs.Inc
Include ..\include\Stub.inc
Include ..\include\Defs.Inc
                   
  Segment32        

;---------------------------------------------------------------------
; Liberta um bloco de mem¢ria alocado
;
;---------------------------------------------------------------------
Public _DpmiFreeMem
 
_DpmiFreeMem Proc Near                                  
            Arg @Bloco:Dword
                                                              
         If PreserveRegsOnCall
            Push edi esi eax es
         EndIf               
            mov es,_SelData0 
            mov edi,@Bloco   
            mov esi,es:[edi-4]                  ;recupera o handle
            mov di,si        
            shr esi,16                          ;em si:di
            mov ax,0502h     
            int 31h          
         If PreserveRegsOnCall
            Pop es eax esi edi
         EndIf                     
            ret                    
                              
         EndP                                                         
                                   
EndSegment32
End
