//
//  EventModel.h
//  fb_event
//
//  Created by zack on 3/24/21.
//

#ifndef EventModel_h
#define EventModel_h
#import <Foundation/Foundation.h>

@interface EventModel : NSObject
-(void) loadJson;
-(NSString *) eventAtIndex:(NSInteger) index section:(NSInteger)sec;
-(BOOL) eventConflictAtIndex:(NSInteger) index section:(NSInteger)sec;
-(NSInteger) numberOfSections;
-(NSInteger) numberOfDateInSection:(NSInteger) section;
-(NSString *) sectionHeader:(NSInteger) section;
@end

#endif /* EventModel_h */
