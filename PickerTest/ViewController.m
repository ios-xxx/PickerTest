//
//  ViewController.m
//  PickerTest
//
//  Created by admin on 16/1/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray *  citysArr;//获得全国所有省市区
    
    NSMutableArray * provinces;//省
    
    NSMutableArray * citys;//市
    
    NSMutableArray * countys;//县
    
    NSMutableArray * countysTmp; //临时有存放县数组中内容
    
    UIPickerView * picker;
    
    UILabel* pickerLabel;
    
    NSString * province; //省
    
    NSString * city;//市
    
    NSString * county; //县
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

//获取中国所有城市
-(void)getChinaCitysAndCounty
{
    //获取文件路径
    NSString * path = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"txt"];
    
    NSString * pathContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //NSLog(@"path=%@",pathContents);
    
    citysArr =[NSJSONSerialization JSONObjectWithData:[pathContents dataUsingEncoding:NSUTF8StringEncoding]
                                              options:NSJSONReadingMutableContainers error:NULL];
    //将全国所有省名字存入这个数组
    provinces = [[NSMutableArray alloc]initWithCapacity:50];
    
    //将当前省所有市名字存入这个数组
    citys = [[NSMutableArray alloc]initWithCapacity:30];
    
    //将当前省所有市名字存入这个数组
    countysTmp = [[NSMutableArray alloc]initWithCapacity:30];
    
    //得到全国所有省并存入数组
    for (NSDictionary * dict in citysArr)
    {
        //获取省名字
        NSString * citystr = [dict objectForKey:@"name"];
        
        [ provinces addObject:citystr];
    }
    
    //默认省
    province=@"北京";
    //默认市
    city=@"北京";
    //默认区或县
    county = @"东城区";
    
    //获取默认省有多少个市
    [self getCityAndCounty:0];
    //获取默认市有多少个县和区
    [self getCountys:0];
    // Do any additional setup after loading the view, typically from a nib.
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return  provinces.count;
            break;
        case 1:
            return  citys.count;
            break;
        case 2:
            return  countys.count;
            break;
        default:
            break;
    }
    return YES;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
            
        case 0:
            return [NSString stringWithFormat:@"%@", provinces[row]];
            break;
            
        case 1:
           
                return [NSString stringWithFormat:@"%@",citys[row]];
            break;
            
        case 2:
            
            return [NSString stringWithFormat:@"%@",countys[row]];
            break;
            
        default:
            return @"";
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 10.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    
    pickerView.tintColor = [UIColor blackColor];
    
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
            
        case 0:
        {
            [citys removeAllObjects];
            
            [countys removeAllObjects];
            
            [countysTmp removeAllObjects];
           
            //获取当前省所有市
            NSMutableArray * currenCity = [self getCityAndCounty:row];
            //获取当前市所有区和县
            NSMutableArray * currenCounty = [self getCountys:0];
           
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
            province = provinces[row];
            
            city = currenCity[0];
            
            county = currenCounty[0];
            break;
        }
            
        case 1:
        {
            //获得市的县和区
           NSMutableArray * currenCounty = [self getCountys:row];
            
            city = pickerLabel.text;
            
            county = currenCounty[1];
            
            [pickerView reloadComponent:2];
            
            [pickerView selectRow:1 inComponent:2 animated:YES];
            
            break;
        }
        default:
            county = pickerLabel.text;
            break;
    }
}
//得到当前县和区
-(NSMutableArray *)getCountys:(NSInteger )_row
{
    //把当前市的所有区和县转换为字符串
    NSString * countyStr= [countysTmp componentsJoinedByString:@","];
    
    //  NSLog(@"%@",countyStr);
    //把转换好的字符串再转回数组（通过“/”间隔元素）
    NSArray * countyArr = [countyStr componentsSeparatedByString:NSLocalizedString(@"/", nil)];
  //  NSLog(@"%lu",(unsigned long)countyArr.count);
 
    NSArray * countyTmpArr = [countyArr[_row] componentsSeparatedByString:@","];
   
    [countys removeAllObjects];
    
    //把转换后的县和区赋值给保存县和区的数组
    countys =(NSMutableArray *) countyTmpArr;
    
    return  countys;
}
//获取当前省会所有市和（区、县）
-(NSMutableArray *)getCityAndCounty:(NSInteger )_row
{
    NSDictionary * dictCity = [citysArr[_row] objectForKey:@"city"];
    
    for (NSDictionary * dict in dictCity)
    {
        
        NSString * cityStr = [dict objectForKey:@"name"];
        //获取当前省所有市
        [ citys addObject:cityStr];
        
        //NSLog(@"%@",citys);
        
        //获取北京直辖市所有区和县
        NSArray * countyArr = [NSArray arrayWithObjects:[dict objectForKey:@"area"], nil];
        
        for (NSArray * ArrCounty  in countyArr )
        {
            int i = 0;
            for (NSString * countyStr in ArrCounty) {
                
                i++;
                
                [countysTmp addObject:countyStr];
                
                if (i == ArrCounty.count-1) {
                    
                    [countysTmp addObject:@"/"];
                }
                
                //NSLog(@"%@",countys);
            }
            
        }
        
        
    }
    return citys;
}

//删除和替换字符串
-(NSString *)deleteStr:(NSMutableString *)str_1 andToStr:(NSString *)str_2 andStrLength:(NSInteger )_length;
{
    
    NSRange range =[str_1 rangeOfString:str_2];
    
    //NSLog(@"range==%ld",range.length);
    
    if (range.length > 0)
    {
        NSRange deleage={range.location,range.length};
        
        [str_1 deleteCharactersInRange:deleage];
    }
    
    return str_1;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    //获取中国所有城市
    [self getChinaCitysAndCounty];
    
    UIButton * BtnView = [[UIButton alloc]init];
    
    BtnView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    
    [BtnView addTarget:self action:@selector(BtnTap:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:BtnView];
    
    
    picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    picker.delegate = self;
    picker.dataSource = self;
   // picker.backgroundColor=[UIColor orangeColor];
    
    [self.view addSubview:picker];
    
    [UIView animateWithDuration:0.8 animations:^{
        
        BtnView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
        picker.frame = CGRectMake(10, self.view.center.y-150, self.view.frame.size.width-20, 200);
    }];
}

-(void)BtnTap:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        sender.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
        
        picker.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
        
    } completion:^(BOOL finished) {
        
        [sender removeFromSuperview];
        
        [picker removeFromSuperview];
        
        NSLog(@"%@/%@/%@",province,city,county);
    }];
    
    [provinces removeAllObjects];
    
    [citys removeAllObjects];
    
    [countys removeAllObjects];
    
    [countysTmp removeAllObjects];
    
}

@end
