

.model large,pascal
.386p
Locals

Include ..\include\Segs.Inc
Include ..\include\Stub.inc
Include ..\include\Defs.Inc
Include ..\include\DpmiLib.Inc
Include ..\include\DosLib.Inc

Segment32

HelloWorld Db'Hello Word!!',0ah,0dh,'$'

public _main
_main proc
      mov edx,offset HelloWorld
      mov ah,09h
      int 21h

      ret
      endp
endsegment32
end