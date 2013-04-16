//
//  ViewController.m
//  BarScanner
//
//  Created by 朱 皓斌 on 13-3-31.
//  Copyright (c) 2013年 朱 皓斌. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad

{
    
    schoolLink=[[NSString alloc]init];
    schoolLink=@"http://app.sfls.cn/sflscc/checkoniphone.asp";
    barDataString=[[NSString alloc]init];
    //barImage=[[UIImage alloc]init];
    reader=[ZBarReaderViewController new];
    reader.readerDelegate=self;
    ZBarImageScanner *scanner=reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    reader.view.frame=CGRectMake(0, 0, 320, 100);
    [self.view addSubview:reader.view];
    
    memberView=[[UIView alloc]initWithFrame:CGRectMake(0, 80, 320, 440)];
    
    
    UISegmentedControl *selectSchool=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"1",@"2", nil]];
    selectSchool.frame= CGRectMake(10, 5, 300, 40);
    selectSchool.segmentedControlStyle=UISegmentedControlStylePlain;
    [selectSchool setTitle:@"上外附中" forSegmentAtIndex:0  ];
    [selectSchool setTitle:@"上外实验" forSegmentAtIndex:1];
    selectSchool.selectedSegmentIndex=0;
    [selectSchool addTarget:self action:@selector(changeSchool:) forControlEvents:UIControlEventValueChanged];
    [memberView addSubview:selectSchool];
    
    
    
    titleLabel=[[UILabel alloc]init];
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 50, 320, 50)];
    titleLabel.backgroundColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.7];
    titleLabel.numberOfLines=2;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.text=@"上海外国语大学附属外国语学校\n电脑社成员签到";
    [memberView addSubview:titleLabel];
    
    ZBarView=[[UILabel alloc]initWithFrame:CGRectMake(0, 100, 320, 30)];
    [ZBarView setTextAlignment:NSTextAlignmentCenter];
    //ZBarView.text=@"dkdkdkdk";
    ZBarView.backgroundColor=[UIColor clearColor];
    [ZBarView setFont:[UIFont systemFontOfSize:30.0f]];
    [ZBarView setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:30.0 ]];
    
    [memberView addSubview:ZBarView];
    
    JsonData=[[NSMutableData alloc]init];
    
    newLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 100, 200, 300)];
    newLabel.backgroundColor=[UIColor clearColor];
    newLabel.numberOfLines=8;
    
    [memberView addSubview:newLabel];
    
    barImageView=[[UIImageView alloc]init];
    barImageView.frame=CGRectMake(0, 320, 320, 100);
    barImageView.backgroundColor=[UIColor redColor];
    //[memberView addSubview:barImageView];
    
        //memberView.backgroundColor=[UIColor colorWithRed:99.0f/255.0f green:165.0f/255.0f blue:1.0 alpha:1];
    //UIImage *backImage=[UIImage imageNamed:@"sflscc.jpg"];
    
    memberView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"sflscc.jpg"]];
    [self.view addSubview:memberView];
    //NSURLConnection *newConnection=[[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.sfls.cn/sflscc/checkOnIphone.asp?ITNUM=9b8a55ed"]]] delegate:self];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startScan:(UIButton *)sender {
    
    reader=[ZBarReaderViewController new];
    reader.readerDelegate=self;
    ZBarImageScanner *scanner=reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    [self presentViewController:reader animated:YES completion:nil];
     
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    SystemSoundID soundID=1009;
    AudioServicesPlaySystemSound(soundID);
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    resultText.text = symbol.data;
    codeText.text=symbol.data;
    // EXAMPLE: do something useful with the barcode image
    resultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    barImageView.image=[info objectForKey: UIImagePickerControllerOriginalImage];
    barDataString=[NSString stringWithFormat:@"%@",symbol.data];
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    //[reader dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@",barDataString);
    ZBarView.text= [barDataString uppercaseString] ;
    NSURLConnection *newConnection=[[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?ITNUM=%@",schoolLink,barDataString]]] delegate:self];
    [barDataString retain];
    //[newConnection start];
    
    
    

}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [JsonData appendData:data];
    //NSLog(@"receivedata:%@",data);
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    SBJSON *newJson=[[SBJSON alloc]init];
    newJson.delegate=self;
    NSString *JsonString=[[NSString alloc]initWithData:JsonData encoding:NSUTF8StringEncoding];
    NSLog(@"receivedata:%@",JsonString);
    NSDictionary *newDic=[[NSDictionary alloc]init];
    
    newDic=[newJson objectWithString:JsonString];
    //NSLog(@"%@",[newDic objectForKey:@"stuName"]);
        newLabel.text=[NSString stringWithFormat:@"签到编号：%@\n学号：%@\n姓名：%@\n班级：%@%@班\n性别：%@\n电话：%@\n电话：%@\nEmail:%@",barDataString,[newDic objectForKey:@"stuNum"],[newDic objectForKey:@"stuName"],[newDic objectForKey:@"stuGrade"],[newDic objectForKey:@"stuClass"],[newDic objectForKey:@"stuGen"],[newDic objectForKey:@"stuPhone1"],[newDic objectForKey:@"stuPhone2"],[newDic objectForKey:@"Email"]];
    JsonData=[[NSMutableData alloc]init];
    
       
}

-(void)changeSchool:(UISegmentedControl *)Seg{
     NSInteger Index = Seg.selectedSegmentIndex;    
    NSLog(@"%i",Index);
    if (Index==0) {
        schoolLink=@"http://app.sfls.cn/sflscc/checkoniphone.asp";
        titleLabel.text=@"上海外国语大学附属外国语学校\n电脑社成员签到";
    }
    else{
        schoolLink=@"http://app.sfls.cn/shiyan/checkoniphone.asp";
        titleLabel.text=@"上海外国语大学第一实验学校\n电脑社成员签到";
    }
    
}



@end


















