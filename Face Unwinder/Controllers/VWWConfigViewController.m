//
//  VWWConfigViewController.m
//  Face Unwinder
//
//  Created by Zakk Hoyt on 10/8/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWConfigViewController.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "ELCAssetTablePicker.h"
#import "VWWStitcherViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

static NSString *kSegueSelectToStitch = @"segueSelectToStitch";

@interface VWWConfigViewController () <ELCImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *images;
@property (weak, nonatomic) IBOutlet UIButton *removeImagesButton;
@property (weak, nonatomic) IBOutlet UIButton *selectImagesButton;
@property (weak, nonatomic) IBOutlet UIButton *stitchImagesButton;
@property (weak, nonatomic) IBOutlet UISwitch *useThumbnailsSwitch;
@property (nonatomic) BOOL useThumbnails;
@end

@implementation VWWConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.images = [@[]mutableCopy];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateButtonTitles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:kSegueSelectToStitch]){
        VWWStitcherViewController *vc = segue.destinationViewController;
        vc.images = self.images;
    }
}

#pragma mark Private
-(void)updateButtonTitles{
    [self.useThumbnailsSwitch setOn:self.useThumbnails];
    [self.removeImagesButton setTitle:[NSString stringWithFormat:@"Remove Images (%d)", self.images.count] forState:UIControlStateNormal];
//    [self.selectImagesButton setTitle:[NSString stringWithFormat:@"2.) Select Images (%d)", self.images.count] forState:UIControlStateNormal];
    [self.stitchImagesButton setTitle:[NSString stringWithFormat:@"3.) Stitch Images (%d)", self.images.count] forState:UIControlStateNormal];
}


#pragma mark IBActions
- (IBAction)removeImagesButtonTouchUpInside:(id)sender {
    [self.images removeAllObjects];
    [self updateButtonTitles];
}


- (IBAction)selectImagesButtonTouchUpInside:(id)sender {
    [self chooseExistingPhoto];
    
}


- (IBAction)stitchImagesButtonTouchUpInside:(id)sender {
    [self performSegueWithIdentifier:kSegueSelectToStitch sender:self];
}

- (IBAction)useThumbnailsSwitchValueChanged:(UISwitch*)sender {
    self.useThumbnails = sender.on;
    [self.images removeAllObjects];
    [self updateButtonTitles];
}






-(void)chooseExistingPhoto{
    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName: nil bundle: nil];
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
    [albumController setParent:elcPicker];
	[elcPicker setDelegate:self];

    [self presentViewController:elcPicker animated:YES completion:^{
       
    }];
    
}


#pragma mark ELCImagePickerControllerDelegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    NSLog(@"images: %@", info);

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    
    for(NSDictionary *dictionary in info){
        
        if(self.useThumbnails) {
            NSString *assetURLString = dictionary[@"UIImagePickerControllerReferenceURL"];
            NSURL *assetURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", assetURLString]];
            __weak VWWConfigViewController *weakSelf = self;
            
            [library assetForURL:assetURL
                     resultBlock:^(ALAsset *asset) {
                         UIImage *thumbnail = [UIImage imageWithCGImage:asset.thumbnail];
                         [weakSelf.images addObject:thumbnail];
                         NSLog(@"added thumbnail");
                         [self updateButtonTitles];
                     } failureBlock:^(NSError *error) {
                         NSLog(@"Error iterating ALAsset");
                     }];
        }
        else{
            UIImage *image = dictionary[@"UIImagePickerControllerOriginalImage"];
            [self.images addObject:image];
        }
    }
    [self updateButtonTitles];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    NSLog(@"%s", __func__);
    
    [self updateButtonTitles];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
