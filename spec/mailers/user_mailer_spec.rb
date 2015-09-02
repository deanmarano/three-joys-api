require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "single_use_session" do
    let(:mail) { UserMailer.single_use_session }

    xit "renders the headers" do
      expect(mail.subject).to eq("Single use session")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    xit "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
