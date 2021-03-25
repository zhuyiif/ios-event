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
        [item setValue:[startStr eventDate] forKey:@"start_date"];
        
        NSString *endStr = [item objectForKey:@"end"];
        [item setValue:[endStr eventDate] forKey:@"end_date"];
        self.eventArray[i] = item;
    }
    
    // sort by start date
    NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"start_date" ascending:YES];
    self.eventArray = [[self.eventArray sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
    
    // group by day and check if conflict with previous most recent end date
    NSDate *preMostRecentEndDate;
    NSMutableArray *groupArray = [[NSMutableArray alloc] init];
    [groupArray addObject:[self.eventArray objectAtIndex:0]];
    [self.eventGroupByDayArray addObject:groupArray];
    preMostRecentEndDate =[[self.eventArray objectAtIndex:0] objectForKey:@"end_date"];
    
    for (int i = 1; i < self.eventArray.count; i++) {
        NSMutableDictionary *item = [self.eventArray objectAtIndex:i] ;
        NSDate *startDate = [item objectForKey:@"start_date"];
        NSDate *endDate = [item objectForKey:@"end_date"];
        // compare with previouse start date ,put into same array if it's same day
        NSMutableDictionary *preItem = [self.eventArray objectAtIndex:i - 1] ;
        NSDate *preStartDate = [preItem objectForKey:@"start_date"];
        
        //check previous most recent end date
        if([[NSCalendar currentCalendar] isDate:startDate inSameDayAsDate:preStartDate]) {
            NSComparisonResult dateComRes = [startDate compare:preMostRecentEndDate];
            if(dateComRes == NSOrderedAscending) {
                // conflict
                [item setObject:@"true" forKey:@"conflict"];
                [preItem setObject:@"true" forKey:@"conflict"];
            }
            [groupArray addObject:item];
            // check current enddate with most recent end date
            NSComparisonResult endDateComRes = [endDate compare:preMostRecentEndDate];
            if(endDateComRes != NSOrderedAscending) {
                //update preMostRecentEndDate
                preMostRecentEndDate = endDate;
            }
        }
        else {
            //if it's different date, create a new array
            groupArray = [[NSMutableArray alloc] init];
            [groupArray addObject:item];
            [self.eventGroupByDayArray addObject:groupArray];
            preMostRecentEndDate = endDate;
        }
    }
}


// for display
-(NSString *) eventAtIndex:(NSInteger) index section:(NSInteger)sec {
    NSArray *array = [self.eventGroupByDayArray objectAtIndex:sec];
    NSDictionary *item = [array objectAtIndex:index] ;
    NSString *start = [item objectForKey:@"start"];
    NSString *end = [item objectForKey:@"end"];
    NSString *title = [item objectForKey:@"title"];
    
    NSString *display = [NSString stringWithFormat:@"start = %@ \r\n end = %@ \r\n %@",start,end,title];
    return display;
}

-(BOOL) eventConflictAtIndex:(NSInteger) index section:(NSInteger)sec {
    NSArray *array = [self.eventGroupByDayArray objectAtIndex:sec];
    NSDictionary *item = [array objectAtIndex:index] ;
    if ([item objectForKey:@"conflict"] == nil) {
        return false;
    }
    return true;
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
    NSDate* startDate =  [event objectForKey:@"start_date"] ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d"];
    NSString *strDate = [dateFormatter stringFromDate:startDate];
    return strDate;
}

@end
