//
//  MyViewController.m
//  PhoneBook
//
//  Created by Serik Klement on 11.03.17.
//  Copyright © 2017 Serik Klement. All rights reserved.
//

#import "MyViewController.h"
#import "Clients.h"

@interface MyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray *arrayClients;

@end

@implementation MyViewController

// Реализовано дополнительно:
// фото - рамдомная картинка из 5шт
// возраст - 3 цвета значения возраста 
// кнопка reset - возврат всех значений в дефолт


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUserDef];
    
    [self createTableView];
    
    //[self.myTableView reloadData];
    
    self.navigationItem.title = @"Clients";
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                target:self
                                                                                action:@selector(actionEdit:)];
    
    self.navigationItem.rightBarButtonItem = editButton;
    
    // массив кнопок слева
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(actionAddClient:)];
    
    
    
    UIBarButtonItem *reset = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                               target:self
                                                                               action:@selector(deliteUserDefault)];
    
    self.navigationItem.leftBarButtonItems = @[addButton, reset];
    
}

#pragma mark - Action

// нажатие на кнопку Edit
- (void) actionEdit:(UIBarButtonItem*) sender {
    
    BOOL isEditing = self.myTableView.editing;
    
    [self.myTableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.myTableView.editing) {
        
        item = UIBarButtonSystemItemDone;
        
    }
    
    UIBarButtonItem *tempEditButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                    target:self
                                                                                    action:@selector(actionEdit:)];
    
    [self.navigationItem setRightBarButtonItem:tempEditButton
                                      animated:YES];
}

// нажатие на кнопку +
- (void) actionAddClient:(UIBarButtonItem*) sender  {
    
    Clients *client = [Clients randomClient];
    
    NSInteger newClientIndex = 0;
    
    //    NSMutableArray *arrayTemp = [NSMutableArray arrayWithArray:self.arrayClients];
    //    [arrayTemp insertObject:client atIndex:newClientIndex];
    //    self.arrayClients = arrayTemp;
    
    [self.arrayClients insertObject:client atIndex:newClientIndex];
    
    [self.myTableView reloadData];
    
    [self saveUserDefault];
    
}

// нажатие на кнопку reset - возврат к дефолтным настройкам
- (void) deliteUserDefault {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault removeObjectForKey:@"arrayClients"];
    
    [userDefault synchronize];
    
    [self loadUserDef];
    
    [self.myTableView reloadData];
    
}

#pragma mark - UITableViewDataSource

// создаю секции
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrayClients count];
}

// создаю ряды

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Clients";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
    }
    
    Clients *tempClient = [self.arrayClients objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%zd.  %@ %@",indexPath.row + 1, tempClient.name, tempClient.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd", tempClient.age];
    cell.imageView.image = [UIImage imageNamed:tempClient.image];
    
    if (tempClient.age <= 30) {
        
        cell.detailTextLabel.textColor = [UIColor orangeColor];
        
    } else if (tempClient.age >= 36) {
        
        cell.detailTextLabel.textColor = [UIColor redColor];
        
    } else {
        
        cell.detailTextLabel.textColor = [UIColor greenColor];
        
    }
    
    return cell;
    
}

// перемещаение рядов
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    [self.arrayClients exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
    [self saveUserDefault];
    
}

// удаляю ряды
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Clients *client = [self.arrayClients objectAtIndex:indexPath.row];
        
        NSMutableArray *arrayTemp = [NSMutableArray arrayWithArray:self.arrayClients];
        
        [arrayTemp removeObject:client];
        
        self.arrayClients = arrayTemp;
        [self.myTableView reloadData];
        
        [self saveUserDefault];
    }
    
}
 // сохранение настроек
- (void) saveUserDefault {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *arrayDic = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [self.arrayClients count]; i++) {
        
        Clients *client = [self.arrayClients objectAtIndex:i];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setValue:client.name forKey:@"name"]; // записываю в дикшинари значения
        [dic setValue:client.lastName forKey:@"lastName"];
        [dic setValue:client.image forKey:@"image"];
        
        NSNumber *number = [NSNumber numberWithInteger:client.age]; // преобразовываю простой тип в намбер
        [dic setValue:number forKey:@"age"];
        
        [arrayDic addObject:dic];
        
    }
    
    [userDefault setObject:arrayDic forKey:@"arrayClients"];
    
    [userDefault synchronize]; // момент сохранения
    
}


#pragma mark - TableView

// создаю таблицу
- (void) createTableView {
    
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStyleGrouped];
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    self.myTableView = tableView;
    
}

// загрузка системы
- (void) loadUserDef {
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSArray *arrayUserDef = [userDef objectForKey:@"arrayClients"]; // получаю по ключу
    
    self.arrayClients = [[NSMutableArray alloc] init];
    
    if (arrayUserDef == nil) {
        
        for (NSInteger i = 0; i < 30; i++) {
            
            Clients *client = [Clients randomClient];
            
            //client.num = i;
            
            [self.arrayClients addObject:client];
            
        }
        
    } else {
        
        for (NSInteger i = 0; i < [arrayUserDef count]; i++) {
            
            NSDictionary *dic = [arrayUserDef objectAtIndex:i];
            
            Clients *client = [[Clients alloc] init];
            
            client.name = [dic objectForKey:@"name"]; // достаю изменённые значения
            client.lastName = [dic objectForKey:@"lastName"];
            client.image = [dic objectForKey:@"image"];
            
            NSNumber *num = [dic objectForKey:@"age"];
            client.age = [num integerValue];
            
            [self.arrayClients addObject:client];
            
        }
        
    }
    
}

@end
