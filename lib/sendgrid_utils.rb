# frozen_string_literal: true

module SendgridUtils
  include SendGrid

  def self.send_brand_message(email, master_podcast, group, message)
    podcast_name = master_podcast.name.force_encoding("UTF-8")
    brand_name = group.company_name

    message ||= "Hi #{podcast_name}, It's #{brand_name}. We want to discuss with you about advertising on your podcast. Look forward to hearing from you."

    mail = Mail.new
    mail.template_id = 'd-8cb1e7ebd5ba42eb90bd9deac127226e'
    mail.from = Email.new(
      email: 'hello@matchcasts.com',
      name: 'MatchCasts'
    )
    mail.subject = "MatchCasts - #{brand_name} want to connect with you!"

    personalization = Personalization.new
    personalization.add_to(
      Email.new(
        email: email,
        name: podcast_name
      )
    )
    personalization.add_bcc(
      Email.new(
        email: "thanh@matchcasts.com",
        name: "Thanh from MatchCasts"
      )
    )
    personalization.add_dynamic_template_data(
      {
        "podcast_name" => podcast_name,
        "brand_name" => brand_name,
        "brand_message" => message,
      }
    )

    mail.add_personalization(personalization)

    puts mail.to_json

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end

  def self.send_unread_notification(email, to_name, from_name, message)
    mail = Mail.new
    mail.template_id = 'd-ba04e21d7a8c4b84be98cf0d18b44266'
    mail.from = Email.new(
      email: 'hello@matchcasts.com',
      name: 'MatchCasts'
    )
    mail.subject = "MatchCasts - You have new messages!"

    personalization = Personalization.new
    personalization.add_to(
      Email.new(
        email: email,
        name: to_name
      )
    )
    personalization.add_dynamic_template_data(
      {
        "to_name" => to_name,
        "from_name" => from_name,
      }
    )

    mail.add_personalization(personalization)

    puts mail.to_json

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end
end
