//
//  PasswordGenerator.h
//  RPG
//
//  Created by Jonathan Diehl on 01.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasswordGenerator : NSObject {
	NSUInteger length;
	NSString *exclude;
	BOOL useCapitals;
	BOOL useNumbers;
	BOOL useSymbols1;
	BOOL useSymbols2;
	
	@private
	NSMutableString *capitalConsonants;
	NSMutableString *consonants;
	NSMutableString *vowels;
	NSMutableString *symbols;
}

@property(assign) NSUInteger length;
@property(copy) NSString *exclude;
@property(assign) BOOL useCapitals;
@property(assign) BOOL useNumbers;
@property(assign) BOOL useSymbols1;
@property(assign) BOOL useSymbols2;

- (NSString *)generate;
- (NSString *)generateHashFromString:(NSString *)string;
- (void)save;

// service methods
- (void)generatePassword:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error;
- (void)generateHash:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error;


@end
