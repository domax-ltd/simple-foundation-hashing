//
//  NSData+Hashing.m
//  simple-foundation-hashing
//
//  Created by Richard Stelling on 23/12/2013.
//  Copyright (c) 2013  Empirical Magic Ltd. All rights reserved.
//

#import "NSData+Hashing.h"
#import <zlib.h>

@implementation NSData (Hashing)

- (unsigned long)crc32Value
{
    uLong crcValue = crc32(0L, Z_NULL, 0);
    
    crcValue = crc32(crcValue, [self bytes], (uInt)self.length);
    
    return crcValue;
}

@end
