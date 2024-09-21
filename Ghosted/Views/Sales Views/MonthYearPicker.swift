import SwiftUI

struct MonthYearPicker: View {
    @Binding var selectedDate: Date
    
    let months: [String] = Calendar.current.shortMonthSymbols
    let columns = [
            GridItem(.adaptive(minimum: 80))
        ]
    
    var body: some View {
        VStack {
            //year picker
            HStack {
                Image(systemName: "chevron.left")
                    .frame(width: 24.0)
                    .onTapGesture {
                        var dateComponent = DateComponents()
                        dateComponent.year = -1
                        selectedDate = Calendar.current.date(byAdding: dateComponent, to: selectedDate)!
                        print(selectedDate)
                    }
                
                Text(String(selectedDate.year()))
                         .fontWeight(.bold)
                         .transition(.move(edge: .trailing))
                
                Image(systemName: "chevron.right")
                    .frame(width: 24.0)
                    .onTapGesture {
                        var dateComponent = DateComponents()
                        dateComponent.year = 1
                        selectedDate = Calendar.current.date(byAdding: dateComponent, to: selectedDate)!
                        print(selectedDate)
                    }
            }.padding(15)
            
            //month picker
            LazyVGrid(columns: columns, spacing: 20) {
               ForEach(months, id: \.self) { item in
                    Text(item)
                    .font(.headline)
                    .frame(width: 60, height: 33)
                    .bold()
                    .background(item == selectedDate.monthName() ?  .accent : .secondary)
                    .cornerRadius(8)
                    .onTapGesture {
                        var dateComponent = DateComponents()
                        dateComponent.day = 1
                        dateComponent.month =  months.firstIndex(of: item)! + 1
                        dateComponent.year = Int(selectedDate.year())
                        print(item)
                        selectedDate = Calendar.current.date(from: dateComponent)!
                        print(selectedDate)
                    }
               }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    MonthYearPicker(selectedDate: .constant(Date()))
}

extension Date {
    func year() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    
    func monthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
}
