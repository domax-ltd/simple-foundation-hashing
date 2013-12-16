//
//  NSString+Hashing.m
//  simple-foundation-hashing
//
//  Created by Richard Stelling on 19/08/2013.
//  Copyright (c) 2013 Richard Stelling. All rights reserved.
//

#import "NSString+Hashing.h"
#import <CommonCrypto/CommonDigest.h>

typedef unsigned char*(*shaFamilyFuncPtr)(const void*, CC_LONG, unsigned char*);

@implementation NSString (Hashing)

- (NSString *)sha:(shaFamilyFuncPtr)functionPtr digestLength:(const CC_LONG)length
{
    const char *cStr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    
    uint8_t digest[length];
    functionPtr(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:length * 2];
    
    for(int i = 0; i < length; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output copy];
}

+ (NSString *)sha:(shaFamilyFuncPtr)functionPtr digestLength:(const CC_LONG)length string:(NSString *)firstStr variableStrings:(va_list)strList //nil terminated list
{
    NSString *nextString = nil;
    NSMutableString *output = [NSMutableString stringWithString:firstStr];
    
    do
    {
        nextString = va_arg(strList, NSString*);
        
        if(nextString)
            [output appendString:nextString];
    } while (nextString);
    
    return [output sha:functionPtr digestLength:length];

}

#pragma mark  - Public Class Methods

+ (NSString *)sha1StringWithStrings:(NSString *)aString, ...
{
    va_list ap;
    va_start(ap, aString);
    
    return [self sha:&CC_SHA1 digestLength:CC_SHA1_DIGEST_LENGTH string:aString variableStrings:ap];
}

+ (NSString *)sha224StringWithStrings:(NSString *)aString, ...
{
    va_list ap;
    va_start(ap, aString);
    
    return [self sha:&CC_SHA224 digestLength:CC_SHA224_DIGEST_LENGTH string:aString variableStrings:ap];
}

+ (NSString *)sha256StringWithStrings:(NSString *)aString, ...
{
    va_list ap;
    va_start(ap, aString);
    
    return [self sha:&CC_SHA256 digestLength:CC_SHA256_DIGEST_LENGTH string:aString variableStrings:ap];
}

+ (NSString *)sha384StringWithStrings:(NSString *)aString, ...
{
    va_list ap;
    va_start(ap, aString);
    
    return [self sha:&CC_SHA384 digestLength:CC_SHA384_DIGEST_LENGTH string:aString variableStrings:ap];
}

+ (NSString *)sha512StringWithStrings:(NSString *)aString, ...
{
    va_list ap;
    va_start(ap, aString);
    
    return [self sha:&CC_SHA512 digestLength:CC_SHA512_DIGEST_LENGTH string:aString variableStrings:ap];
}

#pragma mark  - Public String Value Methods

- (NSString *)sha1StringValue
{
    return [self sha:&CC_SHA1 digestLength:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)sha224StringValue
{
    return [self sha:&CC_SHA224 digestLength:CC_SHA224_DIGEST_LENGTH];
}

- (NSString *)sha256StringValue
{
    return [self sha:&CC_SHA256 digestLength:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)sha384StringValue
{
    return [self sha:&CC_SHA384 digestLength:CC_SHA384_DIGEST_LENGTH];
}

- (NSString *)sha512StringValue
{
    return [self sha:&CC_SHA512 digestLength:CC_SHA512_DIGEST_LENGTH];
}

@end
