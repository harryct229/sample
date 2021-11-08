# == Schema Information
#
# Table name: slave_soundon_podcasts
#
#  id                 :integer          not null, primary key
#  artist_name        :binary(429496729 not null
#  country            :string(50)       not null
#  description        :binary(429496729
#  feed_url           :string(500)
#  frequency          :integer
#  genres             :string(1000)     not null
#  hosting            :string(100)
#  hosting_domain     :string(200)
#  image_url          :text(4294967295)
#  import_feed_url    :string(500)
#  is_explicit        :boolean          not null
#  is_ghost           :boolean
#  is_rss_working     :boolean
#  keywords           :text(4294967295)
#  language           :string(50)       not null
#  last_released_at   :datetime
#  name               :binary(429496729 not null
#  owner_email        :string(200)
#  prefixes           :string(500)
#  raw_language       :string(50)       not null
#  social_ids         :text(4294967295)
#  synced_at          :datetime
#  tracking_analytics :string(500)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  podcast_id         :integer
#  soundon_id         :string(50)       not null
#
# Indexes
#
#  slave_sound_podcast_fe903f_idx  (podcast_id)
#  slave_sound_soundon_fe7f3b_idx  (soundon_id)
#  soundon_id                      (soundon_id) UNIQUE
#
class Crawler::SoundonPodcast < Crawler::SlavePodcast
  self.table_name = "slave_soundon_podcasts"

  serialize :social_ids, JSON

  def socials
    _socials = {}

    if social_ids
      SocialNetwork.pluck(:name).map(&:downcase).each do |social|
        urls = social_ids[social]

        if urls
          urls.each do |url|
            if url["name"]
              _socials[social] ||= []
              _socials[social] << url["name"]
              _socials[social] = Utils.url_unique(_socials[social])
            end
          end
        end
      end
    end

    _socials
  end

  rails_admin do
    visible { false }
  end
end
