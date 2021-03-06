ActiveRecord::Base.transaction do
  puts "============= Super Admin ============="
  user = User.new(
    state: "ready",
    email: ENV['ADMIN_EMAIL'],
    password: ENV['ADMIN_PASSWORD'],
    password_confirmation: ENV['ADMIN_PASSWORD'],
    first_name: ENV['ADMIN_FIRST_NAME'],
    last_name: ENV['ADMIN_LAST_NAME'],
    role: 'superadmin'
  )
  user.skip_confirmation!
  user.save!(validate: false)

  if user
    Rails.logger.info "Login with #{ENV['ADMIN_EMAIL']} and #{ENV['ADMIN_PASSWORD']}"
  end

  # # Create a admin user
  # admin = Brand.new(
  #   email: Faker::Internet.email,
  #   password: ENV['ADMIN_PASSWORD'],
  #   password_confirmation: ENV['ADMIN_PASSWORD'],
  #   first_name: Faker::Name.first_name,
  #   last_name: Faker::Name.last_name,
  #   role: 'user',
  # )
  # admin.skip_confirmation!
  # admin.save!

  # user = Brand.new(
  #   email: Faker::Internet.email,
  #   password: ENV['ADMIN_PASSWORD'],
  #   password_confirmation: ENV['ADMIN_PASSWORD'],
  #   first_name: Faker::Name.first_name,
  #   last_name: Faker::Name.last_name,
  #   role: 'user',
  # )
  # user.skip_confirmation!
  # user.save!

  # user = Brand.new(
  #   email: Faker::Internet.email,
  #   password: ENV['ADMIN_PASSWORD'],
  #   password_confirmation: ENV['ADMIN_PASSWORD'],
  #   first_name: Faker::Name.first_name,
  #   last_name: Faker::Name.last_name,
  #   role: 'user',
  # )
  # user.skip_confirmation!
  # user.save!

  # Tier
  puts "============= Tiers ============="
  4.times do |i| 
    tier = Tier.create(
      name: "Tier #{i}",
      priority: i,
    )
  end

  # SocialNetworks
  puts "============= SocialNetworks ============="
  %w(
    Facebook
    Instagram
    Youtube
    LinkedIn
    Twitter
    TikTok
    ClubHouse
    Patreon
    Spotify
  ).each do |social|
    SocialNetwork.create(name: social)
  end

  puts "============= BrandCategories ============="
  [
    "Advertising or Marketing",
    "Arts",
    "Automotive",
    "B2B",
    "Beauty & Fashion",
    "Consumer Packaged Goods",
    "Education",
    "Energy & Utilities",
    "Entertainment",
    "Finance or Financial Services",
    "Food & Beverages",
    "Government & Non-Profit",
    "Healthcare",
    "Others",
    "Political",
    "Real Estates",
    "Retail",
    "Sports",
    "Technology",
    "Telecom",
    "Travel & Hospitality",
  ].each do |category_name|
    BrandCategory.create(name: category_name)
  end

  puts "============= BrandTypes ============="
  [
    "Advertising Agency",
    "Brand Advertiser",
    "Cause or Community",
    "Company or Organization",
    "Media Company",
    "Product Advertiser",
  ].each do |brand_type_name|
    BrandType.create(name: brand_type_name)
  end

  puts "============= PodcastCategories ============="
  podcast_categories = [
    {
      name: "Arts",
      children: [
        "Books",
        "Design",
        "Fashion & Beauty",
        "Food",
        "Performing Arts",
        "Visual Arts",
      ]
    },
    {
      name: "Business",
      children: [
        "Careers",
        "Entreprenuership",
        "Investing",
        "Management",
        "Management & Marketing",
        "Marketing",
        "Non-Profit",
        "Personal Finance",
        "Sales",
        "Shopping",
        "Startup",
        "Venture Capital",
      ]
    },
    {
      name: "Comedy",
      children: [
        "Comedy Interviews",
        "Improv",
        "Stand-Up",
      ]
    },
    {
      name: "Education",
      children: [
        "Courses",
        "Educational Technology",
        "Higher Education",
        "How To",
        "K-12",
        "Language Learning",
        "Self-Improvement",
        "Training",
      ]
    },
    {
      name: "Fiction",
      children: [
        "Comedy Fiction",
        "Drama",
        "Science Fiction",
      ]
    },
    {
      name: "Government",
      children: [
      ]
    },
    {
      name: "Health & Fitness",
      children: [
        "Alternative Health",
        "Fitness",
        "Fitness & Nutrition",
        "Medicine",
        "Mental Health",
        "Nutrition",
        "Self-Help",
        "Sexuality",
      ]
    },
    {
      name: "History",
      children: [
      ]
    },
    {
      name: "Kids & Family",
      children: [
        "Education for Kids",
        "Parenting",
        "Pets & Animals",
        "Stories for Kids",
      ]
    },
    {
      name: "Leisure",
      children: [
        "Animation & Manga",
        "Automotive",
        "Aviation",
        "Crafts",
        "Games",
        "Hobbies",
        "Home & Garden",
        "Other Games",
        "Video Games",
      ]
    },
    {
      name: "Music",
      children: [
        "Music Commentary",
        "Music History",
        "Music Interviews",
      ]
    },
    {
      name: "News",
      children: [
        "Business News",
        "Daily News",
        "Entertainment News",
        "News Commentary",
        "Politics",
        "Sports News",
      ]
    },
    {
      name: "Religion & Spirituality",
      children: [
        "Buddhism",
        "Christianity",
        "Hinduism",
        "Islam",
        "Judaism",
        "Religion",
        "Spirituality",
      ]
    },
    {
      name: "Science",
      children: [
        "Astronomy",
        "Chemistry",
        "Earth Sciences",
        "Life Sciences",
        "Mathematics",
        "Natural Sciences",
        "Nature",
        "Physics",
        "Social Sciences",
      ]
    },
    {
      name: "Society & Culture",
      children: [
        "Audio Drama",
        "Documentary",
        "Personal Journals",
        "Philosophy",
        "Places & Travel",
        "Relationships",
        "Storytelling",
      ]
    },
    {
      name: "Sports",
      children: [
        "Amateur",
        "Baseball",
        "Basketball",
        "College & High School",
        "Cricket",
        "Fantasy Sports",
        "Football",
        "Golf",
        "Hockey",
        "Outdoor",
        "Professional",
        "Rugby",
        "Running",
        "Soccer",
        "Swimming",
        "Tennis",
        "Volleyball",
        "Wilderness",
        "Wrestling",
      ]
    },
    {
      name: "TV & Film",
      children: [
        "After Shows",
        "Film History",
        "Film Interviews",
        "Film Reviews",
        "Movie",
        "TV Reviews",
        "Youtube",
      ]
    },
    {
      name: "Technology",
      children: [
        "AI & Data Science",
        "Apple",
        "Crypto & Blockchain",
        "Gadgets",
        "Podcasting",
        "Programming",
        "Software How-To",
        "Tech News",
        "VR & AR",
        "Web Design",
      ]
    },
    {
      name: "True Crime",
      children: [
      ]
    },
  ]

  podcast_categories.each do |category|
    cat = PodcastCategory.create(name: category[:name])
    category[:children].each do |sub_name|
      cat.sub_categories.create(name: sub_name)
    end
  end

  puts "============= Languages ============="
  [ 
    { code: "ab", name: "Abkhaz" }, 
    { code: "aa", name: "Afar" }, 
    { code: "af", name: "Afrikaans" }, 
    { code: "agq", name: "Aghem" }, 
    { code: "ak", name: "Akan" }, 
    { code: "sq", name: "Albanian" }, 
    { code: "am", name: "Amharic" }, 
    { code: "ar", name: "Arabic" }, 
    { code: "an", name: "Aragonese" }, 
    { code: "hy", name: "Armenian" }, 
    { code: "as", name: "Assamese" }, 
    { code: "ast", name: "Asturian" }, 
    { code: "asa", name: "Asu (Tanzania)" }, 
    { code: "av", name: "Avaric" }, 
    { code: "ae", name: "Avestan" }, 
    { code: "ay", name: "Aymara" }, 
    { code: "az", name: "Azerbaijani" }, 
    { code: "ksf", name: "Bafia" }, 
    { code: "bm", name: "Bambara" }, 
    { code: "ba", name: "Bashkir" }, 
    { code: "eu", name: "Basque" }, 
    { code: "be", name: "Belarusian" }, 
    { code: "bem", name: "Bemba (Zambia)" }, 
    { code: "bn", name: "Bengali" }, 
    { code: "bh", name: "Bihari" }, 
    { code: "bi", name: "Bislama" }, 
    { code: "bs", name: "Bosnian" }, 
    { code: "br", name: "Breton" }, 
    { code: "bg", name: "Bulgarian" }, 
    { code: "my", name: "Burmese" }, 
    { code: "ca", name: "Catalan" }, 
    { code: "ceb", name: "Cebuano" }, 
    { code: "tzm", name: "Central Atlas Tamazight" }, 
    { code: "ccp", name: "Chakma" }, 
    { code: "ch", name: "Chamorro" }, 
    { code: "ce", name: "Chechen" }, 
    { code: "ny", name: "Chichewa" }, 
    { code: "zh", name: "Chinese" }, 
    { code: "yue", name: "Chinese (Cantonese)" }, 
    { code: "hak", name: "Chinese (Hakka)" }, 
    { code: "nan", name: "Chinese (Min Nan)" }, 
    { code: "cv", name: "Chuvash" }, 
    { code: "kw", name: "Cornish" }, 
    { code: "co", name: "Corsican" }, 
    { code: "cr", name: "Cree" }, 
    { code: "hr", name: "Croatian" }, 
    { code: "cs", name: "Czech" }, 
    { code: "da", name: "Danish" }, 
    { code: "dv", name: "Divehi" }, 
    { code: "nl", name: "Dutch" }, 
    { code: "dz", name: "Dzongkha" }, 
    { code: "en", name: "English" }, 
    { code: "eo", name: "Esperanto" }, 
    { code: "et", name: "Estonian" }, 
    { code: "ee", name: "Ewe" }, 
    { code: "ewo", name: "Ewondo" }, 
    { code: "fo", name: "Faroese" }, 
    { code: "fj", name: "Fijian" }, 
    { code: "fi", name: "Finnish" }, 
    { code: "fr", name: "French" }, 
    { code: "fur", name: "Friulian" }, 
    { code: "ff", name: "Fula" }, 
    { code: "gl", name: "Galician" }, 
    { code: "lg", name: "Ganda" }, 
    { code: "ka", name: "Georgian" }, 
    { code: "de", name: "German" }, 
    { code: "el", name: "Greek" }, 
    { code: "gn", name: "Guaran??" }, 
    { code: "gu", name: "Gujarati" }, 
    { code: "ht", name: "Haitian" }, 
    { code: "ha", name: "Hausa" }, 
    { code: "haw", name: "Hawaiian" }, 
    { code: "he", name: "Hebrew" }, 
    { code: "hz", name: "Herero" }, 
    { code: "hi", name: "Hindi" }, 
    { code: "ho", name: "Hiri Motu" }, 
    { code: "hu", name: "Hungarian" }, 
    { code: "is", name: "Icelandic" }, 
    { code: "io", name: "Ido" }, 
    { code: "ig", name: "Igbo" }, 
    { code: "id", name: "Indonesian" }, 
    { code: "ia", name: "Interlingua" }, 
    { code: "ie", name: "Interlingue" }, 
    { code: "iu", name: "Inuktitut" }, 
    { code: "ik", name: "Inupiaq" }, 
    { code: "ga", name: "Irish" }, 
    { code: "it", name: "Italian" }, 
    { code: "ja", name: "Japanese" }, 
    { code: "jv", name: "Javanese" }, 
    { code: "dyo", name: "Jola-Fonyi" }, 
    { code: "kea", name: "Kabuverdianu" }, 
    { code: "kl", name: "Kalaallisut" }, 
    { code: "kam", name: "Kamba (Kenya)" }, 
    { code: "kn", name: "Kannada" }, 
    { code: "kr", name: "Kanuri" }, 
    { code: "ks", name: "Kashmiri" }, 
    { code: "kk", name: "Kazakh" }, 
    { code: "km", name: "Khmer" }, 
    { code: "ki", name: "Kikuyu" }, 
    { code: "rw", name: "Kinyarwanda" }, 
    { code: "rn", name: "Kirundi" }, 
    { code: "kv", name: "Komi" }, 
    { code: "kg", name: "Kongo" }, 
    { code: "kok", name: "Konkani (macrolanguage)" }, 
    { code: "ko", name: "Korean" }, 
    { code: "ku", name: "Kurdish" }, 
    { code: "kj", name: "Kwanyama" }, 
    { code: "ky", name: "Kyrgyz" }, 
    { code: "lo", name: "Lao" }, 
    { code: "la", name: "Latin" }, 
    { code: "lv", name: "Latvian" }, 
    { code: "li", name: "Limburgish" }, 
    { code: "ln", name: "Lingala" }, 
    { code: "lt", name: "Lithuanian" }, 
    { code: "lu", name: "Luba-Katanga" }, 
    { code: "luo", name: "Luo (Kenya and Tanzania)" }, 
    { code: "lb", name: "Luxembourgish" }, 
    { code: "mk", name: "Macedonian" }, 
    { code: "mgh", name: "Makhuwa-Meetto" }, 
    { code: "mg", name: "Malagasy" }, 
    { code: "ms", name: "Malay" }, 
    { code: "ml", name: "Malayalam" }, 
    { code: "mt", name: "Maltese" }, 
    { code: "gv", name: "Manx" }, 
    { code: "mi", name: "M??ori" }, 
    { code: "mr", name: "Marathi" }, 
    { code: "mh", name: "Marshallese" }, 
    { code: "mer", name: "Meru" }, 
    { code: "mn", name: "Mongolian" }, 
    { code: "na", name: "Nauru" }, 
    { code: "nv", name: "Navajo" }, 
    { code: "ng", name: "Ndonga" }, 
    { code: "ne", name: "Nepali" }, 
    { code: "nd", name: "Northern Ndebele" }, 
    { code: "se", name: "Northern Sami" }, 
    { code: "no", name: "Norwegian" }, 
    { code: "nb", name: "Norwegian Bokm??l" }, 
    { code: "nn", name: "Norwegian Nynorsk" }, 
    { code: "ii", name: "Nuosu" }, 
    { code: "yes", name: "Nyankpa" }, 
    { code: "oc", name: "Occitan" }, 
    { code: "oj", name: "Ojibwe" }, 
    { code: "cu", name: "Old Church Slavonic" }, 
    { code: "or", name: "Oriya" }, 
    { code: "om", name: "Oromo" }, 
    { code: "os", name: "Ossetian" }, 
    { code: "pi", name: "P??li" }, 
    { code: "pa", name: "Panjabi" }, 
    { code: "ps", name: "Pashto" }, 
    { code: "fa", name: "Persian" }, 
    { code: "pl", name: "Polish" }, 
    { code: "pt", name: "Portuguese" }, 
    { code: "qu", name: "Quechua" }, 
    { code: "ro", name: "Romanian" }, 
    { code: "rm", name: "Romansh" }, 
    { code: "ru", name: "Russian" }, 
    { code: "sm", name: "Samoan" }, 
    { code: "sg", name: "Sango" }, 
    { code: "sa", name: "Sanskrit" }, 
    { code: "skr", name: "Saraiki" }, 
    { code: "sc", name: "Sardinian" }, 
    { code: "sco", name: "Scots" }, 
    { code: "gd", name: "Scottish Gaelic" }, 
    { code: "sr", name: "Serbian" }, 
    { code: "sve", name: "Serili" }, 
    { code: "sn", name: "Shona" }, 
    { code: "sd", name: "Sindhi" }, 
    { code: "si", name: "Sinhala" }, 
    { code: "sk", name: "Slovak" }, 
    { code: "sl", name: "Slovene" }, 
    { code: "so", name: "Somali" }, 
    { code: "nr", name: "Southern Ndebele" }, 
    { code: "st", name: "Southern Sotho" }, 
    { code: "es", name: "Spanish" }, 
    { code: "su", name: "Sundanese" }, 
    { code: "sw", name: "Swahili" }, 
    { code: "ss", name: "Swati" }, 
    { code: "sv", name: "Swedish" }, 
    { code: "tl", name: "Tagalog" }, 
    { code: "ty", name: "Tahitian" }, 
    { code: "tg", name: "Tajik" }, 
    { code: "ta", name: "Tamil" }, 
    { code: "tt", name: "Tatar" }, 
    { code: "te", name: "Telugu" }, 
    { code: "th", name: "Thai" }, 
    { code: "bo", name: "Tibetan Standard" }, 
    { code: "ti", name: "Tigrinya" }, 
    { code: "to", name: "Tonga" }, 
    { code: "ts", name: "Tsonga" }, 
    { code: "tn", name: "Tswana" }, 
    { code: "enh", name: "Tundra Enets" }, 
    { code: "tr", name: "Turkish" }, 
    { code: "tk", name: "Turkmen" }, 
    { code: "tw", name: "Twi" }, 
    { code: "uk", name: "Ukrainian" }, 
    { code: "ur", name: "Urdu" }, 
    { code: "ug", name: "Uyghur" }, 
    { code: "uz", name: "Uzbek" }, 
    { code: "ve", name: "Venda" }, 
    { code: "vi", name: "Vietnamese" }, 
    { code: "vo", name: "Volap??k" }, 
    { code: "wa", name: "Walloon" }, 
    { code: "cy", name: "Welsh" }, 
    { code: "fy", name: "Western Frisian" }, 
    { code: "wo", name: "Wolof" }, 
    { code: "xh", name: "Xhosa" }, 
    { code: "yav", name: "Yangben" }, 
    { code: "yi", name: "Yiddish" }, 
    { code: "yo", name: "Yoruba" }, 
    { code: "za", name: "Zhuang" }, 
    { code: "zu", name: "Zulu" }
  ].each do |language|
    Language.create(language)
  end

  puts "============= Countries ============="
  [
    { name: "Afghanistan", code: "AF" },
    { name: "??land", code: "AX" },
    { name: "Albania", code: "AL" },
    { name: "Algeria", code: "DZ" },
    { name: "American Samoa", code: "AS" },
    { name: "Andorra", code: "AD" },
    { name: "Angola", code: "AO" },
    { name: "Anguilla", code: "AI" },
    { name: "Antarctica", code: "AQ" },
    { name: "Antigua and Barbuda", code: "AG" },
    { name: "Argentina", code: "AR" },
    { name: "Armenia", code: "AM" },
    { name: "Aruba", code: "AW" },
    { name: "Australia", code: "AU" },
    { name: "Austria", code: "AT" },
    { name: "Azerbaijan", code: "AZ" },
    { name: "Bahamas", code: "BS" },
    { name: "Bahrain", code: "BH" },
    { name: "Bangladesh", code: "BD" },
    { name: "Barbados", code: "BB" },
    { name: "Belarus", code: "BY" },
    { name: "Belgium", code: "BE" },
    { name: "Belize", code: "BZ" },
    { name: "Benin", code: "BJ" },
    { name: "Bermuda", code: "BM" },
    { name: "Bhutan", code: "BT" },
    { name: "Bolivia", code: "BO" },
    { name: "Bonaire", code: "BQ" },
    { name: "Bosnia and Herzegovina", code: "BA" },
    { name: "Botswana", code: "BW" },
    { name: "Bouvet Island", code: "BV" },
    { name: "Brazil", code: "BR" },
    { name: "British Indian Ocean Territory", code: "IO" },
    { name: "British Virgin Islands", code: "VG" },
    { name: "Brunei", code: "BN" },
    { name: "Bulgaria", code: "BG" },
    { name: "Burkina Faso", code: "BF" },
    { name: "Burundi", code: "BI" },
    { name: "Cambodia", code: "KH" },
    { name: "Cameroon", code: "CM" },
    { name: "Canada", code: "CA" },
    { name: "Cape Verde", code: "CV" },
    { name: "Cayman Islands", code: "KY" },
    { name: "Central African Republic", code: "CF" },
    { name: "Chad", code: "TD" },
    { name: "Chile", code: "CL" },
    { name: "China", code: "CN" },
    { name: "Christmas Island", code: "CX" },
    { name: "Cocos [Keeling] Islands", code: "CC" },
    { name: "Colombia", code: "CO" },
    { name: "Comoros", code: "KM" },
    { name: "Cook Islands", code: "CK" },
    { name: "Costa Rica", code: "CR" },
    { name: "Croatia", code: "HR" },
    { name: "Cuba", code: "CU" },
    { name: "Curacao", code: "CW" },
    { name: "Cyprus", code: "CY" },
    { name: "Czech Republic", code: "CZ" },
    { name: "Democratic Republic of the Congo", code: "CD" },
    { name: "Denmark", code: "DK" },
    { name: "Djibouti", code: "DJ" },
    { name: "Dominica", code: "DM" },
    { name: "Dominican Republic", code: "DO" },
    { name: "East Timor", code: "TL" },
    { name: "Ecuador", code: "EC" },
    { name: "Egypt", code: "EG" },
    { name: "El Salvador", code: "SV" },
    { name: "Equatorial Guinea", code: "GQ" },
    { name: "Eritrea", code: "ER" },
    { name: "Estonia", code: "EE" },
    { name: "Ethiopia", code: "ET" },
    { name: "Falkland Islands", code: "FK" },
    { name: "Faroe Islands", code: "FO" },
    { name: "Fiji", code: "FJ" },
    { name: "Finland", code: "FI" },
    { name: "France", code: "FR" },
    { name: "French Guiana", code: "GF" },
    { name: "French Polynesia", code: "PF" },
    { name: "French Southern Territories", code: "TF" },
    { name: "Gabon", code: "GA" },
    { name: "Gambia", code: "GM" },
    { name: "Georgia", code: "GE" },
    { name: "Germany", code: "DE" },
    { name: "Ghana", code: "GH" },
    { name: "Gibraltar", code: "GI" },
    { name: "Greece", code: "GR" },
    { name: "Greenland", code: "GL" },
    { name: "Grenada", code: "GD" },
    { name: "Guadeloupe", code: "GP" },
    { name: "Guam", code: "GU" },
    { name: "Guatemala", code: "GT" },
    { name: "Guernsey", code: "GG" },
    { name: "Guinea", code: "GN" },
    { name: "Guinea-Bissau", code: "GW" },
    { name: "Guyana", code: "GY" },
    { name: "Haiti", code: "HT" },
    { name: "Heard Island and McDonald Islands", code: "HM" },
    { name: "Honduras", code: "HN" },
    { name: "Hong Kong", code: "HK" },
    { name: "Hungary", code: "HU" },
    { name: "Iceland", code: "IS" },
    { name: "India", code: "IN" },
    { name: "Indonesia", code: "ID" },
    { name: "Iran", code: "IR" },
    { name: "Iraq", code: "IQ" },
    { name: "Ireland", code: "IE" },
    { name: "Isle of Man", code: "IM" },
    { name: "Israel", code: "IL" },
    { name: "Italy", code: "IT" },
    { name: "Ivory Coast", code: "CI" },
    { name: "Jamaica", code: "JM" },
    { name: "Japan", code: "JP" },
    { name: "Jersey", code: "JE" },
    { name: "Jordan", code: "JO" },
    { name: "Kazakhstan", code: "KZ" },
    { name: "Kenya", code: "KE" },
    { name: "Kiribati", code: "KI" },
    { name: "Kosovo", code: "XK" },
    { name: "Kuwait", code: "KW" },
    { name: "Kyrgyzstan", code: "KG" },
    { name: "Laos", code: "LA" },
    { name: "Latvia", code: "LV" },
    { name: "Lebanon", code: "LB" },
    { name: "Lesotho", code: "LS" },
    { name: "Liberia", code: "LR" },
    { name: "Libya", code: "LY" },
    { name: "Liechtenstein", code: "LI" },
    { name: "Lithuania", code: "LT" },
    { name: "Luxembourg", code: "LU" },
    { name: "Macao", code: "MO" },
    { name: "Madagascar", code: "MG" },
    { name: "Malawi", code: "MW" },
    { name: "Malaysia", code: "MY" },
    { name: "Maldives", code: "MV" },
    { name: "Mali", code: "ML" },
    { name: "Malta", code: "MT" },
    { name: "Marshall Islands", code: "MH" },
    { name: "Martinique", code: "MQ" },
    { name: "Mauritania", code: "MR" },
    { name: "Mauritius", code: "MU" },
    { name: "Mayotte", code: "YT" },
    { name: "Mexico", code: "MX" },
    { name: "Micronesia", code: "FM" },
    { name: "Moldova", code: "MD" },
    { name: "Monaco", code: "MC" },
    { name: "Mongolia", code: "MN" },
    { name: "Montenegro", code: "ME" },
    { name: "Montserrat", code: "MS" },
    { name: "Morocco", code: "MA" },
    { name: "Mozambique", code: "MZ" },
    { name: "Myanmar [Burma]", code: "MM" },
    { name: "Namibia", code: "NA" },
    { name: "Nauru", code: "NR" },
    { name: "Nepal", code: "NP" },
    { name: "Netherlands", code: "NL" },
    { name: "New Caledonia", code: "NC" },
    { name: "New Zealand", code: "NZ" },
    { name: "Nicaragua", code: "NI" },
    { name: "Niger", code: "NE" },
    { name: "Nigeria", code: "NG" },
    { name: "Niue", code: "NU" },
    { name: "Norfolk Island", code: "NF" },
    { name: "North Korea", code: "KP" },
    { name: "North Macedonia", code: "MK" },
    { name: "Northern Mariana Islands", code: "MP" },
    { name: "Norway", code: "NO" },
    { name: "Oman", code: "OM" },
    { name: "Pakistan", code: "PK" },
    { name: "Palau", code: "PW" },
    { name: "Palestine", code: "PS" },
    { name: "Panama", code: "PA" },
    { name: "Papua New Guinea", code: "PG" },
    { name: "Paraguay", code: "PY" },
    { name: "Peru", code: "PE" },
    { name: "Philippines", code: "PH" },
    { name: "Pitcairn Islands", code: "PN" },
    { name: "Poland", code: "PL" },
    { name: "Portugal", code: "PT" },
    { name: "Puerto Rico", code: "PR" },
    { name: "Qatar", code: "QA" },
    { name: "Republic of the Congo", code: "CG" },
    { name: "R??union", code: "RE" },
    { name: "Romania", code: "RO" },
    { name: "Russia", code: "RU" },
    { name: "Rwanda", code: "RW" },
    { name: "Saint Barth??lemy", code: "BL" },
    { name: "Saint Helena", code: "SH" },
    { name: "Saint Kitts and Nevis", code: "KN" },
    { name: "Saint Lucia", code: "LC" },
    { name: "Saint Martin", code: "MF" },
    { name: "Saint Pierre and Miquelon", code: "PM" },
    { name: "Saint Vincent and the Grenadines", code: "VC" },
    { name: "Samoa", code: "WS" },
    { name: "San Marino", code: "SM" },
    { name: "S??o Tom?? and Pr??ncipe", code: "ST" },
    { name: "Saudi Arabia", code: "SA" },
    { name: "Senegal", code: "SN" },
    { name: "Serbia", code: "RS" },
    { name: "Seychelles", code: "SC" },
    { name: "Sierra Leone", code: "SL" },
    { name: "Singapore", code: "SG" },
    { name: "Sint Maarten", code: "SX" },
    { name: "Slovakia", code: "SK" },
    { name: "Slovenia", code: "SI" },
    { name: "Solomon Islands", code: "SB" },
    { name: "Somalia", code: "SO" },
    { name: "South Africa", code: "ZA" },
    { name: "South Georgia and the South Sandwich Icodes",  code: "GS" },
    { name: "South Korea", code: "KR" },
    { name: "South Sudan", code: "SS" },
    { name: "Spain", code: "ES" },
    { name: "Sri Lanka", code: "LK" },
    { name: "Sudan", code: "SD" },
    { name: "Suriname", code: "SR" },
    { name: "Svalbard and Jan Mayen", code: "SJ" },
    { name: "Swaziland", code: "SZ" },
    { name: "Sweden", code: "SE" },
    { name: "Switzerland", code: "CH" },
    { name: "Syria", code: "SY" },
    { name: "Taiwan", code: "TW" },
    { name: "Tajikistan", code: "TJ" },
    { name: "Tanzania", code: "TZ" },
    { name: "Thailand", code: "TH" },
    { name: "Togo", code: "TG" },
    { name: "Tokelau", code: "TK" },
    { name: "Tonga", code: "TO" },
    { name: "Trinidad and Tobago", code: "TT" },
    { name: "Tunisia", code: "TN" },
    { name: "Turkey", code: "TR" },
    { name: "Turkmenistan", code: "TM" },
    { name: "Turks and Caicos Islands", code: "TC" },
    { name: "Tuvalu", code: "TV" },
    { name: "U.S. Minor Outlying Islands", code: "UM" },
    { name: "U.S. Virgin Islands", code: "VI" },
    { name: "Uganda", code: "UG" },
    { name: "Ukraine", code: "UA" },
    { name: "United Arab Emirates", code: "AE" },
    { name: "United Kingdom", code: "GB" },
    { name: "United States", code: "US" },
    { name: "Uruguay", code: "UY" },
    { name: "Uzbekistan", code: "UZ" },
    { name: "Vanuatu", code: "VU" },
    { name: "Vatican City", code: "VA" },
    { name: "Venezuela", code: "VE" },
    { name: "Vietnam", code: "VN" },
    { name: "Wallis and Futuna", code: "WF" },
    { name: "Western Sahara", code: "EH" },
    { name: "Yemen", code: "YE" },
    { name: "Zambia", code: "ZM" },
    { name: "Zimbabwe", code: "ZW" }
  ].each do |country|
    Country.create(country)
  end

end
