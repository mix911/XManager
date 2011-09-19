//
//  MessageBoxYesNo.h
//  XManager
//
//  Created by demo on 19.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface MessageBoxYesNo : NSPanel {
    IBOutlet    NSTextField*    message;
    
    bool isPressYes;
    NSModalSession modalSession;
    
//    SEL yesCallback;
//    id  target;
//    id  params;
}

//-(void) showDialog :(NSString*)message :(NSString*)title :(id)target :(SEL)yesCallback :(id)params;

-(bool) doModal :(NSString*)message :(NSString*)title;

-(BOOL) windowShouldClose :(id)sender;

-(IBAction) pressNo :(id)sender;
-(IBAction) pressYes:(id)sender;

@end
