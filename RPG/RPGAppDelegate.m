//
//  RPGAppDelegate.m
//  RPG
//
//  Created by Jonathan Diehl on 01.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import "RPGAppDelegate.h"
#import "PasswordGenerator.h"

#define kMinimizedDeltaSize 258.0

@implementation RPGAppDelegate

@synthesize window, mainView, output, passwordGenerator;


#pragma mark IBActions

- (IBAction)setPasswordLength:(NSButton *)sender;
{
	passwordGenerator.length = sender.title.intValue;
	[passwordGenerator generate];
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

- (IBAction)generate6:(id)sender;
{
	passwordGenerator.length = 6;
	[passwordGenerator generate];
}

- (IBAction)generate8:(id)sender;
{
	passwordGenerator.length = 8;
	[passwordGenerator generate];
}

- (IBAction)generate12:(id)sender;
{
	passwordGenerator.length = 12;
	[passwordGenerator generate];
}

- (IBAction)generate24:(id)sender;
{
	passwordGenerator.length = 24;
	[passwordGenerator generate];
}

- (IBAction)generate32:(id)sender;
{
	passwordGenerator.length = 32;
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
	windowAnimationsEnabled = NO;
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

- (void)windowDidResignKey:(NSNotification *)notification
{
	if(!windowAnimationsEnabled) return;
	
	CGRect frame;
	
	// move main view up
	frame = self.mainView.frame;
	frame.origin.y += kMinimizedDeltaSize;
//	self.mainView.frame = frame;
	
	// change window size
	frame = self.window.frame;
	frame.size.height -= kMinimizedDeltaSize;
	[self.window setFrame:frame display:YES animate:YES];

}

- (void)windowDidBecomeKey:(NSNotification *)notification
{
	if(!windowAnimationsEnabled) {
		windowAnimationsEnabled = YES;
		return;
	}
	
	CGRect frame;
	
	// move main view up
	frame = self.mainView.frame;
	frame.origin.y -= kMinimizedDeltaSize;
//	self.mainView.frame = frame;
	
	// change window size
	frame = self.window.frame;
	frame.size.height += kMinimizedDeltaSize;
	[self.window setFrame:frame display:YES animate:YES];
}


#pragma mark PasswordGeneratorDelegate

- (void)passwordGenerator:(PasswordGenerator *)passwordGenerator didGeneratePassword:(NSString *)password;
{
	self.output.stringValue = password;
	[self.output becomeFirstResponder];
}

@end
