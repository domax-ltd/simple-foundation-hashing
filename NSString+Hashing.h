//
//  NSString+Hashing.h
//  
//
//  Created by Richard Stelling on 19/08/2013.
//  Copyright (c) 2013 Richard Stelling. All rights reserved.
//

@import Foundation;

@interface NSString (Hashing)

+ (NSString *)sha1StringWithStrings:(NSString *)aString, ... NS_REQUIRES_NIL_TERMINATION __attribute__((const));
- (NSString *)sha1Value __attribute__((pure));

@end
