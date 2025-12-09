# 1. Remove snap version
sudo snap remove yt-dlp

# 2. Install official binary
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
  -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp



hash -r

which yt-dlp
yt-dlp --version

/usr/local/bin/yt-dlp \
  --cookies-from-browser firefox \
  -f "best[height<=480]" \
  --concurrent-fragments 8 \
  "https://www.youtube.com/watch?v=smTnSl6UKi0&list=PLpIkg8OmuX-L_QqcKB5abYynQbonaNcq3"
