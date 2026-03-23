//
//  SettingsView.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/20/26.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var library: LibraryStore
    @EnvironmentObject var profile: UserProfile
    @Environment(\.dismiss) var dismiss
    @AppStorage("colorSchemePreference") private var colorSchemePreference: String = "Follow iOS Setting"
    @State private var showDataControls = false
    @State private var showAbout = false

    var body: some View {
        NavigationStack {
            Form {

                Section(header: Text("Appearance")) {
                    Picker("Theme", selection: $colorSchemePreference) {
                        Text("Follow iOS Setting").tag("Follow iOS Setting")
                        Text("Light").tag("Light")
                        Text("Dark").tag("Dark")
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }

                Section(header: Text("Data")) {
                    Button(action: { showDataControls = true }) {
                        HStack {
                            Text("Data controls")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Section(header: Text("About")) {
                    Button(action: { showAbout = true }) {
                        HStack {
                            Text("About Watchlist")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Data storage")
                        Spacer()
                        Text("On device")
                            .foregroundColor(.secondary)
                    }
                }

            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showDataControls) {
                DataControlsView()
                    .environmentObject(library)
                    .environmentObject(profile)
            }
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
            .preferredColorScheme(
                colorSchemePreference == "Dark" ? .dark :
                colorSchemePreference == "Light" ? .light : nil
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(LibraryStore())
    }
}
