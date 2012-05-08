//
//  Switch.h
//  XManager
//
//  Created by demo on 08.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef XManager_Switch_h
#define XManager_Switch_h

#define SWITCH (expr)\
{\
    typeof(expr) val = (expr);

#define CASE (expr)\
if (val == (expr)) {

#define ENDCASE }else

#define DEFAULT }else{

#define ENDDEFAULT }

#endif
