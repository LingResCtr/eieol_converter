#!/bin/sh

inputfile=${1:-"old_norse.html"} # optionally allow HTML file name as argument; 'old norse' sample otherwise
cp $inputfile preconversion.html

# <span lang="non" class="Unicode"> gets lost in Pandoc; convert it to some
# textual encoding that's unlikely to appear in the text itself, so that it's
# preserved, and we can grab it and convert it ourselves later.
#   <span lang='non' class="Unicode">thing</span> -> <span>(((non--thing</span>
langcodes='als aln xcl cu ang hit ae peo fro got grc non sga la lv lt orv sa xto txb'
for isolang in `echo $langcodes | tr " " "\n"`; do
   sed -i'bkup' s/"<span lang=['\"]$isolang['\"][^>]*>"/\<span\>\(\(\($isolang--/g preconversion.html
   sed -i'bkup' s/"<span [^ ]* lang=['\"]$isolang['\"]>"/\<span\>\(\(\($isolang--/g preconversion.html
   sed -i'bkup' s/"<span [^ ]* lang=['\"]$isolang['\"][^>]*>"/\<span\>\(\(\($isolang--/g preconversion.html
done

# `pandoc --chapters` just so that it processes h6 in addition to the other header levels...
pandoc --chapters preconversion.html -o converted.tex
# pandoc processes h1-h6 different than we want - change the output for those
sed -i'bkup' s/^\\\\chapter/\\\\title/g converted.tex
sed -i'bkup' s/^\\\\section/\\\\chapter/g converted.tex
sed -i'bkup' s/^\\\\subsection/\\\\author/g converted.tex
sed -i'bkup' s/^\\\\subsubsection/\\\\section/g converted.tex
sed -i'bkup' s/^\\\\paragraph/\\\\subsection/g converted.tex
sed -i'bkup' s/^\\\\subparagraph/\\\\subsubsection/g converted.tex

# scrape out the text encoding for <span lang=> that we created in the
# first step and replace it with a Latex /textlang command
sed -i'bkup' s/"{(((als--"/\\\\textalbanian{/g converted.tex
sed -i'bkup' s/"{(((aln--"/\\\\textalbanian{/g converted.tex
sed -i'bkup' s/"{(((xcl--"/\\\\textarmenian{/g converted.tex
sed -i'bkup' s/"{(((cu--"/\\\\textbulgarian{/g converted.tex
sed -i'bkup' s/"{(((ang--"/\\\\textenglish{/g converted.tex
sed -i'bkup' s/"{(((hit--"/\\\\textenglish{/g converted.tex
sed -i'bkup' s/"{(((ae--"/\\\\textfarsi{/g converted.tex
sed -i'bkup' s/"{(((peo--"/\\\\textfarsi{/g converted.tex
sed -i'bkup' s/"{(((fro--"/\\\\textfrench{/g converted.tex
sed -i'bkup' s/"{(((got--"/\\\\textgerman{/g converted.tex
sed -i'bkup' s/"{(((grc--"/\\\\textgreek{/g converted.tex # FIXME: \begin{greek}[variant=ancient] TEXT HERE \end{greek}
sed -i'bkup' s/"{(((non--"/\\\\texticelandic{/g converted.tex
sed -i'bkup' s/"{(((sga--"/\\\\textirish{/g converted.tex
sed -i'bkup' s/"{(((la--"/\\\\textlatin{/g converted.tex
sed -i'bkup' s/"{(((lv--"/\\\\textlatvian{/g converted.tex
sed -i'bkup' s/"{(((lt--"/\\\\textlithuanian{/g converted.tex
sed -i'bkup' s/"{(((orv--"/\\\\textrussian{/g converted.tex
sed -i'bkup' s/"{(((sa--"/\\\\textsanskrit{/g converted.tex
sed -i'bkup' s/"{(((xto--"/\\\\textsanskrit{/g converted.tex
sed -i'bkup' s/"{(((txb--"/\\\\textsanskrit{/g converted.tex

