//
//  JournalEntryView.swift
//  ProjectSwiftUi
//
//  Created by KOUITINI Ambre on 16/10/2024.
//

import SwiftUI

struct JournalEntry: Identifiable {
    let id = UUID()
    var date: Date
    var content: String
}

struct JournalEntryView: View {
    @State private var journalEntries: [JournalEntry] = []
    @State private var showingDetailView = false
    @State private var selectedEntry: JournalEntry?
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    
    let backgroundColor = Color(red: 0.1, green: 0.1, blue: 0.15)
    let surfaceColor = Color(red: 0.15, green: 0.15, blue: 0.2)
    let accentColor = Color(red: 0.6, green: 0.8, blue: 0.8)
    let textColor = Color.white
    let secondaryTextColor = Color(white: 0.7)
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Picker("Mois", selection: $selectedMonth) {
                        ForEach(1...12, id: \.self) { month in
                            Text(monthName(month)).tag(month)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(accentColor)
                    
                    Picker("Année", selection: $selectedYear) {
                        ForEach((2020...Calendar.current.component(.year, from: Date())), id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(accentColor)
                    
                    Spacer()
                    
                    Button(action: {
                        selectedEntry = nil
                        showingDetailView = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(accentColor)
                            .font(.title2)
                    }
                }
                .padding()
                
                List {
                    ForEach(daysInSelectedMonthYear(), id: \.self) { date in
                        if date <= Date() {
                            if let entry = journalEntries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                                journalEntryRow(for: entry)
                            } else {
                                emptyJournalEntryRow(for: date)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .sheet(isPresented: $showingDetailView) {
            JournalDetailView(journalEntries: $journalEntries, entry: $selectedEntry, isPresented: $showingDetailView)
        }
    }
    
    private func journalEntryRow(for entry: JournalEntry) -> some View {
        Button(action: {
            selectedEntry = entry
            showingDetailView = true
        }) {
            HStack(alignment: .top, spacing: 15) {
                VStack {
                    Text(entry.date.day)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(entry.date.weekdayShort)
                        .font(.caption)
                }
                .frame(width: 50)
                .foregroundColor(accentColor)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(entry.content)
                        .lineLimit(2)
                        .foregroundColor(textColor)
                }
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(surfaceColor)
    }
    
    private func emptyJournalEntryRow(for date: Date) -> some View {
        Button(action: {
            selectedEntry = JournalEntry(date: date, content: "")
            showingDetailView = true
        }) {
            HStack(alignment: .top, spacing: 15) {
                VStack {
                    Text(date.day)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(date.weekdayShort)
                        .font(.caption)
                }
                .frame(width: 50)
                .foregroundColor(secondaryTextColor)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Pas d'entrée")
                        .foregroundColor(secondaryTextColor)
                        .italic()
                }
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(backgroundColor)
    }
    
    private func daysInSelectedMonthYear() -> [Date] {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: selectedYear, month: selectedMonth)
        guard let date = calendar.date(from: dateComponents),
              let range = calendar.range(of: .day, in: .month, for: date) else {
            return []
        }
        
        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: date)
        }.sorted(by: >)
    }
    
    private func monthName(_ month: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        return dateFormatter.monthSymbols[month - 1]
    }
}

struct JournalDetailView: View {
    @Binding var journalEntries: [JournalEntry]
    @Binding var entry: JournalEntry?
    @Binding var isPresented: Bool
    @State private var journalContent: String = ""
    @State private var entryDate: Date = Date()
    
    let backgroundColor = Color(red: 0.1, green: 0.1, blue: 0.15)
    let surfaceColor = Color(red: 0.15, green: 0.15, blue: 0.2)
    let inputBackgroundColor = Color(red: 0.1, green: 0.1, blue: 0.15)
    let accentColor = Color(red: 0.6, green: 0.8, blue: 0.8)
    let textColor = Color.white
    let secondaryTextColor = Color(white: 0.7)
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Fermer") {
                        if !journalContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            saveEntry()
                        }
                        isPresented = false
                    }
                    .foregroundColor(accentColor)
                }
                .padding()
                
                Text(formattedDate(entryDate))
                    .font(.headline)
                    .foregroundColor(textColor)
                    .padding(.top)
                
                Divider()
                    .background(secondaryTextColor)
                    .padding(.vertical)
                
                TextEditor(text: $journalContent)
                    .scrollContentBackground(.hidden)
                    .background(inputBackgroundColor)
                    .foregroundColor(textColor)
                    .cornerRadius(8)
                    .padding(.bottom)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(surfaceColor, lineWidth: 1)
                    )
            }
            .padding()
        }
        .onAppear {
            if let existingEntry = entry {
                journalContent = existingEntry.content
                entryDate = existingEntry.date
            } else {
                journalContent = ""
                entryDate = Date()
            }
            
            UITextView.appearance().backgroundColor = .clear
        }
    }
    
    private func saveEntry() {
        if let index = journalEntries.firstIndex(where: { $0.id == entry?.id }) {
            journalEntries[index].content = journalContent
            journalEntries[index].date = entryDate
        } else {
            let newEntry = JournalEntry(date: entryDate, content: journalContent)
            journalEntries.append(newEntry)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: date)
    }
}

extension Date {
    var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }
    
    var weekdayShort: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "E"
        return formatter.string(from: self).lowercased() + "."
    }
}

struct JournalEntryView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryView()
    }
}
