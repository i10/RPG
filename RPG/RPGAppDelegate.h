//
//  RPGAppDelegate.h
//  RPG
//
//  Created by Jonathan Diehl on 01.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PasswordGenerator.h"

@interface RPGAppDelegate : NSObject <NSApplicationDelegate, PasswordGeneratorDelegate> {
@private
	NSWindow *window;
	NSTextField *output;
	PasswordGenerator *passwordGenerator;
}

@property(assign) IBOutlet NSWindow *window;
@property(assign) IBOutlet NSTextField *output;
@property(assign) IBOutlet PasswordGenerator *passwordGenerator;

- (IBAction)setPasswordLength:(id)sender;
- (IBAction)copyOutput:(id)sender;

@end
