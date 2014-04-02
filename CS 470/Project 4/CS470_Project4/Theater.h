//
//  Theater.h
//  TableViewDemoPart1
//
//  Created by AAK on 3/8/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Theater : NSObject

-(id) initWithDictionary: (NSDictionary *) dictionary;

- (NSString *) theaterName;
- (NSString *) line1address;
- (NSString *) cityName;
- (NSString *) zipCode;
- (NSString *) state;
- (void) print;

@end
