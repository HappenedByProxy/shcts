function best() {
  yt-dlp --format '(bestvideo[vcodec^=av01][height>=4320][fps>30]/bestvideo[vcodec^=vp9.2][height>=4320][fps>$a'
}

function quick-warc {
        if [ -f $1.warc.gz ]
        then
                echo "$1.warc.gz already exists"
        else
                wget --warc-file=$1 --warc-cdx --mirror --page-requisites --no-check-certificate --restrict-file-names=windows \
                -e robots=off --waitretry 5 --timeout 60 --tries 5 --wait 1 \
                -U "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27" \
                "http://$1/"
        fi
}

function 0x0() {

  PS3='Select null pointer instance: '
  options=("0x0.st - 512MiB" "envs.sh - 512MiB" "ttm.sh - 256MiB" "Pixeldrain - 18.63GiB" "Quit")
  file=($1)
  select opt in "${options[@]}"
  do
      case $opt in
          "0x0.st - 512MiB")
              url=(https://0x0.st)
              break
              ;;
          "envs.sh - 512MiB")
              url=(https://envs.sh)
              break
              ;;
          "ttm.sh - 256MiB")
              url=(https://ttm.sh)
              break
              ;;
          "Pixeldrain - 18.63GiB")
             url=(https://pixeldrain.com/api/file/)
             id_=$(curl -T "$file" $url | jq -r '.id')
             printf "https://pixeldrain.com/u/$id_ " | tee >(clip.exe) && exit
             ;;
          "Quit")
              break
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done

curl -F"file=@$file" $url | tee >(clip.exe)
#echo $file $url
}
