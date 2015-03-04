//  Copyright (c) 2013 Scott Talbot. All rights reserved.

#import "STW3CDateFormatter.h"

//#define NS_ENABLE_CALENDAR_NEW_API 1

static NSString * const STW3CDateFormatterRegExpPattern = @""
"^"
"(\\d{4})(?:-(\\d{2})(?:-(\\d{2})(?:T(\\d{2})(?::(\\d{2})(?:(?::(\\d{2})(?:.(\\d+))?)?(?:(Z|([+-])(\\d\\d):(\\d\\d)))?)?)?)?)?)?"
"$";

static NSRegularExpression *STW3CDateFormatterRegExp = nil;

static NSUInteger const STW3CDateFormatterCalendarUnits = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond/*|NSCalendarUnitNanosecond*/|NSCalendarUnitTimeZone;


static inline void STW3CDateFormatterInit(STW3CDateFormatter *self);


@implementation STW3CDateFormatter {
@package
	NSCalendar *_gregorian;
}

+ (void)initialize {
	if (self == [STW3CDateFormatter class]) {
		NSError *error = nil;
		STW3CDateFormatterRegExp = [[NSRegularExpression alloc] initWithPattern:STW3CDateFormatterRegExpPattern options:0 error:&error];
		NSAssert(STW3CDateFormatterRegExp, @"failed to create regex: %@", error);
	}
}

- (id)init {
	if ((self = [super init])) {
		STW3CDateFormatterInit(self);
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		STW3CDateFormatterInit(self);
	}
	return self;
}


- (NSTimeZone *)timeZone {
	return [_gregorian timeZone];
}
- (void)setTimeZone:(NSTimeZone *)timeZone {
	return [_gregorian setTimeZone:timeZone];
}


- (NSString *)stringForObjectValue:(id)obj {
	if ([obj isKindOfClass:[NSDate class]]) {
		NSDate * const date = obj;

		NSDateComponents * const components = [_gregorian components:STW3CDateFormatterCalendarUnits fromDate:date];
		char buf[25];
		char *p = buf;

		NSInteger const YYYY = components.year;
		if (YYYY != NSDateComponentUndefined) {
			NSInteger const v = (int)MAX(0, YYYY);
			*p++ = '0' + (char)(v / 1000);
			*p++ = '0' + (v % 1000) / 100;
			*p++ = '0' + (v % 100) / 10;
			*p++ = '0' + (v % 10);
		} else {
			*p++ = '0';
			*p++ = '0';
			*p++ = '0';
			*p++ = '0';
		}

		*p++ = '-';

		NSInteger const MM = components.month;
		if (MM != NSDateComponentUndefined) {
			NSInteger const v = (int)MAX(1, MM);
			*p++ = '0' + (v % 100) / 10;
			*p++ = '0' + (v % 10);
		} else {
			*p++ = '0';
			*p++ = '1';
		}

		*p++ = '-';

		NSInteger const DD = components.day;
		if (DD != NSDateComponentUndefined) {
			NSInteger const v = (int)MAX(1, DD);
			*p++ = '0' + (v % 100) / 10;
			*p++ = '0' + (v % 10);
		} else {
			*p++ = '0';
			*p++ = '1';
		}

		*p++ = 'T';

		NSInteger const hh = components.hour;
		if (hh != NSDateComponentUndefined) {
			NSInteger const v = (int)MAX(0, hh);
			*p++ = '0' + (v % 100) / 10;
			*p++ = '0' + (v % 10);
		} else {
			*p++ = '0';
			*p++ = '0';
		}

		*p++ = ':';

		NSInteger const mm = components.minute;
		if (mm != NSDateComponentUndefined) {
			NSInteger const v = (int)MAX(0, mm);
			*p++ = '0' + (v % 100) / 10;
			*p++ = '0' + (v % 10);
		} else {
			*p++ = '0';
			*p++ = '0';
		}

		NSInteger const ss = components.second;
		if (ss != NSDateComponentUndefined && ss != 0) {
			NSInteger const v = (int)MAX(0, ss);
			*p++ = '0' + (v % 100) / 10;
			*p++ = '0' + (v % 10);
		}

		NSTimeZone * const tz = components.timeZone;
		NSInteger const tzs = [tz secondsFromGMTForDate:date];
		if (tzs == 0) {
			*p++ = 'Z';
		} else {
			*p++ = (tzs < 0) ? '-' : '+';
			NSUInteger const tzspos = (NSUInteger)abs((int)tzs);
			{
				NSInteger const v = (int)tzspos / (60 * 60);
				*p++ = '0' + (v % 100) / 10;
				*p++ = '0' + (v % 10);
			}
			*p++ = ':';
			{
				NSInteger const v = (int)tzspos % (60 * 60);
				*p++ = '0' + (v % 100) / 10;
				*p++ = '0' + (v % 10);
			}
		}

		return [[NSString alloc] initWithBytes:buf length:(NSUInteger)(p - buf) encoding:NSUTF8StringEncoding];
	}
	return nil;
}

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error {
	NSArray * const matches = [STW3CDateFormatterRegExp matchesInString:string options:0 range:(NSRange){ .length = [string length] }];

	NSTextCheckingResult * const match = [matches lastObject];
	NSRange const yearRange = [match rangeAtIndex:1];
	NSRange const monthRange = [match rangeAtIndex:2];
	NSRange const dayRange = [match rangeAtIndex:3];
	NSRange const hourRange = [match rangeAtIndex:4];
	NSRange const minuteRange = [match rangeAtIndex:5];
	NSRange const secondRange = [match rangeAtIndex:6];
	NSRange const timezoneRange = [match rangeAtIndex:8];
	NSRange const timezonesignRange = [match rangeAtIndex:9];
	NSRange const timezonehourRange = [match rangeAtIndex:10];
	NSRange const timezoneminuteRange = [match rangeAtIndex:11];

	NSDateComponents * const components = [[NSDateComponents alloc] init];
	components.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];

	if (yearRange.location != NSNotFound) {
		components.year = [[string substringWithRange:yearRange] integerValue];
	}
	if (monthRange.location != NSNotFound) {
		components.month = [[string substringWithRange:monthRange] integerValue];
	}
	if (dayRange.location != NSNotFound) {
		components.day = [[string substringWithRange:dayRange] integerValue];
	}
	if (hourRange.location != NSNotFound) {
		components.hour = [[string substringWithRange:hourRange] integerValue];
	}
	if (minuteRange.location != NSNotFound) {
		components.minute = [[string substringWithRange:minuteRange] integerValue];
	}
	if (secondRange.location != NSNotFound) {
		components.second = [[string substringWithRange:secondRange] integerValue];
	}
	if (timezoneRange.location != NSNotFound) {
		NSString * const timezonestring = [string substringWithRange:timezoneRange];
		if (![@"Z" isEqualToString:timezonestring]) {
			NSInteger const timezonesign = [@"-" isEqualToString:[string substringWithRange:timezonesignRange]] ? -1 : 1;
			NSInteger const timezonehour = [[string substringWithRange:timezonehourRange] integerValue];
			NSInteger const timezoneminute = [[string substringWithRange:timezoneminuteRange] integerValue];
			components.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:timezonesign * ((timezonehour * 60 + timezoneminute) * 60)];
		}
	}

	NSCalendar * const gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	gregorian.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];

	NSDate * const date = [gregorian dateFromComponents:components];
	if (date) {
		if (obj) {
			*obj = date;
		}
		return YES;
	}

	if (error) {
		*error = @"Malformed input";
	}

	return NO;
}


- (NSString *)stringFromDate:(NSDate *)date {
	return [self stringForObjectValue:date];
}

- (NSDate *)dateFromString:(NSString *)string {
	id date;

	NSString *errorDescription = nil;
	if ([self getObjectValue:&date forString:string errorDescription:&errorDescription]) {
		return date;
	}

	return nil;
}

@end


static inline void STW3CDateFormatterInit(STW3CDateFormatter *self) {
	self->_gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	self->_gregorian.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
}
