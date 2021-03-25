//
//  EventModel.m
//  fb_event
//
//  Created by zack on 3/24/21.
//

#import "EventModel.h"
#import "NSString+Helpers.h"

@interface EventModel ()

@property (strong, nonatomic) NSMutableArray * eventArray;

@property (strong, nonatomic) NSMutableArray * eventGroupByDayArray;

@end

@implementation EventModel

- (instancetype)init {
    self = [super init];
    self.eventGroupByDayArray = [[NSMutableArray alloc] init];
    return self;
}

-(void) loadJson {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mock" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.eventArray = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] mutableCopy];
    
    // convert string date to NSDate
    for (int i = 0; i < self.eventArray.count; i++) {
        NSMutableDictionary *item = [[self.eventArray objectAtIndex:i] mutableCopy];
        NSString *startStr = [item objectForKey:@"start"];
        [item setValue:[startStr eventDate] forKey:@"start"];
        
        NSString *endStr = [item objectForKey:@"end"];
        [item setValue:[endStr eventDate] forKey:@"end"];
        self.eventArray[i] = item;
    }
    
    // sort by start date
    NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"start" ascending:YES];
    self.eventArray = [[self.eventArray sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
    
    for (int i = 0; i < self.eventArray.count; i++) {
        NSDictionary *item = [self.eventArray objectAtIndex:i] ;
        NSDate *startDate = [item objectForKey:@"start"];
        NSLog(@"after sort start = %@",startDate);
    }
    
    // group by day
    NSMutableArray *groupArray = [[NSMutableArray alloc] init];
    [groupArray addObject:[self.eventArray objectAtIndex:0]];
    [self.eventGroupByDayArray addObject:groupArray];
    
    for (int i = 1; i < self.eventArray.count; i++) {
        NSDictionary *item = [self.eventArray objectAtIndex:i] ;
        NSDate *startDate = [item objectForKey:@"start"];
        
        NSDictionary *preItem = [self.eventArray objectAtIndex:i - 1] ;
        NSDate *preStartDate = [preItem objectForKey:@"start"];
        
        NSLog(@"%@ %@", startDate, preStartDate);
        
        if([[NSCalendar currentCalendar] isDate:startDate inSameDayAsDate:preStartDate]) {
            [groupArray addObject:item];
            NSLog(@"same day");
        }
        else {
            NSLog(@"different day");
            // create a new array
            groupArray = [[NSMutableArray alloc] init];
            [groupArray addObject:item];
            [self.eventGroupByDayArray addObject:groupArray];
        }
    }
    
    
    
    
}

-(NSInteger) numberOfSections {
    return self.eventGroupByDayArray.count;
}

-(NSInteger) numberOfDateInSection:(NSInteger) section {
    NSArray *array = [self.eventGroupByDayArray objectAtIndex:section];
    return array.count;
}

-(NSString *) sectionHeader:(NSInteger) section {
    NSArray *array = [self.eventGroupByDayArray objectAtIndex:section];
    NSDictionary *event = [array firstObject];
    NSDate* startDate =  [event objectForKey:@"start"] ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d"];
    NSString *strDate = [dateFormatter stringFromDate:startDate];
    return strDate;
}

@end
