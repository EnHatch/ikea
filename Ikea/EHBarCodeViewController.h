//
//  EHBarCodeViewController.h
//  Ikea
//
//  Created by Peter Verrillo on 5/19/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZBarSDK.h"

@interface EHBarCodeViewController : UIViewController <ZBarReaderDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *capturedImageView;
@property (nonatomic, retain) IBOutlet UILabel *barcodeLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;

-(void) loadBarCodeScanner;

@end
