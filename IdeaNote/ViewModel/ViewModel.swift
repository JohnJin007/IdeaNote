//
//  ViewModel.swift
//  IdeaNote
//
//  Created by v_jinlilili on 25/12/2024.
//
import SwiftUI
import Foundation
import Combine

class ViewModel: ObservableObject {
    //数据模型
    @Published var noteModels:[NoteModel] = []
    
    //笔记参数
    @Published var writeTime: String = ""
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var searchText: String = ""
    @Published var selectedNoteModel: NoteModel = NoteModel(writeTime: "", title: "", content: "")
    //判断是否正在搜索
    @Published var isSearching: Bool = false
    
    //判断是否是新增
    @Published var isAdd:Bool = true
    
    //打开新建笔记弹窗
    @Published var showNewNoteView:Bool = false
    
    //打开编辑笔记弹窗
    @Published var showEditNoteView:Bool = false
    
    //打开删除确认弹窗
    @Published var showActionSheet:Bool = false
    
    //提示信息
    @Published var showToast = false
    @Published var showToastMessage: String = "提示信息"
    
    //初始化
    init() {
        loadItems()
        saveItems()
    }
    
    // 获取设备上的文档目录路径
    func documentDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // 获取plist数据文件的路径
    func dataFilePath() -> URL {
        documentDirectory().appendingPathComponent("IdeaNote.plist")
    }
    
    // 将数据写入本地存储
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(noteModels)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
            loadItems()
        } catch {
            print("Error writing items to file: \(error.localizedDescription)")
        }
    }
    
    // 从本地存储加载数据
    func loadItems() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                noteModels = try decoder.decode([NoteModel].self, from: data)
            } catch {
                print("Error reading items:\(error.localizedDescription)")
            }
        }
    }
    
    // 创建笔记
    func addItem(writeTime: String, title: String, content: String) {
        let newItem = NoteModel(writeTime: writeTime, title: title, content: content)
        noteModels.append(newItem)
        saveItems()
    }
     
    // 获得数据项ID
    func getItemById(itemId: UUID) -> NoteModel? {
        return noteModels.first(where: { $0.id == itemId }) ?? nil
    }
    
    // 删除笔记
    func deleteItem(itemId: UUID) {
        if isSearching {//从搜索列表中进行删除
            loadItems()//加载本地所有项目noteModels
            noteModels.removeAll(where: { $0.id == itemId })//从noteModels中移除删除项
            saveItems()//将noteModels保存到本地文件
            searchContent()//展示搜索结果列表
        } else {//从展示列表中进行删除
            noteModels.removeAll(where: { $0.id == itemId })
            saveItems()
        }
    }

    // 编辑笔记
    func editItem(item: NoteModel) {
        if isSearching {//在搜索列表中进行编辑
            loadItems()//加载本地所有项目noteModels
            if let id = noteModels.firstIndex(where: { $0.id == item.id }) {
                //修改item
                noteModels[id] = item
                
                //将noteModels保存到本地文件
                saveItems()
               
                //显示搜索列表
                searchContent()
            }
        } else {//在展示列表中进行编辑
            if let id = noteModels.firstIndex(where: { $0.id == item.id }) {
                //修改item
                noteModels[id] = item
                
                //将noteModels保存到本地文件
                saveItems()
            }
        }
    }
    
    // 搜索笔记
    func searchContent() {
        let query = searchText.lowercased()
        DispatchQueue.global(qos: .background).async {
            let filter = self.noteModels.filter { $0.content.lowercased().contains(query) }
            DispatchQueue.main.async {
                self.noteModels = filter
            }
        }
    }
    
    // 获取当前系统时间
    func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: Date())
    }
    
    // 判断输入是否为空
    func isNull(text: String) -> Bool {
        if text == "" {
            return true
        }
        return false
    }
}
