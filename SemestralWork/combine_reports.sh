
rm -r figures
rm -r sources

mkdir figures
mkdir sources

for filename in zips/*.zip; do
    name=${filename##*/}
    unzip zips/$name -d tmp
    mkdir figures/$(basename "$name" .zip)
    mv tmp/figures/* figures/$(basename "$name" .zip)/
    mv tmp/main.tex sources/$(basename "$name" .zip).tex

    rm -r tmp
done
