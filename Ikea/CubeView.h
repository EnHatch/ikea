//
//  CubeView.h
//  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 EnHatch, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "isgl3d.h"

@interface CubeView : Isgl3dBasic3DView {
 
@private
    // The multi-material cube
    Isgl3dMultiMaterialCube * _cube;
}
 
@end
