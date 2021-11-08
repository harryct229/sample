class PodcastMailer < ApplicationMailer
  def podcast_approval_email(id) 
    @podcast = Podcast.find(id) 
    mail( 
      to: @podcast.podcaster.email, 
      subject: "Your podcast ownership is approved!"
    )
  end 
end
