//
//  DiaryEntry.h
//  Diary
//
//  Created by Jeremy Petter on 2015-05-24.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum DiaryEntryMood{
    DiaryEntryMoodGood,
    DiaryEntryMoodAverage,
    DiaryEntryMoodBad
}DiaryEntryMood;

@interface DiaryEntry : NSManagedObject

@property (nonatomic, retain) NSString* body;
@property (nonatomic) int16_t mood;
@property (nonatomic, retain) NSString* location;
@property (nonatomic, retain) NSData* imageData;
@property (nonatomic) NSTimeInterval date;

@property (nonatomic, readonly) NSString* sectionName;

@end
