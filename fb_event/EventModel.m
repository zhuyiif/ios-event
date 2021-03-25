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

@end

@implementation EventModel

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
   
    
    
}

-(void) sortEventArray {
}
@end
