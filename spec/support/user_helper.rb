
def create_logged_in_user
  post "/users", user: {
    email: "testuser@example.com",
    password: "secret123",
    password_confirmation: "secret123"
  }
end

def logout
  delete destroy_user_session_path
end

def create_user
  create_logged_in_user
  logout
end
