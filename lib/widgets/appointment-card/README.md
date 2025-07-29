# Appointment Card Components

This folder contains the refactored and modularized appointment card components for better code organization and maintainability.

## File Structure

```
appointment-card/
├── index.dart                          # Main export file
├── appointment_status_helper.dart      # Date/time and status logic
├── appointment_details_modal.dart      # Bottom sheet details view
├── appointment_actions.dart            # Action handlers (cancel, etc.)
├── appointment_card_components.dart    # UI components
└── README.md                          # This documentation
```

## Components Overview

### 1. AppointmentStatusHelper (`appointment_status_helper.dart`)
**Purpose**: Handles all date/time calculations and status logic
- `getAppointmentStatus()` - Determines current status based on real-time
- `getAppointmentDateTime()` - Parses appointment date/time from slots
- `getFormattedTime()` - Returns formatted time string
- `getRelativeTimeInfo()` - Returns relative time ("in 2 hours", "2 hours ago")
- `canCancelAppointment()` - Business logic for cancellation rules

### 2. AppointmentDetailsModal (`appointment_details_modal.dart`)
**Purpose**: Manages the detailed view modal
- `show()` - Displays the appointment details bottom sheet
- Clean, reusable modal component

### 3. AppointmentActions (`appointment_actions.dart`)
**Purpose**: Handles user actions on appointments
- `handleCancel()` - Manages appointment cancellation flow
- Extensible for future actions (reschedule, complete, etc.)

### 4. AppointmentCardComponents (`appointment_card_components.dart`)
**Purpose**: Reusable UI components for the card
- `buildPatientAvatar()` - Patient avatar component
- `buildStatusTimeHeader()` - Status and time display
- `buildPatientDoctorInfo()` - Patient and doctor information
- `buildDetailsRow()` - Appointment details row
- `buildOptionsMenu()` - Three-dot menu component

### 5. PatientAppointmentCard (`../patient_appointment_card_new.dart`)
**Purpose**: Main card widget that orchestrates all components
- Clean, focused build method
- Delegates functionality to appropriate helpers
- Easy to understand and maintain

## Benefits of This Structure

1. **Separation of Concerns**: Each file has a single responsibility
2. **Reusability**: Components can be reused in other parts of the app
3. **Testability**: Each component can be tested independently
4. **Maintainability**: Changes to specific functionality are isolated
5. **Readability**: Code is much easier to understand and navigate

## Usage

```dart
import 'package:medshala/widgets/patient_appointment_card_new.dart';

// Use the card as before
PatientAppointmentCard(appointment: appointmentModel)
```

## Future Enhancements

- Add more appointment actions (reschedule, complete, etc.)
- Create theme variants for different appointment types
- Add animation components for status changes
- Implement accessibility improvements
