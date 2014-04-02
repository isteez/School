//
//  ShowTime.h
//  TableViewDemoPart1
//
//  Created by AAK on 3/8/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Showtime : NSObject

-(id) initWithDictionary: (NSDictionary *) dictionary;

- (NSString *) time;
- (NSString *) movieTitle;
- (NSString *) theaterName;
- (void) print;

@end
