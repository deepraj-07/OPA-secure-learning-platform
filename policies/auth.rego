package auth

default allow = false

# Instructor
allow {
    input.role == "instructor"
    input.action == "create"
}

allow {
    input.role == "instructor"
    input.action == "update"
    input.owner == true
}

allow {
    input.role == "instructor"
    input.action == "delete"
    input.owner == true
    not input.published
}

# Student
allow {
    input.role == "student"
    input.action == "view"
    input.enrolled == true
}

# Guest
allow {
    input.role == "guest"
    input.action == "view"
    input.free == true
}
