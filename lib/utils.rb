# frozen_string_literal: true

module Utils
  MASKED_EMAIL_REGEXES = [
    /@anchor\.fm/,
    /@example\.com/,
    /feeds@spreaker\.com/,
    /feeds@soundcloud\.com/,
    /@mg\.pippa\.io/,
    /podcast@ximalaya\.com/,
  ]

  def self.url_no_scheme(url)
    url.gsub!("https://", "https:/")
    url.gsub!("https:/", "https://")
    url.gsub!("http://", "http:/")
    url.gsub!("http:/", "http://")

    begin
      uri = URI(url)
      (uri.hostname + uri.path).gsub(/\/$/, "")
    rescue Exception => e
      url
    end
  end

  def self.url_unique(urls)
    uniq = []
    uniq_normalized = []

    urls.each do |url|
      normalized = self.url_no_scheme(url).downcase
      if !normalized.in?(uniq_normalized)
        uniq << url
        uniq_normalized << normalized
      end
    end

    uniq
  end

  def self.get_domain(url)
    uri = URI(url)
    uri.hostname
  end

  def self.generate_filters()
    {
      "1": [ 
        (Time.current - 7.days).beginning_of_day,
        Time.current
      ],
      "2": [ 
        (Time.current - 14.days).beginning_of_day,
        Time.current
      ],
      "3": [ 
        (Time.current - 30.days).beginning_of_day,
        Time.current
      ],
      "4": [ 
        (Time.current - 90.days).beginning_of_day,
        Time.current
      ],
      "5": [
        Time.current.last_month.beginning_of_month,
        Time.current.beginning_of_month
      ],
      "6": [
        0,
        Time.current
      ]
    }
  end

  def self.valid_email?(email)
    email.match(Devise.email_regexp).present?
  end

  def self.masked_email?(email)
    MASKED_EMAIL_REGEXES.any? do |regex|
      email.match(regex)
    end
  end
end
