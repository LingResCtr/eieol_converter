#!/bin/sh

inputfile="old_norse.html"

# <span lang="non" class="Unicode"> gets lost in Pandoc; convert it to some
# textual encoding that's unlikely to appear in the text itself, so that it's
# preserved, and we can grab it and convert it ourselves later.
#   <span lang='non' class="Unicode">thing</span> -> <span>(((non-thing)))</span>
sed s/"<span lang='non' class='Unicode'>"/\<span\>\(\(\(non-/g $inputfile > preconversion.html

# `pandoc --chapters` just so that it processes h6 in addition to the other header levels...
pandoc --chapters preconversion.html -o converted.latex
# pandoc processes h1-h6 different than we want - change the output for those
sed --in-place s/^\\\\chapter/\\\\title/g converted.latex
sed --in-place s/^\\\\section/\\\\chapter/g converted.latex
sed --in-place s/^\\\\subsection/\\\\author/g converted.latex
sed --in-place s/^\\\\subsubsection/\\\\section/g converted.latex
sed --in-place s/^\\\\paragraph/\\\\subsection/g converted.latex
sed --in-place s/^\\\\subparagraph/\\\\subsubsection/g converted.latex

# scrape out the text encoding for <span lang=> that we created in the
# first step and replace it with a Latex /textlang command
sed --in-place s/"{(((non-"/\\\\texticelandic{/g converted.latex
