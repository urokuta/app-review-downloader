require 'zlib'
require 'json'
require 'csv'
date = Date.today.to_s.gsub(" ","")
app_id = ARGV[0]
str = %W(
curl 'https://itunes.apple.com/WebObjects/MZStore.woa/wa/userReviewsRow?id=#{app_id}&displayable-kind=11&startIndex=0&endIndex=5000&sort=1&appVersion=all'
-H 'X-Apple-Store-Front:143462-9,32'
-H 'Accept  */*'
-H 'Accept-Encoding:gzip,deflate'
-H 'Connection:keep-alive'
-H 'User-Agent:iTunes/12.5.3 (Macintosh; OS X 10.10.5) AppleWebKit/600.8.9'
-H 'Accept-Language:ja;q=1.0, en;q=0.9'
-H 'X-Apple-Tz:32400'
-H 'Referer:https://itunes.apple.com/jp/app/id#{app_id}?mt=8'
)*' '
# should add cookie in Headers
str << " > app-review-#{app_id}-#{date}.gz"
`#{str}`
s = Zlib::GzipReader.new(File.open "app-review-#{app_id}-#{date}.gz").read
obj = JSON.parse s
CSV.open("app-review-#{app_id}-#{date}.csv", "wb") do |csv|
  obj["userReviewList"].each do |h|
    csv << [
      h["name"],
      h["date"],
      h["rating"],
      h["title"],
      h["body"].gsub("\n", " ").gsub("\r\n", " "),
    ]
  end
end
