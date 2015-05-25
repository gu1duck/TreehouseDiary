//
//  NewEntryViewController.m
//  Diary
//
//  Created by Jeremy Petter on 2015-05-24.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "EntryViewController.h"
#import "DiaryEntry.h"
#import "CoreDataStack.h"
#import <CoreLocation/CoreLocation.h>

@interface EntryViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@property (nonatomic) UIImage *pickedImage;
@property (nonatomic) DiaryEntryMood pickedMood;
@property (nonatomic) CLLocationManager* locationManager;
@property (nonatomic) NSString* location;

@end

@implementation EntryViewController
- (IBAction)badPressed:(id)sender {
    self.pickedMood = DiaryEntryMoodBad;
}
- (IBAction)averagePressed:(id)sender {
    self.pickedMood = DiaryEntryMoodAverage;
}
- (IBAction)goodPressed:(id)sender {
    self.pickedMood = DiaryEntryMoodGood;
}

-(void) setPickedMood:(DiaryEntryMood)mood{
    _pickedMood = mood;
    
    self.goodButton.alpha = 0.5f;
    self.averageButton.alpha = 0.5f;
    self.badButton.alpha = 0.5f;
    
    int moodInt = (int)mood;
    
    switch(moodInt){
        case 0:
            self.goodButton.alpha = 1.0f;
            break;
        case 1:
            self.averageButton.alpha = 1.0f;
            break;
        case 2:
            self.badButton.alpha = 1.0f;
            break;
    }
}

- (IBAction)doneWasPressed:(id)sender {
    if (self.entry != nil){
        [self updateDiaryEntry];
    } else {
        [self insertDiaryEntry];
    }
    [self dismissSelf];
}
- (IBAction)cancelWasPressed:(id)sender {
    [self dismissSelf];
}

-(void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)insertDiaryEntry{
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    DiaryEntry* entry = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    entry.body = self.textView.text;
    entry.date = [[NSDate date] timeIntervalSince1970];
    entry.mood = self.pickedMood;
    entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 1.0);
    entry.location = self.location;
    [coreDataStack saveContext];
    
}

-(void)updateDiaryEntry{
    self.entry.body = self.textView.text;
    self.entry.mood = self.pickedMood;
    self.entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 1.0);
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate* date;
    
    if (self.entry != nil){
        self.textView.text = self.entry.body;
        self.pickedMood = self.entry.mood;
        date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
        self.pickedImage = [UIImage imageWithData: self.entry.imageData];
    } else {
        self.pickedMood = DiaryEntryMoodAverage;
        date = [NSDate date];
        [self loadLocation];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    self.textView.inputAccessoryView = self.accessoryView;
    self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame)/2;
    
}

-(void)loadLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = 1000;
    
    [self.locationManager startUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self.locationManager stopUpdatingLocation];
    CLLocation* location = locations[0];
    CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks, NSError* error){
        CLPlacemark *placemark = placemarks[0];
        self.location = placemark.name;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}
- (IBAction)imagePickerButtonWasPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    } else {
        [self promptForPhotoRoll];
    }
}

-(void) promptForSource{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photos", nil];
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex != actionSheet.firstOtherButtonIndex){
            [self promptForCamera];
        }
        [self promptForPhotoRoll];
    }
}

-(void)promptForCamera{
    UIImagePickerController* controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void)promptForPhotoRoll{
    UIImagePickerController* controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setPickedImage:(UIImage *)pickedImage{
    
    _pickedImage = pickedImage;
    if (pickedImage == nil){
        [self.imageButton setImage:[UIImage imageNamed:@"icn_noimage"] forState:UIControlStateNormal];
    } else {
        [self.imageButton setImage:pickedImage forState:UIControlStateNormal];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
