;####################################################################
;
; Dpmi Stub Loader v1.0b
; 
; Programado por Joao Pinheiro aka Ancestor (c) 2000 
; 
; Biblioteca de Funá‰es DPMI
;
;
;####################################################################
  
.model large,pascal           
.386p
Locals
  
Include ..\include\Segs.Inc
Include ..\include\Stub.inc
Include ..\include\Defs.Inc
Include ..\include\DpmiLib.Inc

  Segment32        


;--------------------------------------------------------------------
;Executa um int em modo real
;Os registos s∆o passados ao procedimento em modo real
;
;--------------------------------------------------------------------
_ExecRmProc Proc Near
           Arg @CsIP:dword,@Params:dword

        If PreserveRegsOnCall
           push es
        EndIf
           Call SaveRmRegs                      ;Salva os registos rm
           mov Ebx,@CsIp
           mov cx,bx                
           mov _RmRegs._ip,cx       
           shr ebx,16               
           mov _RmRegs._Cs,bx
           mov ax,0301h
           mov ecx,@Params                
           xor bx,bx      
           mov es,_SelData32
           mov edi,offset _RmRegs
           int 31h
           Call RestoreRmRegs                   ;restaura os registos
        If PreserveRegsOnCall
           pop es
        EndIf
           ret

        Endp
                         
             EndP
                                   
EndSegment32
End
