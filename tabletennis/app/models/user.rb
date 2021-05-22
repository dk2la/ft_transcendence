class User < ActiveRecord::Base
  enum status: [:offline, :online]

  #FRIENDS INVITATIONS RELATIVES
  has_many :invitations
  has_many :pending_invitations, -> { where confirmed: false }, class_name: 'Friendship', foreign_key: "friend_id"


  #GUILD RELATIVES
  has_one :guild_member
  has_one :guild, :through => :guild_member

  #GAMES RELATIVES 1:1
  has_one :game_member
  has_one :game, :through => :game_member

  #CHAT ROOMS RELATIVE
  has_many :room_members
  has_many :chat_rooms, :through => :room_members
  has_many :blocked_users, class_name: "BlockedUser", dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:marvin]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.nickname = auth.info.nickname
    end
  end

  def friends
    friends_i_sent_invitation = Friendship.where(user_id: id, confirmed: true).pluck(:friend_id)
    friends_i_got_invitation = Friendship.where(friend_id: id, confirmed: true).pluck(:user_id)
    ids = friends_i_sent_invitation + friends_i_got_invitation
    User.where(id: ids)
  end

  def friend_with?(user)
    Friendship.confirmed_record?(id, user.id)
  end

  def send_invitation(user)
    invitations.create(friend_id: user.id)
  end

end
