#!/bin/bash

# ./performance_test.sh | tee readme.md 

mkdir -p out

# echo "<style>"
# echo "img {height: 30%;width: 30%;}"
# echo "</style>""

start() {
    start_time=$(date +%s.%N)
}

end() {
    end_time=$(date +%s.%N)
    runtime=$( echo "$end_time - $start_time" | bc )
    echo "| $1 | $2 | $runtime | <img src='$3' width="150" height="150"> |  [image]($4) | "
}

size() {
    echo `stat -c %s $1 | numfmt --to=iec`
}

test_func_heic() {
    start
    outname="out/$filename.heic"
    convert $filename $outname
    end "heic" `size $outname` "out/mini_heic_$filename.png" "$outname"
    convert $outname +repage -crop 440x420+1400+2200 +repage "out/mini_heic_$filename.png"
}

test_func_jpeg() {
    start
    jpegoptim -q -o -d out -m"$1" $filename
    outname=out/$1_$filename
    mv out/$filename $outname
    end "jpeg$1" `size out/$1_$filename` "out/mini_jpeg$1_$filename.png" "$outname"
    convert $outname +repage -crop 440x420+1400+2200 +repage "out/mini_jpeg$1_$filename.png"
}

test_func_webp() {
    start
    outname="out/$1_$filename.webp"
    cwebp -quiet -q $1 $filename -o $outname
    end "webp$1" `size $outname` "out/mini_webp$1_$filename" "$outname"
    convert $outname +repage -crop 440x420+1400+2200 +repage "out/mini_webp$1_$filename"
}

test_func_original() {
    start
    outname="out/original_$filename"
    cp $filename $outname
    end "original" `size $outname` "out/mini_webp_original_$filename" "$outname"
    convert $outname +repage -crop 440x420+1400+2200 +repage "out/mini_webp_original_$filename"
}

filename="IMG_20200315_125023.jpg"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

out="$1.md"
filename="$1"

echo "| Type     | Size    | Runtime | Zoom    |Size     |" | tee $out
echo "| -------- | ------- | ------- | ------- | ------- |" | tee -a $out

test_func_original     | tee -a $out
test_func_heic  | tee -a $out
test_func_jpeg "1"  | tee -a $out
test_func_jpeg "10"  | tee -a $out
test_func_jpeg "30"  | tee -a $out
test_func_jpeg "50"  | tee -a $out
test_func_jpeg "60"  | tee -a $out
test_func_jpeg "85"  | tee -a $out
test_func_jpeg "100"  | tee -a $out
test_func_webp "10"  | tee -a $out
test_func_webp "30"  | tee -a $out
test_func_webp "50"  | tee -a $out
test_func_webp "60"  | tee -a $out
test_func_webp "85"  | tee -a $out
test_func_webp "100"  | tee -a $out

# convert in.png +repage -crop 640x620+0+0 +repage out.png
