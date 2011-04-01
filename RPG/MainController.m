//
//  MainController.m
//  RPG
//
//  Created by Jonathan Diehl on 06.01.09.
//  Copyright 2009 Media Computing Group. All rights reserved.
//

#import "MainController.h"


@implementation MainController

// constructor
- (id) init
{
	self = [super init];
	if (self != nil) {
		// set defaults
		defaults = [NSUserDefaults standardUserDefaults];
		[defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithInt:8], @"passwordLength", 
									[NSNumber numberWithBool:YES], @"useLowerLetters", 
									[NSNumber numberWithBool:YES], @"useUpperLetters", 
									[NSNumber numberWithBool:YES], @"useNumbers", 
									[NSNumber numberWithBool:NO], @"useSymbols",
									@"", @"exclude",
									[NSNumber numberWithInt:-1], @"window.x",
									nil]];
	}
	return self;
}

// initialize
- (void)awakeFromNib;
{
	// init ranomizer
	srandom(time(0));
	
	// position window on screen
	if([defaults integerForKey:@"window.x"] >= 0) {
		NSPoint origin;
		origin.x = [defaults integerForKey:@"window.x"];
		origin.y = [defaults integerForKey:@"window.y"];
		[window setFrameOrigin:origin];
	} else {
		[window center];
	}
	
	[self generate:self];
}

// generate passwords
- (void)generate:(id)sender;
{
	// make sure fields are updated
	[window makeFirstResponder:result];

	// base character set
	NSMutableString *chars = [NSMutableString string];
	if([defaults boolForKey:@"useLowerLetters"]) [chars appendString:@"qwertyuiopasdfghjklzxcvbnm"];
	if([defaults boolForKey:@"useUpperLetters"]) [chars appendString:@"QWERTYUIOPASDFGHJKLZXCVBNM"];
	if([defaults boolForKey:@"useNumbers"])      [chars appendString:@"1234567890"];
	if([defaults boolForKey:@"useSymbols"])      [chars appendString:@"!@#$%^&*()-_=+[{]}\\|;:'\",<.>/?~"];
	
	// empty character set?
	if([chars length] == 0) {
		[[NSAlert alertWithMessageText:@"Cannot generate password" 
										 defaultButton:@"Ok" 
									   alternateButton:nil 
										   otherButton:nil 
							 informativeTextWithFormat:@"Please select at least one source"] runModal];
		return;
	}

	// excludes
	NSString *exclude = [defaults stringForKey:@"exclude"];
	for(int i=0; i < [exclude length]; i++) {
		NSString *c = [NSString stringWithFormat:@"%C", [exclude characterAtIndex:i]];
		[chars deleteCharactersInRange:[chars rangeOfString:c]];
	}
	
	// now empty character set?
	if([chars length] == 0) {
		[[NSAlert alertWithMessageText:@"Cannot generate password" 
										 defaultButton:@"Ok" 
									   alternateButton:nil 
										   otherButton:nil 
							 informativeTextWithFormat:@"Please make sure not to exclude all characters from the source"] runModal];
		return;
	}
	
	// create random password
	NSMutableString *pw = [NSMutableString string];
	for(int j=0; j < [defaults integerForKey:@"passwordLength"]; j++) {
		int r = random() % [chars length];
		[pw appendFormat:@"%C", [chars characterAtIndex:r]];
	}
	
	// publish result
	[result setStringValue:pw];
	[window makeFirstResponder:result];
}

// show the about panel
- (IBAction)showAbout:(id)sender;
{
	[aboutPanel center];
	[aboutPanel orderFront:sender];
}

#pragma mark NSWindow Delegate

// windows moved
// store the new position in the defaults
- (void)windowDidMove:(NSNotification *)notification;
{
	NSRect frame = [window frame];
	[defaults setInteger:frame.origin.x forKey:@"window.x"];
	[defaults setInteger:frame.origin.y forKey:@"window.y"];
}


@end
