//
//  MessageBoxYesNo.m
//  XManager
//
//  Created by demo on 19.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageBoxYesNo.h"

@implementation MessageBoxYesNo

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

//-(void) showDialog:(NSString *)m :(NSString*)title :(id)t :(SEL)callback :(id)p {
//    // Запомним target и callback
//    yesCallback = callback;
//    target = t;
//    params = p;
//    
//    // Установим сообщение и загаловок
//    [message    setStringValue:m];
//    [self       setTitle:title];
//    
//    [[NSApplication sharedApplication] runModalForWindow:self];
//}

-(bool) doModal:(NSString *)m :(NSString *)title {
    isPressYes = false;
    
    [message setStringValue:m];
    [self setTitle:title];
    
    [[NSApplication sharedApplication] runModalForWindow:self];
    
    return isPressYes;
}

-(BOOL) windowShouldClose:(id)sender {
    [[NSApplication sharedApplication] abortModal];
    return YES;
}

-(IBAction) pressNo:(id)sender {
    [self performClose:sender];
}

-(IBAction) pressYes:(id)sender {
    isPressYes = true;
    [self pressNo:sender];
}

@end
