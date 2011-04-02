//
//  RPGAppDelegate.m
//  RPG
//
//  Created by Jonathan Diehl on 01.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import "RPGAppDelegate.h"
#import "PasswordGenerator.h"

@implementation RPGAppDelegate

@synthesize window, output, passwordGenerator;


#pragma mark IBActions

- (IBAction)setPasswordLength:(NSButton *)sender;
{
	passwordGenerator.length = sender.title.intValue;
}

- (IBAction)copyOutput:(id)sender;
{
	NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];

	// copy the output to the paste board
	[pasteboard clearContents];
	[pasteboard writeObjects:[NSArray arrayWithObject:self.output.stringValue]];
}

- (IBAction)generate:(id)sender;
{
	[passwordGenerator generate];
}


#pragma mark NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// init randomizer
	srandom((int)time(0));
	
	// load window position from user defaults
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSPoint origin = NSMakePoint([defaults floatForKey:@"window.x"], [defaults floatForKey:@"window.y"]);
	if(origin.x > 0 && origin.y > 0) {
		[self.window setFrameOrigin:origin];
	}
	
	// otherwise: center window
	else
	{
		CGSize screenSize = [[NSScreen mainScreen] frame].size;
		CGSize windowSize = self.window.frame.size;
		CGPoint origin = CGPointMake((screenSize.width-windowSize.width)/2.0, (screenSize.height-windowSize.height)/2.0);
		[self.window setFrameOrigin:origin];
	}
	
	// generate password
	[passwordGenerator generate];
}

- (void)applicationWillTerminate:(NSNotification *)notification;
{
	[passwordGenerator save];
}


#pragma mark NSWindowDelegate

// windows moved
// store the new position in the defaults
- (void)windowDidMove:(NSNotification *)notification;
{
	NSRect frame = [self.window frame];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setFloat:frame.origin.x forKey:@"window.x"];
	[defaults setFloat:frame.origin.y forKey:@"window.y"];
}


#pragma mark PasswordGeneratorDelegate

- (void)passwordGenerator:(PasswordGenerator *)passwordGenerator didGeneratePassword:(NSString *)password;
{
	self.output.stringValue = password;
	[self.output becomeFirstResponder];
}

@end
