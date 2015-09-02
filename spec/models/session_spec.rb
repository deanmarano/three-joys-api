require 'rails_helper'

RSpec.describe Session, type: :model do
  it 'requires a user' do
    session = Session.create
    expect(session).to_not be_persisted
    expect(session.errors.messages).to eq({user: ["can't be blank"]})
  end

  it 'sets the token on creation' do
    user = User.create!(email: 'dean.marano@gmail.com', name: 'Deano')
    session = Session.create(user: user)
    expect(session).to be_persisted
    expect(session.token).to be_present
  end
end
