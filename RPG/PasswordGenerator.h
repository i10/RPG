//
//  PasswordGenerator.h
//  RPG
//
//  Created by Jonathan Diehl on 01.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PasswordGenerator;
@protocol PasswordGeneratorDelegate
- (void)passwordGenerator:(PasswordGenerator *)passwordGenerator didGeneratePassword:(NSString *)password;
@end


@interface PasswordGenerator : NSObject {
	NSUInteger length;
	BOOL useLowerLetters;
	BOOL useUpperLetters;
	BOOL useNumbers;
	BOOL useSymbols;
	NSString *exclude;
	
	@private
	id<PasswordGeneratorDelegate> delegate;
}

@property(assign) NSUInteger length;
@property(assign) BOOL useLowerLetters;
@property(assign) BOOL useUpperLetters;
@property(assign) BOOL useNumbers;
@property(assign) BOOL useSymbols;
@property(retain) NSString *exclude;

@property(assign) IBOutlet id<PasswordGeneratorDelegate> delegate;

- (void)generate;


@end
