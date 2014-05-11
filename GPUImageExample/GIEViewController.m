//
//  GIEViewController.m
//  GPUImageExample
//
//  Created by mito on 2014/05/11.
//  Copyright (c) 2014年 mito. All rights reserved.
//

#import "GIEViewController.h"
#import <GPUImage.h>

@interface GIEViewController ()
@property (weak, nonatomic) IBOutlet GPUImageView *gpuImageView;
@property (strong) GPUImageStillCamera *stillCamera;
@property (strong) GPUImagePicture *sourceImage;
@property (assign) NSUInteger selectedIndex;
@end

@implementation GIEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.stillCamera = [GPUImageStillCamera new];
    self.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    UIImage *image = [UIImage imageNamed:@"otter.jpg"];
    self.sourceImage = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];

    [self processImage];
}

- (IBAction)tap:(id)sender {
    self.selectedIndex = (self.selectedIndex + 1) % 6;
    [self processImage];
}

- (void)processImage
{
    GPUImageFilter *filter = [self filterByIndex:self.selectedIndex];
    BOOL isCamera = YES;
    if (isCamera) {
        [self.stillCamera removeAllTargets];
        [self.stillCamera addTarget:filter];
        [self.stillCamera startCameraCapture];
    } else {
        [self.sourceImage removeAllTargets];
        [self.sourceImage addTarget:filter];
        [self.sourceImage processImage];
    }
}

- (GPUImageFilter *)filterByIndex:(NSUInteger)index
{
    GPUImageFilter *filter = nil;
    switch (index) {
        case 0:
        {
            GPUImageSaturationFilter *saturationFilter = [GPUImageSaturationFilter new];
            saturationFilter.saturation = 1.0;
            filter = saturationFilter;
        }
            break;
        case 1:
        {
            GPUImageSobelEdgeDetectionFilter *sobelFilter = [GPUImageSobelEdgeDetectionFilter new];
            [sobelFilter forceProcessingAtSize:self.gpuImageView.sizeInPixels];
            filter = sobelFilter;
        }
            break;
        case 2:
        {
            GPUImageAmatorkaFilter *amatorkaFilter = [GPUImageAmatorkaFilter new];
            filter = (GPUImageFilter *)amatorkaFilter;
        }
            break;
        case 3:
        {
            GPUImageSepiaFilter *sepiaFilter = [GPUImageSepiaFilter new];
            filter = sepiaFilter;
        }
            break;
        case 4:
        {
            GPUImageSketchFilter *sketchFilter = [GPUImageSketchFilter new];
            filter = sketchFilter;
        }
            break;
        case 5:
        {
            GPUImageToonFilter *toonFilter = [GPUImageToonFilter new];
            filter = toonFilter;
        }
    }
    [filter addTarget:self.gpuImageView];
    return filter;
}

@end
