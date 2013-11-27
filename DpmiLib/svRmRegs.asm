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
Include ..\include\DpmiLib.Inc

  Segment32        

Public SaveRmRegs, RestoreRmRegs
;--------------------------------------------------------------------
; Salva os registos pra _RmRegs
;--------------------------------------------------------------------

SaveRmRegs Proc Near

           mov dword ptr _RmRegs._ax,eax
           mov dword ptr _RmRegs._bx,ebx
           mov dword ptr _RmRegs._cx,ecx
           mov dword ptr _RmRegs._dx,edx
           mov dword ptr _RmRegs._si,esi
           mov dword ptr _RmRegs._di,edi
           mov ax,_RmDs
           mov bx,_RmEs
           mov cx,_RmFs
           mov dx,_RmGs
           mov _RmRegs._ds,ax
           mov _RmRegs._es,bx
           mov _RmRegs._fs,cx
           mov _RmRegs._gs,dx
           Mov dx,_stack16Seg
           Mov _RmRegs._ss,dx                  ;Stack de modo real
           mov _rmregs._sp,RmStackSize
           mov dword ptr _rmRegs._bp,0
           pushfd                              ;Flags
           pop eax                        
           mov _RmRegs._Flags,ax    
           ret
        EndP

;--------------------------------------------------------------------
; Restaura os registos de _RmRegs
;--------------------------------------------------------------------

RestoreRmRegs Proc Near

           pushfd
           pop ebx
           mov cx,_RmRegs._Flags
           mov eax,ebx
           and eax,0FFFF00FFh
           or ax,cx
           push eax        
           popfd    
           mov ax,_RmRegs._ds
           mov bx,_RmRegs._es
           mov cx,_RmRegs._fs
           mov dx,_RmRegs._gs
           mov _RmDs,ax
           mov _RmEs,bx
           mov _rmFs,cx
           mov _rmGs,dx
           Mov Edi,dword ptr _RmRegs._di
           Mov Esi,dword ptr _RmRegs._si
           Mov Eax,dword ptr _RmRegs._ax
           Mov Ebx,dword ptr _RmRegs._bx
           Mov Ecx,dword ptr _RmRegs._cx
           Mov Edx,dword ptr _RmRegs._dx
           ret

         EndP

EndSegment32
End
