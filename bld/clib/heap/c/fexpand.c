/****************************************************************************
*
*                            Open Watcom Project
*
*    Portions Copyright (c) 1983-2002 Sybase, Inc. All Rights Reserved.
*
*  ========================================================================
*
*    This file contains Original Code and/or Modifications of Original
*    Code as defined in and that are subject to the Sybase Open Watcom
*    Public License version 1.0 (the 'License'). You may not use this file
*    except in compliance with the License. BY USING THIS FILE YOU AGREE TO
*    ALL TERMS AND CONDITIONS OF THE LICENSE. A copy of the License is
*    provided with the Original Code and Modifications, and is also
*    available at www.sybase.com/developer/opensource.
*
*    The Original Code and all software distributed under the License are
*    distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
*    EXPRESS OR IMPLIED, AND SYBASE AND ALL CONTRIBUTORS HEREBY DISCLAIM
*    ALL SUCH WARRANTIES, INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF
*    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR
*    NON-INFRINGEMENT. Please see the License for the specific language
*    governing rights and limitations under the License.
*
*  ========================================================================
*
* Description:  Far heap expansion routines.
*
****************************************************************************/


#include "dll.h"        // needs to be first
#include "variety.h"
#include <stddef.h>
#include <malloc.h>
#include "heap.h"
#include "heapacc.h"

#if defined(__BIG_DATA__)

_WCRTLINK void *_expand( void *stg, size_t amount )
{
    return( _fexpand( stg, amount ) );
}

#endif

_WCRTLINK void _WCFAR *_fexpand( void _WCFAR *stg, size_t req_size )
{
    __segment   seg;
    void _WCNEAR        *tmp;

    seg = FP_SEG( stg );
    if( seg == _DGroup() ) {
        tmp = _nexpand( (void _WCNEAR *)FP_OFF( stg ), req_size );
        if( tmp == NULL )  return( NULL );
    } else if( _bexpand( seg,(void __based(void) *)FP_OFF( stg ), req_size )
                                == _NULLOFF ) {
        return( NULL );
    }
    return( stg );
}
