class User < ApplicationRecord
	before_validation :ensure_session_token 
	validates :session_token, uniqueness: true 

	def ensure_session_token 
		self.session_token ||= generate_session_token 
	end

	def generate_session_token
		token = SecureRandom::urlsafe_base64
		while User.exists?(session_token: token)
			token = SecureRandom::urlsafe_base64
		end
		token 
	end

	def password=(password)
		self.password_digest = Bcrypt::Password.create(password)
		@password = password
	end
end