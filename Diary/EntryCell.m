//
//  EntryCell.m
//  Diary
//
//  Created by Jeremy Petter on 2015-05-24.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "EntryCell.h"
#import "DiaryEntry.h"
#import <QuartzCore/QuartzCore.h>

@interface EntryCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;


@end

@implementation EntryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)heightForEntry: (DiaryEntry *) entry atWidth: (CGFloat) width{
    const CGFloat topMargin = 35.0f;
    const CGFloat bottomMargin = 120.0f;
    const CGFloat minHeight = 120.0f;
    
    UIFont* font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGRect boundingBox = [entry.body boundingRectWithSize:CGSizeMake(width-149.0, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: font} context:nil];
    
    return MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin +bottomMargin);
}

- (void)configureCellForEntry:(DiaryEntry*)entry{
    self.bodyLabel.text = entry.body;
    self.locationLabel.text = entry.location;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EEEE, MMMM d yyyy"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    if (entry.imageData){
        self.mainImage.image = [UIImage imageWithData:entry.imageData];
    } else {
        self.mainImage.image = [UIImage imageNamed:@"icn_noimage"];
    }
    if (entry.mood == DiaryEntryMoodGood){
        self.moodImageView.image = [UIImage imageNamed:@"icn_happy"];
        
    } else if (entry.mood == DiaryEntryMoodBad){
        self.moodImageView.image = [UIImage imageNamed:@"icn_bad"];
    } else {
        self.moodImageView.image = [UIImage imageNamed:@"icn_average"];
    }
    
    self.mainImage.layer.cornerRadius = CGRectGetWidth(self.mainImage.frame) / 2;
    if (entry.location.length > 0) {
        self.locationLabel.text = entry.location;
    } else {
        self.locationLabel.text = @"No location";
    }
    
}

@end
