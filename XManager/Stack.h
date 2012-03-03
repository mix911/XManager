//
//  Stack.h
//  XManager
//
//  Created by demo on 21.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//////////////////////////////////////////////////////////////////////////////////
// Stack - class represent stack data structure
//////////////////////////////////////////////////////////////////////////////////
@interface Stack : NSObject 
{
    NSMutableArray* array;
}

-(bool) isEmpty;
-(void) push:(id)obj;
-(void) pushArray:(NSArray*)array;
-(id)   pop;

@end
