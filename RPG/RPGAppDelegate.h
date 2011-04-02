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
	NSView *mainView;
	NSTextField *output;
	PasswordGenerator *passwordGenerator;
	BOOL windowAnimationsEnabled;
}

@property(assign) IBOutlet NSWindow *window;
@property(assign) IBOutlet NSView *mainView;
@property(assign) IBOutlet NSTextField *output;
@property(assign) IBOutlet PasswordGenerator *passwordGenerator;

- (IBAction)generate:(id)sender;
- (IBAction)generate6:(id)sender;
- (IBAction)generate8:(id)sender;
- (IBAction)generate12:(id)sender;
- (IBAction)generate24:(id)sender;
- (IBAction)generate32:(id)sender;

- (IBAction)copyOutput:(id)sender;

@end
