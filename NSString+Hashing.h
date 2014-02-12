//
//  NSString+Hashing.h
//  simple-foundation-hashing
//
//  Created by Richard Stelling on 19/08/2013.
//  Copyright (c) 2013 Richard Stelling. All rights reserved.
//

@import Foundation;

@interface NSString (Hashing)

/*
 SHA Family
 */

+ (NSString *)sha1StringWithStrings:(NSString *)aString, ... NS_REQUIRES_NIL_TERMINATION __attribute__((const));
- (NSString *)sha1StringValue __attribute__((pure));

+ (NSString *)sha224StringWithStrings:(NSString *)aString, ... NS_REQUIRES_NIL_TERMINATION __attribute__((const));
- (NSString *)sha224StringValue __attribute__((pure));

+ (NSString *)sha256StringWithStrings:(NSString *)aString, ... NS_REQUIRES_NIL_TERMINATION __attribute__((const));
- (NSString *)sha256StringValue __attribute__((pure));

+ (NSString *)sha384StringWithStrings:(NSString *)aString, ... NS_REQUIRES_NIL_TERMINATION __attribute__((const));
- (NSString *)sha384StringValue __attribute__((pure));

+ (NSString *)sha512StringWithStrings:(NSString *)aString, ... NS_REQUIRES_NIL_TERMINATION __attribute__((const));
- (NSString *)sha512StringValue __attribute__((pure));

@end
