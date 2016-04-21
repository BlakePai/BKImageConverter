//
//  ViewController.m
//  ImageDataConverter
//
//  Created by Blake Pai on 4/12/16.
//

#import "ViewController.h"

typedef NS_ENUM(NSUInteger, EncodeType) {
    
    kEncodeUTF8Char,
    kEncodeBase64,
    
};

@interface ViewController()

@property (assign) EncodeType encodeType;
@property (strong) IBOutlet NSTextView *dataView;
@property (strong) IBOutlet NSTextField *dataLength;
@property (strong) IBOutlet NSPopUpButton *popupButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _encodeType = kEncodeUTF8Char;
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)openImage:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
       
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *theDoc = [[openPanel URLs] objectAtIndex:0];
            
            [self encode:[NSData dataWithContentsOfURL:theDoc]];
            
        }
        
    }];
}


-(void)encode:(NSData *)data
{
    if (_popupButton.indexOfSelectedItem == kEncodeUTF8Char)
    {
        [self encodeWithUTF8Char:data];
    }
    else if (_popupButton.indexOfSelectedItem == kEncodeBase64)
    {
        [self encodeWithBase64:data];
    }
}

-(void)encodeWithUTF8Char:(NSData *)data
{
    NSString *dataString = @"";
    NSString *dataLen = [NSString stringWithFormat:@"%tu", data.length];
    const unsigned char *data_char = data.bytes;
    
//    NSLog(@"Length : %d", (int)data.length);
//    for (int i=0; i<data.length; i++)
//    {
//        printf("0x%02x, ", data_char[i]);
//    }
//    
//    printf("/n");

    for (int i=0; i<data.length; i++)
    {
        dataString = [dataString stringByAppendingString:[NSString stringWithFormat:@"0x%02x", data_char[i]]];
        if (i != data.length-1)
        {
            dataString = [dataString stringByAppendingString:@", "];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_dataView setString:dataString];
        [_dataLength setStringValue:dataLen];
    });
}

-(void)encodeWithBase64:(NSData *)data
{
    NSString *dataString = [data base64EncodedStringWithOptions:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_dataView setString:dataString];
    });
}

@end
