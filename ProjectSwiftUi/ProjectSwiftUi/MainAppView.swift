//
//  MainAppView.swift
//  ProjectSwiftUi
//
//  Created by KOUITINI Ambre on 16/10/2024.
//
import SwiftUI

struct EmotionRecord: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    var emotion: String
}

struct MainAppView: View {
    @State private var isLoggedOut = false
    @State private var username: String = "root"
    @State private var selectedEmotion: String = ""
    @State private var emotionRecords: [EmotionRecord] = []
    @State private var currentDate = Date()
    @State private var selectedDate: Date?
    @State private var showingEmotionPopup = false
    @State private var showingEmotionPicker = false
    @State private var popupEmotion: String?
    
    let emotions = ["😊", "😢", "😐", "😡", "😰", "🥰", "😴", "🤔"]
    private let calendar = Calendar.current
    
    let backgroundColor = Color(red: 0.1, green: 0.1, blue: 0.15)
    let surfaceColor = Color(red: 0.15, green: 0.15, blue: 0.2)
    let accentColor = Color(red: 0.6, green: 0.8, blue: 0.8)
    let textColor = Color.white
    let secondaryTextColor = Color(white: 0.7)
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 25) {
                    HStack {
                       Spacer()
                       Button(action: {
                           isLoggedOut = true
                       }) {
                           Text("Déconnexion")
                               .foregroundColor(accentColor)
                       }
                   }
                   .padding(.top)
                   .padding(.horizontal)
                    
                    Text("Bonjour, \(username) 👋")
                        .font(.system(size: 28, weight: .medium, design: .rounded))
                        .foregroundColor(textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Comment te sens-tu aujourd'hui ?")
                            .font(.headline)
                            .foregroundColor(secondaryTextColor)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 15) {
                            ForEach(emotions, id: \.self) { emotion in
                                Button(action: {
                                    selectEmotion(emotion)
                                }) {
                                    Text(emotion)
                                        .font(.system(size: 40))
                                        .padding(10)
                                        .background(selectedEmotion == emotion ? accentColor.opacity(0.3) : surfaceColor)
                                        .cornerRadius(15)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(surfaceColor)
                    .cornerRadius(20)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Calendrier des émotions ")
                            .font(.headline)
                            .foregroundColor(secondaryTextColor)
                        
                        VStack {
                            HStack {
                                Button(action: previousMonth) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(accentColor)
                                }
                                Spacer()
                                Text(monthFormatter.string(from: currentDate))
                                    .font(.headline)
                                    .foregroundColor(textColor)
                                Spacer()
                                Button(action: nextMonth) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(accentColor)
                                }
                            }
                            .padding(.bottom)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                                ForEach(getDaysInMonth(), id: \.self) { date in
                                    if let date = date {
                                        Button(action: {
                                            handleDateSelection(date)
                                        }) {
                                            DayView(date: date, emotion: emotionForDate(date), accentColor: accentColor)
                                        }
                                        .disabled(date > Date())
                                    } else {
                                        Text("")
                                            .frame(height: 35)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(surfaceColor)
                    .cornerRadius(20)
                    
                    Spacer()
                }
                .padding()
            }
            .frame(alignment: .topLeading)
            .background(backgroundColor.edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $showingEmotionPopup, content: {
                if let date = selectedDate, let emotion = popupEmotion {
                    EmotionPopupView(date: date, emotion: emotion)
                }
            })
            .sheet(isPresented: $showingEmotionPicker, content: {
                if let date = selectedDate {
                    EmotionPickerView(date: date, emotions: emotions, onSelect: { emotion in
                        selectEmotion(emotion, for: date)
                        showingEmotionPicker = false
                    })
                }
            })
            .fullScreenCover(isPresented: $isLoggedOut) {
                ContentView()
            }
        }
    }
    
    func selectEmotion(_ emotion: String, for date: Date? = nil) {
        let targetDate = date ?? calendar.startOfDay(for: Date())
        if let index = emotionRecords.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: targetDate) }) {
            emotionRecords[index].emotion = emotion
        } else {
            let newRecord = EmotionRecord(date: targetDate, emotion: emotion)
            emotionRecords.append(newRecord)
        }
        selectedEmotion = emotion
    }
    
    private func handleDateSelection(_ date: Date) {
        selectedDate = date
        if date <= Date() {
            if let emotion = emotionForDate(date) {
                popupEmotion = emotion
                showingEmotionPopup = true
            } else {
                showingEmotionPicker = true
            }
        }
    }
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }
    
    private func getDaysInMonth() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentDate) else { return [] }
        let days = calendar.dateComponents([.day], from: monthInterval.start, to: monthInterval.end).day!
        
        let firstWeekday = calendar.component(.weekday, from: monthInterval.start)
        let paddingDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        var dates: [Date?] = Array(repeating: nil, count: paddingDays)
        
        for day in 1...days {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthInterval.start) {
                dates.append(date)
            }
        }
        
        return dates
    }
    
    private func emotionForDate(_ date: Date) -> String? {
        emotionRecords.first { calendar.isDate($0.date, inSameDayAs: date) }?.emotion
    }
    
    private func previousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
    }
    
    private func nextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
    }
}

struct EmotionPopupView: View {
    let date: Date
    let emotion: String
    let backgroundColor = Color(red: 0.1, green: 0.1, blue: 0.15)
    let textColor = Color.white
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text(emotion)
                    .font(.system(size: 60))
                
                Text(formattedDate(date))
                    .font(.headline)
                    .foregroundColor(textColor)
                
                Text(emotionTitle(for: emotion))
                    .font(.title2)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                
                Text(emotionDescription(for: emotion))
                    .font(.body)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                    .padding()
                
                HStack {
                    Text("⭐️")
                    Text("Conseil:")
                        .font(.headline)
                        .foregroundColor(textColor)
                }
                
                Text(adviceForEmotion(emotion))
                    .font(.body)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding()
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date)
    }
    
    private func emotionTitle(for emotion: String) -> String {
        switch emotion {
        case "😊", "🥰": return "Joie"
        case "😢", "😰": return "Tristesse"
        case "😐", "🤔": return "Neutre"
        case "😡": return "Colère"
        case "😴": return "Fatigue"
        default: return "Émotion"
        }
    }
    
    private func emotionDescription(for emotion: String) -> String {
        switch emotion {
        case "😊", "🥰": return "Vous vous sentiez joyeux et content ce jour-là."
        case "😢", "😰": return "Vous avez ressenti de la tristesse ou de l'anxiété."
        case "😐", "🤔": return "Votre humeur était neutre ou pensive."
        case "😡": return "Vous avez éprouvé de la colère ou de la frustration."
        case "😴": return "Vous vous sentiez fatigué ou avez eu besoin de repos."
        default: return "Vous avez ressenti cette émotion particulière."
        }
    }
    
    private func adviceForEmotion(_ emotion: String) -> String {
        switch emotion {
        case "😊", "🥰":
            return "Profitez de cette bonne humeur pour faire quelque chose que vous aimez et partagez la autour de vous !"
        case "😢", "😰":
            return "N'hésitez pas à vous confier à quelqu'un de confiance. Demain sera un jour meilleur 😊"
        case "😐", "🤔":
            return "Pourquoi ne pas essayer de faire une (nouvelle) activité qui vous stimule ou vous détend."
        case "😡":
            return "Prenez un moment pour respirer profondément et vous calmer."
        case "😴":
            return "Accordez-vous un moment de repos si possible."
        default:
            return "Prenez le temps d'explorer cette émotion et ce qu'elle signifie pour vous."
        }
    }
}

struct EmotionPickerView: View {
    let date: Date
    let emotions: [String]
    let onSelect: (String) -> Void
    let backgroundColor = Color(red: 0.1, green: 0.1, blue: 0.15)
    let textColor = Color.white
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Choisissez une émotion pour \(formattedDate(date))")
                    .font(.headline)
                    .foregroundColor(textColor)
                    .padding()
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 15) {
                    ForEach(emotions, id: \.self) { emotion in
                        Button(action: {
                            onSelect(emotion)
                        }) {
                            Text(emotion)
                                .font(.system(size: 40))
                                .padding(10)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(15)
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date)
    }
}

struct DayView: View {
    let date: Date
    let emotion: String?
    let accentColor: Color
    
    private let calendar = Calendar.current
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundForEmotion(emotion))
            Text(dayFormatter.string(from: date))
                .foregroundColor(.white)
                .font(.system(size: 12, weight: .medium))
        }
        .frame(height: 35)
    }
    
    private func backgroundForEmotion(_ emotion: String?) -> Color {
        guard let emotion = emotion else { return Color.gray.opacity(0.2) }
        switch emotion {
        case "😊", "🥰": return Color(red: 0.4, green: 0.8, blue: 0.7)
        case "😢", "😰": return Color(red: 0.5, green: 0.7, blue: 0.9)
        case "😐", "🤔": return Color(red: 1.0, green: 0.8, blue: 0.6)
        case "😡": return Color(red: 1.0, green: 0.6, blue: 0.6)
        case "😴": return Color(red: 0.8, green: 0.6, blue: 0.8)
        default: return accentColor
        }
    }
}

struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
    }
}
