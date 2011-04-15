//
//  DeleteCharactersFromString.h
//  RPG
//
//  Created by Jonathan Diehl on 15.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableString (DeleteCharactersFromString)
- (void)deleteCharactersFromString:(NSString *)string;
@end
