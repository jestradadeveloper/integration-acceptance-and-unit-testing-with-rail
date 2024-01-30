class Achievement < ApplicationRecord
  validates :title, presence: true
  enum privacy: { public_access: 0, private_access: 1, friends_access: 2 }

  def description_html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(description)
  end
end
