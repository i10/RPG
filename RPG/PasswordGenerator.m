//
//  PasswordGenerator.m
//  RPG
//
//  Created by Jonathan Diehl on 01.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import "PasswordGenerator.h"

#define kLowerLetters @"qwertyuiopasdfghjklzxcvbnm"
#define kUpperLetters @"QWERTYUIOPASDFGHJKLZXCVBNM"
#define kNumbers @"1234567890"
#define kSymbols1 @"-/:;()$&@\".,?!'"
#define kSymbols2 @"[]{}#%^*+=_\\|~<>"


@implementation PasswordGenerator

@synthesize length, useLowerLetters, useUpperLetters, useNumbers, useSymbols1, useSymbols2, exclude;
@synthesize delegate;

// generate the password
- (void)generate;
{
	NSUInteger i;
	
	// base character set
	NSMutableString *chars = [NSMutableString string];
	if(self.useLowerLetters)	[chars appendString:kLowerLetters];
	if(self.useUpperLetters)	[chars appendString:kUpperLetters];
	if(self.useNumbers)			[chars appendString:kNumbers];
	if(self.useSymbols1)		[chars appendString:kSymbols1];
	if(self.useSymbols2)		[chars appendString:kSymbols2];

	// excludes
	NSString *c;
	for(i=0; i < [self.exclude length]; i++) {
		c = [NSString stringWithFormat:@"%C", [exclude characterAtIndex:i]];
		[chars deleteCharactersInRange:[chars rangeOfString:c]];
	}
	
	// ensure that we have at least some characters
	if([chars length] == 0) return;
	
	// create random password
	NSMutableString *pw = [NSMutableString string];
	NSUInteger r;
	for(i=0; i < self.length; i++) {
		r = random() % [chars length];
		[pw appendFormat:@"%C", [chars characterAtIndex:r]];
	}
	
	// save
	[self save];
	
	// inform delegate
	[self.delegate passwordGenerator:self didGeneratePassword:pw];
}

- (void)save;
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// store configuration in user defaults
	[defaults setInteger:self.length forKey:@"length"];
	[defaults setBool:self.useLowerLetters forKey:@"useLowerLetters"];
	[defaults setBool:self.useUpperLetters forKey:@"useUpperLetters"];
	[defaults setBool:self.useNumbers forKey:@"useNumbers"];
	[defaults setBool:self.useSymbols1 forKey:@"useSymbols1"];
	[defaults setBool:self.useSymbols2 forKey:@"useSymbols2"];
	[defaults setObject:self.exclude forKey:@"exclude"];
}

- (id)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		// set the default configuration
		[defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithInteger:8], @"length",
									[NSNumber numberWithBool:YES], @"useLowerLetters",
									[NSNumber numberWithBool:YES], @"useUpperLetters",
									[NSNumber numberWithBool:YES], @"useNumbers",
									[NSNumber numberWithBool:YES], @"useSymbols1",
									[NSNumber numberWithBool:NO], @"useSymbols2",
									@"zZyY", @"exclude",
									nil]];
		
		// load configuration from user defaults
		length = [defaults integerForKey:@"length"];
		useLowerLetters = [defaults boolForKey:@"useLowerLetters"];
		useUpperLetters = [defaults boolForKey:@"useUpperLetters"];
		useNumbers = [defaults boolForKey:@"useNumbers"];
		useSymbols1 = [defaults boolForKey:@"useSymbols1"];
		useSymbols2 = [defaults boolForKey:@"useSymbols2"];
		exclude = [[defaults objectForKey:@"exclude"] copy];
		
    }
    return self;
}

@end
