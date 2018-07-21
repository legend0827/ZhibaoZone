//
//  CoreDataOperation.swift
//  ZhibaoZone
//
//  Created by Kevin on 26/12/2017.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import CoreData

class CoreDataOperation: NSObject {
    // 检查账号是否存在，或者检查附属账号是否已设置
    func checkAccountAvaiable(forAddtional isAddtional:Bool) -> Bool{
        //获取管理的数据上下文，对象
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        if isAddtional {
            //声明数据的请求
            let fetchRequest =  NSFetchRequest<TokenRestored>(entityName:"TokenRestored")
            fetchRequest.returnsObjectsAsFaults = false
            // 设置查询条件
            let predicate = NSPredicate(format: "id = 2")
            fetchRequest.predicate = predicate
            
            //创建User对象
            let TokenRestored = NSEntityDescription.insertNewObject(forEntityName: "TokenRestored", into: managedObjectContext) as! TokenRestored
            //查询操作
            do {
                let fetchResults = try managedObjectContext.fetch(fetchRequest)
                if fetchResults.count == 0 {
                    return false
                }else{
                    for object in fetchResults{
                        if object.token == "NOTSET"{
                            return false
                        }else{
                            return true
                        }
                    }
                    return false
                }
            } catch {
                // fatalError("保存失败\(error)")
                return false
            }
        }else{
            //声明数据的请求
            let fetchRequest =  NSFetchRequest<UserAccount>(entityName:"UserAccount")
            fetchRequest.returnsObjectsAsFaults = false
            // 设置查询条件
            let predicate = NSPredicate(format: "id = 1")
            fetchRequest.predicate = predicate
            //查询操作
            do {
                let fetchResults = try managedObjectContext.fetch(fetchRequest)
                if fetchResults.count == 0 {
                    return false
                }else{
                    return true
                }
            } catch {
               // fatalError("保存失败\(error)")
                return false
            }
        }
        return false
    }
    
    func saveToken(token:String) {
        //获取管理的数据上下文，对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest =  NSFetchRequest<TokenRestored>(entityName:"TokenRestored")
        fetchRequest.returnsObjectsAsFaults = false

        //设置查询条件
        let predicate = NSPredicate(format: "id = 1")
        fetchRequest.predicate = predicate
        //创建User对象
        let TokenRestored = NSEntityDescription.insertNewObject(forEntityName: "TokenRestored", into: context) as! TokenRestored
        
        
        //查询操作
        do {
            let fetchResults = try context.fetch(fetchRequest)
            
            if fetchResults.count != 0 {
                for info in fetchResults{
                    info.id = 1
                    info.token = token
                    print("token updated")
                }
            }else{
                //对象赋值
                TokenRestored.token = token
                TokenRestored.id = 1
                try context.save()
            }
            try context.save()
            print("token inserted or updated")
        } catch {
            fatalError("保存失败\(error)")
        }
    }
    
    func saveAddtionalToken(token:String) {
        //获取管理的数据上下文，对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest =  NSFetchRequest<TokenRestored>(entityName:"TokenRestored")
        fetchRequest.returnsObjectsAsFaults = false
        
        //设置查询条件
        let predicate = NSPredicate(format: "id = 2")
        fetchRequest.predicate = predicate
        //创建User对象
        let TokenRestored = NSEntityDescription.insertNewObject(forEntityName: "TokenRestored", into: context) as! TokenRestored
        
        
        //查询操作
        do {
            let fetchResults = try context.fetch(fetchRequest)
            
            if fetchResults.count != 0 {
                for info in fetchResults{
                    info.id = 2
                    info.token = token
                    print("token Addtional updated")
                }
            }else{
                //对象赋值
                TokenRestored.token = token
                TokenRestored.id = 2
                try context.save()
            }
            try context.save()
            print("token additional inserted or updated")
        } catch {
            fatalError("保存失败\(error)")
        }
    }
    
    func saveAccountInfo(userName:String,nickName:String,userId:Int64,roleType:Int64,password:String) {
        //获取管理的数据上下文，对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest =  NSFetchRequest<UserAccount>(entityName:"UserAccount")
        fetchRequest.returnsObjectsAsFaults = false
        // 设置查询条件
        let predicate = NSPredicate(format: "id = 1")
        fetchRequest.predicate = predicate
        
        //创建User对象
        let userAccount = NSEntityDescription.insertNewObject(forEntityName: "UserAccount", into: context) as! UserAccount
        //查询操作
        do {
            let fetchResults = try context.fetch(fetchRequest)
            if fetchResults.count == 0 {
                //对象赋值
                userAccount.id = 1
                userAccount.nickName = nickName.lowercased()
                userAccount.roleType = roleType
                userAccount.userId = userId
                userAccount.userName = userName
                userAccount.password = password
                print("inserted recoreds in userAccount")
            }else{
                for info in fetchResults{
                    if info.userName != userName.lowercased(){
                        //删除手势密码
                        UserDefaults.standard.removeObject(forKey: gestureFinalSaveKey)
                        updateOrWriteDataToServer(isToOpen:false,isToDelete:true)
                    }
                    info.id = 1
                    info.userName = userName.lowercased()
                    info.nickName = nickName
                    info.roleType = roleType
                    info.userId = userId
                    info.password  = password
                }
            }
            try context.save()
            print("new records saved")
        } catch {
            fatalError("保存失败\(error)")
        }
    }
    
    func saveAddtionalAccount(userName:String,nickName:String,userId:Int64,roleType:Int64,password:String){
        //获取管理的数据上下文，对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest =  NSFetchRequest<UserAccount>(entityName:"UserAccount")
        fetchRequest.returnsObjectsAsFaults = false
        // 设置查询条件
        let predicate = NSPredicate(format: "id = 2")
        fetchRequest.predicate = predicate
        
        //创建User对象
        let userAccount = NSEntityDescription.insertNewObject(forEntityName: "UserAccount", into: context) as! UserAccount
        //查询操作
        do {
            let fetchResults = try context.fetch(fetchRequest)
            if fetchResults.count == 0 {
                //对象赋值
                userAccount.id = 2
                userAccount.nickName = nickName.lowercased()
                userAccount.roleType = roleType
                userAccount.userId = userId
                userAccount.userName = userName
                userAccount.password = password
                //return false
                print("inserted recoreds in userAccount at 2")
            }else{
                for info in fetchResults{
                    if info.userName != userName.lowercased(){
                        //删除手势密码
                        UserDefaults.standard.removeObject(forKey: gestureFinalSaveKey)
                        updateOrWriteDataToServer(isToOpen:false,isToDelete:true)
                    }
                    info.id = 2
                    info.userName = userName.lowercased()
                    info.nickName = nickName
                    info.roleType = roleType
                    info.userId = userId
                    info.password  = password
                }
              //  return true
            }
            try context.save()
            print("records saved at 2")
        } catch {
            fatalError("保存失败\(error)")
        }
    }
    
    func saveProducerOfManager(userName:String,nickName:String,userId:Int64,roleType:Int64,password:String){
        //获取管理的数据上下文，对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest =  NSFetchRequest<UserAccount>(entityName:"UserAccount")
        fetchRequest.returnsObjectsAsFaults = false
        // 设置查询条件
        let predicate = NSPredicate(format: "id = 3")
        fetchRequest.predicate = predicate
        
        //创建User对象
        let userAccount = NSEntityDescription.insertNewObject(forEntityName: "UserAccount", into: context) as! UserAccount
        //查询操作
        do {
            let fetchResults = try context.fetch(fetchRequest)
            if fetchResults.count == 0 {
                //对象赋值
                userAccount.id = 3
                userAccount.nickName = nickName.lowercased()
                userAccount.roleType = roleType
                userAccount.userId = userId
                userAccount.userName = userName
                userAccount.password = password
                //return false
                print("inserted recoreds in userAccount at 3")
            }else{
                for info in fetchResults{
                    if info.userName != userName.lowercased(){
                        //删除手势密码
                        UserDefaults.standard.removeObject(forKey: gestureFinalSaveKey)
                        updateOrWriteDataToServer(isToOpen:false,isToDelete:true)
                    }
                    info.id = 3
                    info.userName = userName.lowercased()
                    info.nickName = nickName
                    info.roleType = roleType
                    info.userId = userId
                    info.password  = password
                }
                //  return true
            }
            try context.save()
            print("records saved at 3")
        } catch {
            fatalError("保存失败\(error)")
        }
    }
    
    func saveProducerOfManagerToken(token:String) {
        //获取管理的数据上下文，对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest =  NSFetchRequest<TokenRestored>(entityName:"TokenRestored")
        fetchRequest.returnsObjectsAsFaults = false
        
        //设置查询条件
        let predicate = NSPredicate(format: "id = 3")
        fetchRequest.predicate = predicate
        //创建User对象
        let TokenRestored = NSEntityDescription.insertNewObject(forEntityName: "TokenRestored", into: context) as! TokenRestored
        
        
        //查询操作
        do {
            let fetchResults = try context.fetch(fetchRequest)
            
            if fetchResults.count != 0 {
                for info in fetchResults{
                    info.id = 3
                    info.token = token
                    print("token Addtional updated")
                }
            }else{
                //对象赋值
                TokenRestored.token = token
                TokenRestored.id = 3
                try context.save()
            }
            try context.save()
            print("token additional inserted or updated")
        } catch {
            fatalError("保存失败\(error)")
        }
    }
}
