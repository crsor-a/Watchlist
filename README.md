# Watchlist

Welcome to the Watchlist repository!

**Due to technical limitations with the development hardware, Watchlist is built entirely on Xcode 14.2 with SDKs designed for iOS 16.0. It can easily be upgraded to current SDKs for newer iOS versions like iOS 26. I plan to implement such an update myself later down the road.**

Watchlist is a native SwiftUI app that I designed with the following capabilities:

- A Home tab summarizes recent additions, favorites, and charts corresponding to TMDb data
- New content entries are automatically filled in with the TMDb API, with the option of manual entry for flexibility
- Shows have episode guides pulled from TMDb, providing rich context about a show's context with seasons, descriptions, and imagery
- A Library tab allows comprehensive categorization and viewing of all content entries
- A deeply personal Me tab provides analytics about logged data, support for profile creation with names, access to app settings, and import/export of user data and libraries

The app is currently in the *very* early stages of development, and new features are in the formative stages to enrich the experience long-term:

- An Explore tab provides rich recommendations based on algorithmic data collected from user entries, tied to their local account
- An advanced filtering sheet allows for rich categorization of items in the Library tab
- Graphical analytics in Me with charts for more visual user data
- Rotating contextual greetings in Home
- Trailers and video content in content pages
- Functional import system (no, the import backend has not been developed yet.)
- Profile avatars -- customizable color backgrounds and emoji icons as a substitution for typography of first initial
- Individual rating of TV episodes -- accessible from the episode guide
- Contextual autofill search in Add New Content adds additional specifications such as genre, year of release, cast, director, and other variables in addition to title to make it easier to locate
- SDK upgrades, dynamic poster and visuals, possibly gradients?

Images of app GUI and app icon are coming soon!

No licensing information because I doubt this repository is finding an audience anywhere else 😔
