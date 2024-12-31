//
//  NewNoteView.swift
//  IdeaNote
//
//  Created by v_jinlilili on 25/12/2024.
//

import SwiftUI

struct NewNoteView: View {
    // 引用viewModel
    @EnvironmentObject var viewModel: ViewModel
    
    //声明参数
    @State var noteModel: NoteModel
    
    // 关闭弹窗
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: 关闭按钮
    private func closeBtnView() -> some View {
        Button {
            //关闭弹窗
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 17))
                .foregroundColor(.gray)
        }
    }
    
    // MARK: 完成按钮
    private func finishBtnView() -> some View {
        Button {
            //判断当前是新增还是编辑
            if viewModel.isAdd {
                if viewModel.isNull(text: viewModel.title) { //判断标题是否为空
                    viewModel.showToast = true
                    viewModel.showToastMessage = "请输入标题"
                } else if viewModel.isNull(text: viewModel.content) { //判断内容是否为空
                    viewModel.showToast = true
                    viewModel.showToastMessage = "请输入内容"
                } else { //校验通过
                    // 新增一条笔记
                    viewModel.addItem(writeTime: viewModel.getCurrentTime(), title: viewModel.title, content: viewModel.content)
                    //关闭弹窗
                    presentationMode.wrappedValue.dismiss()
                }
            } else {
                if viewModel.isNull(text: noteModel.title) { //判断标题是否为空
                    viewModel.showToast = true
                    viewModel.showToastMessage = "标题不能为空"
                } else if viewModel.isNull(text: noteModel.content) { //判断内容是否为空
                    viewModel.showToast = true
                    viewModel.showToastMessage = "内容不能为空"
                } else {//校验通过
                    let _ = print(noteModel)
                    // 保存一条新笔记
                    viewModel.editItem(item: noteModel)
                    //关闭弹窗
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } label: {
            Text("完成")
                .font(.system(size: 17))
        }
    }
    
    // MARK: 标题输入框
    private func titleView() -> some View {
        TextField("请输入标题", text: viewModel.isAdd ? $viewModel.title : $noteModel.title)
            .font(.system(size: 17))
            .padding()
    }
    
    // MARK: 多行内容输入框
    private func contentView() -> some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: viewModel.isAdd ? $viewModel.content : $noteModel.content)
                .font(.system(size: 17))
                .padding()
            
            if viewModel.isAdd ? viewModel.content.isEmpty : noteModel.content.isEmpty {
                Text("请输入内容")
                    .foregroundColor(Color(UIColor.placeholderText))
                    .font(.system(size: 17))
                    .padding(.vertical, 23)
                    .padding(.horizontal, 20)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                titleView()
                Divider()
                contentView()
            }
            .navigationBarTitle(viewModel.isAdd ? "新建笔记" : "编辑笔记", displayMode: .inline)
            .navigationBarItems(leading: closeBtnView(), trailing: finishBtnView())
            .toast(present: $viewModel.showToast, message: $viewModel.showToastMessage)
        }
    }
}
