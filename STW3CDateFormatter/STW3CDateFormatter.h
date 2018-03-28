//  Copyright (c) 2013 Scott Talbot. All rights reserved.

#import <Foundation/Foundation.h>


@interface STW3CDateFormatter : NSFormatter

@property (nonatomic,strong,nullable) NSTimeZone *timeZone;

- (NSString * __nonnull)stringFromDate:(NSDate * __nonnull)date;
- (NSDate * __nullable)dateFromString:(NSString * __nonnull)string;

@end
