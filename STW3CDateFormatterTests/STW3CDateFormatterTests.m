//  Copyright (c) 2013 Scott Talbot. All rights reserved.

#import <XCTest/XCTest.h>

#import "STW3CDateFormatter.h"


static NSUInteger const STW3CDateFormatterTestsCalendarUnits = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond/*|NSCalendarUnitNanosecond*/|NSCalendarUnitTimeZone;


@interface STW3CDateFormatterTests : XCTestCase
@end

@implementation STW3CDateFormatterTests {
@private
	STW3CDateFormatter *_formatter;
	NSCalendar *_gregorian;
}

- (void)setUp {
    [super setUp];

	_gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	_gregorian.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
	_formatter = [[STW3CDateFormatter alloc] init];
}

- (void)testParsing {
	{
		NSString * const input = @"1997";
		NSDate * const outputDate = [_formatter dateFromString:input];
		NSDateComponents * const outputDateComponents = [_gregorian components:STW3CDateFormatterTestsCalendarUnits fromDate:outputDate];

		XCTAssertEqual(outputDateComponents.year, (NSInteger)1997, @"");
		XCTAssertEqual(outputDateComponents.month, (NSInteger)1, @"");
		XCTAssertEqual(outputDateComponents.day, (NSInteger)1, @"");
		XCTAssertEqual(outputDateComponents.hour, (NSInteger)0, @"");
		XCTAssertEqual(outputDateComponents.minute, (NSInteger)0, @"");
		XCTAssertEqual(outputDateComponents.second, (NSInteger)0, @"");
		XCTAssertEqual([outputDateComponents.timeZone secondsFromGMT], (NSInteger)0, @"");
	}
	{
		NSString * const input = @"1997-07";
		NSDate * const outputDate = [_formatter dateFromString:input];
		NSDateComponents * const outputDateComponents = [_gregorian components:STW3CDateFormatterTestsCalendarUnits fromDate:outputDate];

		XCTAssertEqual(outputDateComponents.year, (NSInteger)1997, @"");
		XCTAssertEqual(outputDateComponents.month, (NSInteger)7, @"");
		XCTAssertEqual(outputDateComponents.day, (NSInteger)1, @"");
		XCTAssertEqual(outputDateComponents.hour, (NSInteger)0, @"");
		XCTAssertEqual(outputDateComponents.minute, (NSInteger)0, @"");
		XCTAssertEqual(outputDateComponents.second, (NSInteger)0, @"");
		XCTAssertEqual([outputDateComponents.timeZone secondsFromGMT], (NSInteger)0, @"");
	}
	{
		NSString * const input = @"1997-07-16";
		NSDate * const outputDate = [_formatter dateFromString:input];
		NSDateComponents * const outputDateComponents = [_gregorian components:STW3CDateFormatterTestsCalendarUnits fromDate:outputDate];

		XCTAssertEqual(outputDateComponents.year, (NSInteger)1997, @"");
		XCTAssertEqual(outputDateComponents.month, (NSInteger)7, @"");
		XCTAssertEqual(outputDateComponents.day, (NSInteger)16, @"");
		XCTAssertEqual(outputDateComponents.hour, (NSInteger)0, @"");
		XCTAssertEqual(outputDateComponents.minute, (NSInteger)0, @"");
		XCTAssertEqual(outputDateComponents.second, (NSInteger)0, @"");
		XCTAssertEqual([outputDateComponents.timeZone secondsFromGMT], (NSInteger)0, @"");
	}
	{
		NSString * const input = @"1997-07-16T00:00Z";
		NSDate * const outputDate = [_formatter dateFromString:input];
		NSDateComponents * const outputDateComponents = [_gregorian components:STW3CDateFormatterTestsCalendarUnits fromDate:outputDate];

		XCTAssertEqual(outputDateComponents.year, (NSInteger)1997, @"");
		XCTAssertEqual(outputDateComponents.month, (NSInteger)7, @"");
		XCTAssertEqual(outputDateComponents.day, (NSInteger)16, @"");
		XCTAssertEqual(outputDateComponents.hour, (NSInteger)0, @"");
		XCTAssertEqual(outputDateComponents.minute, (NSInteger)0, @"");
		XCTAssertEqual(outputDateComponents.second, (NSInteger)0, @"");
		XCTAssertEqual([outputDateComponents.timeZone secondsFromGMT], (NSInteger)0, @"");
	}
	{
		NSString * const input = @"1997-07-16T19:20+01:00";
		NSDate * const outputDate = [_formatter dateFromString:input];
		NSDateComponents * const outputDateComponents = [_gregorian components:STW3CDateFormatterTestsCalendarUnits fromDate:outputDate];

		XCTAssertEqual(outputDateComponents.year, (NSInteger)1997, @"");
		XCTAssertEqual(outputDateComponents.month, (NSInteger)7, @"");
		XCTAssertEqual(outputDateComponents.day, (NSInteger)16, @"");
		XCTAssertEqual(outputDateComponents.hour, (NSInteger)18, @"");
		XCTAssertEqual(outputDateComponents.minute, (NSInteger)20, @"");
		XCTAssertEqual(outputDateComponents.second, (NSInteger)0, @"");
		XCTAssertEqual([outputDateComponents.timeZone secondsFromGMT], (NSInteger)0, @"");
	}
	{
		NSString * const input = @"1997-07-16T19:20:30+01:00";
		NSDate * const outputDate = [_formatter dateFromString:input];
		NSDateComponents * const outputDateComponents = [_gregorian components:STW3CDateFormatterTestsCalendarUnits fromDate:outputDate];

		XCTAssertEqual(outputDateComponents.year, (NSInteger)1997, @"");
		XCTAssertEqual(outputDateComponents.month, (NSInteger)7, @"");
		XCTAssertEqual(outputDateComponents.day, (NSInteger)16, @"");
		XCTAssertEqual(outputDateComponents.hour, (NSInteger)18, @"");
		XCTAssertEqual(outputDateComponents.minute, (NSInteger)20, @"");
		XCTAssertEqual(outputDateComponents.second, (NSInteger)30, @"");
		XCTAssertEqual([outputDateComponents.timeZone secondsFromGMT], (NSInteger)0, @"");
	}
	{
		NSString * const input = @"1997-07-16T19:20:30.45+01:00";
		NSDate * const outputDate = [_formatter dateFromString:input];
		NSDateComponents * const outputDateComponents = [_gregorian components:STW3CDateFormatterTestsCalendarUnits fromDate:outputDate];

		XCTAssertEqual(outputDateComponents.year, (NSInteger)1997, @"");
		XCTAssertEqual(outputDateComponents.month, (NSInteger)7, @"");
		XCTAssertEqual(outputDateComponents.day, (NSInteger)16, @"");
		XCTAssertEqual(outputDateComponents.hour, (NSInteger)18, @"");
		XCTAssertEqual(outputDateComponents.minute, (NSInteger)20, @"");
		XCTAssertEqual(outputDateComponents.second, (NSInteger)30, @"");
		XCTAssertEqual([outputDateComponents.timeZone secondsFromGMT], (NSInteger)0, @"");
	}
	{
		NSString * const input = @"1997-07-16T19:20:30.45+00:00";
		NSDate * const outputDate = [_formatter dateFromString:input];
		NSDateComponents * const outputDateComponents = [_gregorian components:STW3CDateFormatterTestsCalendarUnits fromDate:outputDate];

		XCTAssertEqual(outputDateComponents.year, (NSInteger)1997, @"");
		XCTAssertEqual(outputDateComponents.month, (NSInteger)7, @"");
		XCTAssertEqual(outputDateComponents.day, (NSInteger)16, @"");
		XCTAssertEqual(outputDateComponents.hour, (NSInteger)19, @"");
		XCTAssertEqual(outputDateComponents.minute, (NSInteger)20, @"");
		XCTAssertEqual(outputDateComponents.second, (NSInteger)30, @"");
		XCTAssertEqual([outputDateComponents.timeZone secondsFromGMT], (NSInteger)0, @"");
	}
	{
		NSString * const input = @"1997-07-16T19:20:30.45-01:00";
		NSDate * const outputDate = [_formatter dateFromString:input];
		NSDateComponents * const outputDateComponents = [_gregorian components:STW3CDateFormatterTestsCalendarUnits fromDate:outputDate];

		XCTAssertEqual(outputDateComponents.year, (NSInteger)1997, @"");
		XCTAssertEqual(outputDateComponents.month, (NSInteger)7, @"");
		XCTAssertEqual(outputDateComponents.day, (NSInteger)16, @"");
		XCTAssertEqual(outputDateComponents.hour, (NSInteger)20, @"");
		XCTAssertEqual(outputDateComponents.minute, (NSInteger)20, @"");
		XCTAssertEqual(outputDateComponents.second, (NSInteger)30, @"");
		XCTAssertEqual([outputDateComponents.timeZone secondsFromGMT], (NSInteger)0, @"");
	}

	{
		NSString * const inputA = @"1994-11-05T08:15:30-05:00";
		NSString * const inputB = @"1994-11-05T13:15:30Z";
		NSDate * const outputA = [_formatter dateFromString:inputA];
		NSDate * const outputB = [_formatter dateFromString:inputB];

		XCTAssertEqualObjects(outputA, outputB, @"");
	}
}

- (void)testStringing {
	{
		NSDate * const input = [NSDate dateWithTimeIntervalSince1970:0];
		NSString * const output = [_formatter stringFromDate:input];
		NSString * const expected = @"1970-01-01T00:00Z";
		XCTAssertEqualObjects(output, expected, @"");
	}
	{
		NSDate * const input = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
		NSString * const output = [_formatter stringFromDate:input];
		NSString * const expected = @"2001-01-01T00:00Z";
		XCTAssertEqualObjects(output, expected, @"");
	}
}

@end
