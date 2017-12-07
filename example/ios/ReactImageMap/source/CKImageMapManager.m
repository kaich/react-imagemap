//
//  CKImageMapManager.m
//  ReactImageMap
//
//  Created by mk on 2017/12/4.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "CKImageMapManager.h"
#import "ReactImageMap-Swift.h"

@implementation CKRNImageMapManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(imageURLString, NSString)
RCT_EXPORT_VIEW_PROPERTY(markers, NSArray);

- (UIView *)view
{
  return [[CKReactImageMapView alloc] init];
}


@end

