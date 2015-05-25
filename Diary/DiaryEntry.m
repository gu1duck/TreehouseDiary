//
//  DiaryEntry.m
//  Diary
//
//  Created by Jeremy Petter on 2015-05-24.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "DiaryEntry.h"


@implementation DiaryEntry

@dynamic body;
@dynamic mood;
@dynamic location;
@dynamic imageData;
@dynamic date;

-(NSString *)sectionName{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:self.date];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    return [dateFormatter stringFromDate:date];
}

@end
