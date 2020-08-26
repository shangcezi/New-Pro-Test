//
//  ViewController.m
//  socketTest
//
//  Created by apple on 2019/12/3.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ViewController.h"
#import <GCDAsyncSocket.h>
//#import <AFNetworking.h>
#import <SocketRocket.h>


#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<GCDAsyncSocketDelegate,SRWebSocketDelegate>
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;
@property (strong, nonatomic) SRWebSocket *webSocket;

@property (strong, nonatomic) UITextView *logLabel;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"Socket";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"SendMessage" style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Connect2" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClicked)];
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self buildUI];
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://192.168.1.174:8282?token=1234"]]];
    
    self.webSocket.delegate = self;
    
    self.dataArray = [NSMutableArray array];
}
-(void)buildUI{
    
    _logLabel = [[UITextView alloc] init];
    _logLabel.backgroundColor = [UIColor lightGrayColor];
    _logLabel.frame = CGRectMake(20, 100, ScreenW -40, ScreenH - 200);
    _logLabel.textColor = [UIColor blueColor];
    [self.view addSubview:_logLabel];
    
    NSArray *titleArray = @[@"↑",@"↓"];
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(ScreenW -50, ScreenH -300+ (80 + 20) *i, 40, 80);
        button.tag = i;
//        button.backgroundColor = UIColor.lightGrayColor;
        [button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        
    }
    
    UIView *userView = [UIView new];
    userView.backgroundColor = [UIColor cyanColor];
    userView.frame = CGRectMake(self.view.bounds.size.width -100, self.view.bounds.size.height -100, 80, 80);
//    userView.userInteractionEnabled = YES;

}

-(void)buttonClicked:(UIButton *)sender{
    
    if (sender.tag == 0) {//向上
        NSMutableDictionary *paraM = [NSMutableDictionary dictionary];
         paraM[@"type"] = @"say";
         paraM[@"group_id"] = @"1234";
         paraM[@"operation"] = @"up";
        [self optionWithParaM:paraM];
        
    }else if (sender.tag == 1){//向下
        
        NSMutableDictionary *paraM = [NSMutableDictionary dictionary];
        paraM[@"type"] = @"say";
        paraM[@"group_id"] = @"1234";
        paraM[@"operation"] = @"down";
        [self optionWithParaM:paraM];
    }
    
}

//连接服务器
-(void)leftButtonClicked{
    
           NSMutableDictionary *paraM = [NSMutableDictionary dictionary];
           paraM[@"uid"] = @"uid4";
           paraM[@"url"] = @"http://locat.testtp.com/test_socket_old/t.html";
           paraM[@"func"] = @"down";
    
    
           [self optionWithParaM:paraM];
    
    
/*
    NSError *error = nil;
//    [self.clientSocket connectToHost:@"192.168.1.174" onPort:2900 viaInterface:nil withTimeout:5 error:nil];
    
    if ([self.clientSocket connectToHost:@"192.168.1.174" onPort:8282 error:&error]) {
      
//      Alert(error.)
//        [self alertMessage:@"连接成功1"];

    }else{
              NSLog(@"connect error ----->%@",error);
              NSString *errMessage = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
              NSLog(@"%@",errMessage);
              [self alertMessage:errMessage];
    }
 */
}


//断开连接
-(void)rightButtonClicked{
    
//    self.webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"ws://192.168.1.174:8282/websocket"]];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.webSocket open];
        
    });
    
    
}


-(void)optionWithParaM:(NSMutableDictionary *)paraM{

        NSString *string = @"";
        string = [NSString stringWithFormat:@"%@\n",[self dictionaryToJson:paraM]];
        string = [self fixStringWithString:string];
        string = [NSString stringWithFormat:@"%@\n",string];
        NSLog(@"string ---->%@",string);
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        [self.dataArray addObject:[NSString stringWithFormat:@"本地发送 : %@",string]];
       [self updataLogMessage];
       [self.webSocket send:data];
    
//        [self.clientSocket writeData:d.,ata withTimeout:-1 tag:0];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    NSMutableDictionary *paraM = [NSMutableDictionary dictionary];
    paraM[@"uid"] = @"uid4";
    paraM[@"url"] = @"http://locat.testtp.com/test_socket_old/t.html";
    paraM[@"func"] = @"choiceUrl";
    [self optionWithParaM:paraM];
   
    
}


-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    NSLog(@" ----- >%@",sock.userData);
    
    NSLog(@"连接成功 ============== ");
    [self alertMessage:@"连接成功2"];
    
      NSMutableDictionary *paraM = [NSMutableDictionary dictionary];
       paraM[@"uid"] = @"uid5";
//       paraM[@"url"] = @"http://locat.testtp.com/test_socket_old/t.html";
       paraM[@"func"] = @"choiceUrl";
//       [self optionWithParaM:paraM];
    
    
    
}
//MARK :
//连接失败
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"连接失败 ================ ");
    [self alertMessage:@"连接失败"];
    
    
    NSMutableDictionary *paraM = [NSMutableDictionary dictionary];
       paraM[@"uid"] = @"uid4";
       paraM[@"url"] = @"http://locat.testtp.com/test_socket_old/t.html";
       paraM[@"func"] = @"choiceUrl";
       [self optionWithParaM:paraM]; 
    
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
 
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  
    NSLog(@"接受到了消息======>%@",str);
    
    [self alertMessage:str];
}


#pragma mark socketRocket Deleate


//连接成功
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    [self alertMessage:@"socketRocket 连接成功!"];
    
    
}


-(void)updataLogMessage{
      NSString *logString = [self.dataArray componentsJoinedByString:@"\n"];
      self.logLabel.text = logString;
}

-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
    NSLog(@"接收消息 ---- %@", message);
    

    [self alertMessage:[NSString stringWithFormat:@"收到消息:\n%@",message]];
    
    [self.dataArray addObject:[NSString stringWithFormat:@"收到消息 :%@\n",message]];
    
    [self updataLogMessage];
    
        NSDictionary *dict = [self dictionaryWithJsonString:message];
//        NSLog(@"id    --- >%@",[dict objectForKey:@"client_id"]);
 
    if ([[dict objectForKey:@"type"] isEqualToString:@"init"]) {
        NSMutableDictionary *bindDict = [NSMutableDictionary dictionary];
        bindDict[@"type"] = @"bind";
        bindDict[@"group_id"] = @"1234";
        [self optionWithParaM:bindDict];
        

    }
    
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    
    
    [self alertMessage:[NSString stringWithFormat:@"连接错误 ,错误信息 \n%@",error.userInfo.allValues]];
    NSLog(@"连接失败，这里可以实现掉线自动重连，要注意以下几点---- >%@",error);
//    NSLog(@"1.判断当前网络环境，如果断网了就不要连了，等待网络到来，在发起重连");
//    NSLog(@"2.判断调用层是否需要连接，例如用户都没在聊天界面，连接上去浪费流量");
    //关闭心跳包
//    [webSocket close];
//
//    [self reConnect];
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
    return nil;
    }

NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
NSError *err;
NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&err];
if(err)
{
    NSLog(@"json解析失败：%@",err);
    return nil;
}
    return dic;
}


-(NSString *)fixStringWithString:(NSString *)string{
    NSMutableString *mutString = [NSMutableString stringWithString:string];
    NSRange range = NSMakeRange(0, string.length);
    [mutString replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range];
    NSRange spaceRange = NSMakeRange(0, mutString.length);
    [mutString replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:spaceRange];
    return mutString;
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


-(void)alertMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
