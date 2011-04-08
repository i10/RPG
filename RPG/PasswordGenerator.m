//
//  PasswordGenerator.m
//  RPG
//
//  Created by Jonathan Diehl on 01.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import "PasswordGenerator.h"
#import "sha1.h"

char *removeCharacters(char *string, const char *characters) {
	if(characters == NULL) return string;
	
	char *result = malloc(sizeof(char) * (strlen(string)+1));
	
	char *p;
	char c;
	int i,j=0;
	for(i=0; i<strlen(string); i++) {
		c = string[i];
		p = strchr(characters, c);
		if(!p) result[j++] = c;
	}
	
	result[j] = '\0';
	return result;
}

// generate a word of a certain length
NSString *generateWord(NSUInteger length, BOOL capitalize, NSString *excludes) {
	static char *Consonants = "QWERTYUIOPASDFGHJKLZXCVBNM";
	static char *consonants = "qwrtypsdfghjklzxcvbnm";
//	static char *Vowels = "EUIOA";
	static char *vowels = "euioa";
	
	char *chars;
	char word[length+1];
	char c;
	for(int i = 0; i < length; i++) {
		switch(i%2) {
			case 0:
				if(i == 0 && capitalize) chars = Consonants;
				else chars = consonants;
				break;
			case 1:
				chars = vowels;
				break;
		}
		chars = removeCharacters(chars, [excludes cStringUsingEncoding:NSMacOSRomanStringEncoding]);
		c = chars[random()%strlen(chars)];
		word[i] = c;
	}
	
	// terminate string
	word[length] = '\0';
	
	return [NSString stringWithFormat:@"%s", word];
}

NSString *generateSpecial(BOOL useDigits, BOOL useSpecial1, BOOL useSpecial2, NSString *excludes) {
	static char *digits = "1234567890";
	static char *special1 = "-/:;()$&@\".,?!'";
	static char *special2 = "[]{}#%^*+=_\\|~<>";
	
	int choices = useDigits + useSpecial1 + useSpecial2;
	char *chars;
	
	// only one choice
	if(choices == 1) {
		if(useDigits) chars = digits;
		else if(useSpecial1) chars = special1;
		else chars = special2;
	}
	
	// two choices
	else if(choices == 2) {
		switch(random()%2) {
			case 0:
				if(useDigits) chars = digits;
				else if(useSpecial1) chars = special1;
				else chars = special2;
				break;
			case 1:
				if(useSpecial2) chars = special2;
				else if(useSpecial1) chars = special1;
				else chars = digits;
				break;
		}
	}
	
	// three choices
	else switch(random()%3) {
		case 0:
			chars = digits;
			break;
		case 1:
			chars = special1;
			break;
		case 2:
			chars = special2;
			break;
	}
	
	// remove excludes
	removeCharacters(chars, [excludes cStringUsingEncoding:NSMacOSRomanStringEncoding]);
	
	// get random character
	char c = chars[random()%strlen(chars)];
	
	return [NSString stringWithFormat:@"%c", c];
}

NSString *generateHash(NSString *string) {
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

@implementation PasswordGenerator

@synthesize length, exclude, useCapitals, useNumbers, useSymbols1, useSymbols2;
@synthesize delegate;

// generate a password
- (void)generate;
{
	// save
	[self save];
	
	// do we also use special characters?
	BOOL useSpecial = self.useNumbers || self.useSymbols1 || self.useSymbols2;
	
	NSMutableString *chars = [NSMutableString string];
	int charsRemaining = (int)self.length;
	int wordLength;
	while(charsRemaining > 0) {
		
		// add a word
		if(charsRemaining > 1) {
			wordLength = 2;
			if(charsRemaining > 2) wordLength += (int)(random()%MIN(charsRemaining-2, 4));
			
			// avoid 2 symbols at the end
			if(charsRemaining-wordLength == 2) wordLength++;

			// special case: we do not allow special characters but would have only 1 char remaining -> make the word longer
			if(!useSpecial && charsRemaining-wordLength == 1) wordLength++;
			
			[chars appendString:generateWord(wordLength, self.useCapitals, self.exclude)];
			charsRemaining -= wordLength;
		}
		 
		 // add a symbol
		if(useSpecial && charsRemaining > 0) {
			[chars appendString:generateSpecial(self.useNumbers, self.useSymbols1, self.useSymbols2, self.exclude)];
			charsRemaining -= 1;
		}
	}

	// inform delegate
	[self.delegate passwordGenerator:self didGeneratePassword:chars];
}

// generate a hash from a given string
- (NSString *)generateHashFromString:(NSString *)string;
{
	return generateHash(string);
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
									@"", @"exclude",
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
