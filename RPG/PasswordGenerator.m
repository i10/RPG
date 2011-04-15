//
//  PasswordGenerator.m
//  RPG
//
//  Created by Jonathan Diehl on 01.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#define kCapitalConsonants @"QWERTYUIOPASDFGHJKLZXCVBNM"
#define kConsonants @"qwrtypsdfghjklzxcvbnm"
#define kVowels @"euioa"
#define kDigits @"1234567890"
#define kSymbols1 @"-/:;()$&@\".,?!'"
#define kSymbols2 @"[]{}#%^*+=_\\|~<>"

#import "PasswordGenerator.h"
#import "sha1.h"
#import "NSMutableString+DeleteCharactersFromString.h"
#import "NSString+RandomCharacter.h"


// private methods
@interface PasswordGenerator ()
- (void)updateChars;
- (NSString *)generateWordWithLength:(NSUInteger)length;
- (char)generateSymbol;
@end


@implementation PasswordGenerator

@synthesize length, exclude, useCapitals, useNumbers, useSymbols1, useSymbols2;
@synthesize delegate;


// generate a password
- (void)generate;
{
	// save
	[self save];
	
	// update characters
	[self updateChars];
	
	// are any character sets empty?
	BOOL hasLetters = [consonants length] > 0 || [vowels length] > 0;
	BOOL hasSymbols = [symbols length] > 0;
	
	if(!hasLetters && !hasSymbols) return;
	
	NSMutableString *chars = [NSMutableString string];
	int charsRemaining = (int)self.length;
	int wordLength;
	while(charsRemaining > 0) {
		
		// add a word
		if(hasLetters && charsRemaining > 1) {
			wordLength = 2;
			if(charsRemaining > 2) wordLength += (int)(random()%MIN(charsRemaining-2, 4));
			
			// avoid 2 symbols at the end
			if(charsRemaining-wordLength == 2) wordLength++;

			// special case: we do not allow special characters but would have only 1 char remaining -> make the word longer
			if(!hasSymbols && charsRemaining-wordLength == 1) wordLength++;
			
			[chars appendString:[self generateWordWithLength:wordLength]];
			charsRemaining -= wordLength;
		}
		 
		 // add a symbol
		if(hasSymbols && charsRemaining > 0) {
			[chars appendFormat:@"%c", [self generateSymbol]];
			charsRemaining -= 1;
		}
	}

	// inform delegate
	[self.delegate passwordGenerator:self didGeneratePassword:chars];
}

// generate a hash from a given string
- (NSString *)generateHashFromString:(NSString *)string;
{
	static SHA1Context sha;
	SHA1Reset(&sha);
	
	// input the string
	SHA1Input(&sha, (const unsigned char *)[string cStringUsingEncoding:NSMacOSRomanStringEncoding], (unsigned int)[string length]);
	
	// compute the hash
	if(!SHA1Result(&sha)) {
		// todo: error handling
		return nil;
    }
	
	NSMutableString *hash = [NSMutableString string];
	for(int i = 0; i < 5 ; i++) {
		[hash appendFormat:@"%X", sha.Message_Digest[i]];
	}
	
	return [[hash copy] autorelease];
}

// save the configuration to the user defaults
- (void)save;
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// store configuration in user defaults
	[defaults setInteger:self.length forKey:@"length"];
	[defaults setObject:self.exclude forKey:@"exclude"];
	[defaults setBool:self.useCapitals forKey:@"useCapitals"];
	[defaults setBool:self.useNumbers forKey:@"useNumbers"];
	[defaults setBool:self.useSymbols1 forKey:@"useSymbols1"];
	[defaults setBool:self.useSymbols2 forKey:@"useSymbols2"];
}


#pragma mark private methods

- (void)updateChars;
{
	[capitalConsonants release];
	[consonants release];
	[vowels release];
	[symbols release];
	
	// letters
	capitalConsonants = [[NSMutableString alloc] initWithString:kCapitalConsonants];
	consonants = [[NSMutableString alloc] initWithString:kConsonants];
	vowels = [[NSMutableString alloc] initWithString:kVowels];
	
	// symbols
	symbols = [[NSMutableString alloc] init];
	if(self.useNumbers) [symbols appendString:kDigits];
	if(self.useSymbols1) [symbols appendString:kSymbols1];
	if(self.useSymbols2) [symbols appendString:kSymbols2];
	
	// excludes
	[capitalConsonants deleteCharactersFromString:self.exclude]; 
	[consonants deleteCharactersFromString:self.exclude]; 
	[vowels deleteCharactersFromString:self.exclude]; 
	[symbols deleteCharactersFromString:self.exclude]; 
}

- (NSString *)generateWordWithLength:(NSUInteger)wordLength;
{
	NSMutableString *word = [NSMutableString stringWithCapacity:wordLength];
	NSString *chars;

	BOOL hasCapitals = [capitalConsonants length] > 0;
	BOOL hasConsonants = [consonants length] > 0;
	BOOL hasVowels = [vowels length] > 0;

	for(int i = 0; i < wordLength; i++) {
		switch(i%2) {
			case 0:
				// consonants
				if(i == 0 && self.useCapitals && hasCapitals) chars = capitalConsonants;
				else if(hasConsonants) chars = consonants;
				else chars = vowels;
				break;
			case 1:
				// vowels
				if(hasVowels) chars = vowels;
				else chars = consonants;
				break;
		}
		
		// append random character
		[word appendFormat:@"%c", [chars randomCharacter]];
	}
	
	return [[word copy] autorelease];
}

// generate a word of a certain length
- (char)generateSymbol;
{
	return [symbols randomCharacter];
}

#pragma mark init & cleanup

// init
- (id)init
{
    self = [super init];
    if (self) {
		// init randomizer
		srandom((int)time(0));
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		// set the default configuration
		[defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithInteger:8], @"length",
									@"lI", @"exclude",
									[NSNumber numberWithBool:YES], @"useCapitals",
									[NSNumber numberWithBool:YES], @"useNumbers",
									[NSNumber numberWithBool:YES], @"useSymbols1",
									[NSNumber numberWithBool:NO], @"useSymbols2",
									nil]];
		
		// load configuration from user defaults
		length = [defaults integerForKey:@"length"];
		exclude = [[defaults objectForKey:@"exclude"] retain];
		useCapitals = [defaults boolForKey:@"useCapitals"];
		useNumbers = [defaults boolForKey:@"useNumbers"];
		useSymbols1 = [defaults boolForKey:@"useSymbols1"];
		useSymbols2 = [defaults boolForKey:@"useSymbols2"];
		
    }
    return self;
}

// cleanup
- (void)dealloc {
    [super dealloc];
}

@end
