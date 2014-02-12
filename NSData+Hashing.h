//
//  NSData+Hashing.h
//  simple-foundation-hashing
//
//  Created by Richard Stelling on 23/12/2013.
//  Copyright (c) 2013  Empirical Magic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Hashing)

- (unsigned long)crc32Value;

@end
