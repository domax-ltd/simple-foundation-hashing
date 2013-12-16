//
//  NSURL+Hashing.m
//  simple-foundation-hashing
//
//  Created by Richard Stelling on 13/12/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "NSURL+Hashing.h"
#import <zlib.h>

const unsigned long SFHInvalidCRC = 0;

const CFIndex SFHStreamEmpty = 0;
const CFIndex SFHStreamError = -1;

const NSInteger SFHCRC32MaxBufferSize = 1024;

@implementation NSURL (Hashing)

- (CFReadStreamRef)openReadStream:(NSURL *)url error:(NSError **)error
{
    // Get the file URL
    CFURLRef fileURL = (__bridge CFURLRef)(url);
    
    // Create and open the read stream
    CFReadStreamRef readStream = NULL;
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault, fileURL);
    
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    
    if(!didSucceed)
    {
        switch(CFReadStreamGetStatus(readStream))
        {
            case kCFStreamStatusError:
                if(*error != NULL)
                    *error = CFBridgingRelease(CFReadStreamCopyError(readStream));
                
                CFReadStreamClose(readStream);
                CFRelease(readStream);
                readStream = NULL;
                
                break;
                
            default:
                break;
        }
    }
    
    return readStream;
}

#pragma mark - Public API

- (void)crc32ValueWithProgress:(SFHProgressBlock)progressBlock compleation:(SFHCpmpleationBlock)compleationBlock
{
    [self crc32ValueFrom:0 progress:progressBlock compleation:compleationBlock];
}

- (void)crc32ValueFrom:(NSInteger)offset progress:(SFHProgressBlock)progressBlock compleation:(SFHCpmpleationBlock)compleationBlock
{
    [self crc32ValueForRange:NSMakeRange(offset, NSIntegerMax) progress:progressBlock compleation:compleationBlock options:SFHProgressUpdateSlow];
}

- (void)crc32ValueForRange:(NSRange)fileRange progress:(SFHProgressBlock)progressBlock compleation:(SFHCpmpleationBlock)compleationBlock options:(SFHCRC32Options)crc32Options
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        
        __block BOOL terminate = NO;
        
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:self.path error:nil];
        double fileSize = (double)[attrs fileSize];
        
        //Open Stream for reading
        CFReadStreamRef stream = [self openReadStream:self error:&error];
        

        
        NSAssert(stream, @"Could not open a stream to %@", self);
        
        if(!stream)
        {
            compleationBlock(self, SFHInvalidCRC, error); //failed
        }
        else
        {
            //Read upto start of range
            CFReadStreamSetProperty(stream, kCFStreamPropertyFileCurrentOffset, (CFNumberRef)@(fileRange.location));
            
            CFStreamStatus status = CFReadStreamGetStatus(stream);
            
            if(status == kCFStreamStatusError)
                NSLog(@"ERROR");
            
            long totalBytesRead = 0;
            double percentage = 0.05; //set this with options
            const int reportFreq = (int)ceil((fileSize * percentage)/SFHCRC32MaxBufferSize);
            int report = 0;
            
            BOOL readMoreData = YES;
            UInt8 buffer[SFHCRC32MaxBufferSize];
            uLong crc = crc32(0L, Z_NULL, 0);
            
            CFIndex maxReadLength = (CFIndex)sizeof(buffer);
            
            while(readMoreData)
            {
                if(terminate)
                    break; //we've been told to stop, TODO: error
                
                CFIndex readBytesCount = CFReadStreamRead(stream,
                                                          (UInt8 *)buffer,
                                                          MIN(maxReadLength, (fileRange.length - totalBytesRead)));
                
                totalBytesRead += readBytesCount; //update bytes read
                
                if (readBytesCount == SFHStreamError) break;
                else if (readBytesCount == SFHStreamEmpty) {
                    readMoreData = NO;
                    continue;
                }
                else if(totalBytesRead >= fileRange.length)
                {
                    readMoreData = NO;
                }
                
                crc = crc32(crc, buffer, (uInt)readBytesCount);
                
                
                report++;
                
                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if(((report % reportFreq) == 0) && (fileSize > 0))
                        terminate = !progressBlock(((double)totalBytesRead/fileSize));
                });
            }
            
            // Check if the read operation succeeded
            if(!readMoreData) //success
            {
                progressBlock(1.0f);
                compleationBlock(self, crc, nil);
            }
            else
            {
                compleationBlock(self, SFHInvalidCRC, error); //failed
            }
            
            CFReadStreamClose(stream);
            CFRelease(stream);
            stream = NULL;
        }
        
    });
}

@end
