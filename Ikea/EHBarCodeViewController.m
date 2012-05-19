//
//  EHBarCodeViewController.m
//  Ikea
//
//  Created by Peter Verrillo on 5/19/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import "EHBarCodeViewController.h"

#import "ZBarSDK.h"

@interface EHBarCodeViewController ()

@end

@implementation EHBarCodeViewController

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
    // Do any additional setup after loading the view from its nib.
    [self loadBarCodeScanner];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) loadBarCodeScanner
{
    ZBarReaderViewController *vc = [ZBarReaderViewController new];
    vc.readerDelegate = self;
    
    [vc.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:0];
    vc.readerView.zoom = 1.0;
    
    [self presentModalViewController:vc animated:YES];
    
}

//zbarcode scanner delegate methods
- (void) imagePickerController: (UIImagePickerController*)reader didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSLog(@"Results: %@", results);
    
    [reader dismissModalViewControllerAnimated:YES];
    
    [self.navigationController popViewControllerAnimated:NO];
}

@end
