# PROJECT_SPEC.md
# ALU Internship Connect
**Version:** 1.0  
**Framework:** Flutter  
**Backend:** Firebase  
**Target Platform:** Android (Primary), iOS (Compatible)

---

# Project Overview

## Project Title

**ALU Internship Connect**

---

## Project Summary

ALU Internship Connect is a mobile application designed specifically for the African Leadership University ecosystem.

The application bridges the gap between:

- ALU students seeking internship opportunities
- Student-led startups looking for talented students

Instead of students struggling to find internships and startups struggling to recruit skilled teammates, the platform creates a centralized ecosystem where both parties can connect.

This application is **NOT** a job board.

It is an ecosystem designed around collaboration, startup growth, experiential learning, and community building.

---

# Problem Statement

Many ALU students face difficulties obtaining internship experience because:

- Established companies have limited internship openings.
- Hiring processes are competitive.
- Students often lack professional experience.

Meanwhile, many student entrepreneurs need assistance in:

- Software Development
- UI/UX Design
- Marketing
- Product Management
- Community Management
- Operations
- Business Analysis
- Data Analysis
- Research
- Finance
- Content Creation

However, there is currently no dedicated platform connecting these two groups inside ALU.

The goal is to solve this problem.

---

# Project Goals

The application should:

- Connect students with startups
- Help startups recruit student talent
- Improve internship accessibility
- Support startup growth
- Encourage collaboration
- Provide real-world experience
- Create a scalable ecosystem for ALU

---

# Primary Users

## Student

Students looking for internships.

Capabilities:

- Register
- Login
- Complete profile
- Browse opportunities
- Search internships
- Filter opportunities
- Bookmark opportunities
- View startup profiles
- Apply
- Track applications
- Receive updates

---

## Startup

Student founders and startup teams.

Capabilities:

- Register startup
- Create organization profile
- Verify startup
- Post internships
- Edit opportunities
- View applicants
- Accept or reject applicants
- Communicate with students

---

## Administrator (Recommended)

Not required but strongly recommended.

Responsibilities:

- Verify startups
- Remove fake organizations
- Moderate content
- Manage reported users
- Approve startup registrations

---

# Core Features (Required)

## 1. Authentication

Firebase Authentication

Support:

- Email registration
- Login
- Forgot password
- Logout
- Session persistence

---

## 2. User Onboarding

Collect:

Student:

- Name
- Program
- Year
- Skills
- Interests
- CV
- Portfolio
- LinkedIn

Startup:

- Startup name
- Description
- Industry
- Team size
- Founder
- Logo
- Website
- Contact information

---

## 3. Startup Profiles

Each startup should have:

- Logo
- Name
- Industry
- Description
- Founder
- Team size
- Social links
- Website
- Verification badge

---

## 4. Opportunity Posting

Startups create opportunities containing:

- Title
- Description
- Skills required
- Duration
- Internship type
- Remote/Hybrid/On-site
- Deadline
- Number of openings
- Benefits
- Responsibilities

---

## 5. Opportunity Discovery

Students should be able to:

Browse

Search

Filter by:

- Industry
- Skills
- Duration
- Internship type
- Remote
- Recently posted

Sort by:

- Newest
- Deadline
- Most relevant

---

## 6. Application Submission

Students can:

Apply

Upload:

- Resume
- Cover Letter
- Portfolio

Application status:

- Pending
- Reviewed
- Shortlisted
- Accepted
- Rejected

---

## 7. Real-Time Updates

Firestore streams should update:

- New opportunities
- Applications
- Application status
- Notifications

without refreshing the app.

---

## 8. Firebase Backend

Must use Firebase for:

Authentication

Cloud Firestore

Cloud Storage

(Optional)

Cloud Messaging

---

## 9. State Management

Use a modern architecture such as:

- Riverpod (Recommended)
- BLoC
- Cubit
- Provider

State management should be consistent across the entire application.

---

# Recommended Additional Features

To score highly, implement several of these:

## Bookmark Opportunities

Students save internships.

---

## Notifications

Notify students when:

- Application reviewed
- Accepted
- Rejected
- New opportunity posted

---

## Messaging

Simple chat between:

Startup ↔ Student

---

## Startup Verification

Verified badge after admin approval.

---

## Application Tracker

Timeline:

Applied

↓

Reviewed

↓

Interview

↓

Accepted

---

## Student Portfolio

Skills

Projects

GitHub

LinkedIn

Resume

Certificates

---

## Recommendation System

Recommend internships based on:

Skills

Program

Interests

Previous applications

---

## Analytics Dashboard

For startups:

Applications received

Views

Open positions

Applicant statistics

---

## Interview Scheduling

Allow startups to:

Create interview

Choose date

Notify student

---

# User Journey

## Student

Register

↓

Login

↓

Complete profile

↓

Browse internships

↓

View startup

↓

Apply

↓

Track application

↓

Receive notification

---

## Startup

Register

↓

Create startup

↓

Verification

↓

Post internship

↓

Receive applicants

↓

Review

↓

Accept/Reject

---

# Firebase Architecture

## Authentication

Firebase Authentication

---

## Firestore Collections

users

```
users
    uid
    role
    fullName
    email
    program
    skills
    interests
    profileImage
```

---

startups

```
startups
    startupId
    founderId
    name
    description
    logo
    verified
    website
```

---

opportunities

```
opportunities
    opportunityId
    startupId
    title
    description
    location
    duration
    deadline
    createdAt
```

---

applications

```
applications
    applicationId
    opportunityId
    studentId
    resume
    status
    appliedAt
```

---

bookmarks

```
bookmarks
```

---

notifications

```
notifications
```

---

messages (optional)

```
messages
```

---

# Folder Structure (Recommended)

```
lib/

core/

features/

authentication/

onboarding/

home/

opportunities/

applications/

startup/

notifications/

chat/

profile/

shared/

widgets/

services/

repositories/

models/

providers/

routes/

utils/

main.dart
```

---

# Architecture

Recommended:

Feature-first Clean Architecture

Each feature contains:

```
feature

data

models

repositories

presentation

screens

widgets

providers

services
```

Separate:

UI

Business Logic

Database

State

Navigation

---

# UI/UX Principles

The application should be:

Modern

Minimal

Accessible

Responsive

Professional

Consistent

Fast

Easy to navigate

Use:

Empty states

Loading states

Error states

Success feedback

Confirmation dialogs

Snackbars

---

# Error Handling

Must handle:

No internet

Authentication errors

Firestore failures

Empty searches

Empty applications

Validation errors

Image upload failures

---

# Security Considerations

Use Firestore Security Rules.

Students should:

NOT edit startups.

Startups should:

NOT edit student profiles.

Users should:

Only edit their own data.

Admin should:

Have elevated permissions.

---

# Performance Considerations

Lazy loading

Pagination

Firestore indexing

Image caching

Efficient rebuilds

Minimal database reads

---

# Code Standards

Use:

Meaningful naming

Reusable widgets

Repository pattern

Null safety

Immutable models

Comments where necessary

Proper folder organization

Avoid duplicated code

---

# Deliverables

## GitHub Repository

Complete Flutter project.

---

## Demo Video

7–10 minutes

Demonstrate:

Authentication

CRUD

Firebase Console

State Management

Architecture

Major workflows

Technical decisions

---

## Technical Report (PDF)

Include:

Project overview

Problem statement

Architecture

Database design

Firebase integration

State management

UI/UX reasoning

Challenges

Testing

Scalability

Future improvements

Architecture diagrams

Screenshots

References (APA or IEEE)

---

# Rubric Priorities

Highest scoring areas:

- Excellent UI/UX
- Strong Firebase integration
- Proper CRUD
- Modern state management
- Clean architecture
- Scalable code
- Feature completeness
- Technical explanation
- Professional report
- Original thinking

---

# Success Criteria

A successful project should:

✓ Be fully functional

✓ Run on a real Android device or emulator

✓ Use Firebase Authentication

✓ Use Firestore

✓ Use proper state management

✓ Have clean architecture

✓ Demonstrate real-time updates

✓ Be original

✓ Be easy to explain

✓ Follow Flutter best practices

✓ Be maintainable

✓ Be scalable

✓ Provide a polished user experience

---

# Implementation Roadmap

## Phase 1

- Project setup
- Firebase setup
- Folder architecture
- State management

---

## Phase 2

Authentication

Onboarding

Profile creation

---

## Phase 3

Startup management

Opportunity posting

Opportunity browsing

---

## Phase 4

Applications

Bookmarks

Notifications

---

## Phase 5

Real-time synchronization

Validation

Error handling

Loading states

---

## Phase 6

Testing

Performance optimization

UI polish

Documentation

Demo preparation

---

# Notes for AI Coding Agents (Cursor)

This project should be implemented with production-quality engineering practices.

Prioritize:

- Clean Architecture
- Feature-first folder structure
- Riverpod for state management (preferred)
- Firebase Authentication
- Cloud Firestore
- Cloud Storage where needed
- Reusable widgets
- Strong form validation
- Proper loading, success, and error states
- Real-time Firestore streams
- Separation of concerns using repositories and services
- Scalable and maintainable codebase
- Well-documented classes and methods where appropriate

Avoid generating boilerplate-heavy or generic CRUD code. Every implementation should reflect thoughtful UX, robust state management, and clean software engineering principles suitable for an academic capstone project.