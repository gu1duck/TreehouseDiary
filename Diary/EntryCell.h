//
//  EntryCell.h
//  Diary
//
//  Created by Jeremy Petter on 2015-05-24.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiaryEntry;

@interface EntryCell : UITableViewCell
+ (CGFloat)heightForEntry: (DiaryEntry *) entry atWidth: (CGFloat) width;
- (void) configureCellForEntry:(DiaryEntry*)entry;

@end
