#!/bin/bash

mkdir -p out

filename="IMG_20200315_125023.jpg"

echo "| Type     | Size    | Runtime | Zoom    |Size     |"
echo "| -------- | ------- | ------- | ------- | ------- |"

start() {
    start_time=$(date +%s.%N)
}

end() {
    end_time=$(date +%s.%N)
    runtime=$( echo "$end_time - $start_time" | bc )
    echo "| $1 | $2 | $runtime | ![image]($3) | "
}

test_func_heic() {
    start
    outname="out/$filename.heic"
    convert $filename $outname
    end "heic" `stat -c %s $outname` "out/mini_heic_$filename.png"
    convert $outname +repage -crop 440x420+1400+2200 +repage "out/mini_heic_$filename.png"
}

test_func_jpeg() {
    start
    jpegoptim -q -o -d out -m"$1" $filename
    outname=out/$1_$filename
    mv out/$filename $outname
    end "jpeg$1" `stat -c %s out/$1_$filename` "out/mini_jpeg$1_$filename.png"
    convert $outname +repage -crop 440x420+1400+2200 +repage "out/mini_jpeg$1_$filename.png"
}

test_func_webp() {
    start
    outname="out/$1_$filename.webp"
    cwebp -quiet -q $1 $filename -o $outname
    end "webp$1" `stat -c %s $outname` "out/mini_webp$1_$filename"
    convert $outname +repage -crop 440x420+1400+2200 +repage "out/mini_webp$1_$filename"
}

test_func_jpeg "1"
test_func_heic
test_func_jpeg "10"
test_func_jpeg "30"
test_func_jpeg "50"
test_func_jpeg "60"
test_func_jpeg "85"
test_func_jpeg "100"
test_func_webp "10"
test_func_webp "30"
test_func_webp "50"
test_func_webp "60"
test_func_webp "85"
test_func_webp "100"


# convert in.png +repage -crop 640x620+0+0 +repage out.png
