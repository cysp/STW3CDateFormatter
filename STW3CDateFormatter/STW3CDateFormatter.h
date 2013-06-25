//  Copyright (c) 2013 Scott Talbot. All rights reserved.

#import <Foundation/Foundation.h>


@interface STW3CDateFormatter : NSFormatter

@property (nonatomic,strong) NSTimeZone *timeZone;

- (NSString *)stringFromDate:(NSDate *)date;
- (NSDate *)dateFromString:(NSString *)string;

@end
