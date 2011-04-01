//
//  PasswordGenerator.m
//  RPG
//
//  Created by Jonathan Diehl on 01.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import "PasswordGenerator.h"


@implementation PasswordGenerator

@synthesize length, useLowerLetters, useUpperLetters, useNumbers, useSymbols, exclude;
@synthesize delegate;

// generate the password
- (void)generate;
{
	NSUInteger i;
	
	// base character set
	NSMutableString *chars = [NSMutableString string];
	if(self.useLowerLetters) [chars appendString:@"qwertyuiopasdfghjklzxcvbnm"];
	if(self.useUpperLetters) [chars appendString:@"QWERTYUIOPASDFGHJKLZXCVBNM"];
	if(self.useNumbers)      [chars appendString:@"1234567890"];
	if(self.useSymbols)      [chars appendString:@"!@#$%^&*()-_=+[{]}\\|;:'\",<.>/?~"];
	
	// excludes
	NSString *c;
	for(i=0; i < [self.exclude length]; i++) {
		c = [NSString stringWithFormat:@"%C", [exclude characterAtIndex:i]];
		[chars deleteCharactersInRange:[chars rangeOfString:c]];
	}
	
	// ensure that we have at least some characters
	if([chars length] != 0) return;
	
	// create random password
	NSMutableString *pw = [NSMutableString string];
	NSUInteger r;
	for(i=0; i < self.length; i++) {
		r = random() % [chars length];
		[pw appendFormat:@"%C", [chars characterAtIndex:r]];
	}
	
	// inform delegate
	[self.delegate passwordGenerator:self didGeneratePassword:pw];
}

@end
