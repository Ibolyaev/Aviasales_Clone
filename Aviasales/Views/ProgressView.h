//
//  ProgressView.h
//  air
//
//  Created by kuzindmitry on 08.11.2017.
//  Copyright © 2017 kuzindmitry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

+ (instancetype)sharedInstance;

- (void)show:(void (^)(void))completion;
- (void)dismiss:(void (^)(void))completion;

@end
