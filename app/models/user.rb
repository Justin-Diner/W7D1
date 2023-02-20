class User < ApplicationRecord
	before_validation :ensure_session_token 
	validates :session_token, :username, uniqueness: true, presence: true 
	validates :password, length: {minimum: 6}, allow_nil: true 
	validates :password_digest, presence: true 

	def ensure_session_token 
		self.session_token ||= generate_unique_session_token 
	end

	def password=(password)
		self.password_digest = Bcrypt::Password.create(password)
		@password = password
	end

	def is_password?(password)
		bcrypt_obj = BCrypt::Password.new(self.password_digest)
		bcrypt_obj.is_password?(password)
	end

	def self.find_by_credentials(username, password)
		user = User.find_by(username: username)
		if user && user.is_password?(password)
			return user 
		else 
			nil
		end
	end

	def reset_session_token! 
		self.session_token = generate_unique_session_token
		self.save!
		self.session_token
	end

	private
	def generate_unique_session_token
		token = SecureRandom::urlsafe_base64
		while User.exists?(session_token: token)
			token = SecureRandom::urlsafe_base64
		end
		token 
	end

end