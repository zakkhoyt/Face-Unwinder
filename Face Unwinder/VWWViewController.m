//
//  VWWViewController.m
//  Face Unwinder
//
//  Created by Zakk Hoyt on 10/8/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWViewController.h"
#import "CVWrapper.h"

@interface VWWViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* spinner;
@property (nonatomic, weak) IBOutlet UIImageView* imageView;
@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;
@end

@implementation VWWViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self stitch];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) stitch
{
    [self.spinner startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        //        NSArray* imageArray = [NSArray arrayWithObjects:
        //                               [UIImage imageNamed:@"pano_19_16_mid.jpg"]
        //                               ,[UIImage imageNamed:@"pano_19_20_mid.jpg"]
        //                               ,[UIImage imageNamed:@"pano_19_22_mid.jpg"]
        //                               ,[UIImage imageNamed:@"pano_19_25_mid.jpg"]
        //                               , nil];
        //        NSArray *imageArray = @[[UIImage imageNamed:@"photo1.jpg"],
        //                                [UIImage imageNamed:@"photo2.jpg"],
        //                                [UIImage imageNamed:@"photo3.jpg"],
        //                                [UIImage imageNamed:@"photo4.jpg"],
        //                                [UIImage imageNamed:@"photo5.jpg"],
        //                                [UIImage imageNamed:@"photo6.jpg"]];
        //        NSArray *imageArray = @[[UIImage imageNamed:@"photo7.jpg"],
        //                                [UIImage imageNamed:@"photo8.jpg"],
        //                                [UIImage imageNamed:@"photo9.jpg"],
        //                                [UIImage imageNamed:@"photo10.jpg"],
        //                                [UIImage imageNamed:@"photo11.jpg"],
        //                                [UIImage imageNamed:@"photo12.jpg"]];
        //        NSArray *imageArray = @[[UIImage imageNamed:@"41.jpg"],
        //                                [UIImage imageNamed:@"42.jpg"],
        //                                [UIImage imageNamed:@"43.jpg"],
        //                                [UIImage imageNamed:@"44.jpg"],
        //                                [UIImage imageNamed:@"45.jpg"],
        //                                [UIImage imageNamed:@"46.jpg"]];
        NSArray *imageArray = @[[UIImage imageNamed:@"61.jpg"],
                                [UIImage imageNamed:@"62.jpg"],
                                [UIImage imageNamed:@"63.jpg"],
                                [UIImage imageNamed:@"64.jpg"],
                                [UIImage imageNamed:@"65.jpg"],
                                [UIImage imageNamed:@"66.jpg"]];
        
        
        UIImage* stitchedImage = [CVWrapper processWithArray:imageArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog (@"stitchedImage %@",stitchedImage);
            UIImageView* imageView = [[UIImageView alloc] initWithImage:stitchedImage];
            self.imageView = imageView;
            [self.scrollView addSubview:imageView];
            self.scrollView.backgroundColor = [UIColor blackColor];
            self.scrollView.contentSize = self.imageView.bounds.size;
            self.scrollView.maximumZoomScale = 4.0;
            self.scrollView.minimumZoomScale = 0.1;
            self.scrollView.contentOffset = CGPointMake(-(self.scrollView.bounds.size.width-self.imageView.bounds.size.width)/2, -(self.scrollView.bounds.size.height-self.imageView.bounds.size.height)/2);
            NSLog (@"scrollview contentSize %@",NSStringFromCGSize(self.scrollView.contentSize));
            [self.spinner stopAnimating];
            
        });
    });
}

#pragma mark - scroll view delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
@end
