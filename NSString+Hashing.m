//
//  NSString+Hashing.m
//  simple-foundation-hashing
//
//  Created by Richard Stelling on 19/08/2013.
//  Copyright (c) 2013 Richard Stelling. All rights reserved.
//

#import "NSString+Hashing.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Hashing)

+ (NSString *)sha1StringWithStrings:(NSString *)aString, ...
{
    va_list ap;
    va_start(ap, aString);
    
    NSString *nextString = nil;
    NSMutableString *output = [NSMutableString stringWithString:aString];
    
    do
    {
        nextString = va_arg(ap, NSString*);
        
        if(nextString)
            [output appendString:nextString];
    } while (nextString);
    
    return [output sha1StringValue];
}

- (NSString *)sha1StringValue
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output copy];
}

@end
