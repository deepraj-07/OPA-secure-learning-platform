# OPA Secure Learning Platform

A production-ready secure learning platform that demonstrates Open Policy Agent (OPA) integration for fine-grained authorization control. This project showcases how to enforce complex access policies using declarative Rego rules.

## Description

The OPA Secure Learning Platform enforces role-based access control (RBAC) with advanced policy rules for course management. It supports three primary roles—Instructor, Student, and Guest—each with specific permissions for viewing, creating, updating, and deleting courses. Policies are defined in Rego and evaluated by OPA, providing a flexible and maintainable authorization layer.

## Tech Stack

- **Node.js**: Runtime environment for the Express server
- **Express**: Lightweight web framework for HTTP routing
- **OPA (Open Policy Agent)**: Policy engine for declarative authorization
- **Axios**: HTTP client for OPA communication
- **GitHub Actions**: CI/CD automation for policy validation

## Folder Structure

```
opa-secure-learning-platform/
├── app/
│   ├── server.js                    # Express server entry point
│   ├── routes/
│   │   └── course.js                # Course access route with middleware
│   └── middleware/
│       └── opa.js                   # OPA authorization middleware
├── policies/
│   ├── auth.rego                    # Authorization policies (RBAC)
│   └── ci.rego                      # CI/CD validation policies
├── test/
│   └── test.http                    # REST Client test cases
├── .github/
│   └── workflows/
│       └── ci.yml                   # GitHub Actions workflow
├── package.json                     # Node.js dependencies and scripts
└── README.md                         # Project documentation
```

## How to Run Locally

### Prerequisites

- Node.js (v14 or higher)
- OPA (v0.45 or higher)
- npm

### Setup

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Start OPA server**:
   ```bash
   opa run -s -l localhost:8181 policies/
   ```
   This command starts OPA in server mode listening on `localhost:8181` and loads policies from the `policies/` directory.

3. **Start the Node.js server**:
   ```bash
   npm start
   ```
   The Express server will run on `http://localhost:3000`.

4. **Test with REST Client**:
   Use the test cases in `test/test.http` with VS Code's REST Client extension or similar tools.

## Sample Request JSON for Each Role

### Instructor - Create Course
```json
{
  "role": "instructor",
  "action": "create",
  "courseId": "COURSE001"
}
```

### Instructor - Update Own Course
```json
{
  "role": "instructor",
  "action": "update",
  "courseId": "COURSE001",
  "owner": true
}
```

### Instructor - Update with Owner Flag
```json
{
  "role": "instructor",
  "action": "update",
  "owner": true
}
```

### Instructor - Delete Published Course (Denied)
```json
{
  "role": "instructor",
  "action": "delete",
  "courseId": "COURSE001",
  "owner": true,
  "published": true
}
```

### Student - View Enrolled Course
```json
{
  "role": "student",
  "action": "view",
  "courseId": "COURSE001",
  "enrolled": true
}
```

### Guest - View Free Course
```json
{
  "role": "guest",
  "action": "view",
  "courseId": "COURSE001",
  "free": true
}
```

## Test Case Results

| Test # | Role | Action | Condition | Expected Result | Status Code |
|--------|------|--------|-----------|-----------------|-------------|
| 1 | Student | View | Not Enrolled | Access Denied | 403 |
| 2 | Instructor | Update | Owner: True | Access Granted | 200 |
| 3 | Instructor | Update | Owner: False | Access Denied | 403 |
| 4 | Guest | View | Free: False | Access Denied | 403 |
| 5 | Instructor | Delete | Published: True | Access Denied | 403 |

## Authorization Rules Summary

### Instructor Role
- **Create**: Can create any course
- **Update**: Can update courses where `owner == true`
- **Delete**: Can delete courses where `owner == true`, but blocked if `published == true`

### Student Role
- **View**: Can view courses where `enrolled == true`

### Guest Role
- **View**: Can view courses where `free == true`

### Global Restrictions
- No role can delete a published course
- All actions on non-matching conditions result in 403 Access Denied

## CI/CD Pipeline

The GitHub Actions workflow automatically validates policies on every push to `main`:

1. Checks out code
2. Installs OPA
3. Creates test input with valid values
4. Evaluates policies using OPA CLI
5. Confirms policy validation success

### Policy Validation Rules (CI/CD)

- Course price must be non-negative
- Published courses must have all content present
- Deployments only allowed in production environment

## Running Tests

To run the test cases manually:

1. Ensure OPA server is running on `localhost:8181`
2. Ensure Express server is running on `localhost:3000`
3. Use VS Code REST Client extension or `curl` to execute requests in `test/test.http`

Example with curl:
```bash
curl -X POST http://localhost:3000/course-access \
  -H "Content-Type: application/json" \
  -d '{"role":"student","action":"view","enrolled":false}'
```

Expected response (403):
```json
{
  "error": "Access Denied"
}
```

## Error Handling

- **403 Forbidden**: Request denied by OPA policy
- **500 Internal Server Error**: OPA service unavailable or communication error

The middleware catches all OPA connection errors and returns detailed error information for debugging.
