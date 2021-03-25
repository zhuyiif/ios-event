//
//  NSString+Helpers.m
//  fb_event
//
//  Created by zack on 3/23/21.
//

#import <Foundation/Foundation.h>
#import "NSString+Helpers.h"

@implementation NSString (NumberConvenience)

- (NSDate *)eventDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, y hh:mm a"];
    NSDate *dateFromString = [dateFormatter dateFromString:self];
    return dateFromString;
}

@end
