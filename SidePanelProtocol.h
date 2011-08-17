//
//  SidePanelProtocol.h
//  XManager
//
//  Created by demo on 12.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SidePanelProtocol <NSObject>

@required
-(void) changeFolder:(NSString*)folder;
-(bool) enterToRow  :(NSInteger)row;
-(bool) goUp;
-(void) addTabFromCurrent;

@end
