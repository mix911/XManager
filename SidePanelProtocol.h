//
//  SidePanelProtocol.h
//  XManager
//
//  Created by demo on 12.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SidePanelProtocol <NSObject>

-(void) changeFolder:(NSString*)folder;
-(void) addTabFromCurrent;

@end
