//
//  ContentView.swift
//  IdeaNote
//
//  Created by v_jinlilili on 24/12/2024.
//

import SwiftUI

// MARK: 列表内容
struct NoteListRow: View {
    //引用viewModel
    @EnvironmentObject var viewModel: ViewModel
    // 项目NoteModel
    @Binding var noteModel: NoteModel
    
    var body: some View {
        HStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(noteModel.writeTime)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text(noteModel.title)
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                    Text(noteModel.content)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                }
            }
            
            Spacer()
            
            //更多操作
            Button {
                viewModel.showActionSheet = true
                viewModel.selectedNoteModel = noteModel
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
                    .font(.system(size: 23))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .contentShape(Rectangle()) //完全可点击的行
        //点击整个Row进行编辑
        .onTapGesture {
            viewModel.isAdd = false
            viewModel.showEditNoteView = true
            viewModel.selectedNoteModel = noteModel
        }
    }
}

struct ContentView: View {
    // 引用viewModel
    @EnvironmentObject var viewModel: ViewModel
    
    // MARK: 缺省图
    private func noDataView() -> some View {
        VStack(alignment: .center, spacing: 20) {
            Image("mainImage")
                .resizable()
                .scaledToFit()
                .frame(width: 149.5, height: 138.5)
                
            Text("记录下这个世界的点滴")
                .font(.system(size: 17))
                .bold()
                .foregroundColor(.gray)
        }
    }
    
    // MARK: 新建笔记按钮
    private func newNoteBtnView() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    viewModel.isAdd = true
                    viewModel.writeTime = viewModel.getCurrentTime()
                    viewModel.title = ""
                    viewModel.content = ""
                    viewModel.showNewNoteView = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.blue)
                }

            }
        }
        .padding(.trailing, 20)
        .padding(.bottom, 32)
        .opacity(viewModel.isSearching ? 0 : 1) //搜索时隐藏新建笔记按钮
    }
    
    // MARK: 搜索栏
    private func searchBarView() -> some View {
        HStack {
            TextField("搜索内容", text: $viewModel.searchText)
                .padding(.horizontal, 32)   //水平内边距，与文本内容
                .padding(.vertical, 7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        //Spacer()
                        
                        //编辑时显示清除按钮
                        if viewModel.searchText != "" {
                            Button {
                                viewModel.searchText = ""
                                viewModel.loadItems()
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }

                        }
                    }
                }
                .onChange(of: viewModel.searchText) { oldValue, newValue in
                    if viewModel.searchText != "" {
                        viewModel.isSearching = true
                        viewModel.searchContent()
                    } else {
                        viewModel.searchText = ""
                        viewModel.isSearching = false
                        viewModel.loadItems()
                    }
                }
        }
        .padding(.horizontal, 15)
    }
    
    //笔记列表
    func noteListView() -> some View {
        List {
            ForEach(viewModel.noteModels) { noteItem in
                if let index = viewModel.noteModels.firstIndex(where: {$0.id == noteItem.id}) {
                    NoteListRow(noteModel: $viewModel.noteModels[index])
                }
            }
        }
        .listStyle(InsetListStyle())
        //编辑笔记
        .sheet(isPresented: $viewModel.showEditNoteView) {
            NewNoteView(noteModel: viewModel.selectedNoteModel)
        }
        //删除笔记
        .actionSheet(isPresented: $viewModel.showActionSheet) {
            ActionSheet(title: Text("你确定要删除此项吗?"),
                        message: nil,
                        buttons: [
                            .destructive(Text("删除"), action: {
                                viewModel.deleteItem(itemId: viewModel.selectedNoteModel.id)
                            }),
                            .cancel(Text("取消"))
                        ])
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isSearching == false && viewModel.noteModels.count == 0 {
                    noDataView()
                } else {
                    VStack {
                        searchBarView()
                        noteListView()
                    }
                }
                newNoteBtnView()
            }
            .navigationBarTitle("念头笔记", displayMode: .inline)
        }
        .sheet(isPresented: $viewModel.showNewNoteView) {
            NewNoteView(noteModel: NoteModel(writeTime: "", title: "", content: ""))
        }
    }
}

#Preview {
    ContentView()
}
