//
//  RPGAppDelegate.m
//  RPG
//
//  Created by Jonathan Diehl on 01.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import "RPGAppDelegate.h"
#import "PasswordGenerator.h"

#define kMinimizedDeltaSize 245.0

NSInteger segmentIndexToLength(NSInteger index) {
	switch(index) {
		case 0: return 6;
		case 1: return 8;
		case 2: return 12;
		case 3: return 24;
		case 4: return 36;
	}
	return 8;
}

NSInteger lengthToSegmentIndex(NSInteger length) {
	switch(length) {
		case 6: return 0;
		case 8: return 1;
		case 12: return 2;
		case 24: return 3;
		case 36: return 4;
	}
	return 1;
}

@implementation RPGAppDelegate

@synthesize window, aboutWindow, mainView, lengthControl, output, passwordGenerator;


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
	passwordGenerator.length = segmentIndexToLength([self.lengthControl selectedSegment]);
	[passwordGenerator generate];
}

- (IBAction)generateFromMenu:(NSMenuItem *)menuItem;
{
	passwordGenerator.length = [menuItem tag];
	[passwordGenerator generate];
}


#pragma mark NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// init randomizer
	srandom((int)time(0));
	
	[self.window setFrameAutosaveName:@"window"];
	
	// update segmented control
	[self.lengthControl setSelectedSegment:lengthToSegmentIndex(self.passwordGenerator.length)];
	
	// generate password
	[passwordGenerator generate];
}

- (void)applicationWillTerminate:(NSNotification *)notification;
{
	windowAnimationsEnabled = NO;
	[passwordGenerator save];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
	// remove focus from output field to avoid ugly text selection
	[self.window makeFirstResponder:nil];
	
	if(!windowAnimationsEnabled) return;
	
	CGRect rect;
	
	// move main view up
	rect = self.mainView.bounds;
	rect.origin.y = -kMinimizedDeltaSize;
	self.mainView.bounds = rect;
	
	// change window size
	rect = self.window.frame;
	rect.size.height -= kMinimizedDeltaSize;
	[self.window setFrame:rect display:YES animate:NO];
}

- (void)applicationWillBecomeActive:(NSNotification *)notification
{
	// focus output field
	[self.window makeFirstResponder:self.output];

	if(!windowAnimationsEnabled) {
		windowAnimationsEnabled = YES;
		return;
	}
	
	CGRect rect;
	
	// change window size
	rect = self.window.frame;
	rect.size.height += kMinimizedDeltaSize;
	[self.window setFrame:rect display:YES animate:NO];
	
	// move main view up
	rect = self.mainView.bounds;
	rect.origin.y = 0.0;
	self.mainView.bounds = rect;
	self.mainView.frame = rect;
	
}


#pragma mark NSWindowDelegate

- (void)windowDidResignKey:(NSNotification *)notification;
{
	[self.aboutWindow orderOut:self];
}


#pragma mark PasswordGeneratorDelegate

- (void)passwordGenerator:(PasswordGenerator *)passwordGenerator didGeneratePassword:(NSString *)password;
{
	self.output.stringValue = password;
	[self.window makeFirstResponder:self.output];
}

@end
