//
//  qcdDemoViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "qcdDemoViewController.h"
#import "ChildViewController.h"


@interface qcdDemoViewController ()

@end

@implementation qcdDemoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    Company *companyOne = [[Company alloc]initWithName:@"Apple mobile devices" andcompanyLogo:@"apple.png"];
    Product *product1 = [[Product alloc]initWithProductName:@"iPad" andproductImage:@"iPad.png" andProductUrl:@"https://www.apple.com/shop/buy-ipad/ipad-air-2"];
    
    
    Product *product2 = [[Product alloc]initWithProductName:@"iPod Touch" andproductImage:@"ipodtouch.png" andProductUrl:@"https://www.apple.com/shop/buy-iphone/iphone6"];
    
    Product *product3 = [[Product alloc]initWithProductName:@"iPhone" andproductImage:@"iphone.png" andProductUrl:@"https://www.apple.com/shop/buy-iphone/iphone5s"];
    
    companyOne.listOfCompanyProducts = [[NSMutableArray alloc]initWithObjects:product1,product2,product3, nil];
    
      Company *companyTwo = [[Company alloc]initWithName:@"Samsung mobile devices" andcompanyLogo: @"samsung.png"];
    
    Product *product4 = [[Product alloc]initWithProductName:@"Galaxy S4" andproductImage:@"galaxys4.png" andProductUrl:@"http://www.samsung.com/global/microsite/galaxys4/"];
    
    
    Product *product5 = [[Product alloc]initWithProductName:@"Galaxy Note" andproductImage:@"galaxys5.png" andProductUrl:@"http://www.samsung.com/us/mobile/cell-phones/SM-G925TZDATMB"];
    
      Product *product6 = [[Product alloc]initWithProductName:@"Galaxy Tab" andproductImage:@"galaxys6.png" andProductUrl:@"http://www.samsung.com/us/mobile/cell-phones/SM-G925RZKAUSC"];
    
     companyTwo.listOfCompanyProducts = [[NSMutableArray alloc]initWithObjects:product4,product5,product6, nil];
    
    
     Company *companyThree = [[Company alloc]initWithName:@"Motorola mobile devices" andcompanyLogo:@"motorola.png"];
    
    
    
    
    Product *product7 = [[Product alloc]initWithProductName:@"X Pure Edition" andproductImage:@"motorola1.png" andProductUrl:@"https://www.motorola.com/us/products/moto-g"];
    
    
    Product *product8 = [[Product alloc]initWithProductName:@"Moto E" andproductImage:@"motorola2.png" andProductUrl:@"http://www.motorola.com/us/products/moto-x-pure-edition"];
    
    Product *product9 = [[Product alloc]initWithProductName:@"Moto X" andproductImage:@"motorola3.jpeg" andProductUrl:@"https://www.motorola.com/us/smartphones/moto-e-2nd-gen/moto-e-2nd-gen.html"];
    
    companyThree.listOfCompanyProducts = [[NSMutableArray alloc]initWithObjects:product7,product8,product9, nil];
    
    
    
    Company *companyFour = [[Company alloc]initWithName:@"HTC mobile devices" andcompanyLogo:@"htc.png"];
    
    Product *product10 = [[Product alloc]initWithProductName:@"Desire 123" andproductImage:@"htc1.png" andProductUrl:@"http://www.htc.com/us/smartphones/htc-desire-626/"];
    
    
    Product *product11 = [[Product alloc]initWithProductName:@"Desire 510" andproductImage:@"htc2.png" andProductUrl:@"http://www.htc.com/us/smartphones/htc-one-mini/"];
    
    Product *product12 = [[Product alloc]initWithProductName:@"Desire 237" andproductImage:@"htc3.png" andProductUrl:@"http://www.htc.com/us/smartphones/htc-one-max/"];

      companyFour.listOfCompanyProducts = [[NSMutableArray alloc]initWithObjects:product10,product11,product12, nil];
    
    self.companyList = [[NSMutableArray alloc]initWithObjects:companyOne,companyTwo,companyThree,companyFour, nil];
    
    
    
    self.title = @"Mobile device makers";
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.companyList count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Company *company = [self.companyList  objectAtIndex:[indexPath row]];
    cell.textLabel.text = company.companyName;
    cell.imageView.image = [UIImage imageNamed:company.companyLogo];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.companyList removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }   
   // else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   // }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    Company *companyToMove = [self.companyList objectAtIndex:fromIndexPath.row];
    [self.companyList removeObjectAtIndex:fromIndexPath.row];
    [self.companyList insertObject:companyToMove atIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    Company *company = [self.companyList objectAtIndex:[indexPath row]];
    self.childVC.title = company.companyName;
    self.childVC.company = company;
    
    [self.navigationController pushViewController:self.childVC animated:YES];
}
 


@end
