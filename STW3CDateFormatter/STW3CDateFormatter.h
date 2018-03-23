//  Copyright (c) 2013 Scott Talbot. All rights reserved.

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSInteger, STW3CDateFormatterOptions) {
	STW3CDateFormatterOptionOverrideTimeZone = 1,
};

@interface STW3CDateFormatter : NSFormatter

@property (nonatomic,strong,nullable) NSTimeZone *timeZone;

- (NSString * __nonnull)stringFromDate:(NSDate * __nonnull)date;
- (NSDate * __nullable)dateFromString:(NSString * __nonnull)string NS_SWIFT_UNAVAILABLE("");
- (NSDate * __nullable)dateFromString:(NSString * __nonnull)string options:(STW3CDateFormatterOptions)options;

@end
