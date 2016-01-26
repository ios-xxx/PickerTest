//
//  ViewController.h
//  PickerTest
//
//  Created by admin on 16/1/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *TxtInput;


@end

