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

-(void) loadBarCodeScanner;

@end
