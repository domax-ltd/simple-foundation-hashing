//
//  NSURL+Hashing.h
//  simple-foundation-hashing
//
//  Created by Richard Stelling on 13/12/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const unsigned long SFHInvalidCRC;

///Progress Block. This is called at regular intervals while the CRC32 hash
///is being calulated. The paramiter `progress` is a value between 0.0 and 1.0
///returning NO (false) will cancel the calculation and cause compleationBlock
//to be called with an error object.
typedef BOOL (^SFHProgressBlock)(double progress);

///Compleation Block. If `crc32Value` is nil check `error` for a cause.
typedef void(^SFHCpmpleationBlock)(NSURL *url, unsigned long crc32Value, NSError *error);

typedef NS_OPTIONS(NSInteger, SFHCRC32Options)
{
    SFHProgressUpdateSlow = 1 << 0,
    SFHProgressUpdateFast = 1 << 1,
};

@interface NSURL (Hashing)

- (void)crc32ValueWithProgress:(SFHProgressBlock)progressBlock compleation:(SFHCpmpleationBlock)compleationBlock;

- (void)crc32ValueFrom:(NSInteger)offset progress:(SFHProgressBlock)progressBlock compleation:(SFHCpmpleationBlock)compleationBlock;

///Asyncronos callulation of CRC32 hash from an arbitrary range of the file identified by self
- (void)crc32ValueForRange:(NSRange)fileRange progress:(SFHProgressBlock)progressBlock compleation:(SFHCpmpleationBlock)compleationBlock options:(SFHCRC32Options)crc32Options;

@end
