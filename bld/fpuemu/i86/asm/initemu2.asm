;*****************************************************************************
;*
;*                            Open Watcom Project
;*
;*    Portions Copyright (c) 1983-2002 Sybase, Inc. All Rights Reserved.
;*
;*  ========================================================================
;*
;*    This file contains Original Code and/or Modifications of Original
;*    Code as defined in and that are subject to the Sybase Open Watcom
;*    Public License version 1.0 (the 'License'). You may not use this file
;*    except in compliance with the License. BY USING THIS FILE YOU AGREE TO
;*    ALL TERMS AND CONDITIONS OF THE LICENSE. A copy of the License is
;*    provided with the Original Code and Modifications, and is also
;*    available at www.sybase.com/developer/opensource.
;*
;*    The Original Code and all software distributed under the License are
;*    distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
;*    EXPRESS OR IMPLIED, AND SYBASE AND ALL CONTRIBUTORS HEREBY DISCLAIM
;*    ALL SUCH WARRANTIES, INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF
;*    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR
;*    NON-INFRINGEMENT. Please see the License for the specific language
;*    governing rights and limitations under the License.
;*
;*  ========================================================================
;*
;* Description:  Init 16-bit OS/2 FPU emulation
;*
;*****************************************************************************

.8087

include struct.inc
include mdef.inc
include xinit.inc

public  FJSRQQ
FJSRQQ  equ             0000H
public  FISRQQ
FISRQQ  equ             0000H
public  FIERQQ
FIERQQ  equ             0000H
public  FIDRQQ
FIDRQQ  equ             0000H
public  FIWRQQ
FIWRQQ  equ             0000H
public  FJCRQQ
FJCRQQ  equ             0000H
public  FJARQQ
FJARQQ  equ             0000H
public  FICRQQ
FICRQQ  equ             0000H
public  FIARQQ
FIARQQ  equ             0000H

        xinit   __init_87_emulator,INIT_PRIORITY_FPU
        xfini   __fini_87_emulator,INIT_PRIORITY_FPU

DGROUP  group   _DATA
        assume  ds:DGROUP

_DATA segment word public 'DATA'
        extrn   __8087   : byte
        extrn   __real87 : byte
_DATA ends

_TEXT segment word public 'CODE'

        extrn   __init_8087_emu : near
        extrn   __x87id         : near

        extrn   __hook8087      : near
        extrn   __unhook8087    : near

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;      void _init_87_emulator( void )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

public  __init_87_emulator
__init_87_emulator proc
        call    __hook8087              ; hook into int7 if 80x87 not present
        mov     byte ptr __real87,al    ; set whether real 80x87 present
        call    __x87id                 ;
        mov     byte ptr __8087,al      ;
        call    __init_8087_emu         ; initialize the 80x87
                                        ; at this point we can't tell the real
                                        ; thing from the fake since emulator is
                                        ; hooked in
        ret                             ; return to caller
__init_87_emulator endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;      void _fini_87_emulator( void )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

public __fini_87_emulator
__fini_87_emulator proc
        call    __unhook8087            ; unhook from int7
        ret
__fini_87_emulator endp


_TEXT   ends

        end
