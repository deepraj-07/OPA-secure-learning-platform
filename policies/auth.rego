package auth

default allow = false

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

allow {
    input.role == "student"
    input.action == "view"
    input.enrolled == true
}

allow {
    input.role == "guest"
    input.action == "view"
    input.free == true
}
