# Bank Sampah - Flutter MVVM Implementation

## Overview
Bank Sampah is a mobile application for waste management built with Flutter using MVVM (Model-View-ViewModel) architecture. The app allows users to schedule waste pickups, view earning balances, and access waste management guides. Admin users can manage pickups and waste categories.

## Project Structure

### Architecture: MVVM
- **Models** (`lib/models/`): Data structures representing domain entities
- **ViewModels** (`lib/viewmodels/`): Business logic and state management using ChangeNotifier
- **Views** (`lib/views/`): UI screens and reusable widgets
- **Config** (`lib/config/`): Theme, colors, and app configuration

### Color Scheme
Primary: `#2E7D32` (Forest Green)
Light: `#43A047`, Dark: `#145214`
Secondary: Grays and neutral tones
Status: Success (green), Error (red), Pending (orange)

### Typography
Font: Plus Jakarta Sans
Weights: 400, 500, 600, 700, 800
Sizes: Scale from 11px (label) to 36px (display)

## Implemented Screens

### Authentication Flows
1. **Splash Screen** - Brand introduction with auto-navigation to login
2. **Login Screen** - Email/password authentication with Google option
3. **Register Screen** - Full registration form with phone and terms agreement

### User Flows
4. **Home Screen** - Dashboard with greeting, location card, and menu options
5. **Pickup Screen** - Schedule waste pickup with category, weight, date, and notes
6. **Guide Screen** - Waste sorting tips and category pricing information
7. **Balance Screen** - View total saldo, statistics, and transaction history

### Admin Flows (Auto-routes when user.isAdmin = true)
8. **Admin Home** - Dashboard with user stats, total waste, and admin menu
9. **Admin Pickup** - Manage pickup requests with status filtering and detail modals
10. **Admin Category** - Add/edit/delete waste categories with pricing
11. **Admin Balance** - Process user withdrawal requests with approval/rejection

### State Management
- **AuthViewModel**: Handles login, registration, logout
- **HomeViewModel**: Manages balance, transactions, and user data
- **PickupViewModel**: Manages pickup form state and calculations
- **AdminViewModel**: Manages pickup requests and category data (admin features)

## Key Features Implemented

### UI Components
- Custom buttons (primary, secondary, icon)
- Custom text inputs with password toggle
- Dropdown selectors
- Custom icons (SVG-style painted)
- Status badges and pills
- Transaction list items
- Menu cards with navigation

### Data Models
```
User { id, name, email, phone, location, isAdmin }
WasteCategory { name, pricePerKg }
WastePickup { id, userId, category, weight, price, date, address, status }
Balance { userId, totalBalance, totalWaste, transactions }
BalanceTransaction { id, type, amount, weight, date, description }
```

### Navigation
- Named routes using MaterialApp routing
- Push/pop/replace navigation
- Conditional navigation based on auth state

## Not Yet Implemented (For Complete Build)

### Features to Add
1. Backend API integration (currently mock data)2. User authentication persistence
3. Image uploads for profiles/verification
4. Real-time notifications
5. Payment gateway integration
6. Database (Firebase/REST API)
7. Error handling and retry logic
8. Offline support with local caching

## Running the Project

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Run with specific device
flutter run -d <device-id>
```

## Admin Features

### Admin Auto-Navigation
- When `authVm.currentUser.isAdmin == true`, user is automatically routed to `/admin-home` instead of regular home
- Admin users see a different dashboard and menu

### Admin Screen Features

**Admin Home**
- Statistics cards: Total Users (138), Total Waste Collected (52 kg)
- Three main menu items: Penjemputan, Kategori Sampah, Kirim Saldo
- Logout button with red accent

**Admin Pickup** (`/admin-pickup`)
- List of waste pickup requests with filter tabs (Semua, Menunggu, Dikonfirmasi)
- Click item to view detail modal
- Detail modal shows: user info, category, weight, price, date, address
- Action buttons: Tolak (Reject), Konfirmasi (Confirm)
- Status-based color coding (yellow=pending, green=confirmed, red=rejected)

**Admin Category** (`/admin-category`)
- List all waste categories with prices
- Add button to open form modal
- Edit/Delete buttons for each category
- Form modal for adding new categories with name and price fields

**Admin Balance** (`/admin-balance`)
- List of user withdrawal requests with filter tabs
- Click item to view detail modal
- Modal shows: user info, withdrawal amount, date, method, account number
- Action buttons: Tolak, Kirim Saldo (Send Balance)

## Testing Flow

**User Flow:**
1. **Splash** → auto-navigates to Login after 3 seconds
2. **Login** → enter credentials → navigates to Home
   - Or Register for new account
3. **Home** → access three main menus:
   - Jemput Sampah (Pickup scheduling)
   - Panduan Pengiriman (Waste guide)
   - Saldo (Balance view)
4. **Logout** → returns to Login screen

**Admin Flow:**
1. Call `authVm.loginAsAdmin(email, password)` to login as admin
2. Auto-redirects to `/admin-home`
3. Access admin menus to manage system
4. Click items to see detail modals with actions

## Mock Data
The app uses hardcoded mock data for:
- User information (Budi Santoso)
- Waste categories and prices
- Transaction history
- Pickup requests

Replace with API calls when backend is ready.

## Design System Compliance
All screens match the Figma/Claude Design prototype:
- Green gradient headers
- Rounded corners (13px, 16px, 20px)
- Consistent spacing (8px, 12px, 16px, 18px, 20px)
- Material Design 3 foundations
- Status color usage (yellow for pending, green for confirmed, red for error)

## Next Steps for Completion

1. **Create Admin Screens**: Use existing admin VM and structure
2. **API Integration**: Connect to backend endpoints
3. **Image Assets**: Add proper icon assets instead of custom painters
4. **Form Validation**: Add comprehensive input validation
5. **Error Handling**: Add try-catch and error dialogs
6. **Loading States**: Enhance loading indicators
7. **State Persistence**: Save auth token and user data locally
8. **Testing**: Add unit and widget tests

## Dependencies
- `provider: ^6.0.0` - State management
- `flutter` - Framework
- `material_design_icons` - Icons (included)

## Notes for Developers
- All colors centralized in `lib/config/colors.dart`
- Theme defined in `lib/config/theme.dart`
- Reusable widgets in `lib/views/widgets/`
- Each screen has corresponding ViewModel
- Data flows from ViewModel → View (unidirectional)
- Use Consumer widgets for reactive updates
