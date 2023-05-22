all: dist/kana3.shuf.json dist/kana4.shuf.json dist/kana5.shuf.json

dist/kana3.shuf.json: dist/kana345.txt
	cat dist/kana345.txt | LC_COLLATE=C.UTF-8 grep -oE '^[ぁ-ゔー]{3}$$' | \
	shuf | \
	sed -e 's/^/"/g' | sed -e 's/$$/"/g' | \
	sed -z 's/\n/,/g' | \
	sed -e 's/^/[/' | sed -e 's/,$$/]/' > dist/kana3.shuf.json

dist/kana4.shuf.json: dist/kana345.txt
	cat dist/kana345.txt | LC_COLLATE=C.UTF-8 grep -oE '^[ぁ-ゔー]{4}$$' | \
	shuf | \
	sed -e 's/^/"/g' | sed -e 's/$$/"/g' | \
	sed -z 's/\n/,/g' | \
	sed -e 's/^/[/' | sed -e 's/,$$/]/' > dist/kana4.shuf.json

dist/kana5.shuf.json: dist/kana345.txt
	cat dist/kana345.txt | LC_COLLATE=C.UTF-8 grep -oE '^[ぁ-ゔー]{5}$$' | \
	shuf | \
	sed -e 's/^/"/g' | sed -e 's/$$/"/g' | \
	sed -z 's/\n/,/g' | \
	sed -e 's/^/[/' | sed -e 's/,$$/]/' > dist/kana5.shuf.json

dist/kana345.txt: filtered.txt
	mkdir -p dist
	cat filtered.txt > dist/kana345.txt

filtered.txt: cleansed.txt exclusion.txt
	cat cleansed.txt | grep -v -x -f exclusion.txt > filtered.txt

cleansed.txt: hiragana.txt
	cat hiragana.txt | LC_COLLATE=C.UTF-8 grep -v -e ゔ -e ゑ -e 'ーー' -e '^ん' -e '^を' > cleansed.txt

hiragana.txt: kana.txt
	cat kana.txt | sed 's/ァ/ぁ/g' | sed 's/ア/あ/g' | sed 's/ィ/ぃ/g' | sed 's/イ/い/g' | sed 's/ゥ/ぅ/g' | sed 's/ウ/う/g' | sed 's/ェ/ぇ/g' | sed 's/エ/え/g' | sed 's/ォ/ぉ/g' | sed 's/オ/お/g' | sed 's/カ/か/g' | sed 's/ガ/が/g' | sed 's/キ/き/g' | sed 's/ギ/ぎ/g' | sed 's/ク/く/g' | sed 's/グ/ぐ/g' | sed 's/ケ/け/g' | sed 's/ゲ/げ/g' | sed 's/コ/こ/g' | sed 's/ゴ/ご/g' | sed 's/サ/さ/g' | sed 's/ザ/ざ/g' | sed 's/シ/し/g' | sed 's/ジ/じ/g' | sed 's/ス/す/g' | sed 's/ズ/ず/g' | sed 's/セ/せ/g' | sed 's/ゼ/ぜ/g' | sed 's/ソ/そ/g' | sed 's/ゾ/ぞ/g' | sed 's/タ/た/g' | sed 's/ダ/だ/g' | sed 's/チ/ち/g' | sed 's/ヂ/ぢ/g' | sed 's/ッ/っ/g' | sed 's/ツ/つ/g' | sed 's/ヅ/づ/g' | sed 's/テ/て/g' | sed 's/デ/で/g' | sed 's/ト/と/g' | sed 's/ド/ど/g' | sed 's/ナ/な/g' | sed 's/ニ/に/g' | sed 's/ヌ/ぬ/g' | sed 's/ネ/ね/g' | sed 's/ノ/の/g' | sed 's/ハ/は/g' | sed 's/バ/ば/g' | sed 's/パ/ぱ/g' | sed 's/ヒ/ひ/g' | sed 's/ビ/び/g' | sed 's/ピ/ぴ/g' | sed 's/フ/ふ/g' | sed 's/ブ/ぶ/g' | sed 's/プ/ぷ/g' | sed 's/ヘ/へ/g' | sed 's/ベ/べ/g' | sed 's/ペ/ぺ/g' | sed 's/ホ/ほ/g' | sed 's/ボ/ぼ/g' | sed 's/ポ/ぽ/g' | sed 's/マ/ま/g' | sed 's/ミ/み/g' | sed 's/ム/む/g' | sed 's/メ/め/g' | sed 's/モ/も/g' | sed 's/ャ/ゃ/g' | sed 's/ヤ/や/g' | sed 's/ュ/ゅ/g' | sed 's/ユ/ゆ/g' | sed 's/ョ/ょ/g' | sed 's/ヨ/よ/g' | sed 's/ラ/ら/g' | sed 's/リ/り/g' | sed 's/ル/る/g' | sed 's/レ/れ/g' | sed 's/ロ/ろ/g' | sed 's/ヮ/ゎ/g' | sed 's/ワ/わ/g' | sed 's/ヰ/ゐ/g' | sed 's/ヱ/ゑ/g' | sed 's/ヲ/を/g' | sed 's/ン/ん/g' | sed 's/ヴ/ゔ/g' | sort | uniq > hiragana.txt

kana.txt: JMdict_e
	cat JMdict_e | grep \<reb\> | LC_COLLATE=C.UTF-8 grep -oE '[ぁ-ゔァ-ヺー]+' | LC_COLLATE=C.UTF-8 grep -oE '^[ぁ-ゔァ-ヺー]{3,5}$$' > kana.txt

JMdict_e: JMdict_e.gz
	gzip -d -k JMdict_e.gz

JMdict_e.gz:
	wget ftp://ftp.edrdg.org/pub/Nihongo//JMdict_e.gz

exclusion.txt: exclusion
	xxd -r exclusion | xxd -r > exclusion.txt

exclusiondump:
	xxd exclusion.txt | xxd > exclusion
