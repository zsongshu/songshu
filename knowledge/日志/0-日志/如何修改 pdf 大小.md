# 如何修改 pdf 大小


#!/bin/bash
\# 合法值只有 5 个宏：/screen, /ebook, /printer, /prepress, /default，分别对应约 72 dpi、150 dpi、300 dpi、300+ dpi。
\# /bin/bash -c "$(curl -fsSL <https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh>)"
\# brew install ghostscript
\# ./gs.sh ~/Downloads/example.pdf
dpi=46
quality=70
outfile="${1%.\*}\_${dpi}q${quality}.pdf"

gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \\
   -sOutputFile="$outfile" \\
   -dCompatibilityLevel=1.4 \\
   -dPDFSETTINGS=/screen \\
   -dColorImageResolution=$dpi \\
   -dGrayImageResolution=$dpi \\
   -dMonoImageResolution=$dpi \\
   -dDownsampleColorImages=true \\
   -dDownsampleGrayImages=true \\
   -dDownsampleMonoImages=true \\
   -dAutoFilterColorImages=false \\
   -dColorImageFilter=/DCTEncode \\
   -c "<</QFactor 0.9 /Quality $quality >> setdistillerparams" \\
   -f "$1"




    Created at: 2025-11-18T11:31:30+08:00
    Updated at: 2025-11-18T11:31:59+08:00

