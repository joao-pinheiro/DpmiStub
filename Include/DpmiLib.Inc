;####################################################################
;
; Dpmi Stub Loader v1.0b
; 
; Programado por Joao Pinheiro aka Ancestor (c) 2000 
; 
; Biblioteca de Fun‡äes DPMI - Ficheiro de Include
;
;
;####################################################################

Segment32
Include ..\include\Structs.Inc
;====================================================================

Global _RmDS:word
Global _RmES:Word
Global _RmFS:Word
Global _RmGS:Word

Global _RmRegs:DpmiRegisters
Global _DpmiMemInfo:DpmiMemInfoStruc

;====================================================================

Global _DpmiAllocDescriptors:Near
Global _DpmiFreeDescriptor:Near
Global _DpmiSegment2Descriptor:Near
Global _DpmiGetBase:Near
Global _DpmiSetBase:Near
Global _DpmiSetAccessR:Near
Global _DpmiCreateAlias:Near
Global _DpmiGetDescr:Near
Global _DpmiSetDescr:Near

Global _DpmiGetDosMem:Near
Global _DpmiFreeDosMem:Near
Global _DpmiResizeDosMem:Near

Global _DpmiGetRmIntVec:Near
Global _DpmiSetRmIntVec:Near                            
Global _DpmiGetException:Near
Global _DpmiSetException:Near
Global _DpmiGetPmIntVec:Near                            
Global _DpmiSetPmIntVec:Near
Global _DpmiAllocCallBack:Near
Global _DpmiFreeCallBack:near
Global _DpmiGetVersion:Near

Global _DpmiCallRmProc:Near 
Global SaveRmRegs:Near      
Global RestoreRmRegs:Near   
Global _ExecRmInt:Near      
Global _ExecRmProc:Near     
             
Global _DpmiGetMemoryInfo:Near
Global _DpmiGetMem:Near
Global _DpmiFreeMem:Near
Global _DpmiResizeMem:Near

Global _DpmiLockZone:Near
Global _DpmiUnockZone:Near
Global _DpmiMarkAsPageable:Near
Global _DpmiRelockZone:Near
Global _DpmiGetPageSize:Near

Global _DpmiPhysicalMap:Near
Global _DpmiVcli:Near
Global _DpmiVSti:Near

;====================================================================
EndSegment32                
