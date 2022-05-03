//
//  SchoolsScreen.swift
//  Motiv
//
//  Created by William Little on 2022-05-03.
//

import SwiftUI

struct SchoolsScreen: View {
    
    @State var schools: [School] = [
        School(image: "queenscover", logo: "queenslogo", title: "Queen's University", index: 0, offset: 0),
        School(image: "stlawrencecover", logo: "slclogo", title: "St. Lawrence College", index: 1, offset: 0),
        School(image: "westerncover", logo: "westernlogo", title: "University of Western Ontario", index: 2, offset: 0),
        School(image: "wlucover", logo: "queenslogo", title: "Wilfred Laurier University", index: 3, offset: 0),
        School(image: "uoftcover", logo: "queenslogo", title: "University of Toronto", index: 4, offset: 0),
        School(image: "guelphcover", logo: "queenslogo", title: "Guelph University", index: 5, offset: 0)
    ]
    
    @State var scrolled = 0
    
    func calculateWidth() -> CGFloat {
        
        // 30 Padding
        let screen = UIScreen.main.bounds.width - 25
        
        let width = screen - 20
        
        return width
        
    }
    
    var body: some View {
        ZStack {
            ForEach(schools.reversed()) { school in
                
                HStack {
                    ZStack(alignment: .top) {
                        Image(school.image)
                            .resizable()
                        // MARK: Dynamic height dependent on index of school card
                            .aspectRatio(contentMode: .fill)
                            .frame(width: calculateWidth(), height: (UIScreen.main.bounds.height / 1.8) - CGFloat((school.index - scrolled) * 40))
                            .cornerRadius(25)
                            .offset(x: CGFloat((school.index - scrolled) * 20))

                        VStack(alignment: .leading) {
                            HStack {
                                Text(school.title)
                                    .font(.system(size: 26))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                Image(school.logo)
                                    .resizable()
                                    .frame(width: 30, height: 38)
                                    .frame(alignment: .trailing)
                                    .padding(.horizontal)
                            }
                            
                            
                            Text(school.index > 1 ? "COMING SOON" : "423 Active Users")
                                .foregroundColor(.white)
                                .font(.footnote)
                                .fontWeight(.semibold)
                            if school.index > 1 {
                                
                            } else {
                                Text("27 Houses")
                                    .foregroundColor(.white)
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: CGFloat((school.index - scrolled) * 20))
                        .padding(.vertical, 30)
                        .padding(.horizontal, 40)
                        
                        Spacer(minLength: 0)
                    }
                }
                .contentShape(Rectangle())
                // Adding gesture
                .offset(x: school.offset)
                .gesture(DragGesture().onChanged({ (value) in
                    
                    withAnimation {
                        
                        // Doesn't allow movement of last card
                        if value.translation.width < 0 && school.index != schools.last!.index {
                            
                            schools[school.index].offset = value.translation.width
                            
                        } else {
                            // Restore Schools
                            if school.index > 0 {
                                
                                schools[school.index - 1].offset = -(calculateWidth() + 60) + value.translation.width
                            }
                        }
                        
                    }
                    
                }).onEnded({ (value) in
                    
                    withAnimation {
                        
                        if value.translation.width < 0 {
                            if -value.translation.width > 180 && school.index != schools.last!.index {
                                // Removes from screen
                                schools[school.index].offset = -(calculateWidth() + 60)
                                scrolled += 1
                            } else {
                                schools[school.index].offset = 0
                            }
                        
                           
                        } else {
                            
                            if school.index > 0 {
                                
                                if value.translation.width > 180 {
                                    schools[school.index - 60].offset = 0
                                    scrolled -= 1
                                } else {
                                    schools[school.index - 1].offset = -(calculateWidth() + 60)
                                }
                            }
                                
                        }
                    }
                    
                }))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BG"))
    }
}

struct SchoolsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SchoolsScreen()
    }
}
